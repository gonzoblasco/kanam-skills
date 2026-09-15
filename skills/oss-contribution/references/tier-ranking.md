# Tier Ranking - OSS Contribution Reference

Classification of target repositories for strategic contributions.

## Tier System

### Tier 0 - High Impact, High Visibility
Repos with large audiences, PRs reviewed rigorously.

- **shadcn/ui** - UI components, massive audience
- **TanStack (react-query, react-router, table)** - Core stack libraries
- **Vercel (next.js, ai-sdk)** - Main framework
- **Biome** - Stack toolchain

**Strategy:** small and precise PRs. Human description, no automation traces. Concrete bugs without competition -> quick PR.

### Tier 1 - Strategic Value
Repos we actively use or that complement the stack.

- **Supabase** - Main backend
- **Radix UI / Ariakit** - Headless UI primitives
- **React Aria** - Accessibility
- **Playwright** - E2E testing
- **Vitest** - Unit testing

**Strategy:** small features, DX improvements, accessibility fixes.

### Tier 2 - Community Building
Repos where to build presence without review pressure.

- **create-stack-next** - Own project, full control
- **workflow-kit** - Own project
- **Accessibility repos** (axe-core, WAI-ARIA practices)
- **Framework documentation**

**Strategy:** regular contributions, issues, reviews of others' PRs.

## Opportunity Detection

Look for open issues without competing PRs (use `scripts/triage-issues.sh`). Prioritize:

- Concrete bugs with a clear repro (quick fix, high value)
- Accessibility issues (the user's specialty)
- Issues where the reporter already identified the root cause (faster analysis)
- Issues labeled `good first issue` or `help wanted` in Tier 0/1 repos
