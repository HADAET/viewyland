# app/db/database.py

import os
import time
from contextlib import contextmanager
from threading import Lock

import psycopg2
from psycopg2 import OperationalError, InterfaceError
from psycopg2.extras import RealDictCursor, execute_batch
from psycopg2.pool import ThreadedConnectionPool


# =========================================================
# DATABASE CONFIG
# =========================================================

DATABASE_URL_BKP = os.getenv("DATABASE_URL_BKP")

if not DATABASE_URL_BKP:
    raise RuntimeError("DATABASE_URL_BKP environment variable is not set.")


# =========================================================
# CONNECTION POOL
# =========================================================

_pool = None
_pool_lock = Lock()


def _create_pool():
    """Create a fresh PostgreSQL connection pool (lazy)."""

    return ThreadedConnectionPool(
        minconn=1,
        maxconn=10,
        dsn=DATABASE_URL_BKP,
        sslmode="require",
        connect_timeout=10,
        # Keep TCP connections alive.
        keepalives=1,
        keepalives_idle=30,
        keepalives_interval=10,
        keepalives_count=3,
    )


def _get_pool():
    """Return the current pool, creating it if needed."""

    global _pool

    if _pool is not None:
        return _pool

    with _pool_lock:
        if _pool is None:
            _pool = _create_pool()

    return _pool


def _reset_pool():
    """Discard the current pool (used when connections are unusable)."""

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
    """Detect errors that mean the PostgreSQL connection is unusable."""

    if isinstance(error, (OperationalError, InterfaceError)):
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

    return any(text in message for text in connection_messages)


# =========================================================
# QUERY PLACEHOLDER CONVERSION
# =========================================================

def _convert_query(query: str) -> str:
    """
    Project code uses SQLite-style '?' placeholders.
    psycopg2 needs '%s'.
    """

    return query.replace("?", "%s")


# =========================================================
# DEBUG CURSOR
# =========================================================

