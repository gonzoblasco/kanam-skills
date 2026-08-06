#!/usr/bin/env python3
"""
Template stdio MCP wrapper.
Copy and adapt for each new server.

Usage:
  python3 <server>-mcp.py list
  python3 <server>-mcp.py call <tool_name> '{"arg": "value"}'
"""
import json
import subprocess
import sys
import os
from pathlib import Path

SERVER_CMD = ["npx", "-y", "<package-name>"]  # replace
SECRET_PATH = Path.home() / ".openclaw" / "secrets" / "<name>-token"  # optional

def send(stdin, msg):
    line = json.dumps(msg)
    stdin.write(line + "\n")
    stdin.flush()

def recv(stdout):
    line = stdout.readline()
    if not line:
        sys.exit("server closed stdout")
    return json.loads(line)

def handshake(proc):
    send(proc.stdin, {
        "jsonrpc": "2.0",
        "id": 0,
        "method": "initialize",
        "params": {
            "protocolVersion": "2024-11-05",
            "capabilities": {},
            "clientInfo": {"name": "openclaw-mcp-wrapper", "version": "1.0.0"}
        }
    })
    init_resp = recv(proc.stdout)
    if "error" in init_resp:
        sys.exit(f"initialize failed: {init_resp['error']}")
    send(proc.stdin, {
        "jsonrpc": "2.0",
        "method": "notifications/initialized"
    })
    return init_resp

def list_tools(proc):
    send(proc.stdin, {"jsonrpc": "2.0", "id": 1, "method": "tools/list", "params": {}})
    return recv(proc.stdout)

def call_tool(proc, name, args):
    send(proc.stdin, {"jsonrpc": "2.0", "id": 2, "method": "tools/call", "params": {"name": name, "arguments": args}})
    return recv(proc.stdout)

def main():
    env = os.environ.copy()
    if SECRET_PATH.exists():
        env["<TOKEN_ENV>"] = SECRET_PATH.read_text().strip()  # replace

    proc = subprocess.Popen(SERVER_CMD, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, env=env)
    try:
        handshake(proc)
        if sys.argv[1] == "list":
            print(json.dumps(list_tools(proc), indent=2))
        elif sys.argv[1] == "call" and len(sys.argv) >= 3:
            args = json.loads(sys.argv[3]) if len(sys.argv) > 3 else {}
            print(json.dumps(call_tool(proc, sys.argv[2], args), indent=2))
        else:
            print("usage: list | call <tool> [args-json]")
    finally:
        proc.stdin.close()
        proc.wait()

if __name__ == "__main__":
    main()
