# app/db/database.py

import os
import time
from contextlib import contextmanager
from threading import Lock

import psycopg2
from psycopg2 import OperationalError, InterfaceError
from psycopg2.extras import RealDictCursor
from psycopg2.pool import ThreadedConnectionPool


# =========================================================
# DATABASE CONFIG
# =========================================================

DATABASE_URL = os.getenv("DATABASE_URL")

if not DATABASE_URL:
    raise RuntimeError(
        "DATABASE_URL environment variable is not set."
    )


# =========================================================
# CONNECTION POOL
# =========================================================

_pool = None
_pool_lock = Lock()


def _create_pool():
    """
    Create a fresh PostgreSQL connection pool.

    The pool is created lazily.
    """

    return ThreadedConnectionPool(
        minconn=1,
        maxconn=10,
        dsn=DATABASE_URL,
        sslmode="require",
        connect_timeout=10,

        # Keep TCP connections alive.
        keepalives=1,
        keepalives_idle=30,
        keepalives_interval=10,
        keepalives_count=3,
    )


def _get_pool():
    """
    Return the current connection pool.

    If no pool exists, create one.
    """

    global _pool

    if _pool is not None:
        return _pool

    with _pool_lock:

        if _pool is None:
            _pool = _create_pool()

    return _pool


def _reset_pool():
    """
    Completely discard the current pool.

    Used when PostgreSQL/Neon connections are no longer usable.
    """

    global _pool

    with _pool_lock:

        old_pool = _pool
        _pool = None

        if old_pool is not None:

            try:
                old_pool.closeall()
            except Exception:
                pass


# =========================================================
# CONNECTION ERROR DETECTION
# =========================================================

def _is_connection_error(error: Exception) -> bool:
    """
    Detect errors that indicate the PostgreSQL connection
    itself is no longer usable.
    """

    if isinstance(
        error,
        (
            OperationalError,
            InterfaceError,
        ),
    ):
        return True

    message = str(error).lower()

    connection_messages = (
        "ssl connection has been closed",
        "server closed the connection",
        "connection already closed",
        "connection is closed",
        "connection not open",
        "connection refused",
        "connection reset",
        "could not connect",
        "connection timed out",
        "terminating connection",
        "closed unexpectedly",
        "server terminated",
        "broken pipe",
        "network is unreachable",
    )

    return any(
        text in message
        for text in connection_messages
    )


# =========================================================
# QUERY PLACEHOLDER CONVERSION
# =========================================================

def _convert_query(query: str) -> str:
    """
    Existing project code uses SQLite-style '?' placeholders.

    psycopg2/PostgreSQL requires '%s'.

    Example:

        WHERE item_no=?

    becomes:

        WHERE item_no=%s
    """

    return query.replace("?", "%s")


# =========================================================
# DEBUG CURSOR
# =========================================================

class DebugCursor:
    """
    Small cursor wrapper.

    It preserves the existing project style:

        connection.execute(...).fetchall()
        connection.execute(...).fetchone()

    while internally using psycopg2.
    """

    def __init__(self, connection):
        self.connection = connection
        self.cursor = None

    # -----------------------------------------------------
    # EXECUTE
    # -----------------------------------------------------

    def execute(
        self,
        query,
        params=None,
    ):
        started = time.perf_counter()

        try:

            self.cursor = self.connection.cursor(
                cursor_factory=RealDictCursor
            )

            postgres_query = _convert_query(
                query
            )

            if params is None:

                self.cursor.execute(
                    postgres_query
                )

            else:

                self.cursor.execute(
                    postgres_query,
                    params,
                )

            elapsed = (
                time.perf_counter()
                - started
            ) * 1000

            print(
                "[SQL DEBUG] "
                f"{elapsed:.2f} ms | "
                f"{query.strip()[:300]}"
            )

            return self

        except Exception:

            if self.cursor is not None:

                try:
                    self.cursor.close()
                except Exception:
                    pass

                self.cursor = None

            raise

    # -----------------------------------------------------
    # FETCH ONE
    # -----------------------------------------------------

    def fetchone(self):

        if self.cursor is None:
            raise RuntimeError(
                "fetchone() called before execute()."
            )

        return self.cursor.fetchone()

    # -----------------------------------------------------
    # FETCH ALL
    # -----------------------------------------------------

    def fetchall(self):

        if self.cursor is None:
            raise RuntimeError(
                "fetchall() called before execute()."
            )

        return self.cursor.fetchall()

    # -----------------------------------------------------
    # ITERATION
    # -----------------------------------------------------

    def __iter__(self):

        if self.cursor is None:
            raise RuntimeError(
                "Iteration started before execute()."
            )

        return iter(self.cursor)

    # -----------------------------------------------------
    # CLOSE
    # -----------------------------------------------------

    def close(self):

        if self.cursor is not None:

            try:
                self.cursor.close()
            except Exception:
                pass

            self.cursor = None


