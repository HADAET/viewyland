import getpass
import hashlib
import hmac
import re
import secrets
import sys

from app.db.database import get_connection


PASSWORD_ITERATIONS = 310_000
USERNAME_PATTERN = re.compile(r"^[A-Za-z0-9._-]{3,50}$")


def hash_admin_password(password: str) -> str:
    salt = secrets.token_bytes(16)
    digest = hashlib.pbkdf2_hmac(
        "sha256",
        password.encode("utf-8"),
        salt,
        PASSWORD_ITERATIONS,
    )
    return f"pbkdf2_sha256${PASSWORD_ITERATIONS}${salt.hex()}${digest.hex()}"


def verify_admin_password(password: str, stored_hash: str | None) -> bool:
    if not stored_hash:
        return False

    try:
        algorithm, iterations_text, salt_hex, digest_hex = stored_hash.split("$", 3)
        iterations = int(iterations_text)
        salt = bytes.fromhex(salt_hex)
        expected_digest = bytes.fromhex(digest_hex)
    except (ValueError, TypeError):
        return False

    if algorithm != "pbkdf2_sha256" or iterations < 100_000:
        return False

    actual_digest = hashlib.pbkdf2_hmac(
        "sha256",
        password.encode("utf-8"),
        salt,
        iterations,
    )
    return hmac.compare_digest(actual_digest, expected_digest)


def validate_admin_username(username: str) -> str:
    username = username.strip()
    if not USERNAME_PATTERN.fullmatch(username):
        raise ValueError(
            "Username must be 3-50 characters using letters, numbers, dots, "
            "underscores, or hyphens."
        )
    return username


def validate_admin_full_name(full_name: str) -> str:
    full_name = full_name.strip()
    if not full_name or len(full_name) > 50:
        raise ValueError("Full name must be between 1 and 50 characters.")
    return full_name


def validate_admin_password(password: str) -> str:
    if len(password) < 6:
        raise ValueError("Password must be at least 6 characters.")
    if len(password) > 1024:
        raise ValueError("Password must be no more than 1024 characters.")
    return password


def create_initial_super_admin(
    username: str,
    full_name: str,
    password: str,
) -> None:
    username = validate_admin_username(username)
    full_name = validate_admin_full_name(full_name)
    password_hash = hash_admin_password(validate_admin_password(password))

    with get_connection() as connection:
        connection.execute("LOCK TABLE admin_users IN EXCLUSIVE MODE")
        existing_user = connection.execute(
            "SELECT 1 FROM admin_users LIMIT 1"
        ).fetchone()
        if existing_user:
            raise RuntimeError(
                "admin_users is not empty; create additional accounts from "
                "the Super Admin page."
            )

        connection.execute(
            """
            INSERT INTO admin_users (username, full_name, password_hash, role)
            VALUES (?, ?, ?, 'super_admin')
            """,
            (username, full_name, password_hash),
        )


def main() -> int:
    if len(sys.argv) != 2:
        print(
            "Usage: python -m app.services.admin_auth_service <username>",
            file=sys.stderr,
        )
        return 2

    try:
        username = validate_admin_username(sys.argv[1])
        full_name = validate_admin_full_name(input("Full name: "))
        password = validate_admin_password(getpass.getpass("New password (6+ chars): "))
        confirmation = getpass.getpass("Confirm password: ")
        if password != confirmation:
            raise ValueError("Passwords do not match.")
        create_initial_super_admin(username, full_name, password)
    except (ValueError, RuntimeError) as error:
        print(f"Could not create Super Admin: {error}", file=sys.stderr)
        return 1

    print(f"Created the initial Super Admin account '{username}'.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
