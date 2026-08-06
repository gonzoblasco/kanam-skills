#!/usr/bin/env python3
"""
supabase-mcp.py — stdio wrapper for @supabase/mcp-server-supabase
Usage:
  python3 supabase-mcp.py list
  python3 supabase-mcp.py call list_projects
  python3 supabase-mcp.py call list_tables '{"project_id": "...", "schemas": ["public"]}'
"""

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path


def get_pat():
    secret_path = Path.home() / ".openclaw" / "secrets" / "supabase-pat"
    if secret_path.exists():
        return secret_path.read_text().strip()
    env_pat = os.environ.get("SUPABASE_PAT")
    if env_pat:
        return env_pat
    print("Error: SUPABASE_PAT not found. Store it in ~/.openclaw/secrets/supabase-pat or set SUPABASE_PAT env.", file=sys.stderr)
    sys.exit(1)


def run_mcp_command(req):
    pat = get_pat()
    proc = subprocess.Popen(
        ["npx", "-y", "@supabase/mcp-server-supabase@latest", "--access-token", pat],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    proc.stdin.write(json.dumps(req) + "\n")
    proc.stdin.flush()
    # Read response line by line until we get a matching id or process exits
    response_lines = []
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
    # Fallback: read whatever is left
    proc.wait(timeout=5)
    remaining = proc.stdout.read()
    if remaining:
        for line in remaining.strip().split("\n"):
            try:
                msg = json.loads(line.strip())
                if msg.get("id") == req["id"] or "result" in msg or "error" in msg:
                    return msg
            except Exception:
                continue
    return None


def initialize():
    req = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
            "protocolVersion": "2025-03-26",
            "capabilities": {},
            "clientInfo": {"name": "openclaw", "version": "1.0"},
        },
    }
    return run_mcp_command(req)


def tools_list():
    init = initialize()
    if init is None or "error" in init:
        print(json.dumps({"error": "init failed", "details": init}, indent=2))
        sys.exit(1)
    req = {
        "jsonrpc": "2.0",
        "id": 2,
        "method": "notifications/initialized",
    }
    run_mcp_command(req)

    req = {
        "jsonrpc": "2.0",
        "id": 3,
        "method": "tools/list",
    }
    resp = run_mcp_command(req)
    if resp is None:
        print(json.dumps({"error": "no response"}, indent=2))
        sys.exit(1)
    return resp


def call_tool(tool_name, arguments=None):
    init = initialize()
    if init is None or "error" in init:
        print(json.dumps({"error": "init failed", "details": init}, indent=2))
        sys.exit(1)
    req = {
        "jsonrpc": "2.0",
        "id": 2,
        "method": "notifications/initialized",
    }
    run_mcp_command(req)

    req = {
        "jsonrpc": "2.0",
        "id": 4,
        "method": "tools/call",
        "params": {"name": tool_name, "arguments": arguments or {}},
    }
    resp = run_mcp_command(req)
    return resp


def main():
    parser = argparse.ArgumentParser(description="Supabase MCP wrapper")
    parser.add_argument("command", choices=["list", "call"], help="Command")
    parser.add_argument("args", nargs="*", help="Tool name and optional JSON arguments")
    args = parser.parse_args()

    if args.command == "list":
        resp = tools_list()
        print(json.dumps(resp, indent=2))
    elif args.command == "call":
        if not args.args:
            print("Usage: python3 supabase-mcp.py call <tool_name> [json_args]", file=sys.stderr)
            sys.exit(1)
        tool_name = args.args[0]
        arguments = {}
        if len(args.args) > 1:
            try:
                arguments = json.loads(args.args[1])
            except json.JSONDecodeError as e:
                print(f"Invalid JSON arguments: {e}", file=sys.stderr)
                sys.exit(1)
        resp = call_tool(tool_name, arguments)
        print(json.dumps(resp, indent=2))


if __name__ == "__main__":
    main()
