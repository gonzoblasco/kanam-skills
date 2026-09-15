#!/usr/bin/env python3
"""
github-mcp.py - stdio wrapper for the official GitHub MCP server.
Usage:
  python3 github-mcp.py list
  python3 github-mcp.py call list_issues '{"owner": "facebook", "repo": "astryx", "state": "open"}'
"""

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path


def get_token():
    secret_path = Path.home() / ".openclaw" / "secrets" / "github-token"
    if secret_path.exists():
        return secret_path.read_text().strip()
    env_token = os.environ.get("GITHUB_PERSONAL_ACCESS_TOKEN")
    if env_token:
        return env_token
    print("Error: GitHub token not found. Store it in ~/.openclaw/secrets/github-token or set GITHUB_PERSONAL_ACCESS_TOKEN.", file=sys.stderr)
    sys.exit(1)


def get_binary():
    candidates = [
        Path.home() / ".openclaw" / "bin" / "github-mcp",
        Path("/tmp/github-mcp"),
    ]
    for c in candidates:
        if c.exists():
            return str(c)
    print("Error: github-mcp binary not found. Build it from github.com/github/github-mcp-server", file=sys.stderr)
    sys.exit(1)


def handshake(proc):
    """Complete MCP initialization handshake with the subprocess."""
    init_req = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
            "protocolVersion": "2025-03-26",
            "capabilities": {},
            "clientInfo": {"name": "openclaw", "version": "1.0"},
        },
    }
    proc.stdin.write(json.dumps(init_req) + "\n")
    proc.stdin.flush()

    # Read until we get init response
    init_resp = None
    for line in proc.stdout:
        line = line.strip()
        if not line:
            continue
        try:
            msg = json.loads(line)
        except json.JSONDecodeError:
            continue
        if msg.get("id") == 1:
            init_resp = msg
            break
    if init_resp is None or "error" in init_resp:
        return None

    # Send initialized notification
    notify = {"jsonrpc": "2.0", "method": "notifications/initialized"}
    proc.stdin.write(json.dumps(notify) + "\n")
    proc.stdin.flush()
    return init_resp


def send_request(proc, req):
    proc.stdin.write(json.dumps(req) + "\n")
    proc.stdin.flush()
    for line in proc.stdout:
        line = line.strip()
        if not line:
            continue
        try:
            msg = json.loads(line)
        except json.JSONDecodeError:
            continue
        if msg.get("id") == req["id"]:
            return msg
        if "result" in msg or "error" in msg:
            return msg
    return None


def run_mcp_command(req, toolsets="default"):
    token = get_token()
    binary = get_binary()
    env = os.environ.copy()
    env["GITHUB_PERSONAL_ACCESS_TOKEN"] = token

    proc = subprocess.Popen(
        [binary, "stdio", f"--toolsets={toolsets}"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        env=env,
    )

    init_resp = handshake(proc)
    if init_resp is None:
        return None

    return send_request(proc, req)


def main():
    parser = argparse.ArgumentParser(description="GitHub MCP wrapper")
    parser.add_argument("command", choices=["list", "call"], help="Command")
    parser.add_argument("args", nargs="*", help="Tool name and optional JSON arguments")
    parser.add_argument("--toolsets", default="default", help="Comma-separated toolsets")
    args = parser.parse_args()

    if args.command == "list":
        resp = run_mcp_command({"jsonrpc": "2.0", "id": 3, "method": "tools/list"}, args.toolsets)
        print(json.dumps(resp, indent=2))
    elif args.command == "call":
        if not args.args:
            print("Usage: python3 github-mcp.py call <tool_name> [json_args] [--toolsets=...]", file=sys.stderr)
            sys.exit(1)
        tool_name = args.args[0]
        arguments = {}
        if len(args.args) > 1:
            try:
                arguments = json.loads(args.args[1])
            except json.JSONDecodeError as e:
                print(f"Invalid JSON arguments: {e}", file=sys.stderr)
                sys.exit(1)
        resp = run_mcp_command({
            "jsonrpc": "2.0",
            "id": 4,
            "method": "tools/call",
            "params": {"name": tool_name, "arguments": arguments},
        }, args.toolsets)
        print(json.dumps(resp, indent=2))


if __name__ == "__main__":
    main()
