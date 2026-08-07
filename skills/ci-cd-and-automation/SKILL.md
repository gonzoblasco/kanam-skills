---
name: ci-cd-and-automation
description: Automatiza la configuración de pipelines de CI/CD. Usar al configurar o modificar pipelines de build y deployment. Usar cuando necesitás automatizar quality gates, configurar test runners en CI, o establecer estrategias de deployment.
---

# CI/CD y Automatización

## Resumen

Automatizá los quality gates para que ningún cambio llegue a producción sin pasar tests, lint, type checking y build. CI/CD es el mecanismo de enforcement para todas las demás skills - atrapa lo que los humanos y los agentes se pierden, y lo hace de forma consistente en cada cambio.

**Shift Left:** Atrapá los problemas lo antes posible en el pipeline. Un bug atrapado en el linting cuesta minutos; el mismo bug atrapado en producción cuesta horas. Mové los checks hacia arriba - análisis estático antes de los tests, tests antes de staging, staging antes de producción.

**Más Rápido es Más Seguro:** Lotes más chicos y releases más frecuentes reducen el riesgo, no lo aumentan. Un deployment con 3 cambios es más fácil de debuggear que uno con 30. Los releases frecuentes generan confianza en el proceso de release en sí.

## Cuándo Usarlo

- Al configurar el pipeline de CI de un proyecto nuevo
- Al agregar o modificar checks automatizados
- Al configurar pipelines de deployment
- Cuando un cambio debería disparar verificación automatizada
- Al debuggear fallas de CI

## El Pipeline de Quality Gates

Cada cambio pasa por estos gates antes del merge:

```
Pull Request Opened
    │
    ▼
┌─────────────────┐
│   LINT CHECK     │  eslint, prettier
│   ↓ pass         │
│   TYPE CHECK     │  tsc --noEmit
│   ↓ pass         │
│   UNIT TESTS     │  jest/vitest
│   ↓ pass         │
│   BUILD          │  npm run build
│   ↓ pass         │
│   INTEGRATION    │  API/DB tests
│   ↓ pass         │
│   E2E (optional) │  Playwright/Cypress
│   ↓ pass         │
│   SECURITY AUDIT │  npm audit
│   ↓ pass         │
│   BUNDLE SIZE    │  bundlesize check
└─────────────────┘
    │
    ▼
  Ready for review
```

**Ningún gate se puede saltar.** Si el lint falla, arreglá el lint - no desactives la regla. Si un test falla, arreglá el código - no saltes el test.

## Configuración de GitHub Actions

### Pipeline Básico de CI

```yaml
# .github/workflows/ci.yml
name: CI

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Type check
        run: npx tsc --noEmit

      - name: Test
        run: npm test -- --coverage

      - name: Build
        run: npm run build

      - name: Security audit
        run: npm audit --audit-level=high
```

### Con Tests de Integración de Base de Datos

```yaml
  integration:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_DB: testdb
          POSTGRES_USER: ci_user
          POSTGRES_PASSWORD: ${{ secrets.CI_DB_PASSWORD }}
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'
      - run: npm ci
      - name: Run migrations
        run: npx prisma migrate deploy
        env:
          DATABASE_URL: postgresql://ci_user:${{ secrets.CI_DB_PASSWORD }}@localhost:5432/testdb
      - name: Integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgresql://ci_user:${{ secrets.CI_DB_PASSWORD }}@localhost:5432/testdb
```

> **Nota:** Incluso para bases de datos de test solo-CI, usá GitHub Secrets para las credenciales en vez de hardcodear valores. Esto genera buenos hábitos y previene la reutilización accidental de credenciales de test en otros contextos.

### Tests E2E

```yaml
  e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'
      - run: npm ci
      - name: Install Playwright
        run: npx playwright install --with-deps chromium
      - name: Build
        run: npm run build
      - name: Run E2E tests
        run: npx playwright test
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: playwright-report
          path: playwright-report/
```

## Devolviendo las Fallas de CI a los Agentes

El poder de CI con agentes de IA es el loop de feedback. Cuando CI falla:

```
CI falla
    │
    ▼
Copiar la salida de la falla
    │
    ▼
Pasarla al agente:
"El pipeline de CI falló con este error:
[pegar el error específico]
Arreglá el problema y verificá localmente antes de pushear de nuevo."
    │
    ▼
El agente arregla → pushea → CI corre de nuevo
```

**Patrones clave:**

```
Falla de lint → El agente corre `npm run lint --fix` y commitea
Error de tipo → El agente lee la ubicación del error y arregla el tipo
Falla de test → El agente sigue la skill debugging-and-error-recovery
Error de build → El agente revisa config y dependencias
```

## Estrategias de Deployment

### Preview Deployments (Deployments de Vista Previa)

Cada PR obtiene un preview deployment para testing manual:

```yaml
# Deploy preview on PR (Vercel/Netlify/etc.)
deploy-preview:
  runs-on: ubuntu-latest
  if: github.event_name == 'pull_request'
  steps:
    - uses: actions/checkout@v4
    - name: Deploy preview
      run: npx vercel --token=${{ secrets.VERCEL_TOKEN }}
```

### Feature Flags

Los feature flags desacoplan el deployment del release. Desplegá features incompletas o riesgosas detrás de flags para poder:

