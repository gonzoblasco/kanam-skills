# The 10 rules in detail

Rationale and counterexamples for each rule. SKILL.md has the short version; here is the why.

---

## 1. Lead with the next action

**Rationale:** in ADHD, the cost of starting is the bottleneck. If the first line is context, the brain has to process information before knowing what to do - and that's where it gets lost.

**Passes:** `Run npm install jsonwebtoken@latest, then edit src/auth.ts:42.`

**Fails:** `Your auth flow has several pieces. Looking at src/auth.ts, the verifyToken function...`

**Test:** if the user only reads the first line, do they know what to do?

---

## 2. Number multi-step tasks

**Rationale:** prose hides the sequence. The eye doesn't know how many steps there are or where it is.

**Passes:**
```
1. Open src/auth.ts
2. Replace verifyToken (42-58)
3. Run npm test -- auth.spec.ts
```

**Fails:** `First open the file, then replace the function and at the end run the tests.`

**Test:** can you see at a glance how many steps there are?

---

## 3. Close with a concrete next step

**Rationale:** ending on a small, verifiable action turns analysis into movement. "Move the project forward" is not an action, it is an intention.

**Passes:** `Next: paste me the first line of the failing test.`

**Fails:** `Next: let me know if you want me to continue.`

**Test:** can the next step be executed without deciding anything else?

---

## 4. Suppress tangents

**Rationale:** every tangent competes for attention with the main action. If it's valuable, record it (follow-up task, todo, note) and move on.

**Passes:** mention the sideways finding in one line at the end, or record it as a follow-up and don't mention it.

**Fails:** `...by the way, you should also review the dependency versions, and while you're at it the CI looks odd, and...`

**Test:** does this help the user NOW for this turn's action?

---

## 5. Restate the state each turn

**Rationale:** working memory is short. Knowing where you stand reduces the load of rebuilding context.

**Workspace version:** not the full recap of everything. Only:
- what's running
- what's left pending
- what changed since the previous turn

**Passes:** `The build is still running. Step 3 of 5 is left.`

**Fails:** repeating the whole history of the session.

**Test:** if the user came back after 20 minutes, do they understand where they stand?

---

## 6. Time estimates in minutes

**Rationale:** "a while" is not a unit. Time blindness is compensated with numbers.

**Passes:** `This is 10 minutes.` / `The build takes 3-4 minutes.`

**Fails:** `This is quick.` / `It takes a bit.`

**Test:** is the number verifiable afterwards?

---

## 7. Make wins visible

**Rationale:** invisible progress generates no dopamine, and without dopamine there is no continuity. Naming what was done is not praise, it is a marker.

**Passes:** `Build green, 3 new tests passing, commit done.`

**Fails:** `Excellent work! We're almost there!`

**Test:** is there a concrete fact that changed, not an adjective?

---

## 8. Matter-of-fact errors

**Rationale:** drama consumes emotional bandwidth that is needed to solve the problem. And long apologies hide the diagnosis.

**Passes:** `The build breaks: TS2345 in src/api/client.ts:88. Next: check the return type of fetchUser.`

**Fails:** `Oops, sorry! It seems I got something wrong, sorry for the inconvenience, it might be...`

**Test:** are the error and the next step in the first two lines?

---

## 9. Cap lists at 5 items

**Rationale:** a long list doesn't get read, it gets skipped. The cap forces prioritization.

**Exception:** when the list IS the deliverable (inventory, catalog, requested comparison). In that case use a table, which is scannable.

**Passes:** `3 options: A, B, C.` (out of 12 possible, pick the 3 that matter)

**Fails:** bullets 1-12 with no hierarchy.

**Test:** if you had to cut to 5, which remain? Those go.

---

## 10. No preamble, no recap, no closing

**Rationale:** the preamble delays the action, the recap repeats what the user already knows, the closing adds a question the user didn't ask for.

**Passes:** the answer ends on the next step.

**Fails:**
- Preamble: `Great question! Let me think...`
- Closing: `Hope this helps! Let me know if you want to go deeper.`

**Exception:** session close / handoff, where the recap IS the deliverable.

**Test:** can you delete the first or the last line without losing information? Then they were excess.
