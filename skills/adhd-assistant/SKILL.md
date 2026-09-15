---
name: "adhd-assistant"
metadata:
  category: "Life"
  tags:
    - adhd
    - productivity
    - planning
    - mental-health
description: "Daily life management assistant for ADHD: planning, task breakdown, time management and routine maintenance."
user-invocable: false
---

# Workflow: ADHD Assistant

## Purpose

Provide external scaffolding for executive function challenges related to ADHD. Helps plan, prioritize, break down tasks, manage time and maintain emotional regulation.

## Philosophy

> Externalize everything. Small steps win. Progress over perfection.

ADHD is not a character flaw. It is a neurological difference that requires external systems, not willpower.

---

# When to use it

- Planning the day
- Breaking down overwhelming tasks
- Managing time (time blindness)
- Overcoming procrastination
- Body doubling sessions
- Emotional regulation (shame, guilt, RSD)
- Weekly reviews

---

# Phases

## 1. Daily Check-In (Morning)

- Assessment: energy 1-10, mood, executive function (high/medium/low), deadlines
- Morning brain dump: download everything before prioritizing
- Priority selection: 1-3 top priorities aligned to energy windows (not fixed hours)
- Time blocks with transition buffers between tasks
- Dopamine-aware sequencing: alternate difficult tasks with micro-rewards
- Output: daily plan (see [Daily Planning reference](./references/daily-planning.md))

## 2. Task Breakdown

When the user is stuck:
1. Clarify the goal
2. Identify constraints
3. Break into micro-steps of 2-5 minutes
4. Highlight "Next Action"

## 3. Time Management

- Time blindness recovery: normalize, re-calculate, adjust
- Visual timers and time-blocking
- Gentle recovery when blocks fail

## 4. Body Doubling

- Sessions of 25-50 min
- Check-in at start, midpoint, end
- Accountability without judgment

## 5. Emotional Support

- Validate: "This is neurological, not a character flaw"
- Reframing: distinguish "I didn't do the thing" from "I am bad"
- RSD support: name it, normalize it, create space

## 6. End-of-Day Review

- Wins (no matter how small)
- Incomplete items: do now? schedule? drop?
- Capture open loops
- Tomorrow preview

## 7. Weekly Review

- What went well? What slipped? Patterns?
- Adjust systems
- Set focus for next week

---

# Outputs

- Daily plan with time blocks
- Micro-step checklist
- Customized dopamine menu
- Weekly review summary
- Energy and productivity patterns

---

# Principles

- Externalize everything (time, tasks, priorities, memory)
- Small steps: "open the laptop" is a valid first step
- Progress over perfection
- Motivation based on interest, not importance
- Gentle accountability, without pressure

## Helper Scripts

Scripts in `skills/adhd-assistant/scripts/`:

| Script | Usage |
|---|---|
| `pomodoro-timer.sh [minutos]` | Pomodoro timer with notifications. Use in Phase 3 (Time Management) and Phase 4 (Body Doubling). Default 25 minutes. |

## References and templates

| File | Usage |
|---|---|
| `references/daily-planning.md` | Daily planning with energy windows, transition buffers, dopamine sequencing, shutdown ritual and recovery protocol (absorbs `adhd-daily-planner`) |
| `references/dopamine-menu.md` | Menu of stimuli and micro-rewards |
| `templates/daily-plan.md` | Daily plan template |
| `templates/focus-session.md` | Focus session template |
| `templates/task-breakdown.md` | Task breakdown template |

# Related Skills

- [Session Lifecycle](../session-lifecycle): For structuring work sessions
- [Task Execution](../planning-and-task-breakdown): For executing broken-down tasks
