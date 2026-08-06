---
name: debugging-and-error-recovery
description: Guides systematic root-cause debugging. Integrates 5-step triage (reproduce, localize, reduce, fix, guard), forensic logging, failure pattern recognition from investigation memory, and regression prevention. Use when tests fail, builds break, behavior doesn't match expectations, or any unexpected error occurs — not for guessing.
---

# Debugging and Error Recovery: The 5-Step Triage System

## Overview

Systematic debugging with structured triage. When something breaks, **stop adding features**, preserve evidence, and follow a structured process to find and fix the root cause. Guessing wastes time — the 5-step checklist works for test failures, build errors, runtime bugs, and production incidents. This skill integrates **forensic logging**, **failure pattern recognition** from investigation memory, and **regression prevention**.

---

## 🎯 Phase 1: The 5-Step Debug Triage Framework

### Step 1: REPRODUCE (Can I consistently break it?)
**Goal:** Prove the bug is real and not a flaky test/environment issue.

**Checklist:**
- [ ] Can I reproduce this locally? Document steps to reproduce.
- [ ] Is this a one-time error or consistent?
- [ ] Does environment matter (dev/staging/production)?
- [ ] Is the test flaky, or is the bug real?
- [ ] What's the minimal way to trigger it?

**Evidence Capture:**
```bash
# Minimal reproduction case
cat > /tmp/reproduce.ts <<EOF
// Smallest code snippet that triggers the bug
const data = fetch('/api/problematic-endpoint');
try {
  await data.json(); // Boom! TypeError here
} catch (e) {
  console.error('Bug reproduced:', e.message);
  process.exit(1);
}
EOF

# Document:
BUG_REPRODUCTION_STEPS:
1. Clone repo and run npm install
2. Navigate to projects/my-project/
3. Run npm start
4. Open http://localhost:3000/api/v1/problems
5. Observe TypeError in console (see logs/error.log)
```

**Tools:**
- `git blame` — See when this code was added and by whom
- `console.error()` with stack trace capture
- Logs from error monitoring (Sentry, Bugsnag, etc.)
- Screenshots/videos if it's a visual issue

---

### Step 2: LOCALIZE (Where in the codebase?)
**Goal:** Identify the exact file/line/function responsible.

**Binary Search Strategy:**
```bash
# Narrowing down by commenting out code sections
# Start: Comment out half the files/modules
cd projects/my-project/

if npm run test -- --grep "bug-name" fails; then
  echo "Bug is in uncommented section";
else
  echo "Bug is in commented section";
   # Uncomment problematic half, comment other half
fi

# Continue binary search until pinpointed to single function/line
```

**Tools & Techniques:**
- **Git blame + git log** — Who last modified this? When?
- **Stack trace analysis** — Call chain leading to failure
- **Dependency tree inspection** — Is it a third-party library issue?
- **Environment diff check** — What differs between working/broken environments?

**Common Culprits:**
```
✗ Recent PR introduced breaking change in shared utility → Module resolution error
✗ Dependency updated and removed peer dependency → Build failure
✗ Config file typo → ESLint/TypeScript complaint treated as error
✗ Race condition only visible under load → Flaky test
✗ Browser-specific API used without feature detection → Console warning + error
```

---

### Step 3: REDUCE (Can I isolate the cause?)
**Goal:** Create a minimal test case that proves the root cause.

**Strategies:**

#### A) The Rubber Duck Debugging Method
Explain line-by-line what the code should do. Often you'll spot the issue while talking through it.

#### B) Controlled Experiments
```tsx
// Test hypothesis: Is this a React state timing issue?

// Experiment 1: Remove useEffect dependency
function MyComponent({ data }) {
  const [state, setState] = useState(null); // Without proper init
  
  // ✗ BROKEN — State never initializes
  return <div>{state}</div>;
}

// Experiment 2: Add proper effect
function MyComponent({ data }) {
  const [state, setState] = useState(null);
  
  useEffect(() => {
     setState(data); // Proper initialization on mount
   }, [data]);
   
  return <div>{state}</div>;
}

// ✓ FIXED — Now it initializes correctly
```