# =========================================================
# DATABASE CONNECTION WRAPPER
# =========================================================

class DatabaseConnection:
    """
    Wrapper around psycopg2 connection.

    Existing application code can continue using:

        connection.execute(...)
    """

    def __init__(
        self,
        connection,
        pool,
    ):

        self.connection = connection
        self.pool = pool
        self._broken = False

        # Counts queries that have actually succeeded on the CURRENT
        # underlying connection. Used to decide whether it's safe to
        # transparently swap in a fresh connection and retry: if this
        # is the very first query and it failed because the pool handed
        # us an already-dead connection (Neon/idle-suspend killed it),
        # nothing has happened yet, so a silent retry is safe. If a
        # later query in the same transaction dies, we do NOT retry
        # here — the transaction already has state and must be re-run
        # by the caller, not silently restarted mid-way.
        self._queries_run = 0

    # -----------------------------------------------------
    # EXECUTE
    # -----------------------------------------------------

    def execute(
        self,
        query,
        params=None,
    ):

        started = time.perf_counter()

        try:

            cursor = DebugCursor(
                self.connection
            )

            result = cursor.execute(
                query,
                params,
            )

            self._queries_run += 1

            return result

        except Exception as error:

            if _is_connection_error(error) and self._queries_run == 0:

                # -------------------------------------------------
                # TRANSPARENT RETRY
                # -------------------------------------------------
                # This is the first query on this connection and it
                # died on us before doing anything — almost always
                # because the pool handed us a connection that Neon
                # had already silently closed (autosuspend / idle
                # timeout). Nothing has happened yet, so it's safe to
                # swap in a fresh connection and retry once, silently.
                # -------------------------------------------------

                print(
                    "[DB WARNING] "
                    "First query on pooled connection failed "
                    f"({error}). Retrying once with a fresh connection."
                )

                try:
                    self.pool.putconn(
                        self.connection,
                        close=True,
                    )
                except Exception:
                    pass

                self.connection = self.pool.getconn()

                try:

                    cursor = DebugCursor(
                        self.connection
                    )

                    result = cursor.execute(
                        query,
                        params,
                    )

                    self._queries_run += 1

                    print(
                        "[DB DEBUG] "
                        "Retry succeeded on fresh connection."
                    )

                    return result

                except Exception as retry_error:

                    if _is_connection_error(retry_error):

                        print(
                            "[DB WARNING] "
                            "PostgreSQL connection is dead. "
                            "Discarding connection."
                        )

                        self._broken = True

                        try:
                            self.connection.rollback()
                        except Exception:
                            pass

                    raise

            if _is_connection_error(error):

                print(
                    "[DB WARNING] "
                    "PostgreSQL connection is dead. "
                    "Discarding connection."
                )

                self._broken = True

                try:
                    self.connection.rollback()
                except Exception:
                    pass

            raise

        finally:

            elapsed = (
                time.perf_counter()
                - started
            ) * 1000

            if elapsed > 1000:

                print(
                    "[DB DEBUG] "
                    "execute took "
                    f"{elapsed:.2f} ms"
                )

    # -----------------------------------------------------
    # EXECUTEMANY
    # -----------------------------------------------------

    def executemany(
        self,
        query,
        params_list,
    ):

        started = time.perf_counter()

        cursor = None

        try:

            cursor = self.connection.cursor()

            postgres_query = _convert_query(
                query
            )

            cursor.executemany(
                postgres_query,
                params_list,
            )

            self._queries_run += 1

            elapsed = (
                time.perf_counter()
                - started
            ) * 1000

            print(
                "[SQL DEBUG] "
                f"{elapsed:.2f} ms | executemany | "
                f"{query.strip()[:300]}"
            )

            return self

        except Exception as error:

            if cursor is not None:
                try:
                    cursor.close()
                except Exception:
                    pass
                cursor = None

            if _is_connection_error(error) and self._queries_run == 0:

                print(
                    "[DB WARNING] "
                    "First query (executemany) on pooled connection "
                    f"failed ({error}). Retrying once with a fresh "
                    "connection."
                )

                try:
                    self.pool.putconn(
                        self.connection,
                        close=True,
                    )
                except Exception:
                    pass

                self.connection = self.pool.getconn()

                try:

                    cursor = self.connection.cursor()

                    cursor.executemany(
                        postgres_query,
                        params_list,
                    )

                    self._queries_run += 1

                    print(
                        "[DB DEBUG] "
                        "Retry succeeded on fresh connection."
                    )

                    return self

                except Exception as retry_error:

                    if _is_connection_error(retry_error):

                        self._broken = True

                        try:
                            self.connection.rollback()
                        except Exception:
                            pass

                    raise

                finally:

                    if cursor is not None:
                        try:
                            cursor.close()
                        except Exception:
                            pass

            if _is_connection_error(error):

                print(
                    "[DB WARNING] "
                    "PostgreSQL connection is dead. "
                    "Discarding connection."
                )

                self._broken = True

                try:
                    self.connection.rollback()
                except Exception:
                    pass

            raise

        finally:

            if cursor is not None:

                try:
                    cursor.close()
                except Exception:
                    pass

            elapsed = (
                time.perf_counter()
                - started
            ) * 1000

            if elapsed > 1000:

                print(
                    "[DB DEBUG] "
                    "executemany took "
                    f"{elapsed:.2f} ms"
                )

    # -----------------------------------------------------
    # COMMIT
    # -----------------------------------------------------

    def commit(self):

        self.connection.commit()

    # -----------------------------------------------------
    # ROLLBACK
    # -----------------------------------------------------

    def rollback(self):

        try:
            self.connection.rollback()
        except Exception:
            pass


