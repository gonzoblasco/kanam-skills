---
name: "narrative-content"
metadata:
  category: "Content"
  tags:
    - fiction
    - writing
    - narrative
    - novels
    - workshop
description: "Your fiction writing workshop: mentorship, techniques, and guidance to write novels, short stories, and any story."
user-invocable: false
---

# Workflow: Narrative Content - Your Writing Workshop

## Purpose

This skill is your writing companion. It is not a checklist - it is a mentor that guides you based on where you are in your writing journey. It teaches you techniques, helps you get unstuck, and gives you structure without tying you down.

## Philosophy

> Writing is rewriting. But first you have to write.

There is no guilt here, no "I should write more", no comparison. There is a project, a plan, and the desire to tell a story. The rest gets built step by step.

---

## Entry menu

What do you want to do today?

| Option | What for | Recommended script |
|---|---|---|
| **📝 Start a new story** | You have an idea and want to turn it into a plan | `outline-generator.sh` |
| **📐 Structure what you already have** | You have loose scenes or a messy draft | `outline-generator.sh` |
| **✍️ Write the next chapter** | You know what comes next, you need to sit down and write | `progress-tracker.sh --add <words>` |
| **🔍 Revise what you wrote** | You finished something and want to improve it | `revision-check.sh` |
| **📦 Export / publish** | You want DOCX, EPUB, or Markdown | `export-novel.py` |
| **🎯 Pick a genre** | You don't know what your genre is, or you want to explore | - |
| **🧊 I'm stuck** | Writer's block, lost direction, "this is garbage" | - |
| **📚 I want to learn** | You want to improve your craft | - |

Pick an option and let's go.

## Helper Scripts

Scripts in `skills/narrative-content/scripts/`:

| Script | Use |
|---|---|
| `outline-generator.sh` | Generates a structured outline from a premise. Use in Phase 1-2. |
| `progress-tracker.sh [--log file] [--add words] [--status]` | Logs words written per day and shows your streak. Use in every writing session. |
| `revision-check.sh` | Checks chapter structure, arcs, consistency. Use in Phase 4. |
| `export-novel.py` | Exports the novel to Markdown, DOCX or EPUB. Use in Phase 6. |
| `character-sheet.sh` | Creates a character sheet. Use in Phase 2-3. |


---

## Phase 1: Premise - From idea to plan

**When:** You have an idea, an image, a character, or just the urge to write something.

### What we're going to do

1. **Find your central idea** - what is it really about? Not the plot, the heart.
2. **Test that it works** - does the idea sustain a novel? A short story? A saga?
3. **Define genre and tone** - what kind of story is it? What will the reader feel?
4. **Write the premise in 1-2 sentences** - if you can't summarize it, it isn't clear.

### Premise exercises

**"What if..."**
> What if the dead could talk, but only told lies?
> What if the last librarian of humanity had to burn books to survive?

**"And then..."**
> A detective finds a letter from his future self. And then he discovers the killer is himself.

**"But..."**
> A woman discovers she can travel through time. But every trip costs her a year of life.

### Premise test

- [ ] **Does it have conflict?** - no conflict, no story
- [ ] **Is it specific?** - "a boy discovers he's special" is not a premise
- [ ] **Does it have a hook?** - why would someone want to read this?
- [ ] **Does it excite you?** - you'll spend months on this. It has to matter to you.

### Output of this phase

- Premise in 1-2 sentences
- Genre and tone defined
- Decision: novel, short story, or series?

---

## Phase 2: Structure - The skeleton

**When:** You have the premise. Now you need to know what happens and in what order.

### What we're going to do

1. **Pick a structure** - Three-Act, Hero's Journey, Save the Cat!, Snowflake
2. **Go from structure to scene list** - each beat → one or more scenes
3. **Identify weak scenes** - the ones with no conflict or that change nothing
4. **Define the protagonist's arc** - how do they change from start to finish?

### Which structure to pick?

