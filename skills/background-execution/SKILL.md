---
name: "background-execution"
description: "Patterns for running tasks in the background: exec + process, parallel worktrees, auto-notify, isolated workspaces"
metadata:
  category: "Workflow"
  tags:
    - background
    - processes
    - parallelism
    - exec
    - process
user-invocable: false
---

# Workflow: Background Execution

## Purpose
Run long, batch, or parallel tasks in the background using `exec` + `process`, with monitoring, completion notification, and workspace isolation. Complements `task-execution` for tasks that do not require constant interaction.

## When to use it
- Long tasks (>30s) that do not need constant supervision
- Batch processing (multiple files, reviews, fixes)
- Independent parallel tasks (one process per issue, per PR, per module)
- Any interactive process that requires PTY (coding agents, TUIs, REPLs)
- When you need to launch something and have it notify when it finishes without waiting for a heartbeat

## Principles

1. **Never wait passively.** If a task will take a while, launch it in the background and continue with something else.
2. **Always isolate.** Each task in its own temporary directory or git worktree. Never touch the main repo without explicit approval.
3. **Always notify.** Every background task must end with a wake event. Do not leave the user asking "is it done yet?".
4. **PTY for interactive, not for batch.** Interactive processes (coding agents, prompts) → `pty:true`. Batch scripts → `pty:false` (default).
5. **Always log.** Each background process leaves a log file with result, time, and metrics. Do not rely on session memory.
6. **Intervene before it is too late.** If a process shows no signs of life, intervene. Do not wait for it to hang permanently.

## Patterns

### Pattern 1: Launch and Monitor

The base pattern for any background task:

```yaml
# 1. Launch
exec(command: "...", pty: true, background: true, workdir: "/tmp/task-xyz")

# 2. Monitor (when you want to check status)
process(action: poll, sessionId: "<id>")

# 3. View logs
process(action: log, sessionId: "<id>", offset: 0, limit: 50)

# 4. Send input (if the process asks something)
process(action: submit, sessionId: "<id>", text: "y")

# 5. Kill (if it hangs)
process(action: kill, sessionId: "<id>")
```

**Rule:** after launching, do not poll loop. Continue with something else and let the completion wake notify.

### Pattern 2: Isolate in Temp Dir

For tasks that need a clean workspace:

```yaml
# 1. Create temp dir
exec(command: "mktemp -d")
# → returns /tmp/tmp.XXXXX

# 2. Clone / prepare in that dir
exec(command: "git clone <url> /tmp/tmp.XXXXX/repo", workdir: "/tmp/tmp.XXXXX")

# 3. Work there
exec(command: "npm run build", workdir: "/tmp/tmp.XXXXX/repo", background: true)

# 4. When done, clean up
exec(command: "trash /tmp/tmp.XXXXX")
```

**Rule:** always clean up when done. Use `trash` (not `rm -rf`) in case something goes wrong.

### Pattern 3: Git Worktree for Parallel Tasks

To work on multiple issues/PRs in parallel without contaminating the repo:

```yaml
# 1. Create a worktree per task
exec(command: "git worktree add -b fix/issue-78 /tmp/issue-78 main")
exec(command: "git worktree add -b fix/issue-79 /tmp/issue-79 main")

# 2. Launch a process in each worktree
exec(command: "<command>", workdir: "/tmp/issue-78", background: true, pty: true)
exec(command: "<command>", workdir: "/tmp/issue-79", background: true, pty: true)

# 3. Monitor all of them
process(action: list)

# 4. When done, merge and clean up
exec(command: "cd /repo/main && git merge fix/issue-78")
exec(command: "git worktree remove /tmp/issue-78")
```

**Rule:** one worktree per task. Name branches descriptively. Merge only after verifying that each task is complete.

### Pattern 4: Auto-Notify on Completion

So a background task notifies immediately when it finishes:

```yaml
# Include at the end of the command or script:
cron(action: wake, text: "✅ Task X completed: [summary]", mode: "now")
```

**Rule:** every background task MUST end with a wake event. Do not rely on heartbeats or on the user asking.

**Text format:** include what task, result (success/failure), and what is next. E.g.: "✅ Batch review completed: 3 PRs reviewed, 1 with requested changes. Review PR #78."

### Pattern 5: Parallel Batch with Sessions Spawn

For tasks that require conversational context (reviews, analysis):

```yaml
# Launch sub-agents in parallel
sessions_spawn(task: "Review PR #78 in <repo>", context: "isolated")
sessions_spawn(task: "Review PR #79 in <repo>", context: "isolated")

# Wait for results
sessions_yield()
```

**Rule:** use `sessions_spawn` for tasks that need reasoning. Use `exec` + `process` for tasks that are pure commands (build, test, batch script).

### Pattern 6: submit vs write - Input to Processes

When a background process waits for input:

| Action | What it does | When to use it |
|---|---|---|
| `process(action: submit, text: "y")` | Writes text + Enter | Responses to prompts ("Continue? [y/N]") |
| `process(action: write, data: "text")` | Writes raw text (no Enter) | Streaming, partial input |
| `process(action: send-keys, keys: ["ctrl+c"])` | Sends key combination | Interrupt, exit insert mode |

