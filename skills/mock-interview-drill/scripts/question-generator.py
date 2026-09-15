#!/usr/bin/env python3
"""question-generator.py - Generate practice interview questions.

Usage:
  python3 question-generator.py [--role frontend|fullstack|backend|product|data]
                                [--seniority junior|mid|senior]
                                [--target faang|startup|consulting]
                                [--type behavioral|technical|case]
                                [--count <number>]

Outputs a set of practice questions with evaluation criteria.
"""

import sys
import argparse
import random
import json


# ── Behavioral Questions ──

BEHAVIORAL_QUESTIONS = {
    "conflict": [
        "Tell me about a time you disagreed with a teammate or manager. How did you handle it?",
        "Describe a situation where you had to work with someone difficult. What did you do?",
        "Tell me about a time you had to push back on a requirement or deadline.",
        "Tell me about a time you received difficult feedback. How did you respond?",
    ],
    "leadership": [
        "Tell me about a time you led a project or initiative. What was your approach?",
        "Describe a situation where you took ownership of something outside your responsibilities.",
        "Tell me about a time you mentored or helped someone grow.",
        "Tell me about a time you had to influence without authority.",
    ],
    "failure": [
        "Tell me about a time you made a mistake at work. What happened and what did you learn?",
        "Describe a project that didn't go as planned. What would you do differently?",
        "Tell me about a time you had to deliver bad news to a stakeholder.",
        "Tell me about a time you underestimated the complexity of a task.",
    ],
    "teamwork": [
        "Tell me about a time you worked on a cross-functional team. How did you contribute?",
        "Describe a situation where you had to align multiple stakeholders with different priorities.",
        "Tell me about a time you helped a teammate who was struggling.",
        "Tell me about a time you resolved a team disagreement.",
    ],
    "growth": [
        "Tell me about a time you learned a new technology or skill for a project.",
        "Describe a situation where you had to work outside your comfort zone.",
        "Tell me about a time you sought feedback and acted on it.",
        "Tell me about a time you taught yourself something difficult.",
    ],
    "impact": [
        "Tell me about a time you went above and beyond what was expected.",
        "Describe a project where you drove measurable impact for the business.",
        "Tell me about a time you identified a problem no one else saw and fixed it.",
        "Tell me about a time you improved a process or system significantly.",
    ],
}


# ── Technical Questions ──

TECHNICAL_QUESTIONS = {
    "frontend": {
        "junior": [
            "Explain the difference between let, const, and var in JavaScript.",
            "How does the React virtual DOM work?",
            "What is CSS specificity and how does it affect styling?",
            "Explain event delegation in JavaScript.",
            "What is the difference between controlled and uncontrolled components in React?",
        ],
        "mid": [
            "Design a real-time search component with debouncing and caching.",
            "How would you optimize a React app that re-renders too often?",
            "Explain how you'd implement client-side routing.",
            "Design a state management solution for a complex form with 50+ fields.",
            "How would you handle authentication flow in a SPA?",
        ],
        "senior": [
            "Design a component library architecture that supports theming and tree-shaking.",
            "How would you architect a micro-frontend system?",
            "Design a performance monitoring system for a large React app.",
            "How would you migrate a legacy jQuery app to React incrementally?",
            "Design an accessibility audit system that runs in CI.",
        ],
    },
    "fullstack": {
        "junior": [
            "Explain the difference between REST and GraphQL.",
            "How does authentication work in a web application?",
            "What is the difference between SQL and NoSQL databases?",
            "Explain how you'd build a simple CRUD API.",
            "What is CORS and how do you handle it?",
        ],
        "mid": [
            "Design a file upload system with progress tracking.",
            "How would you implement real-time notifications?",
            "Design a rate-limiting system for a public API.",
            "Explain how you'd handle database migrations in production.",
            "Design a search feature with full-text search and filters.",
        ],
        "senior": [
            "Design a multi-tenant SaaS architecture.",
            "How would you architect a billing system that handles subscriptions, invoicing, and payment retries?",
            "Design a data pipeline that processes millions of events per day.",
            "How would you migrate a monolith to microservices incrementally?",
            "Design a system that syncs data between on-premise and cloud databases.",
        ],
    },
    "backend": {
        "junior": [
            "Explain the difference between processes and threads.",
            "What is ACID in databases?",
            "Explain how HTTP caching works.",
            "What is the difference between authentication and authorization?",
            "Explain the CAP theorem.",
        ],
        "mid": [
            "Design a distributed rate limiter.",
            "How would you implement a message queue system?",
            "Design a database schema for a social media platform.",
            "Explain how you'd handle database sharding.",
            "Design a caching strategy for a read-heavy API.",
        ],
        "senior": [
            "Design a distributed transaction system across microservices.",
            "How would you architect a real-time analytics pipeline?",
            "Design a system that guarantees exactly-once message processing.",
            "How would you design a global leaderboard for millions of users?",
            "Design a fault-tolerant distributed database.",
        ],
    },
}


# ── Case Questions ──

