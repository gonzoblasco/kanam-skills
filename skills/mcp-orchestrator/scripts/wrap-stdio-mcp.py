#!/usr/bin/env python3
"""Generate a stdio MCP wrapper from a server command and optional secret name."""
import sys
from pathlib import Path

TEMPLATE = Path(__file__).parent.parent / "references" / "wrapper-template.py"


def generate(package_name: str, secret_name: str = ""):
    code = TEMPLATE.read_text()
    code = code.replace('["npx", "-y", "<package-name>"]', f'["npx", "-y", "{package_name}"]')
    if secret_name:
        code = code.replace('SECRET_PATH = Path.home() / ".openclaw" / "secrets" / "<name>-token"', f'SECRET_PATH = Path.home() / ".openclaw" / "secrets" / "{secret_name}"')
        code = code.replace('env["<TOKEN_ENV>"] = SECRET_PATH.read_text().strip()', 'env["TOKEN"] = SECRET_PATH.read_text().strip()')
    else:
        code = code.replace('SECRET_PATH = Path.home() / ".openclaw" / "secrets" / "<name>-token"', 'SECRET_PATH = Path.home() / ".openclaw" / "secrets" / "none"  # no secret needed')
    return code


def main():
    if len(sys.argv) < 2:
        print("usage: wrap-stdio-mcp.py <package-name> [<secret-name>]")
        sys.exit(1)
    package = sys.argv[1]
    secret = sys.argv[2] if len(sys.argv) > 2 else ""
    print(generate(package, secret))


if __name__ == "__main__":
    main()
