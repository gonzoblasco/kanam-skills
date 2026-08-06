#!/usr/bin/env python3
"""keyword-matcher.py — Match CV keywords against a job description.

Usage:
  python3 keyword-matcher.py <cv-file> <jd-file> [--output <file>]

Outputs a coverage matrix with gaps identified, ready for the
Phase 2 checkpoint in the CV Tailor workflow.

Categories:
  - hard: Technical skills, tools, languages
  - soft: Soft skills, methodologies
  - domain: Industry terms, domain knowledge
"""

import sys
import re
import json
from pathlib import Path
from collections import defaultdict


# Common words to exclude from keyword extraction
STOP_WORDS = {
    "the", "a", "an", "and", "or", "but", "in", "on", "at", "to", "for",
    "of", "with", "by", "from", "as", "is", "was", "are", "were", "be",
    "been", "being", "have", "has", "had", "do", "does", "did", "will",
    "would", "could", "should", "may", "might", "shall", "can", "need",
    "must", "about", "into", "over", "after", "before", "between", "under",
    "above", "below", "up", "down", "out", "off", "just", "also", "very",
    "too", "more", "most", "some", "any", "each", "every", "all", "both",
    "few", "no", "nor", "not", "only", "own", "same", "so", "than", "that",
    "this", "these", "those", "what", "which", "who", "whom", "whose",
    "when", "where", "why", "how", "such", "here", "there", "then",
    "because", "while", "during", "through", "using", "based", "well",
    "year", "years", "new", "including", "including", "within", "without",
    "per", "etc", "e.g.", "i.e.", "vs", "versus", "via", "like",
    "experience", "work", "working", "team", "role", "position", "job",
    "company", "project", "skills", "ability", "able", "strong",
}


# Known technical keywords for categorization
HARD_SKILLS = {
    # Frontend
    "react", "typescript", "javascript", "next.js", "nextjs", "vue", "angular",
    "svelte", "html", "css", "tailwind", "sass", "less", "redux", "zustand",
    "graphql", "apollo", "rest", "restful", "webpack", "vite", "esbuild",
    "jest", "vitest", "playwright", "cypress", "testing-library",
    # Backend
    "node.js", "nodejs", "express", "fastify", "nestjs", "python", "django",
    "flask", "fastapi", "go", "rust", "java", "spring", "kotlin", "c#", ".net",
    "php", "laravel", "ruby", "rails", "postgresql", "postgres", "mysql",
    "mongodb", "sqlite", "redis", "dynamodb", "supabase", "firebase",
    "prisma", "drizzle", "typeorm", "knex", "sqlalchemy",
    # Cloud & DevOps
    "aws", "gcp", "azure", "vercel", "netlify", "cloudflare", "docker",
    "kubernetes", "k8s", "terraform", "ci/cd", "github actions", "gitlab ci",
    "nginx", "linux", "bash", "shell",
    # AI & Data
    "machine learning", "deep learning", "llm", "gpt", "openai", "langchain",
    "tensorflow", "pytorch", "pandas", "numpy", "sql", "etl", "data pipeline",
    "rag", "vector database", "embeddings",
    # Mobile
    "react native", "flutter", "swift", "kotlin", "android", "ios",
    # Tools
    "git", "github", "gitlab", "jira", "confluence", "figma", "sketch",
    "storybook", "chromatic", "biome", "eslint", "prettier",
    # Testing
    "unit testing", "integration testing", "e2e", "tdd", "bdd",
    # Accessibility
    "a11y", "wcag", "aria", "axe", "accessibility",
}

SOFT_SKILLS = {
    "leadership", "mentoring", "collaboration", "communication",
    "problem-solving", "critical thinking", "decision-making",
    "project management", "agile", "scrum", "kanban", "cross-functional",
    "stakeholder management", "teamwork", "ownership", "initiative",
    "adaptability", "growth mindset", "detail-oriented", "self-motivated",
    "time management", "prioritization", "conflict resolution",
    "presentation", "public speaking", "technical writing",
    "code review", "pair programming", "knowledge sharing",
}

DOMAIN_KEYWORDS = {
    "saas", "b2b", "b2c", "enterprise", "startup", "scale-up",
    "dau", "mau", "arr", "mrr", "ltv", "cac", "churn", "retention",
    "conversion", "funnel", "a/b testing", "experimentation",
    "growth", "product-led", "data-driven", "metrics", "kpi",
    "compliance", "gdpr", "hipaa", "soc2", "pci",
    "microservices", "monolith", "distributed systems",
    "api-first", "headless", "jamstack", "ssr", "ssg", "spa",
    "responsive design", "mobile-first", "progressive web app",
    "design system", "component library", "ui/ux",
    "performance", "seo", "lighthouse", "core web vitals",
    "internationalization", "i18n", "localization", "l10n",
}


def extract_keywords(text: str) -> set[str]:
    """Extract meaningful keywords from text."""
    text_lower = text.lower()
    keywords = set()

    # Extract multi-word phrases first (2-3 words)
    # Common patterns: "machine learning", "react native", etc.
    for phrase_len in [3, 2]:
        words = text_lower.split()
        for i in range(len(words) - phrase_len + 1):
            phrase = " ".join(words[i:i + phrase_len])
            # Check if phrase is a known keyword or looks meaningful
            if (phrase in HARD_SKILLS or phrase in SOFT_SKILLS or
                phrase in DOMAIN_KEYWORDS):
                keywords.add(phrase)

    # Extract single words
    words = re.findall(r'[a-zA-Z][a-zA-Z0-9+#.]+', text_lower)
    for word in words:
        if word not in STOP_WORDS and len(word) > 2:
            if (word in HARD_SKILLS or word in SOFT_SKILLS or
                word in DOMAIN_KEYWORDS):
                keywords.add(word)

    return keywords


