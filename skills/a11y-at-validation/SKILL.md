---
name: "a11y-at-validation"
description: "When manual accessibility validation is mandatory in OSS, and how to run it."
---

# Skill: a11y-at-validation

## Goal

Know **when manual accessibility validation is mandatory** (not just recommended) before considering an a11y PR finished, and how to run and document it in an OSS collaboration context.

## Core rule: when manual validation is MANDATORY

Manual AT validation is **mandatory** (not optional) when the change affects **what a screen reader announces** (the spoken phrase, not the attribute) and that announcement is not verifiable by unit tests.

### Boundary: unit test vs manual

| Verifiable by unit test | Only manually verifiable |
|---|---|
| ARIA attributes in the DOM | What the screen reader announces (the phrase) |
| Roles, `aria-labelledby`, `aria-selected` | Announcement timing (when it is said, whether it is said) |
| Accessibility tree structure | Real interaction (roving focus, `aria-activedescendant`) |

**Golden case (2026-08-12, radix-ui/primitives):** PR #4109 added computed `aria-posinset`/`aria-setsize` in `useLayoutEffect`. The attributes were correct in the DOM (51 green tests), but manual validation with VoiceOver+Chrome revealed that the first option without preselection **announced nothing** (#4110) due to a timing race between item mount and the AT announcement. No unit test could catch it.

**Derived rule:** if your change touches `aria-*` that affects announcements, roles, roving focus or `aria-activedescendant`, manual validation is mandatory. Green tests are NOT enough.

## When to apply

Apply this flow in accessibility PRs in OSS repos (Radix, shadcn/ui, TanStack, astryx, etc.) when the change:

- Adds/modifies ARIA attributes that affect announcements (posinset, setsize, live regions, dynamic labels).
- Changes roles or interaction (roving focus, activedescendant, combobox/listbox).
- Ports text to nodes (e.g. portaling option text to the trigger).
- Handles mount timing (useLayoutEffect, effects that paint attributes after the first paint).

## Flow steps

### 1. Identify whether the change touches "announcement" (not just DOM)

If the change falls in the "only manually verifiable" column of the table, AT validation is mandatory. Document this BEFORE considering the PR finished.

### 2. Run manual validation

0. **If the repo has layout tests in a real browser (`.browser.test.*` with vitest), run them first** - it is the automatable evidence maintainers ask for (Adobe explicitly asked for it). In react-spectrum: `yarn vitest run --config=vitest.browser.config.ts --project=chromium-desktop <file>` and `--project=firefox-desktop`. Requires `npx playwright install chromium firefox` the first time. A layout test measures the bounding box of the hidden input against the visible component (what jsdom cannot validate) and is proof that the SR focus ring matches the visual. Document the matrix (browser x result) in the PR.

1. Start the local storybook/playground pointing at the PR branch (workspace build, not main).
2. Enable the system AT:
   - macOS: VoiceOver with **Cmd + F5**.
   - Enable **captions/live captions** (System Preferences -> Accessibility -> VoiceOver -> Verbosity -> Use captions) to visually confirm the announced phrase.
3. Test the edge cases, not just the happy path:
   - Without a preselected value (the first option is usually the broken case).
   - With a preselected value.
   - With grouping (Select.Group) if applicable.
   - "Clear"/placeholder option (empty value) - usually intentional, see step 3.
4. Record in a table what was expected vs what was announced, and whether the captions confirm it.

### 3. If a finding is detected: check whether it is intentional or a bug

BEFORE proposing to change the component, look in the code for whether the behavior is deliberate:

- Guards and comments that document the pattern (e.g. "consumer may render an item with empty value to act as a clear option").
- Functions like `shouldShowPlaceholder`.
- Documented primitive design patterns (e.g. APG).

**If it is intentional** (by design): do NOT touch the component with a PR. Document the finding in an issue with diagnosis + options, and leave the direction decision to the maintainers.

**If it is a real bug**: proceed with a PR, ideally with the finding documented.

### 4. Document the validation in the PR/issue

Comment on the PR with the manual validation evidence (what each case announced, confirmed captions). If there is a separate finding, open a separate issue and reference it - do not mix it with the main PR.

## Before reworking an a11y PR that fails CI: verify against main

When a maintainer reports that an a11y PR fails tests/lint, do NOT rework blindly. Verify first, with empirical evidence, two things:

1. **Does the reported bug exist in current main?** The issue may be old and already solved by another PR. Run the regression test against main (without the fix) - if it passes, the fix is unnecessary and the PR should be closed with the finding documented, not reworked.
2. **Is the fix's assumption about the data model true?** E.g. assuming `item.index` resets per section when in react-stately it is already global. Verify with a debug test that prints the real values (index, parentKey) in the real structure, not by reading the code.

**Method:** write a debug test that renders the real collection and logs the values the fix assumes, run it against main, and compare with what the fix expects. If the original code already produces the correct result, the fix breaks without fixing anything - close the PR with an honest comment instead of insisting.

**Derived rule:** a fix that "fixes" a bug that no longer exists, and that also breaks existing tests due to a false assumption, is not reworked - it is closed documenting the finding. Adobe's (and similar) AI-assisted policy additionally requires human SR validation, which cannot be fabricated.

**Rescue the regression test as a test-only PR:** if the fix is unnecessary but the regression test that accompanies it has value (passes against main and locks in the behavior), do not discard it with the closed PR. Extract it as a test-only PR: `git checkout -b test/<desc> origin/main`, apply only the test diff with `git show <commit> -- <test-file> | git apply`, verify it passes against main, open the PR (without production changes) and reference it in the closing comment of the original PR. That way the test's value survives without dragging the broken fix.

### Distinguish "broken fix" from "sibling test not updated"

When a maintainer reports red CI on an a11y PR, before deciding between closing or reworking, look for whether the failure comes from a **sibling test** that uses the same hook internally but kept the old behavior. E.g. react-spectrum: `SearchAutocomplete.test.js` uses `useComboBox` internally, so a change in the `useComboBox` announcement breaks its asserts even when the fix is correct.

**Method:** `grep -rln "expect(announce)" packages/` (or the assert that changed) to find all tests that depend on the modified behavior, not just the direct component test. If the fix is a valid direction and only the sibling test needs updating to the new behavior (same pattern as the already-updated component test), update it and push - do not close. If instead the fix breaks due to a false assumption about the data model, close it (previous case).

## Common errors

- **Considering an a11y PR finished with only green unit tests.** Tests verify attributes, not announcements.
- **Proposing to change a component before verifying whether the behavior is intentional.** Risk of a PR that breaks the primitive's contract.
- **Posting a comment on your own issue starting with "Thanks for opening this".** That phrase is for thanking someone else who reported; it is absurd when you opened the issue yourself. Start directly with the analysis.
- **Submitting a design PR without consensus.** Design changes to a mature primitive require prior discussion with maintainers, not a unilateral PR.

## Closing checklist

- [ ] Does the change touch announcement/role/interaction? -> manual validation done.
- [ ] Did I test the edge cases (no preselection, placeholder, groups)?
- [ ] Do captions confirm the announced phrase?
- [ ] Did I verify whether a finding is intentional (guards/comments/patterns) before touching the component?
- [ ] Did I document the evidence in the PR and separate findings into their own issues?
