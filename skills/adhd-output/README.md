# ADHD Output

A response format that doesn't bury the answer.

## What is it for?

For when an agent answers you with three paragraphs of context before telling you what to do. This skill forces: **action first**, **numbered steps**, **one concrete next step** at the end.

## When to use it?

- You ask for "be direct", "no fluff", "action first"
- A debugging session where the answer is buried in prose
- You're overloaded and need the next step, not the analysis
- Long reviews where you have to separate finding from action

## The 10 rules

1. Lead with the next action
2. Number multi-step tasks
3. Close with a concrete next step
4. Suppress tangents
5. Restate the state each turn
6. Time estimates in minutes
7. Make wins visible
8. Matter-of-fact errors
9. Cap lists at 5 items
10. No preamble, no recap, no closing

## How is it used?

It is a style skill, not a content skill. It activates on explicit request or by context.

**Explicit request:**
> "Answer me in ADHD format"

**By context:**
> "I can't get started on this bug. What do I do?"

## Before / after

**Before:**
> Great question! Your auth flow has several pieces. Looking at src/auth.ts, the verifyToken function seems to use an old API... Hope this helps!

**After:**
> Run `npm install jsonwebtoken@latest`, then edit `src/auth.ts:42`.
>
> 1. Open `src/auth.ts`
> 2. Replace `verifyToken` (42-58)
> 3. Run `npm test -- auth.spec.ts`
>
> Next: paste me the first line of the failing test.

## Difference from `adhd-assistant`

| Skill | What it does |
|---|---|
| `adhd-assistant` | Life system: planning, breaking down tasks, body doubling |
| `adhd-output` | Response format: how it communicates |

Complementary. One can be active without the other.

## Files

| File | What it contains |
|---|---|
| `references/rules.md` | The 10 rules in detail, with rationale and counterexamples |
| `references/adaptations.md` | What changed from the original and why |
| `templates/response.md` | Response templates + output checklist |
| `scripts/check-output.sh` | Heuristic lint: preamble, closings, apologies, em dash, long lists |

## Using the script

```bash
skills/adhd-output/scripts/check-output.sh answer.md
echo "Great question! ..." | skills/adhd-output/scripts/check-output.sh
```

## Related skills

- [adhd-assistant](../adhd-assistant) - Life system and planning
- [anti-ai](../anti-ai) - AI idiom cleanup
- [session-lifecycle](../session-lifecycle) - Session structure

## Credit

Based on [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd) (MIT), adapted.
