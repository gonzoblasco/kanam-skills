#!/usr/bin/env python3
"""Generate a Streamable HTTP / SSE MCP wrapper template."""
import sys


def generate(url: str, bearer_secret: str = ""):
    secret_block = f"""
secret_path = Path.home() / ".openclaw" / "secrets" / "{bearer_secret}"
headers["Authorization"] = f"Bearer {{secret_path.read_text().strip()}}"
""" if bearer_secret else ""

    code = f"""#!/usr/bin/env python3
import json
import sys
import urllib.request
from pathlib import Path

URL = "{url}"

def call(method, params={{}}):
    headers = {{"Content-Type": "application/json"}}
    {secret_block}
    payload = json.dumps({{"jsonrpc": "2.0", "id": 1, "method": method, "params": params}}).encode()
    req = urllib.request.Request(URL, data=payload, headers=headers, method="POST")
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.loads(resp.read().decode())

if __name__ == "__main__":
    method = sys.argv[1] if len(sys.argv) > 1 else "tools/list"
    params = json.loads(sys.argv[2]) if len(sys.argv) > 2 else {{}}
    print(json.dumps(call(method, params), indent=2))
"""
    return code


def main():
    if len(sys.argv) < 2:
        print("usage: wrap-http-mcp.py <url> [<bearer-secret-name>]")
        sys.exit(1)
    url = sys.argv[1]
    secret = sys.argv[2] if len(sys.argv) > 2 else ""
    print(generate(url, secret))


if __name__ == "__main__":
    main()
