#!/usr/bin/env python3
"""Score an MCP candidate against the evaluation criteria and return a decision."""
import json
import sys

criteria = [
    {"id": "native", "question": "Does OpenClaw have native coverage?", "decisive": True, "if_yes": "discard"},
    {"id": "open_source", "question": "Is the source code inspectable?", "decisive": False, "if_no": "discard"},
    {"id": "maintained", "question": "Maintained in the last 3 months?", "decisive": False, "if_no": "standby"},
    {"id": "free_tier", "question": "Does the free tier actually work?", "decisive": True, "if_no": "discard"},
    {"id": "api_key_ok", "question": "Auth model is API key in ~/.openclaw/secrets/?", "decisive": False, "if_no": "ask"},
    {"id": "stable", "question": "tools/list and sample call work?", "decisive": False, "if_no": "standby"},
    {"id": "redundant", "question": "Overlaps with an existing skill?", "decisive": True, "if_yes": "absorb"},
    {"id": "risk", "question": "Can it post publicly or access personal accounts?", "decisive": True, "if_yes": "ask"},
]


def evaluate(answers: dict) -> dict:
    """answers: dict of criterion id -> 'yes'/'no'/'unknown'."""
    reasons = []
    decision = "install"
    for c in criteria:
        ans = answers.get(c["id"], "unknown")
        if ans == "yes" and c.get("if_yes"):
            if c["if_yes"] in ("discard", "ask"):
                return {"decision": c["if_yes"], "reasons": [f"{c['question']} -> yes"], "answers": answers}
            if c["if_yes"] == "absorb":
                decision = "absorb"
                reasons.append(f"{c['question']} -> yes")
        elif ans == "no" and c.get("if_no"):
            if c["if_no"] in ("discard", "standby", "ask"):
                return {"decision": c["if_no"], "reasons": [f"{c['question']} -> no"], "answers": answers}
            if c["if_no"] == "absorb":
                decision = "absorb"
                reasons.append(f"{c['question']} -> no")
    return {"decision": decision, "reasons": reasons, "answers": answers}


def main():
    if not sys.stdin.isatty():
        answers = json.load(sys.stdin)
    else:
        answers = {}
        for c in criteria:
            answers[c["id"]] = sys.argv[sys.argv.index(f"--{c['id']}") + 1] if f"--{c['id']}" in sys.argv else "unknown"
    result = evaluate(answers)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