| If your story is... | Use |
|---|---|
| **Epic, fantasy, adventure** | Hero's Journey |
| **Thriller, mystery, fast-paced** | Three-Act |
| **Romance, commercial, mainstream** | Save the Cat! |
| **Complex, multiple POVs** | Snowflake Method |
| **You don't know** | Three-Act (it's the most flexible) |

> **See:** [Narrative Structures](./references/narrative-structures.md) for details on each one.

### From structure to scene list

Take each beat of the structure and turn it into 1-3 scenes:

```
Three-Act:
  Act I - Setup
    Inciting Incident → Scene 1: [description]
                       → Scene 2: [description]
    First Plot Point  → Scene 3: [description]
```

Every scene must have:
- **POV** - who sees this scene?
- **Goal** - what does the character want?
- **Conflict** - what stands in the way?
- **Change** - how do they come out different?

### Output of this phase

- Chosen structure
- Scene list (scene by scene)
- Protagonist's arc defined

---

## Phase 3: Drafting - Write, don't edit

**When:** You have the plan. Now it's time to write.

### What we're going to do

1. **Write without editing** - the draft is for discovering the story
2. **Use drafting techniques** - vomit draft, pomodoro, word count goals
3. **Keep the pace** - don't stop to fix, don't look back
4. **Track progress** - no pressure, just data

### Vomit Draft

Write without stopping, without correcting, without looking back.

**Rules:**
- No editing - not even typos
- Don't read what you wrote yesterday
- No judging - "this is garbage" is part of the process
- Don't stop - if you don't know what comes next, write "I don't know what comes next" until something occurs to you

**Goal:** 250-500 words per session. It doesn't matter if they're bad. Bad gets fixed later.

### Assisted co-writing

AI can help you, but **it doesn't write for you**. Use it to:

- **Get unstuck:** "Give me 3 ways this character could get out of this situation"
- **Explore options:** "What if instead of X, Y happened?"
- **Quick feedback:** "Does this dialogue sound natural?"
- **Research:** "What did people wear in Victorian England?"

**Don't use AI to:**
- Write entire paragraphs for you (it shows, and it isn't yours)
- Replace your narrative voice
- Decide the plot (the best decisions are yours)

### Output of this phase

- Written chapters (draft)
- Writing log with progress

### Automatic logging

Every 1-2 chapters (or at the end of each session), run the logging protocol:

1. **Persist to the project's main file** (`projects/<slug>/<slug>.md`):
   - Append the new content at the end of the matching section
   - Keep the chapter numbering structure

2. **Update STATUS.md** in `.knowledge/STATUS.md`:
   - Log what was written (chapters, new characters, twists)
   - Keep an up-to-date summary of the project state

3. **Commit to the project repo:**
   ```bash
   cd projects/<slug> && git add -A && git commit -m "feat: <summary of what was written>"
   ```

4. **Commit to the workspace** (including the skills mirror):
   ```bash
   cd <workspace> && rsync -a --delete --exclude='.DS_Store' skills/ .github/skills/ && git add -A && git commit -m "feat(<slug>): <summary>" && git pull --rebase && git push
   ```

**Exceptions:**
- If the chapter is very short (< 10 lines), you can wait for the next one
- If you're in the middle of a scene you can't interrupt, finish the scene first
- Don't wait more than 2 chapters without logging
- If the session is about to close, log everything before closing

---

## Phase 4: Revision - From draft to story

**When:** You finished the draft. Now start again, but better.

### The 3 levels of revision

Always in this order:

```
1. Structural Revision   → Does the story work?
2. Line Revision         → Does each scene work?
3. Copy Revision         → Does each word work?
```

### Level 1: Structural

- Read the whole story in one sitting
- Does the protagonist's arc work?
- Is every scene necessary?
- Are there plot holes?
- **Don't fix commas yet**

### Level 2: Line

- Does every scene have conflict?
- Does the dialogue sound natural?
- Is the pacing right?
- Does every character have a distinct voice?

### Level 3: Copy

- Repeated words
- Unnecessary adverbs
- Passive voice
- Punctuation and spelling

> **See:** [Revision Guide](./references/revision-guide.md) for the full detail.

### Output of this phase

- Revised story (structural, line, copy)
- Revision log with issues found and resolved

---

## Phase 5: Export - Ready to publish

**When:** The story is ready. You want it in a publishable format.

### Available formats

| Format | What for | How |
|---|---|---|
| **Markdown** | Web, GitHub, collaborative editing | `export-novel.py --format md` |
| **DOCX** | Word, Google Docs, printing | `export-novel.py --format docx` |
| **EPUB** | eBook, Kindle, e-readers | `export-novel.py --format epub` |

### Output of this phase

- File exported in the chosen format
- Ready to share, publish, or print

---

## 🧊 I'm stuck - Writer's Block Rescue

Writer's block is not a lack of inspiration - it is fear of writing badly.

### Diagnose the block

| Symptom | Likely cause |
|---|---|
| "I don't know what to write" | You're not clear on what comes next in the story |
| "Everything I write is bad" | You're judging too early |
| "I don't feel like it" | Fatigue, saturation, you need a break |
| "I lost the thread" | The story went somewhere you didn't plan |
| "This doesn't interest me anymore" | Maybe the project isn't for you (and that's fine) |