#### C) The "What If I..." Method
```bash
# What if I remove this file? → Still works
# What if I add this line back? → Boom, broken!
# What if I change the type signature? → Compile error points to the issue
```

---

### Step 4: FIX (How do I solve it?)
**Goal:** Implement the solution with confidence.

**Before Fixing — Verify:**
- [ ] Root cause clearly understood
- [ ] Minimal fix identified (not band-aid)
- [ ] Tests would fail without this fix (Prove it fixes something)
- [ ] Solution aligns with architecture principles

**Common Fixes:**

#### Fix #1: Race Condition
```tsx
// Problem: State updates race each other
const [count, setCount] = useState(0);

<button onClick={() => {
  setCount(c => c + 1); // Click too fast → lost update
}}/>

// Solution: Use batched updates or async pattern
const increment = useCallback(async () => {
   await new Promise(resolve => setTimeout(resolve, 0)); // Batch to next tick
   setCount(prev => prev + 1);
}, []);
```

#### Fix #2: Module Resolution Error
```bash
# Problem: Module can't be found (CJS vs ESM)
error: Cannot find module '@/utils/helpers'

# Solution A — Check package.json types
{
  "type": "module"  // or "commonjs"
}

# Solution B — Use proper import path
import { helper } from '../../utils/helpers.js';  // Note the .js

# Solution C — tsconfig paths
{
  "compilerOptions": {
    "baseUrl": ".",
     "paths": {
       "@/*": ["src/*"]
    }
   }
}
```

#### Fix #3: Type Error from TypeScript
```tsx
// Problem: Incompatible types
interface User { id: number; name: string }
interface Post { id: number; title: string; author: User['id'] } // ❌ Wrong!

// Solution: Use proper type reference
interface Post { 
  id: number; 
  title: string; 
  authorId: User['id']; // ✅ Correct reference
}
```

---

### Step 5: GUARD (How do I prevent it?)
**Goal:** Add tests, monitoring, or patterns that make this impossible to regress.

**Guardrails Checklist:**
- [ ] Unit test added for this exact scenario
- [ ] Integration test covers the flow
- [ ] E2E test verifies user-facing behavior
- [ ] Monitoring/alerting configured (if production code)
- [ ] Documentation updated if pattern changed
- [ ] ADR created if architectural decision involved

**Test Pyramid Implementation:**
```
       /\  (E2E — 10% of tests, max coverage needed)
      /  \
     /____\  (Integration — 30%, business logic)
    /      \
   /________\  (Unit — 60%, edge cases & helpers)

Guard Example:
- Unit: Edge case where count is -1
- Integration: Full transaction flow with error handling  
- E2E: User can see error message and retry button works
```

---

## 🧠 Phase 2: Forensic Logging (From Debug Agent)

### Structured Error Collection

#### Level Classification
```typescript
enum LogLevel {
  DEBUG = 'debug',     // Verbose, for investigation
  INFO = 'info',       // Normal flow, interesting points
  WARN = 'warn',       // Something might go wrong
  ERROR = 'error',     // Something broke
  FATAL = 'fatal'      // System unusable
}

// Usage:
logger.debug('Starting computation with input:', inputData);
logger.info('Computation completed');
logger.warn('Performance degraded, response time increasing');
logger.error('Payment processing failed', { orderId, error });
logger.fatal('All database connections lost');
```

#### Error Context Capture Template
```javascript
function logError(error, context) {
  const fullContext = {
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV,
    version: pkg.version,
    userId: getUserId(),
    session: getSessionInfo(),
    
    // Error details
    error: {
      message: error.message,
      name: error.name,
      stack: error.stack,
      
      // Additional context
      ...context,
    },
  };
  
  console.error(JSON.stringify(fullContext, null, 2));
  sentry.captureException(error, fullContext);
}
```

