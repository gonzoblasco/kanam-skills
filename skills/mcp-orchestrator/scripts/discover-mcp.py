#!/usr/bin/env python3
"""Discover MCP servers from awesome lists by keyword."""
import json
import re
import sys
from urllib.request import urlopen, Request
import ssl

# certifi is only needed for live network fetch; keep import lazy
# so unit tests can import the module without it.

certifi = None
try:
    import certifi
except ModuleNotFoundError:
    pass

AWESOME_URL = "https://raw.githubusercontent.com/wong2/awesome-mcp-servers/main/README.md"


def fetch_readme():
    ctx = ssl.create_default_context(cafile=certifi.where() if certifi else None)
    req = Request(AWESOME_URL, headers={"User-Agent": "Mozilla/5.0"})
    with urlopen(req, timeout=30, context=ctx) as resp:
        return resp.read().decode("utf-8")


def discover(query: str, text: str):
    query = query.lower()
    results = []
    for line in text.splitlines():
        m = re.search(r"\[([^\]]+)\]\((https?://[^\)]+)\)", line)
        if not m:
            continue
        title, url = m.groups()
        desc = re.sub(r"\[([^\]]+)\]\([^\)]+\)", r"\1", line).strip("- ")
        if query in (title + " " + desc).lower():
            results.append({"title": title, "url": url, "description": desc})
    return results


def main():
    if len(sys.argv) < 2:
        print("usage: discover-mcp.py <keyword>")
        sys.exit(1)
    keyword = sys.argv[1]
    readme = fetch_readme()
    results = discover(keyword, readme)
    print(json.dumps(results, indent=2))


if __name__ == "__main__":
    main()
