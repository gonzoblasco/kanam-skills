---
name: "study-tracker"
description: "One skill to rule them all: course structure + gamification (levels/XP/badges) in a single source of truth under studies/<slug>/."
metadata:
  category: "Learning"
  tags:
    - studies
    - courses
    - books
    - documentation
    - progress
    - gamification
user-invocable: true
---

# Study Tracker - One Skill to Rule Them All

Single study skill. It merges what used to be two skills (a course-structure tracker and a gamified learning tracker) into a single source of truth under `studies/`. It works for ANY study: online courses (Codecademy, Udemy, etc.), technical books (Packt, O'Reilly), bootcamps, interview prep, loose topics.

## Single source of truth (IMPORTANT)

**Every study lives in `studies/<slug>/`.** Never use `study/` (singular) or any other path. The master index is `studies/README.md` - every course/book is registered there.

Why:
- `studies/` is the convention the master index already documented.
- A path-agnostic tracker caused the inconsistency in the first place: one book ended up in `study/` (singular) while a course was in `studies/`.
- After merging, the rule is one: **everything under `studies/<slug>/`**.

## Two study modes

The skill merges both capabilities:

### Mode A - Course structure
For courses with lessons/videos/quizzes (e.g. Codecademy, Udemy):
```
studies/<slug>/
├── README.md          # cover + progress table
├── <track>/           # optional, only if the course has tracks
│   └── <course>/
│       ├── notes/NN-title.md      # notes per lesson/video
│       ├── quiz/NN-question.md     # knowledge checks + model answers
│       └── exercises/               # hands-on exercises
```

### Mode B - Gamified structure
For deep study with levels, XP and badges (books, interview prep, structured topics):
```
studies/<slug>/
├── PLAN.md            # Layer 1: all levels + sublevels + topics (static)
├── level-N-topic.md   # Layer 2: notebook per level (grows with learning)
└── PROGRESS.md        # Layer 3: progress table, XP, badges, streak
```

The two modes **are not mutually exclusive**: an online course can also be gamified with levels/XP (Mode B over Mode A's structure). And a book can carry lesson notes. The rule is that **everything lives under `studies/<slug>/`** - the rest is format.

## The gamification pattern

**Level -> Sublevel -> Topic**, not the other way around. Each topic is a unit that completes and verifies on its own.

1. **Level -> Sublevel -> Topic** - level in big blocks, sublevel in small pieces.
2. **Document in 3 layers** - master plan (static) + artifact per level (grows) + progress record (updated every step).
3. **Gamify** - XP per topic, badges per level, practice streak, final boss (mock interview / full assessment).

## Workflow

### 1. Start a new study
1. Determine the **objective** (learn a course / prepare for an interview / read a book / complement something).
2. Create `studies/<slug>/` with its `README.md` (cover + progress).
3. If gamified: create `PLAN.md` (Layer 1) + an empty `PROGRESS.md` (Layer 3).
4. Register it in the master index `studies/README.md`.

### 2. Per unit (lesson, video, chapter)
1. Give the theory (named concepts, vocabulary).
2. Guide the practice (exercise, design, problem) if applicable.
3. Verify with a question / mock interview.
4. Update the note / level artifact (Layer 2) with what was learned.
5. Update the progress (Layer 3) - mark it, add XP.

### 3. Per level
1. Complete all topics.
2. Mock interview / full level assessment.
3. Self-review (rubric: what went well, what was missing).
4. Award the level badge.

### 4. Final boss (end of study)
1. Full interview/exam-style assessment (if applicable).
2. Close the progress (Layer 3).
3. Update the master plan (Layer 1) if needed.
4. Record the milestone in the daily log.

## Interview / JD prep mode

When the objective is preparing for a role, it gets richer:

**Two input sources:**
- **Input A - formal JD** (job description): extract stack, frameworks, critical levels, evaluation format.
- **Input B - external topic list** (from another AI, a course, the user): validate the list, structure it into levels/sublevels/topics, expand it with user context, verify topics before citing details (fetch prices/dates/specs, never assume).

**Input B variant - book index URL:** if the user passes a URL (Packt, O'Reilly, a mirror), `web_fetch` it to extract the real table of contents and use it as the source of truth for what to cover. If the direct fetch fails (403 anti-bot/Cloudflare), look for the TOC in mirrors or via web search. Group the chapters into logical levels.

**Two passes (map -> depth):**
- **First pass (mapping):** document ALL the content (overview + vocabulary + verification), creating the reference map. Adds no XP.
- **Second pass (mastery):** restart topic by topic in depth - real practice, out-loud verification, adding XP.

## Rules

- **Everything under `studies/<slug>/`** - NEVER `study/` or another path. One source of truth.
- **Level -> Sublevel -> Topic**, not the other way around.
- **Each topic verifies on its own** - don't wait to finish the level.
- **3 artifact layers** for the gamified mode, not one giant doc.
- **Progress updates after every step** - a small change.
- **Named vocabulary** in each topic.
- **Gamify** - XP, badges, streak, final boss.
- **Language:** document in the language of the session.
- **Plain hyphen (-)**, never an em dash.
- **Artifacts are not shared publicly** (personal study material).
- If an exercise grows into a "demo project" with real complexity, move it to `projects/` (it lives with its own repo).

## Relationship with other skills

- **technical-book-processor** - processes technical books chapter by chapter, generating ADRs and a portfolio project under `projects/`. study-tracker is for the user's personal study (under `studies/`); technical-book-processor is for leaving a public/portfolio trail. They complement each other.
- **curriculum-builder** - builds adaptive AI tutors (frontend + LLM). study-tracker documents the user's own study; curriculum-builder builds a tutor for others.
- **content-serializer** - serializes content. study-tracker is about the documentation structure of learning.

## Migration from the previous skills

This skill replaces two merged skills (a course-structure tracker and a gamified learning tracker). When migrating:
- Move anything in `study/` to `studies/<slug>/` (git mv) and delete `study/`.
- Keep `studies/README.md` as the master index, updated with every study.
- The gamification artifacts (plan, progress, levels) also live under `studies/<slug>/`.