---

## 📋 Phase 3: Failure Pattern Recognition (From Debug Investigation)

### Common Failure Patterns & Detection

#### Pattern #1: Circular Dependencies
```javascript
// Detected via static analysis or runtime error
Circular dependency detected: A → B → C → A

// Prevention: Extract shared interface to separate file
// circle-break.ts
export interface UserServiceInterface {
  getUser(id: string): User;
}

// user.service.ts
import { UserServiceInterface } from './circle-break';
class UserService implements UserServiceInterface { ... }
export const userService = new UserService();

// post.service.ts
import { UserServiceInterface } from './circle-break';
```

#### Pattern #2: Event Loop Blocking
```javascript
// Detected via performance monitoring or lighthouse
WARNING: Script execution blocked for > 100ms

// Offload to web worker
const worker = new Worker('./worker.js');
worker.postMessage(data);
worker.onmessage = (e) => setState(e.data);
```

#### Pattern #3: Memory Leaks
```javascript
// Detected via DevTools memory profiler or heap snapshot
WARNING: Memory growing unboundedly over time

// Common leak: event listener never removed
const button = document.createElement('button');
button.addEventListener('click', handleClick); // ← Never removed!
document.body.appendChild(button);

// Fix: Clean up on component mount/unmount
useEffect(() => {
  const btn = document.createElement('button');
  btn.addEventListener('click', handleClick);
  document.body.appendChild(btn);
  
  return () => {
     btn.removeEventListener('click', handleClick); // ← Cleanup!
   };
}, []);
```

---

## 🛡️ Phase 4: Regression Prevention

### Automated Guardrails

#### Pre-Merge Checklist
- [ ] `npm run test` passes locally
- [ ] `npm run lint` passes
- [ ] No breaking changes in public API (if applicable)
- [ ] Performance budget not exceeded

#### CI Shield
```yaml
# .github/workflows/shield.yaml
name: Quality Shield

on: [pull_request]

jobs:
  shield:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      # Layer 1: Fast feedback (lint + types)
      - run: npx biome check --strict .
      
      # Layer 2: Unit tests (parallel, fastest)
      - run: npx vitest run --coverage
      
      # Layer 3: Integration tests (business logic)
      - run: npx vitest run --integration
      
      # Layer 4: Build verification (can it actually build?)
      - run: npm ci && npm run build
      
      # Layer 5: E2E safety net (slow, must pass)
      - run: npx playwright test --workers=4
      
      # Layer 6: Bundle size regression
      - run: npx esbuild --bundle src/index.ts --outfile=/tmp/bundle.js --stats=/tmp/stats.json
      - run: npx esbuild --bundle old-version.ts --outfile=/tmp/old.txt --stats=/tmp/old.txt
      - run: ./scripts/check-bundle-size.sh
      
      # Layer 7: Security audit
      - run: npx npm-audit
```

---

## 🔥 Phase 5: Emergency Recovery Procedures

### When Production is Broken (But You Can't Revert)

#### Step 1: Triage Severity
```
🔴 CRITICAL — System unusable → Emergency patch needed immediately
🟠 HIGH — Core feature broken → Patch within 4 hours
🟡 MEDIUM — Non-core feature affected → Fix by end of day
🟢 LOW — Cosmetic/UX issue → Address in next release
```

#### Step 2: Deploy Hotfix (Not Full Rollback)
```bash
# Don't revert everything if users are mid-action
cd projects/my-project/

git cherry-pick <hotfix-commit> --no-verify

# Verify hotfix works in staging first
npm run test:e2e

# Deploy with feature flag for canary testing
npx feature-toggle enable payment-fix --percentage=5%

# Monitor
npm run sentry:watch
```

---

## 📚 References

See `references/debug-patterns.md` for common failure modes and detection strategies.  
See `references/logging-template.md` for structured error capture guidelines.  
See `references/error-monitoring-setup.md` for Sentry/Bugsnag integration patterns.
