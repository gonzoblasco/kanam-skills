---
name: "anti-ai"
description: "Removes idioms and structures that give away AI-written text so it reads human. Includes the plain-hyphen rule. Use before publishing posts, feedback or PRs."
metadata:
  category: "Content"
  tags:
    - writing
    - humanize
    - anti-ai
    - editing
    - publishing
user-invocable: true
---

# Workflow: Anti-AI

## Purpose

Remove the "smell of AI" from any text before it goes out. It is not rewriting the content: it is stripping the factory marks that give away that a model wrote it, so it reads like a real person.

## Philosophy

> AI doesn't show in what it says, but in how it says it.

A human doesn't write with perfect transitions, forced triads or generic closings. This skill detects those patterns and replaces them with natural language.

## Base mandatory rule: plain hyphen

**NEVER use an em dash (U+2014) or an en dash (U+2013).** Always a plain hyphen (-). It is the hard rule and the most classic AI tell.

Mandatory mechanism: scan the text with a dash-check script before considering the edit done.

## When to use it

- Before publishing a post (a mandatory step in the flow, see below)
- Before sending feedback or comments on other people's PRs/issues
- Before publishing any text outward (docs, issues, PRs, comments)
- When reviewing text that sounds "too perfect" or generic

## Detection categories

### 1. Transition filler
"However", "it is important to note", "worth mentioning", "in conclusion", "on the other hand", repeated "moreover".

**Fix:** delete or replace with a natural connection. A human doesn't announce every turn.

### 2. Predictable structures
- Openings like "In today's world...", "In the era of...", "Nowadays..."
- Forced triads (three adjectives or three perfectly parallel items)
- Lists where every item has exactly the same length and rhythm

**Fix:** break the parallelism. Vary sentence length. Start directly, no preamble.

### 3. Adverbs and filler
"Effectively", "certainly", "undoubtedly", repeated "in fact", "really" adding nothing.

**Fix:** cut it. If the sentence works without the adverb, the adverb is excess.

### 4. False precision
"Approximately", "around", "nearly" when they add no real data.

**Fix:** either give the exact number or drop it. False precision is an AI mark.

### 5. Generic closing
"In summary", "to conclude", "hope this helps", "don't hesitate to reach out".

**Fix:** end on the idea, not the summary. A human closing stops when it's done.

### 6. Em dashes (U+2014 / U+2013)
The base case. Scan the text with the dash-check script.

**Fix:** replace with a plain hyphen (-) or restructure the sentence.

## Workflow

1. **Mechanical scan:** run the dash-check script over the text.
2. **Pattern pass:** review each category (1-5) and mark instances.
3. **Natural rewrite:** replace each instance with human language, preserving the message.
4. **Verification:** read it out loud. If it sounds like an essay, it still smells of AI.
5. **Golden rule:** if you're unsure whether a phrase is an AI mark, ask "would a human say this in a conversation?" If the answer is no, change it.

## Outputs

- Edited text with no AI marks
- List of removed instances (optional, for learning)
- Confirmation that it passed the em dash scan

## Principles

- Don't change the core message; only remove the AI smell
- Preserve the author's voice
- Less is more: if in doubt, cut
- The plain-hyphen rule is non-negotiable

## Related Skills

- [Copy Editing](../copy-editing): To improve marketing copy conversion (complementary, can be chained)
- [Skill Router](../skill-router): To suggest this skill when the context is publishing text outward
