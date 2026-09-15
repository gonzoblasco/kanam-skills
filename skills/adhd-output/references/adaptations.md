# Adaptations from the original

The original skill is [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd) (MIT), designed for CLI coding agents. These are the differences and why.

---

## Changes

### "No recap" -> "Minimal recap of what changed"

**Original:** no recap at all.

**Adapted:** restate only what changed (what's running, what's left, where we stand).

**Why:** in a long-running workspace the memory is the point. The recap is not noise, it is continuity. In a session that runs for hours, knowing where you stand is the difference between resuming and re-discovering. But the full recap of everything is noise - hence "only what changed".

### "Cap at 5 items" -> with an explicit exception

**Original:** hard cap at 5.

**Adapted:** cap by default, exception when the list IS the deliverable.

**Why:** in an inventory, catalog or requested comparison, cutting to 5 destroys the value. The rule exists to force prioritization, not to mutilate deliverables. When the list is the deliverable, use a table instead of bullets.

### "Restate state every turn" -> workspace version

**Original:** restate the state every turn in the message.

**Adapted:** the restatement can live in the progress card instead of the message.

**Why:** in long sessions the progress card is the state surface; duplicating it in the message is noise. The message carries the action, the card carries the state.

### Local context

- Language: keep documentation in the language of the session.
- Added an interaction section with `anti-ai`, `adhd-assistant` and `session-lifecycle`.
- Added a format lint script (`scripts/check-output.sh`), which the original does not have.

---

## What was NOT changed

- **Action first.** No exception.
- **Numbered steps.** No exception.
- **Concrete next step.** No exception.
- **Time estimates in minutes.** No exception.
- **Matter-of-fact errors.** No exception.
- **No preamble or closing.** No exception.
- **Make wins visible.** No exception.
- **Suppress tangents.** No exception.

---

## When NOT to apply this skill

| Situation | Why |
|---|---|
| Session close / handoff | The recap IS the deliverable |
| The user asks for exploratory analysis | Exploration needs the development, not just the conclusion |
| Pedagogical explanation | The step-by-step reasoning IS the value |
| The user asks for a long list | The list is the deliverable |
| Casual conversation | There's no action, just talk |

The general rule: if the user asked for the process, give the process. If they asked for the result, give the result. This skill is for the latter.

---

## License

The original is MIT (c) ayghri. This adaptation keeps the spirit and the 10 rules; the changes are contextual (language, exceptions, scripts).
