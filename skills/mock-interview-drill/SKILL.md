---
name: "mock-interview-drill"
metadata:
  category: "Career"
  tags:
    - interviews
    - preparation
    - star
    - job-search
description: "Realistic mock interviews with follow-up questions: Behavioral (STAR), Technical and Case, with structured diagnosis."
user-invocable: false
---

# Workflow: Mock Interview Drill

## Purpose

Realistic mock interviews with follow-up questions in 3 modes: Behavioral, Technical and Case. Provides structured STAR diagnosis, technical evaluation and sample answers.

## Philosophy

> Practice doesn't make perfect. Practice makes permanent. Practice the right way.

Each mock should feel real. It is not a questionnaire - it is a conversation with controlled pressure, follow-up and diagnosis.

## When to use it

- To practice job interviews
- To prepare behavioral questions with STAR
- To practice system design or algorithms
- To prepare for case interviews (consulting, product)
- To get structured feedback after a mock

## Before you start

Set up the mock:

1. **Choose the type** - Behavioral, Technical, Case, or combined
2. **Define the target** - FAANG, startup, consulting firm (changes the focus)
3. **Define seniority** - junior, mid, senior (changes the depth)
4. **Time** - 30-45 min per mock
5. **Mode** - real conversation, not script reading

> **Tip:** Use `question-generator.py` to automatically generate questions based on role, seniority and target.

---

## Workflow A: Behavioral Interview

### How it works

1. **Ask the question** - open-ended, without interrupting
2. **Listen to the answer** - take notes on the 4 STAR elements
3. **Follow-ups** - 3-5 probing questions
4. **Diagnosis** - A-D rating with specific criteria

### How to evaluate a STAR answer

| Element | What to look for | Red flags |
|---|---|---|
| **S** Situation | Clear context (when, where, scale) | Vague, no dates, no metrics |
| **T** Task | Defined personal role | "The team did..." without their role |
| **A** Action | Concrete actions, not generic ones | "I did what needed to be done" |
| **R** Result | Quantified or qualitative outcome | "It went well" without data |

### STAR Diagnostic Rating

| Rating | Criterion |
|---|---|
| **A** | Covers 4/4 STAR, quantified data, explicit learning |
| **B** | Covers 3/4 STAR, partial data, some reflection |
| **C** | Covers 2/4 STAR, no data, generic answer |
| **D** | Covers 0-1/4 STAR, no structure, does not answer the question |

### Common follow-ups

- "What would you have done differently?"
- "How did the others react?"
- "What did you learn from that experience?"
- "Was there something you didn't know at that moment?"
- "How did you measure the result?"

### What to do if they have no prepared answer

- Give them time to think (10-15 seconds of silence is fine)
- Rephrase the question: "Another similar situation?"
- If they insist they have none: "Tell me about a project that didn't go as you expected"

---

## Workflow B: Technical Interview

### How it works

1. **Present the problem** - system design, algorithm, or domain knowledge
2. **Give them time to think** - 2-3 min of silence is normal
3. **Listen to the approach** - don't interrupt, take notes
4. **Follow-ups** - edge cases, trade-offs, performance, extensibility
5. **Evaluation** - A-D rating with technical criteria

### System Design: what to evaluate by seniority

| Seniority | What to expect | What to evaluate |
|---|---|---|
| **Junior** | Functional, monolithic solution | Clarity, fundamentals, communication |
| **Mid** | Scalable solution with trade-offs | Caching, DB indexing, API design |
| **Senior** | Distributed, fault-tolerant solution | CAP theorem, sharding, consistency |

### Algorithms: what level by target

| Target | Level | Examples |
|---|---|---|
| **FAANG** | LeetCode Medium/Hard | Graphs, DP, trees, arrays |
| **Startup** | LeetCode Easy/Medium | Arrays, strings, hash maps |
| **Consulting** | Not applicable | They usually don't ask algorithms |

### Technical Answer Evaluation

| Rating | Criterion |
|---|---|
| **A** | Clarified requirements, complete design, explicit trade-offs, edge cases covered |
| **B** | Functional design, some trade-offs, partial edge cases |
| **C** | Basic design, no trade-offs, didn't consider failures |
| **D** | No structure, no clarification, incorrect solution |

### Common follow-ups

- "What happens if traffic doubles?"
- "How would you handle a failure in [component]?"
- "Is there another way to solve it?"
- "What is the bottleneck of your design?"
- "How would you monitor this system?"

---

## Workflow C: Case Interview

### How it works

1. **Present the case** - open business problem
2. **Give them time to structure** - 2-3 min
3. **Listen to the approach** - framework, assumptions, analysis
4. **Follow-ups** - data, risks, recommendation
5. **Evaluation** - A-D rating with case criteria

### Frameworks by case type

| Case type | Recommended framework |
|---|---|
| **Profitability** | Revenue - Cost = Profit |
| **Market Entry** | Market attractiveness + Company capability + GTM strategy |
| **M&A / Investment** | Strategic fit + Financial analysis + Risks |
| **Operations** | Process mapping + Cost analysis + Improvement levers |
| **Growth** | Customer funnel + Revenue levers + Competitive position |

> **See:** [Case Frameworks](./references/case-frameworks.md) for details on each framework.

### Case Answer Evaluation

| Rating | Criterion |
|---|---|
| **A** | Appropriate framework, explicit assumptions, structured analysis, clear recommendation |
| **B** | OK framework, partial assumptions, basic analysis, recommendation present |
| **C** | No clear framework, jumps to conclusions, superficial analysis |
| **D** | Disorganized, doesn't structure the problem, doesn't reach a recommendation |

### Common follow-ups

- "What data would you need to validate your hypothesis?"
- "What is the biggest risk of your recommendation?"
- "How would you prioritize between [option A] and [option B]?"
- "What assumptions are you making?"
- "If you had to decide today with the available information, what would you do?"

---

## Outputs

- **STAR Diagnostic Report** - A-D rating with element-by-element breakdown
- **Technical Answer Evaluation** - A-D rating with observations
- **Case Answer Evaluation** - A-D rating with structure feedback
- **Polished sample answers** - improved version of the answer
- **Improvement suggestions** - what to practice for next time

---

## References

- [Behavioral Questions](./references/behavioral-questions.md) - Bank of 24+ questions by category with evaluation criteria
- [System Design Guide](./references/system-design-guide.md) - How to structure system design answers, trade-offs, seniority levels
- [Case Frameworks](./references/case-frameworks.md) - Case frameworks with when to use each one
- [Preparation Guide](./references/preparation-guide.md) - What to study by target and seniority

## Scripts

- [question-generator.py](./scripts/question-generator.py) - Generates practice questions by role, seniority and target

## Helper Scripts

Scripts in `skills/mock-interview-drill/scripts/`:

| Script | Use |
|---|---|
| `question-generator.py` | Generates interview questions by role, seniority and target. Use in "Before you start" and between mocks to vary the question bank. |

## Related Skills

- [CV Tailor](../cv-tailor): To optimize the CV before interviews
