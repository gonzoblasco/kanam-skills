---
name: "content-serializer"
description: "Convert content (courses, blog posts, docs) into weekly multi-platform social posts for LinkedIn and X."
metadata:
  category: Content
  tags:
    - content
    - linkedin
    - twitter
    - x
    - series
    - posts
    - tutorial
user-invocable: false
---

# Workflow: Content Serializer - Technical content into a weekly series

## Purpose

Convert technical content that already exists (a course, a blog, documentation) into a **weekly post series** for **LinkedIn** and **X**, with per-platform format, publishing calendar and adjustment metrics.

It's not for generating content from scratch - it's for **serializing material you already have** (the bootcamp, a tutorial, your docs) into consistent public presence.

## When to use it

- You have a finished course/tutorial/bootcamp and want to publish it as a series
- You want to turn documentation or notes into weekly posts
- You want to position yourself by publishing technical content sustainably

## Philosophy

> Publishing isn't "uploading content" - it's a weekly conversation with your audience.

The goal is not "posting for the sake of posting": it's building a series with an **arc**, where each post leans on the previous one and hooks into the next. Weekly consistency beats the isolated viral post.

---

## Phase 0: Personal brand voice

**When:** Always. Before writing any post, you must know **who is speaking**. It's your voice, not a generic ghostwriter's.

### Your voice (the user)

- **Direct and honest, no beating around the bush.** You say what you think. You don't dress it up to sound more "professional" - honesty IS your professionalism.
- **Sounds like a person, not a programming manual.** No corporate jargon or technical documentation tone. You write the way you talk.
- **Real first person.** "I built", "I found a bug", "it cost me". Not "it is built", not "one finds".
- **Loose and natural.** Short sentences. No filler. It should read like a dev telling a story, not like a press release.
- **With opinions.** You have judgment and you show it. You prefer some things, find others boring, disagree. That makes you human and sets you apart.
- **You document decisions, not just code.** You tell the "why", not only the "what I did". That's what positions you as senior.

### Golden rule of tone

> **The voice is the foundation, but it's NOT rigid - it adapts to the occasion.**

The personal brand tone is not a straitjacket. It modulates based on the post type:

| Occasion | How your voice sounds |
|---------|-------------------|
| **Technical deep-dive** (how you solved X) | Direct, concrete, with evidence. Honesty about the bug you found is gold. |
| **Announcement / launch** (the bootcamp, a release) | Measured enthusiasm, no fake hype. "I built this" instead of "Look at this INCREDIBLE project!". |
| **Thought-leadership / opinion** (a lesson, a stance) | Provocative but without cheap clickbait. Claim + evidence + why it matters. |
| **Request / CTA** (is it useful to you?, follow the series) | Direct and genuine. A single clear question, no begging. |

**Hard tone rules (non-negotiable):**
- **Never em dash (-).** Always use plain hyphen (-). The em dash is not on the keyboard and gives away that it's not a dev writing. (USER.md)
- **No "Great question!" or "I'd be happy to help!".** That fake chatbot warmth makes you sound like a bot.
- **No "in this post I'm going to teach you...".** Tell it, don't announce it.
- **Don't give yourself credit just for being you.** If something failed, say it. Technical vulnerability (I found a bug, I got it wrong) is your biggest credibility asset.

### Tone check before publishing

Re-read the post and ask yourself:
- [ ] Does it sound like the user, or like a programming manual?
- [ ] Is there any em dash (-) that should be a plain hyphen (-)?
- [ ] Is the lesson/opinion there, or only the "what I did"?
- [ ] Is it adapted to the occasion (deep-dive vs announcement vs opinion), or is it all the same?

---

## Phase 1: Source content inventory

**When:** You have the material. Before writing a single post, know what you have.

1. **List the units** of your content. For a course: the levels/modules/chapters. For a blog: the articles. For docs: the major sections.

2. **For each unit, extract** (note it in a table):
   - **Topic** - what it's about
   - **An insight / lesson** - the "why" worth sharing
   - **A piece of evidence** - an example, a result, a bug found
   - **A possible hook** - why someone would read it

3. **Mark the narrative arc** - the units aren't independent: they form a progression (in the bootcamp: from generating code to testing complete systems). That arc is your series.

