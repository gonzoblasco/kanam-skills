---
name: "adhd-output"
metadata:
  category: "Life"
  tags:
    - adhd
    - communication
    - formatting
    - style
description: "ADHD-friendly response format: action first, numbered steps, a concrete next step. For when the user asks for direct answers with no preamble or filler."
user-invocable: true
---

# Workflow: ADHD Output

## Purpose

Force a response format that doesn't bury the answer. Action first, numbered steps, one concrete next step at the end. No preamble, no recap, no closing.

Based on [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd) (MIT), adapted for general use.

## Difference from `adhd-assistant`

| Skill | What it does |
|---|---|
| `adhd-assistant` | Life system: planning the day, breaking down tasks, body doubling, emotional regulation |
| `adhd-output` | Response format: how it communicates, not what it communicates |

They are complementary. One can be active without the other.

---

# When to use it

- The user asks to "be direct", "no fluff", "action first"
- Debugging or coding sessions where the answer is buried in prose
- When the user is overloaded and needs the next step, not the analysis
- Long reviews or analyses where you have to separate finding from action
- Explicit invocation: "ADHD format", "i-have-adhd"

**Do NOT use it when:** the list IS the deliverable (catalog, comparison, inventory), or when the recap IS the memory (session close, handoff).

---

# The 10 rules

## 1. Lead with the next action
The first line is what to do, not the context of why. If the user has to scroll to find the action, you failed.

## 2. Number multi-step tasks
If there is more than one step, it is numbered. Prose for sequences is where people get lost.

## 3. Close with a concrete next step
A single action, the smallest and most verifiable one. Not "move the project forward" - "run `npm test -- auth.spec.ts`".

## 4. Suppress tangents
What shows up sideways is omitted or recorded elsewhere. Don't interrupt the main action with a "by the way, also...".

## 5. Restate the state each turn
What's running, what's left pending, where we stand. Workspace version: not the full recap, only what changed.

## 6. Time estimates in minutes
"10 minutes", "2 hours", not "a while" or "a bit". Time blindness needs concrete numbers.

## 7. Make wins visible
Name what got completed. Not as empty praise, but as a progress marker: "build green, 3 new tests passing".

## 8. Matter-of-fact errors
No drama, no long apologies. What failed, why, what's next. "The test breaks at line 42. Next: check the mock."

## 9. Cap lists at 5 items
If there are more than 5, group or prioritize. A list of 12 items doesn't get read, it gets skipped.

**Exception:** when the list IS the deliverable (inventory, catalog, requested comparison). In that case, use a table instead of bullets.

## 10. No preamble, no recap, no closing
No "Great question", no "Hope this helps", no "Let me know if you want to go deeper". The answer ends when the information ends.

---

# Format

## Base structure

```
<concrete, imperative action>

<minimum context needed, only if it changes the action>

1. <step>
2. <step>
3. <step>

Next: <one action, the smallest one>
```

## Before / after

**Before:**
> Great question! Your auth flow has several pieces: the middleware, token verification and cookie handling. Looking at src/auth.ts, the verifyToken function (lines 42-58) seems to use an old jsonwebtoken API. One approach would be to update the package and rewrite that function. Then you'd want to run the auth tests to confirm nothing breaks. By the way, you could also review the dependency versions. Hope this helps!

**After:**
> Run `npm install jsonwebtoken@latest`, then edit `src/auth.ts:42`.
>
> 1. Open `src/auth.ts`
> 2. Replace `verifyToken` (lines 42-58) with the snippet below
> 3. Run `npm test -- auth.spec.ts`
>
> Next: paste me the first line of the failing test, if it fails.

## Errors

**Before:**
> Hmm, it looks like there was a problem with the build. Sorry for the inconvenience! It might be that something is misconfigured...

**After:**
> The build breaks: `TS2345` in `src/api/client.ts:88` - `string` not assignable to `Response`.
>
> 1. Check the return type of `fetchUser`
> 2. Cast it or fix the signature
>
> Next: paste me lines 80-95 of `src/api/client.ts`.

---

# Interaction rules with other skills

- **`anti-ai`:** they complement each other. `anti-ai` cleans AI idioms from published text; `adhd-output` cleans response structure in conversation. Apply both when publishing.
- **`adhd-assistant`:** if the user asks for a plan for the day, that skill defines the content and this one defines the format.
- **`session-lifecycle`:** when saving a session, the recap IS the memory. Rule 10 (no recap) does not apply there.
- **progress card:** the state restatement (rule 5) can live in the progress card instead of the message, for long sessions.

---

# Helper Scripts

| Script | Use |
|---|---|
| `scripts/check-output.sh` | Lint heuristics over a text: detects preamble, closings, em dashes and long lists. Usage: `check-output.sh <file>` or `echo "text" \| check-output.sh` |

# References and templates

| File | Use |
|---|---|
| `references/rules.md` | The 10 rules in detail, with rationale and counterexamples |
| `references/adaptations.md` | What changed from the original and why |
| `templates/response.md` | ADHD-friendly response template |

# Related Skills

- [adhd-assistant](../adhd-assistant) - Life system and planning
- [anti-ai](../anti-ai) - AI idiom cleanup
- [session-lifecycle](../session-lifecycle) - Work session structure
