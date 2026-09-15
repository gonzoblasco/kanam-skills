# Session Lifecycle

Complete lifecycle of an AI work session.

## What is it for?

To **structure every AI work session**: start (load context + memory), dispatcher (spawn sub-agents), execution, close (write HANDOFF, memory, CHANGELOG), tasks (turn pending items into actionable ones), and workspace commit.

## When to use it?

- When starting each work session
- When closing each session
- When you need to spawn sub-agents
- When there are pending items to turn into tasks

## How is it used?

### Phases

1. **Start** - load context, memory, handoff of the active project
2. **Dispatcher** - spawn sub-agents: fork (needs transcript) vs isolated (independent)
3. **Execution** - main work, decisions, files touched
4. **Close** - scan session, write HANDOFF, memory, CHANGELOG
5. **Tasks** - turn pending items into actionable ones (cron jobs or TODO.md)
6. **Commit** - commit + push the workspace

### Useful scripts

```bash
# Start session
./scripts/session-start.sh --project "my-app" --objective "Implement Google auth"

# Save session
./scripts/session-end.sh --project "my-app" --summary "Auth implemented, PR opened"
```

## References

| File | What it contains |
|---|---|
| `references/session-templates.md` | Templates: session start, session end, HANDOFF |
| `references/subagent-patterns.md` | Fork vs isolated, common patterns, handoff between sub-agents |

## Related skills

- [Incremental Implementation](../incremental-implementation) - To execute tasks within the session
- [Knowledge Management](../knowledge-management) - To record session learnings