> 💡 The insight isn't "what the level does" - it's *the lesson you learned*. In the bootcamp: "a validator you never saw fail protects you from nothing". That's what gets shared, not the technical detail.

---

## Phase 2: Per-platform adaptation

**When:** You have the inventory. Each unit becomes 1+ posts, with different format per platform.

### LinkedIn - storytelling + value

- **Length:** 150-300 words. Post + closing line.
- **Structure:**
  1. **Hook** (1 line) - the lesson/insight, in first person or as a provocative claim
  2. **Setup** (2-3 lines) - context: what you were building
  3. **Development** (3-6 lines) - the "how", with concrete evidence
  4. **Lesson** (2-3 lines) - the universal takeaway, applicable outside the context
  5. **CTA / closing** (1 line) - question, invitation, or "next level"
- **Tone:** your personal brand voice (Phase 0), modulated by the occasion.
- **Hashtags:** 3-5 at the end, relevant to the topic (#AIEngineering, #NodeJS, etc.)

### X - concise + thread

- **Single post:** max 280 characters. One sharp insight.
- **Thread:** 4-8 posts. Hook in the first, technical detail in the middle ones, lesson + CTA in the last.
- **Thread structure:**
  1. **Post 1 (hook):** the claim that sparks curiosity ("I built a microservices system with AI. The most expensive bug wasn't in the code - it was in the validator.")
  2. **Posts 2-5 (development):** steps, evidence, data. Each post self-contained but with continuity.
  3. **Final post (lesson + CTA):** the insight + question or invitation to follow the series.
- **Rule:** each post in the thread must make sense on its own (people read it standalone while scrolling).
- **No hashtag spam:** max 1-2, or none.

### Adaptation table (summary)

| Dimension | LinkedIn | X |
|-----------|----------|---|
| Format | 150-300 word post | 4-8 post thread |
| Tone | Storytelling + value | Sharp, direct |
| Hook | First person, provocative | Curiosity, claim |
| Hashtags | 3-5 at the end | 0-2 |
| CTA | Question or invitation | Question or "follow the series" |

---

## Phase 3: Weekly calendar

**When:** You have the adapted posts. Organize the publishing.

1. **Define the rhythm.** Default: **1 content unit per week** (1 LinkedIn post + 1 X thread per unit). Adjustable.

2. **Assign dates** in narrative arc order. The bootcamp: week 1 = level 1, week 2 = level 2, etc.

3. **Create the calendar** as a table:
   ```
   | Week | Unit | Topic | LinkedIn | X (thread) | Posted |
   |--------|--------|------|----------|----------|----------|
   | 1 | Level 1 | Hello World | ✅ | ✅ | - |
   | 2 | Level 2 | Prompts | ✅ | ✅ | - |
   ```

4. **Prep batch:** write 2-3 weeks of posts in advance (buffer). That way the publishing week is only "review and post", not writing under pressure.

> 💡 The weekly buffer is what makes the series sustainable. Publishing is the habit; writing ahead is what enables it.

---

## Phase 4: Publishing + metrics

**When:** You start publishing. The series adjusts with data, not opinions.

### Before publishing each post
- **Re-read out loud** - if it doesn't flow, it doesn't go.
- **Tone check (Phase 0)** - does it sound like the user and is it adapted to the occasion?
- **Insight check** - is the lesson there, or only the "what I did"?

### Metrics to track (per week)
- **LinkedIn:** impressions, reactions, comments. A comment is worth more than a like.
- **X:** impressions, likes, replies, retweets. A reply is the conversation signal.

### Adjustment rules (week to week)
- **If a format works** (many comments on LinkedIn, many replies on X) -> repeat it next week.
- **If a post dies** -> it's not necessarily bad content; it may be the hook. Change the hook and reuse the body.
- **If the audience asks for more of topic X** -> move it forward in the arc, push the rest back.

---

## Outputs

- Unit inventory (topic, insight, evidence, hook)
- LinkedIn posts (150-300 words each) + X threads (4-8 posts each)
- Weekly calendar with a 2-3 week buffer
- Metrics log + adjustment decisions

## Related Skills

- [Copy Editing](../copy-editing): Final review of each post before publishing