- **Enviar código sin habilitarlo.** Mergeá a main temprano, habilitalo cuando esté listo.
- **Hacer rollback sin redesplegar.** Desactivá el flag en vez de revertir el código.
- **Probar features con canary.** Habilitalo para el 1% de los usuarios, después 10%, después 100%.
- **Correr tests A/B.** Compará el comportamiento con y sin la feature.

```typescript
// Patrón simple de feature flag
if (featureFlags.isEnabled('new-checkout-flow', { userId })) {
  return renderNewCheckout();
}
return renderLegacyCheckout();
```

**Ciclo de vida del flag:** Crear → Habilitar para testing → Canary → Rollout completo → Eliminar el flag y el código muerto. Los flags que viven para siempre se convierten en deuda técnica - establecé una fecha de limpieza cuando los creás.

### Rollouts por Etapas

```
PR merged to main
    │
    ▼
  Staging deployment (auto)
    │ Manual verification
    ▼
  Production deployment (manual trigger or auto after staging)
    │
    ▼
  Monitor for errors (15-minute window)
    │
    ├── Errors detected → Rollback
    └── Clean → Done
```

### Plan de Rollback

Cada deployment debería ser reversible:

```yaml
# Manual rollback workflow
name: Rollback
on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Version to rollback to'
        required: true

jobs:
  rollback:
    runs-on: ubuntu-latest
    steps:
      - name: Rollback deployment
        run: |
          # Deploy the specified previous version
          npx vercel rollback ${{ inputs.version }}
```

## Gestión de Entornos

```
.env.example       → Committed (template for developers)
.env                → NOT committed (local development)
.env.test           → Committed (test environment, no real secrets)
CI secrets          → Stored in GitHub Secrets / vault
Production secrets  → Stored in deployment platform / vault
```

CI nunca debería tener secretos de producción. Usá secretos separados para el testing de CI.

## Automatización Más Allá de CI

### Dependabot / Renovate

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: npm
    directory: /
    schedule:
      interval: weekly
    open-pull-requests-limit: 5
```

### Rol de Build Cop

Designá a alguien responsable de mantener el CI en verde. Cuando el build se rompe, el trabajo del Build Cop es arreglarlo o revertirlo - no la persona cuyo cambio causó la rotura. Esto previene que los builds rotos se acumulen mientras todos asumen que otra persona lo va a arreglar.

### Checks de PR

- **Reviews requeridos:** Al menos 1 aprobación antes del merge
- **Status checks requeridos:** El CI debe pasar antes del merge
- **Protección de rama:** Sin force-pushes a main
- **Auto-merge:** Si todos los checks pasan y está aprobado, mergear automáticamente

## Optimización de CI

Cuando el pipeline supera los 10 minutos, aplicá estas estrategias en orden de impacto:

```
Slow CI pipeline?
├── Cache dependencies
│   └── Use actions/cache or setup-node cache option for node_modules
├── Run jobs in parallel
│   └── Split lint, typecheck, test, build into separate parallel jobs
├── Only run what changed
│   └── Use path filters to skip unrelated jobs (e.g., skip e2e for docs-only PRs)
├── Use matrix builds
│   └── Shard test suites across multiple runners
├── Optimize the test suite
│   └── Remove slow tests from the critical path, run them on a schedule instead
└── Use larger runners
    └── GitHub-hosted larger runners or self-hosted for CPU-heavy builds
```

**Ejemplo: cache y paralelismo**
```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '22', cache: 'npm' }
      - run: npm ci
      - run: npm run lint

  typecheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '22', cache: 'npm' }
      - run: npm ci
      - run: npx tsc --noEmit

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '22', cache: 'npm' }
      - run: npm ci
      - run: npm test -- --coverage
```

## Racionalizaciones Comunes

| Racionalización | Realidad |
|---|---|
| "CI es demasiado lento" | Optimizá el pipeline (ver Optimización de CI abajo), no lo saltes. Un pipeline de 5 minutos previene horas de debuggeo. |
| "Este cambio es trivial, saltate el CI" | Los cambios triviales rompen builds. CI es rápido para cambios triviales de todas formas. |
| "El test es flaky, simplemente volvé a correrlo" | Los tests flaky esconden bugs reales y desperdician el tiempo de todos. Arreglá el flakiness. |
| "Agregamos CI después" | Los proyectos sin CI acumulan estados rotos. Configuralo desde el primer día. |
| "El testing manual es suficiente" | El testing manual no escala y no es repetible. Automatizá lo que puedas. |

## Red Flags

- No hay pipeline de CI en el proyecto
- Las fallas de CI se ignoran o silencian
- Los tests se desactivan en CI para que el pipeline pase
- Deployments de producción sin verificación en staging
- No hay mecanismo de rollback
- Secretos almacenados en código o archivos de config de CI (no en un secrets manager)
- Tiempos de CI largos sin esfuerzo de optimización

## Verificación

Después de configurar o modificar CI:

- [ ] Todos los quality gates están presentes (lint, types, tests, build, audit)
- [ ] El pipeline corre en cada PR y push a main
- [ ] Las fallas bloquean el merge (protección de rama configurada)
- [ ] Los resultados de CI vuelven al loop de desarrollo
- [ ] Los secretos están en el secrets manager, no en el código
- [ ] El deployment tiene un mecanismo de rollback
- [ ] El pipeline corre en menos de 10 minutos para la suite de tests