def categorize_keywords(keywords: set[str]) -> dict[str, list[str]]:
    """Categorize keywords into hard skills, soft skills, and domain."""
    result = defaultdict(list)

    for kw in sorted(keywords):
        if kw in HARD_SKILLS:
            result["hard"].append(kw)
        elif kw in SOFT_SKILLS:
            result["soft"].append(kw)
        elif kw in DOMAIN_KEYWORDS:
            result["domain"].append(kw)
        else:
            result["other"].append(kw)

    return dict(result)


def generate_matrix(jd_keywords: set[str], cv_keywords: set[str]) -> dict:
    """Generate coverage matrix."""
    matched = jd_keywords & cv_keywords
    missing = jd_keywords - cv_keywords
    extra = cv_keywords - jd_keywords

    coverage = len(matched) / len(jd_keywords) * 100 if jd_keywords else 0

    return {
        "coverage_pct": round(coverage, 1),
        "total_jd_keywords": len(jd_keywords),
        "total_cv_keywords": len(cv_keywords),
        "matched": sorted(matched),
        "missing": sorted(missing),
        "extra": sorted(extra),
        "jd_by_category": categorize_keywords(jd_keywords),
        "cv_by_category": categorize_keywords(cv_keywords),
        "matched_by_category": categorize_keywords(matched),
        "missing_by_category": categorize_keywords(missing),
    }


def print_report(matrix: dict):
    """Print a human-readable coverage report."""
    print("=" * 60)
    print("📊 KEYWORD COVERAGE REPORT")
    print("=" * 60)
    print(f"\nCoverage: {matrix['coverage_pct']}%")
    print(f"JD keywords: {matrix['total_jd_keywords']}")
    print(f"CV keywords: {matrix['total_cv_keywords']}")
    print(f"Matched: {len(matrix['matched'])}")
    print(f"Missing: {len(matrix['missing'])}")

    # Coverage bar
    bar_len = 30
    filled = int(matrix['coverage_pct'] / 100 * bar_len)
    bar = "█" * filled + "░" * (bar_len - filled)
    status = "✅ PASS" if matrix['coverage_pct'] >= 80 else "⚠️  GAPS"
    print(f"\n  [{bar}] {matrix['coverage_pct']}% {status}")

    # By category
    print("\n" + "-" * 60)
    print("BY CATEGORY")
    print("-" * 60)

    for cat_name, cat_label in [("hard", "Hard Skills"), ("soft", "Soft Skills"),
                                  ("domain", "Domain/Industry")]:
        jd_cat = matrix['jd_by_category'].get(cat_name, [])
        missing_cat = matrix['missing_by_category'].get(cat_name, [])
        matched_cat = matrix['matched_by_category'].get(cat_name, [])

        if not jd_cat:
            continue

        cat_coverage = (len(matched_cat) / len(jd_cat) * 100) if jd_cat else 0
        print(f"\n  {cat_label}: {cat_coverage:.0f}% ({len(matched_cat)}/{len(jd_cat)})")

        if missing_cat:
            print(f"  ❌ Missing: {', '.join(missing_cat)}")

    # Missing keywords detail
    if matrix['missing']:
        print("\n" + "-" * 60)
        print("GAPS TO ADDRESS")
        print("-" * 60)
        for cat_name, cat_label in [("hard", "Hard Skills"), ("soft", "Soft Skills"),
                                      ("domain", "Domain/Industry")]:
            missing_cat = matrix['missing_by_category'].get(cat_name, [])
            if missing_cat:
                print(f"\n  {cat_label}:")
                for kw in missing_cat:
                    print(f"    • {kw}")

    # Extra keywords (CV has but JD doesn't ask)
    if matrix['extra']:
        print("\n" + "-" * 60)
        print("EXTRA (CV has, JD doesn't mention)")
        print("-" * 60)
        for kw in matrix['extra'][:10]:  # Show top 10
            print(f"  • {kw}")
        if len(matrix['extra']) > 10:
            print(f"  ... and {len(matrix['extra']) - 10} more")

    print("\n" + "=" * 60)
    if matrix['coverage_pct'] >= 80:
        print("✅ RECOMMENDATION: Proceed to STAR Rewriting")
    else:
        print("⚠️  RECOMMENDATION: Address gaps before STAR Rewriting")
        print("   Ask the candidate if they have experience in the missing areas")
    print("=" * 60)


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)

    cv_file = Path(sys.argv[1])
    jd_file = Path(sys.argv[2])
    output_file = None

    if "--output" in sys.argv:
        idx = sys.argv.index("--output")
        if idx + 1 < len(sys.argv):
            output_file = sys.argv[idx + 1]

    if not cv_file.exists():
        print(f"❌ CV file not found: {cv_file}")
        sys.exit(1)
    if not jd_file.exists():
        print(f"❌ JD file not found: {jd_file}")
        sys.exit(1)

    cv_text = cv_file.read_text()
    jd_text = jd_file.read_text()

    print("🔍 Analyzing keywords...")
    jd_keywords = extract_keywords(jd_text)
    cv_keywords = extract_keywords(cv_text)

    matrix = generate_matrix(jd_keywords, cv_keywords)
    print_report(matrix)

    if output_file:
        with open(output_file, "w") as f:
            json.dump(matrix, f, indent=2)
        print(f"\n📄 Full report saved to: {output_file}")


if __name__ == "__main__":
    main()