### Pattern 7: Intervention - Detecting and Rescuing Hung Processes

When a background process shows no signs of life:

```yaml
# 1. Check if it is still alive
process(action: poll, sessionId: "<id>")

# 2. If it is alive but produces no output, view recent logs
process(action: log, sessionId: "<id>", offset: -20)

# 3. If it is waiting for input without showing a prompt, send a signal
process(action: send-keys, sessionId: "<id>", keys: ["ctrl+c"])
# or force exit
process(action: submit, sessionId: "<id>", text: "exit")

# 4. If it does not respond, kill it
process(action: kill, sessionId: "<id>")

# 5. Decide: retry with less load, or escalate
```

**Signs of a hung process:**
- `process(action: poll)` returns "running" but there is no new output in minutes
- The process should have finished but is still active
- Logs show the same message repeated (infinite loop)

**Rule:** if a process has been running for more than double the expected time without new output, intervene. Do not wait for it to hang permanently.

### Anti-pattern: the polling loop of ephemeral sessions

**Symptom:** `process(action: poll, sessionId: "<id>")` returns `No session found for <id>` right after launching an `exec` in the background.

**Cause:** some background `exec` use ephemeral sessions that are not accessible for `process poll`. The real result is obtained by reading the command's log file or waiting for the completion wake, not by querying the session.

**Anti-pattern to avoid:** when `process poll` says `No session found`, do NOT chain `sleep N && ps -p <pid>` in a loop waiting for the process to finish. That can become an infinite loop that burns context and real time (it happened: ~25 min of polling for a 10s build).

**Correct:**
```
# 1. Run with a bounded timeout and yieldMs, redirecting to a log file
exec(command: "npm run build > /tmp/build.log 2>&1; echo EXIT=$?; tail -6 /tmp/build.log", yieldMs: 60000)

# 2. If the tool returns the output directly, use it. If it returns a session
#    that later does not respond, re-read the log file with a single
#    read/exec call instead of poll looping.
exec(command: "tail -20 /tmp/build.log")
```

**Golden rule:** if `process poll` does not find the session, do not insist with sleep/ps. Re-read the command's log file once. If it is not ready yet, let the completion wake notify and continue with something else.

### Pattern 8: Consolidating Parallel Results

After launching N processes in parallel, consolidate results:

```yaml
# 1. Each process writes its result to a shared file
exec(command: "echo '{\"status\":\"ok\",\"task\":\"issue-78\"}' >> /tmp/batch-results.jsonl")

# 2. At the end, read all results
exec(command: "cat /tmp/batch-results.jsonl")

# 3. Consolidate: count successes, failures, pending
# 4. Decide next steps based on results
```

**Result format (each process writes one JSON line):**
```json
{"task": "issue-78", "status": "ok", "duration": 45, "output": "summary"}
{"task": "issue-79", "status": "fail", "duration": 120, "error": "timeout at step 3"}
```

**Rule:** do not consolidate in memory. Each process writes its result to disk. Then read everything together.

### Pattern 9: Process Logging

Each background process must leave a trace:

```yaml
# When launching, redirect output to a log file
exec(command: "<command> 2>&1 | tee /tmp/logs/task-xyz-$(date +%s).log", background: true)

# Or at the end, write a summary
exec(command: "echo 'Task completed: $(date)' >> /tmp/logs/task-xyz-result.txt")
```

**What to log per process:**
- Start and end timestamp
- Executed command
- Exit code (0 = success, != 0 = failure)
- Output summary (first and last lines)
- If it failed: error message

**Rule:** background process logs are saved in `/tmp/logs/` with a descriptive name. They are cleaned up when saving the session or when they exceed 50MB.

## PTY Rules

| Process type | pty | Reason |
|---|---|---|
| Coding agent (Codex, Claude Code) | `true` | They are interactive TUIs, without PTY they hang |
| Batch script (build, test, lint) | `false` | Does not need a terminal, saves resources |
| REPL (node, python, psql) | `true` | Waits for interactive input |
| git command | `false` | Batch, not interactive |
| npm/pnpm command | `false` | Batch, structured output |

## Integration with task-execution

When a `task-execution` task has steps that are long or parallelizable:

1. **Plan** normally in `task-execution`
2. **The batch/parallel steps** run with these patterns
3. **Monitor** with `process` or wait for wake events
4. **Consolidate results** with pattern 8
5. **Continue** when all background steps completed

## Outputs
- Launched and monitored processes
- Consolidated results on completion
- Notification wake events
- Cleaned temp dirs / worktrees
- Logs for each process in `/tmp/logs/`

## Quality tooling

When a background task modifies skill scripts of the workspace, run `npm test` before considering it complete. This runs `test-skills.sh`, bats and pytest.

## Related Skills

- [Task Execution](../planning-and-task-breakdown): For the full task workflow
- [Session Lifecycle](../session-lifecycle): For handoffs and session saving
- [Debug Investigation](../debugging-and-error-recovery): For debugging failing processes