### Rescue techniques

1. **Write 100 words of garbage** - on purpose. "This is garbage and I know it." After 100 words, the block usually breaks.
2. **Switch scenes** - write the scene you most want to write, even if it's from the end.
3. **Write out of order** - you don't need to write chronologically.
4. **Switch medium** - write by hand, in a different app, on a napkin.
5. **Speak the scene** - record yourself telling it as if to a friend.
6. **Skip the block** - write "BLOCK HERE" and move on to the next scene.

---

## 📚 I want to learn - Resources

### Skill references

| Reference | What for |
|---|---|
| [Genre Guide](./references/genre-guide.md) | 8 genres with structure, pitfalls, touchstones |
| [Narrative Structures](./references/narrative-structures.md) | 4 narrative structures in detail |
| [Scene Craft](./references/scene-craft.md) | Anatomy of a scene, template, checklist |
| [Dialogue](./references/dialogue.md) | How to write dialogue that sounds real |
| [Character Development](./references/character-development.md) | Character sheets, archetypes, motivation |
| [Worldbuilding](./references/worldbuilding.md) | World construction, consistency, show don't tell |
| [Revision Guide](./references/revision-guide.md) | 3 levels of revision with checklist |
| [Writing Routines](./references/writing-routines.md) | ADHD-friendly routines, word count goals, tracking |

### Recommended reading

**On the craft:**
- *On Writing* - Stephen King (part memoir, part manual)
- *Bird by Bird* - Anne Lamott (writing and life)
- *The Anatomy of Story* - John Truby (narrative structure)
- *Steering the Craft* - Ursula K. Le Guin (the craft of writing)

**On specific genres:**
- *The Fantasy Fiction Formula* - Deborah Chester
- *Writing the Thriller* - T. Macdonald Skillman
- *Romance Writing* - various (workshop-based)

---

## Scripts

| Script | What for |
|---|---|
| [outline-generator.sh](./scripts/outline-generator.sh) | Generates an outline from a premise |
| [character-sheet.sh](./scripts/character-sheet.sh) | Creates character sheets |
| [export-novel.py](./scripts/export-novel.py) | Exports to DOCX, EPUB, MD |
| [revision-check.sh](./scripts/revision-check.sh) | Checks narrative consistency |
| [progress-tracker.sh](./scripts/progress-tracker.sh) | Word count and streak tracking |

## Related Skills

- [Copy Editing](../copy-editing): For the final text revision
- [Planning & Task Breakdown](../planning-and-task-breakdown): For visual timelines of complex stories
