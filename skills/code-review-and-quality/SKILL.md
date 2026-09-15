---
name: "code-review-and-quality"
description: "Conducts multi-axis code review with quality gates. Integrates five-axis review (correctness, readability, architecture, security, performance), anti-pattern de"
---

# Code Review and Quality: The Five-Axis Inspection

## Overview

Multi-dimensional code review with quality gates. Every change gets reviewed before merge - **no exceptions**. This skill combines **five-axis review**, **anti-pattern detection**, and **mentorship feedback** to assess code quality across correctness, readability, architecture, security, and performance.

**The approval standard:** Approve a change when it definitely improves overall code health, even if it isn't perfect. The goal is continuous improvement, not perfection.

---

## 🎯 Phase 1: Five-Axis Review Framework

### Axis 1: Correctness (Is it right?)
**Verification Checklist:**
- [ ] Does it match the spec/requirements exactly?
- [ ] Do all tests pass? (unit, integration, E2E)
- [ ] Are edge cases handled?
- [ ] Is error handling comprehensive?
- [ ] Are type signatures correct (if TypeScript)?

---

### Axis 2: Readability (Is it clear?)
**Verification Checklist:**
- [ ] Would a new team member understand this in < 5 minutes?
- [ ] Are variable/functions meaningfully named?
- [ ] Is nesting depth ≤ 3 levels?
- [ ] Are comments explaining WHY, not WHAT?
- [ ] Follows consistent formatting and conventions?

**Common Issues:**
```tsx
// ✗ BAD - Unreadable function name
function processTransformOptimizeData(data, flag) {
  return data.filter(d => d.active).map(d => d.value).reduce((a,b)=>a+b);
}

// ✓ GOOD - Clear intent
function calculateTotalActiveValues(items) {
  return items
    .filter(item => item.isActive)
    .map(item => item.value)
    .reduce((sum, val) => sum + val, 0);
}
```

---

### Axis 3: Architecture (Is it structured well?)
**Verification Checklist:**
- [ ] Does it follow Single Responsibility Principle?
- [ ] Are dependencies properly managed/injected?
- [ ] Is there appropriate separation of concerns?
- [ ] Does it fit the existing architecture?
- [ ] Are boundaries clear (component/module)?

---

### Axis 4: Security (Is it safe?)
**Verification Checklist:**
- [ ] Is user input validated/sanitized at boundaries?
- [ ] Are secrets never logged or exposed?
- [ ] Are authentication/authorization checks in place?
- [ ] Are SQL injection/XSS/CSRF attacks prevented?
- [ ] Are dependencies checked for vulnerabilities?

---

### Axis 5: Performance (Is it fast?)
**Verification Checklist:**
- [ ] Are database queries optimized (no N+1)?
- [ ] Are unnecessary re-renders prevented (React keys, memo)?
- [ ] Is bundle size monitored?
- [ ] Are heavy operations offloaded to web workers/background?
- [ ] Are loading states handled properly?

---

## 🚫 Phase 2: Anti-Pattern Detection (From Anti-Pattern Czar)

### Critical Anti-Patterns to Detect

#### Pattern #1: Premature Optimization
```tsx
// ✗ ANTI-PATTERN - Optimizing too early
const results = cache.get(key) || fetchData().then(res => res.cache.set(key, res));

// ✓ CORRECT - Lazy loading with caching strategy defined later
const results = useLazyDataFetching({ key, onCache: (val) => cache.set(key, val) });
```

#### Pattern #2: God Component/Service
```tsx
// ✗ ANTI-PATTERN - 400+ lines doing everything
function Dashboard() { // 450 lines of logic... }

// ✓ CORRECT - Decomposed
function Dashboard() {
  return (
    <Layout>
      <Sidebar />
      <ContentArea>
        <StatsPanel />
        <ChartDataVisualization />
        <RecentActivityFeed />
      </ContentArea>
    </Layout>
  );
}
```

#### Pattern #3: Feature Envy
```tsx
// ✗ ANTI-PATTERN - Method belongs in a new class
class Order {
  applyPromoCode(code) { // This should be in PromoCodeService!
    // ...
  }
}

// ✓ CORRECT - Separated concern
class Order { /* only Order logic */ }
class PromoCodeService {
  apply(code, amount) { /* promo logic here */ }
}
```

#### Pattern #4: Spaghetti Conditions
```tsx
// ✗ ANTI-PATTERN - 50+ if conditions in one file
function handleAction(type) {
  if (type === 'A') return ...;
  if (type === 'B') return ...;
  // ... 45 more conditions
}

// ✓ CORRECT - Strategy pattern or map
function handleAction(type) {
  const handlers = {
    A: handleTypeA,
    B: handleTypeB,
    // ...
  };
  return handlers[type]?.() ?? defaultHandler();
}
```

#### Pattern #5: Magic Numbers/Strings
```tsx
// ✗ ANTI-PATTERN - Hidden constants
const MAX_RETRIES = 5;
const API_TIMEOUT = 3000;
const ERROR_CODES = { INVALID_USER: 401, NOT_FOUND: 404 };

// ✓ CORRECT - Named constants in config file
// api-config.ts
export const RETRIES = 5;
export const TIMEOUTS = { API: 3000 };
export const ERROR_CODES = { ... };
```

---

## 📋 Phase 3: Review Severity Labels

### 🟢 Nit (Low Priority)
**Definition:** Cosmetic issues, minor style inconsistencies, optional improvements.

