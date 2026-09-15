---
name: "clawdstrike"
description: "Security audit of the OpenClaw gateway"
---

# clawdstrike

## Description
Runs a security audit against an OpenClaw gateway deployment. Evaluates network exposure, firewall state, filesystem hygiene, plugin supply chain, and configuration keys. Emits an OK/VULNERABLE report with severity levels, redacted evidence and fix instructions.

## When to use it
- To verify whether the OpenClaw gateway is reachable from outside the local network
- To audit third-party skills and plugins for supply chain risks
- To verify firewall and port configuration on the host
- To review filesystem permissions and symlinks on the gateway machine
- To produce a shareable security report before giving the team access

## Workflow
1. Run clawdstrike
2. The script collects system information (verified allowlist)
3. Evaluates against the security checklist
4. Produces a report with severity, evidence and fix instructions
5. Review the report and apply fixes by priority

## Related tooling

| Skill / Script | Use |
|---|---|
| `code-review-and-quality` | Secret and hardcoded URL scanning in workspace files (absorbed into review-quality). |
| `engineering-governance/scripts/secret-scan.sh` | Additional credential scanning in skills and configuration. |
| `arc-trust-verifier` | Assess the trustworthiness of third-party skills and plugins (supply chain). |

## Notes
- Operates from a strict verified allowlist
- Does not run untrusted remote code
- Does not modify system state