# =========================================================
# GET CONNECTION
# =========================================================

@contextmanager
def get_connection():
    """
    Get a PostgreSQL connection from the pool.

    Dead connections are discarded instead of being returned
    to the pool.
    """

    started = time.perf_counter()

    pool = _get_pool()

    connection = None
    broken = False

    # -----------------------------------------------------
    # GET CONNECTION
    # -----------------------------------------------------

    try:

        get_started = time.perf_counter()

        connection = pool.getconn()

        print(
            "[DB DEBUG] pool.getconn: "
            f"{(
                time.perf_counter()
                - get_started
            ) * 1000:.2f} ms"
        )

    except Exception as error:

        print(
            "[DB ERROR] "
            "Could not get connection: "
            f"{error}"
        )

        _reset_pool()

        pool = _get_pool()

        connection = pool.getconn()

    # -----------------------------------------------------
    # BASIC CONNECTION CHECK
    # -----------------------------------------------------
    #
    # IMPORTANT:
    #
    # We do NOT execute SELECT 1 here.
    #
    # connection.closed only checks local psycopg2 state.
    # If Neon has silently killed the SSL connection,
    # the real query will detect it.
    # -----------------------------------------------------

    try:

        if connection.closed:

            print(
                "[DB WARNING] "
                "Pool returned a closed connection. "
                "Replacing it."
            )

            pool.putconn(
                connection,
                close=True,
            )

            connection = pool.getconn()

    except Exception as error:

        print(
            "[DB WARNING] "
            f"Connection check failed: {error}"
        )

        try:
            pool.putconn(
                connection,
                close=True,
            )
        except Exception:
            pass

        connection = pool.getconn()

    # -----------------------------------------------------
    # WRAP CONNECTION
    # -----------------------------------------------------

    db = DatabaseConnection(
        connection,
        pool,
    )

    try:

        yield db

        # -------------------------------------------------
        # COMMIT
        # -------------------------------------------------

        commit_started = time.perf_counter()

        try:

            db.connection.commit()

            print(
                "[DB DEBUG] commit: "
                f"{(
                    time.perf_counter()
                    - commit_started
                ) * 1000:.2f} ms"
            )

        except Exception as error:

            if _is_connection_error(error):

                broken = True

                print(
                    "[DB WARNING] "
                    "Commit failed because "
                    "PostgreSQL connection died."
                )

            raise

    except Exception as error:

        # -------------------------------------------------
        # CONNECTION ERROR
        # -------------------------------------------------

        if _is_connection_error(error):

            broken = True

            print(
                "[DB WARNING] "
                "Connection error detected: "
                f"{error}"
            )

        # -------------------------------------------------
        # ROLLBACK
        # -------------------------------------------------

        try:
            db.connection.rollback()
        except Exception:
            pass

        raise

    finally:

        # -------------------------------------------------
        # DatabaseConnection.execute() may have detected
        # a broken connection.
        # -------------------------------------------------

        if getattr(
            db,
            "_broken",
            False,
        ):

            broken = True

        # -------------------------------------------------
        # RETURN CONNECTION TO POOL
        #
        # NOTE: db.connection may no longer be the same
        # object as the local `connection` variable above —
        # DatabaseConnection.execute()/executemany() silently
        # swap it out when the pool hands back an already-dead
        # connection and a transparent retry succeeds. We must
        # return whichever connection db is holding NOW.
        # -------------------------------------------------

        connection = db.connection

        if connection is not None:

            try:

                pool.putconn(
                    connection,
                    close=broken,
                )

                if broken:

                    print(
                        "[DB DEBUG] "
                        "Broken connection discarded."
                    )

            except Exception as error:

                print(
                    "[DB WARNING] "
                    "Could not return connection: "
                    f"{error}"
                )

                try:
                    connection.close()
                except Exception:
                    pass

        print(
            "[DB DEBUG] TOTAL connection context: "
            f"{(
                time.perf_counter()
                - started
            ) * 1000:.2f} ms"
        )


# =========================================================
# DATABASE HEALTH CHECK
# =========================================================

def check_database_connection() -> bool:
    """
    Explicit database health check.

    This function DOES execute SELECT 1.

    Do NOT call this before every normal request.
    """

    try:

        with get_connection() as connection:

            connection.execute(
                "SELECT 1"
            ).fetchone()

        return True

    except Exception as error:

        print(
            "[DB HEALTH] "
            f"Database unavailable: {error}"
        )

        return False


# =========================================================
# DATABASE INITIALIZATION
# =========================================================

def initialize_database():
    """
    Compatibility function used by app.main.

    This does NOT execute SQL.

    It only initializes the PostgreSQL connection pool.
    """

    try:

        _get_pool()

        print(
            "[DB INIT] "
            "PostgreSQL connection pool initialized."
        )

    except Exception as error:

        print(
            "[DB INIT WARNING] "
            "Could not initialize PostgreSQL pool: "
            f"{error}"
        )