**Examples:**
- Missing trailing comma
- Inconsistent spacing in one file
- Could use a more descriptive variable name but it's understandable
- Missing JSDoc comment that would be nice but isn't critical

**Action:** Comment inline, don't block merge (unless accumulation is problematic)

---

### 🟡 FYI (For Your Information - Medium Priority)
**Definition:** Important context, potential future improvements, architecture awareness.

**Examples:**
- This approach might become a performance bottleneck at scale
- Consider extracting to a shared utility for reuse in other modules
- Good pattern but worth documenting as a design decision

**Action:** Add comment noting the observation, consider mentioning in ADR if architectural impact

---

### 🔴 Blocker (Critical - Must Fix Before Merge)
**Definition:** Functional bugs, security vulnerabilities, critical architecture violations.

**Examples:**
```tsx
// 🔴 BLOCKER - Security vulnerability
const userInput = req.body.email;
// No validation, no sanitization - potential XSS/injection!

// Should be:
const userInput = sanitize(req.body.email); // OWASP validator
if (!isEmail(userInput)) {
  return res.status(400).json({ error: 'Invalid email' });
}
```

---

## 📊 Phase 4: Change Sizing & Review Depth

### Small Changes (< 100 lines)
**Review Focus:**
- Correctness only (unit tests + manual verification)
- Readability check
- Security basics (input validation, secrets)

**Reviewers Needed:** 1 peer minimum

---

### Medium Changes (100-500 lines)
**Review Focus:**
- All five axes covered
- Integration tests required
- Architecture alignment check

**Reviewers Needed:** 2 peers minimum

---

### Large Changes (> 500 lines or multiple files)
**Review Focus:**
- Full five-axis review
- Performance profiling (if applicable)
- Security audit (OWASP Top 10 checks)
- Architecture documentation update (ADR)

**Reviewers Needed:** 3+ peers, possibly including senior engineer

**Required Deliverables:**
- [ ] All tests passing
- [ ] ADR documenting architectural decision
- [ ] Performance baseline comparison
- [ ] Security review sign-off

---

## ⏱️ Phase 5: Review Speed Norms

### Response Time Expectations
- **Nit issues:** 48 hours (cosmetic, can wait)
- **FYI observations:** 72 hours (contextual, worth thinking about)
- **Blockers:** Same-day (must fix before merge possible)

**SLA Targets:**
- Small changes: Review within 24h
- Medium changes: Review within 48h  
- Large changes: Review within 72h or break into smaller PRs

---

## 🧠 Phase 6: Mentorship Feedback Integration (From Code Mentor)

### Constructive Feedback Framework

#### The Sandwich Method (Updated)
1. **What worked well** - Acknowledge good parts first
2. **What can improve** - Actionable suggestions with before/after
3. **Why it matters** - Connect to business impact/maintenance cost

#### Example Feedback:
```
✅ What worked:
- Clean separation of concerns in this component
- Good use of React Query for data fetching
- Tests cover the happy path well

💡 Suggestion:
Consider extracting the validation logic to a separate utility file.

BEFORE:
function handleFormSubmit(e) {
  const email = e.target.email;
  if (!isValidEmail(email)) return;
  if (!hasMinimumLength(email)) return;
  // ... submit
}

AFTER (extracted):
import { validateEmail } from './form-validation-utils';

function handleFormSubmit(e) {
  const email = e.target.email;
  if (!validateEmail(email)) return; // Much clearer!
  // ... submit
}

🎯 Why it matters:
This pattern will appear in multiple forms across the app. Centralizing validation makes it:
1. Easier to maintain (one source of truth)
2. More testable (unit tests instead of inline checks)
3. Consistent across all form inputs
4. Safer (if we need stricter validation later, change in one place)
```

---

## 🔍 Phase 7: Severity Detection Heuristics

### Automatic Severity Assessment

**Security Critical (Blocker):**
- Hardcoded secrets/API keys
- Missing authentication on sensitive routes
- SQL injection patterns detected
- XSS vulnerabilities via unsanitized input

**Architecture Critical (Blocker):**
- Violates single responsibility principle severely
- Creates circular dependencies
- Breaks existing architecture boundaries
- Introduces tight coupling that requires refactoring downstream

**Performance Warning (FYI → Blocker if scale confirmed):**
- N+1 query patterns without confirmation of volume
- Excessive re-renders in production components
- Unoptimized bundle size increases (>20%)

**Style Issues (Nit):**
- Formatting inconsistencies
- Naming preferences
- Import order differences

---

## ✅ Verification Gate Checklist

Before approving any merge request, verify:

### Pre-Merge Checklist
- [ ] All tests passing locally and on CI
- [ ] Code style matches project conventions
- [ ] Five axes reviewed (even if shallow for small changes)
- [ ] Security basics validated (input validation, no secrets exposed)

### Post-Merge Validation
- [ ] No new regression tests failed
- [ ] Deployment completed successfully
- [ ] Monitoring dashboards show stable metrics
- [ ] User feedback doesn't indicate broken functionality

---

## 🚨 Red Flags Requiring Immediate Attention

- Any PR introducing authentication/authorization logic → Security audit mandatory
- Database migration changes → Schema validation required
- Breaking API changes → Versioning strategy documented
- Performance-critical code paths → Profiling required
- Third-party library additions → Vulnerability check + license review

---

## 📚 References

See `references/security-checklist.md` for OWASP Top 10 prevention patterns.
See `references/testing-patterns.md` for test structure guidelines.
See `references/definition-of-done.md` for project-wide quality standards.