class DebugCursor:
    """
    Small cursor wrapper preserving:

        connection.execute(...).fetchall()
        connection.execute(...).fetchone()
    """

    def __init__(self, connection):
        self.connection = connection
        self.cursor = None

    def execute(self, query, params=None):
        try:
            self.cursor = self.connection.cursor(cursor_factory=RealDictCursor)

            postgres_query = _convert_query(query)

            if params is None:
                self.cursor.execute(postgres_query)
            else:
                self.cursor.execute(postgres_query, params)

            return self

        except Exception:
            if self.cursor is not None:
                try:
                    self.cursor.close()
                except Exception:
                    pass
                self.cursor = None
            raise

    def fetchone(self):
        if self.cursor is None:
            raise RuntimeError("fetchone() called before execute().")
        return self.cursor.fetchone()

    def fetchall(self):
        if self.cursor is None:
            raise RuntimeError("fetchall() called before execute().")
        return self.cursor.fetchall()

    def __iter__(self):
        if self.cursor is None:
            raise RuntimeError("Iteration started before execute().")
        return iter(self.cursor)

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
    Wrapper around a psycopg2 connection.

    Existing application code can keep using:

        connection.execute(...)
    """

    def __init__(self, connection, pool):
        self.connection = connection
        self.pool = pool
        self._broken = False

        # Number of queries that succeeded on the CURRENT connection.
        # If the very first query fails with a connection error (e.g.
        # Neon silently closed an idle pooled connection), nothing has
        # happened yet, so a transparent retry on a fresh connection
        # is safe. Later failures are NOT retried here.
        self._queries_run = 0

    # -----------------------------------------------------
    # EXECUTE
    # -----------------------------------------------------

    def execute(self, query, params=None):

        started = time.perf_counter()

        try:
            cursor = DebugCursor(self.connection)
            result = cursor.execute(query, params)
            self._queries_run += 1
            return result

        except Exception as error:

            if _is_connection_error(error) and self._queries_run == 0:

                print(
                    "[DB WARNING] "
                    "First query on pooled connection failed "
                    f"({error}). Retrying once with a fresh connection."
                )

                try:
                    self.pool.putconn(self.connection, close=True)
                except Exception:
                    pass

                self.connection = self.pool.getconn()

                try:
                    cursor = DebugCursor(self.connection)
                    result = cursor.execute(query, params)
                    self._queries_run += 1

                    print("[DB DEBUG] Retry succeeded on fresh connection.")

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
            elapsed = (time.perf_counter() - started) * 1000

            if elapsed > 1000:
                print(f"[DB DEBUG] execute took {elapsed:.2f} ms")

    # -----------------------------------------------------
    # EXECUTEMANY
    # -----------------------------------------------------

    def executemany(self, query, params_list):

        # FIX: `started` must be defined before the try/finally,
        # because the finally block always uses it.
        started = time.perf_counter()

        cursor = None

        # FIX: convert before try so it is always defined in the
        # retry branch below.
        postgres_query = _convert_query(query)

        try:
            cursor = self.connection.cursor()

            # execute_batch sends rows in pages -> far fewer network
            # round trips than plain cursor.executemany().
            execute_batch(
                cursor,
                postgres_query,
                params_list,
                page_size=100,
            )

            self._queries_run += 1
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
                    self.pool.putconn(self.connection, close=True)
                except Exception:
                    pass

                self.connection = self.pool.getconn()

                try:
                    cursor = self.connection.cursor()

                    execute_batch(
                        cursor,
                        postgres_query,
                        params_list,
                        page_size=100,
                    )

                    self._queries_run += 1

                    print("[DB DEBUG] Retry succeeded on fresh connection.")

                    return self

                except Exception as retry_error:

                    if _is_connection_error(retry_error):
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

            if cursor is not None:
                try:
                    cursor.close()
                except Exception:
                    pass

            elapsed = (time.perf_counter() - started) * 1000

            if elapsed > 1000:
                print(f"[DB DEBUG] executemany took {elapsed:.2f} ms")

    # -----------------------------------------------------
    # COMMIT / ROLLBACK
    # -----------------------------------------------------

    def commit(self):
        self.connection.commit()

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

        get_elapsed = (time.perf_counter() - get_started) * 1000
        print(f"[DB DEBUG] pool.getconn: {get_elapsed:.2f} ms")

    except Exception as error:

        print(f"[DB ERROR] Could not get connection: {error}")

        _reset_pool()

        pool = _get_pool()

        connection = pool.getconn()

    # -----------------------------------------------------
    # BASIC CONNECTION CHECK
    #
    # We do NOT run SELECT 1 here. connection.closed only checks
    # local psycopg2 state; if Neon killed the SSL connection,
    # the real query detects it and retries transparently.
    # -----------------------------------------------------

    try:
        if connection.closed:

            print("[DB WARNING] Pool returned a closed connection. Replacing it.")

            pool.putconn(connection, close=True)

            connection = pool.getconn()

    except Exception as error:

        print(f"[DB WARNING] Connection check failed: {error}")

        try:
            pool.putconn(connection, close=True)
        except Exception:
            pass

        connection = pool.getconn()

    # -----------------------------------------------------
    # WRAP CONNECTION
    # -----------------------------------------------------

    db = DatabaseConnection(connection, pool)

    try:
        yield db

        # -------------------------------------------------
        # COMMIT
        # -------------------------------------------------

        commit_started = time.perf_counter()

        try:
            db.connection.commit()

            commit_elapsed = (time.perf_counter() - commit_started) * 1000
            print(f"[DB DEBUG] commit: {commit_elapsed:.2f} ms")

        except Exception as error:

            if _is_connection_error(error):
                broken = True
                print(
                    "[DB WARNING] "
                    "Commit failed because PostgreSQL connection died."
                )

            raise

    except Exception as error:

        if _is_connection_error(error):
            broken = True
            print(f"[DB WARNING] Connection error detected: {error}")

        try:
            db.connection.rollback()
        except Exception:
            pass

        raise

    finally:

        if getattr(db, "_broken", False):
            broken = True

        # db.connection may differ from the local `connection`
        # variable if a transparent retry swapped it. Always return
        # whichever connection db holds NOW.
        connection = db.connection

        if connection is not None:

            try:
                pool.putconn(connection, close=broken)

                if broken:
                    print("[DB DEBUG] Broken connection discarded.")

            except Exception as error:

                print(f"[DB WARNING] Could not return connection: {error}")

                try:
                    connection.close()
                except Exception:
                    pass

        total_elapsed = (time.perf_counter() - started) * 1000
        print(f"[DB DEBUG] TOTAL connection context: {total_elapsed:.2f} ms")


# =========================================================
# DATABASE HEALTH CHECK
# =========================================================

def check_database_connection() -> bool:
    """
    Explicit health check (runs SELECT 1).

    Do NOT call this before every normal request.
    """

    try:
        with get_connection() as connection:
            connection.execute("SELECT 1").fetchone()

        return True

    except Exception as error:
        print(f"[DB HEALTH] Database unavailable: {error}")
        return False


# =========================================================
# DATABASE INITIALIZATION
# =========================================================

def initialize_database():
    """
    Compatibility function used by app.main.

    Does NOT execute SQL; only initializes the connection pool.
    """

    try:
        _get_pool()
        print("[DB INIT] PostgreSQL connection pool initialized.")

    except Exception as error:
<<<<<<< HEAD
        print(f"[DB INIT WARNING] Could not initialize PostgreSQL pool: {error}")
=======
        print(f"[DB INIT WARNING] Could not initialize PostgreSQL pool: {error}")
>>>>>>> 842b09a (enhancement mobile view)