CASE_QUESTIONS = {
    "profitability": [
        "Our client is a SaaS company whose profits have been declining for 3 quarters. Diagnose the problem and recommend a solution.",
        "A retail chain's margins are shrinking despite increasing revenue. What's going on?",
        "A manufacturing company wants to improve its EBITDA by 20%. Where should they focus?",
    ],
    "market_entry": [
        "A US-based fintech wants to expand to Latin America. Should they enter, and how?",
        "A B2B software company is considering launching a B2C version of their product. Analyze the opportunity.",
        "An e-commerce company wants to launch a physical retail presence. Is this a good idea?",
    ],
    "growth": [
        "A mobile app's user growth has plateaued at 1M MAU. How would you re-accelerate growth?",
        "A subscription box company has high acquisition but low retention. What's the problem?",
        "A marketplace platform wants to double GMV in 12 months. What levers can they pull?",
    ],
    "operations": [
        "A logistics company wants to reduce delivery times by 30%. How?",
        "A call center wants to handle 2x volume without hiring more agents. What do you recommend?",
        "A factory wants to reduce defect rate from 5% to 1%. How would you approach this?",
    ],
}


def get_behavioral(count: int = 3) -> list[dict]:
    """Get random behavioral questions from different categories."""
    categories = list(BEHAVIORAL_QUESTIONS.keys())
    random.shuffle(categories)
    selected = []

    for cat in categories[:count]:
        question = random.choice(BEHAVIORAL_QUESTIONS[cat])
        selected.append({
            "type": "behavioral",
            "category": cat,
            "question": question,
            "evaluate": [
                "STAR structure (Situation, Task, Action, Result)",
                "Quantified impact where possible",
                "Self-reflection and learning",
                "Clear role definition (not vague 'we')",
            ],
        })

    return selected


def get_technical(role: str = "fullstack", seniority: str = "mid",
                  count: int = 2) -> list[dict]:
    """Get random technical questions for role/seniority."""
    role_data = TECHNICAL_QUESTIONS.get(role, TECHNICAL_QUESTIONS["fullstack"])
    questions = role_data.get(seniority, role_data["mid"])
    selected_questions = random.sample(questions, min(count, len(questions)))

    return [{
        "type": "technical",
        "role": role,
        "seniority": seniority,
        "question": q,
        "evaluate": [
            "Structured approach (clarify → design → trade-offs)",
            "Technical depth appropriate for seniority",
            "Considers edge cases and failure modes",
            "Clear communication of trade-offs",
        ],
    } for q in selected_questions]


def get_case(count: int = 1) -> list[dict]:
    """Get random case questions from different categories."""
    categories = list(CASE_QUESTIONS.keys())
    random.shuffle(categories)
    selected = []

    for cat in categories[:count]:
        question = random.choice(CASE_QUESTIONS[cat])
        selected.append({
            "type": "case",
            "category": cat,
            "question": question,
            "evaluate": [
                "Framework selection (appropriate for problem type)",
                "Structured thinking (not jumping to conclusions)",
                "Assumptions made explicit",
                "Clear recommendation with rationale",
                "Risk awareness",
            ],
        })

    return selected


def print_questions(questions: list[dict]):
    """Print questions in a readable format."""
    for i, q in enumerate(questions, 1):
        print(f"\n{'=' * 60}")
        print(f"QUESTION {i} - {q['type'].upper()}")
        print(f"{'=' * 60}")
        print(f"\n{q['question']}\n")

        if q['type'] == 'behavioral':
            print(f"  Category: {q['category']}")
        elif q['type'] == 'technical':
            print(f"  Role: {q['role']} | Seniority: {q['seniority']}")

        print(f"\n  Evaluation criteria:")
        for criterion in q['evaluate']:
            print(f"    • {criterion}")

        print()


def main():
    parser = argparse.ArgumentParser(
        description="Generate practice interview questions")
    parser.add_argument("--role", choices=["frontend", "fullstack", "backend",
                                           "product", "data"],
                        default="fullstack")
    parser.add_argument("--seniority", choices=["junior", "mid", "senior"],
                        default="mid")
    parser.add_argument("--target", choices=["faang", "startup", "consulting"],
                        default="startup")
    parser.add_argument("--type", choices=["behavioral", "technical", "case",
                                           "all"],
                        default="all")
    parser.add_argument("--count", type=int, default=3)
    parser.add_argument("--json", action="store_true",
                        help="Output as JSON")

    args = parser.parse_args()

    questions = []

    if args.type in ("behavioral", "all"):
        questions.extend(get_behavioral(args.count))

    if args.type in ("technical", "all"):
        tech_count = max(1, args.count // 2)
        questions.extend(get_technical(args.role, args.seniority, tech_count))

    if args.type in ("case", "all"):
        case_count = 1 if args.type == "case" else 1
        questions.extend(get_case(case_count))

    # Shuffle to mix types
    random.shuffle(questions)

    if args.json:
        print(json.dumps(questions, indent=2))
    else:
        print(f"\n🎯 MOCK INTERVIEW QUESTIONS")
        print(f"   Target: {args.target.upper()} | Role: {args.role} | "
              f"Seniority: {args.seniority}")
        print(f"   {len(questions)} questions generated")
        print_questions(questions)


if __name__ == "__main__":
    main()
