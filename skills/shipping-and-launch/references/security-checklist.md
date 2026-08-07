# Checklist de Seguridad

Referencia rapida para la seguridad de aplicaciones web. Usala junto con la skill `security-and-hardening`.

## Tabla de Contenidos

- [Threat Modeling (Empeza Aca)](#threat-modeling-empeza-aca)
- [Chequeos Pre-Commit](#chequeos-pre-commit)
- [Autenticacion](#autenticacion)
- [Autorizacion](#autorizacion)
- [Validacion de Entrada](#validacion-de-entrada)
- [Security Headers](#security-headers)
- [Configuracion de CORS](#configuracion-de-cors)
- [Proteccion de Datos](#proteccion-de-datos)
- [Seguridad de Dependencias](#seguridad-de-dependencias)
- [Seguridad de IA / LLM](#seguridad-de-ia--llm)
- [Manejo de Errores](#manejo-de-errores)
- [Referencia Rapida OWASP Top 10](#referencia-rapida-owasp-top-10)
- [Referencia Rapida OWASP Top 10 para LLMs](#referencia-rapida-owasp-top-10-para-llms)

## Threat Modeling (Empeza Aca)

Antes de recurrir a los controles, pasa cinco minutos pensando como un atacante:

- [ ] Limites de confianza mapeados (requests, uploads, webhooks, APIs de terceros, output de LLM)
- [ ] Assets nombrados (credenciales, PII, datos de pago, acciones de admin, movimiento de dinero)
- [ ] STRIDE ejecutado por limite (Spoofing, Tampering, Repudiation, Info disclosure, DoS, Elevation)
- [ ] Casos de abuso escritos junto a los casos de uso ("como abusaria yo de esto?")

## Chequeos Pre-Commit

- [ ] Sin secretos en el codigo (`git diff --cached | grep -i "password\|secret\|api_key\|token"`)
- [ ] `.gitignore` cubre: `.env`, `.env.local`, `*.pem`, `*.key`
- [ ] `.env.example` usa valores placeholder (no secretos reales)

## Autenticacion

- [ ] Contrasenas hasheadas con bcrypt (>=12 rondas), scrypt o argon2
- [ ] Cookies de sesion: `httpOnly`, `secure`, `sameSite: 'lax'`
- [ ] Expiracion de sesion configurada (max-age razonable)
- [ ] Rate limiting en el endpoint de login (<=10 intentos por 15 minutos)
- [ ] Tokens de reset de contrasena: con limite de tiempo (<=1 hora), de un solo uso
- [ ] Bloqueo de cuenta despues de fallos repetidos (opcional, con notificacion)
- [ ] MFA soportado para operaciones sensibles (opcional pero recomendado)

## Autorizacion

- [ ] Cada endpoint protegido verifica la autenticacion
- [ ] Cada acceso a un recurso verifica propiedad/rol (previene IDOR)
- [ ] Los endpoints de admin requieren verificacion del rol admin
- [ ] Las API keys estan acotadas a los permisos minimos necesarios
- [ ] Los tokens JWT estan validados (firma, expiracion, issuer)

## Validacion de Entrada

- [ ] Toda la entrada del usuario validada en los limites del sistema (rutas de API, handlers de formularios)
- [ ] La validacion usa allowlists (no denylists)
- [ ] Longitudes de string acotadas (min/max)
- [ ] Rangos numericos validados
- [ ] Formatos de email, URL y fecha validados con librerias apropiadas
- [ ] Uploads de archivos: tipo restringido, tamano limitado, contenido verificado
- [ ] Consultas SQL parametrizadas (sin concatenacion de strings)
- [ ] Output HTML codificado (usa el auto-escaping del framework)
- [ ] URLs validadas antes del redirect (previene open redirect)
- [ ] Fetch de URLs del lado del servidor en allowlist; IPs privadas/reservadas bloqueadas (previene SSRF)

## Security Headers

```
Content-Security-Policy: default-src 'self'; script-src 'self'
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 0  (deshabilitado, confia en CSP)
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

## Configuracion de CORS

```typescript
// Restrictivo (recomendado)
cors({
  origin: ['https://yourdomain.com', 'https://app.yourdomain.com'],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
})

// NUNCA en produccion:
cors({ origin: '*' })  // Permite cualquier origen
```

## Proteccion de Datos

- [ ] Campos sensibles excluidos de las respuestas de API (`passwordHash`, `resetToken`, etc.)
- [ ] Datos sensibles no logueados (contrasenas, tokens, numeros de CC completos)
- [ ] PII encriptada en reposo (si lo requiere la regulacion)
- [ ] HTTPS para toda comunicacion externa
- [ ] Backups de la base de datos encriptados

## Seguridad de Dependencias

Primero localiza el **limite de instalacion**. Si el paquete coincide con una declaracion `workspaces` del padre, usa la raiz de ese workspace; de lo contrario, usa la raiz del proyecto mas cercano que sea dueno de tanto su manifest como su grafo de dependencias. En ese limite, corrobora `packageManager` (cuando este presente), el lockfile y los comandos de CI. Detente si discrepan o si existen lockfiles de managers competidores. Un proyecto anidado es independiente solo cuando esta fuera del workspace del padre; los subproyectos independientes pueden usar legitimanmente managers diferentes.

| Senal de manager/version | Instalacion CI frozen/immutable | Auditoria de advisories conocidos |
|---|---|---|
| npm (`package-lock.json` o `npm-shrinkwrap.json`) | `npm ci` | `npm audit` |
| pnpm | `pnpm install --frozen-lockfile` | `pnpm audit` |
| Yarn 2+ | `yarn install --immutable` | `yarn npm audit -A -R` |
| Yarn 1 | `yarn install --frozen-lockfile` | `yarn audit` |

Para un manager o version no listado, consulta su documentacion oficial; no sustituyas los comandos de otro manager ni los defaults mas nuevos.

### Puerta de Scripts de Instalacion

Nunca descubras los scripts de ciclo de vida de las dependencias ejecutando primero una instalacion ordinaria en un cliente cuyos defaults no se hayan verificado.

1. Bootstrap con los scripts de dependencias deshabilitados, o con una politica documentada de deny-por-default mas enforcement de fail-closed.
2. Inspecciona el origen exacto del script y la version del paquete antes de la aprobacion.
3. Registra la politica nativa de allow/deny mas estrecha en el limite de instalacion y commiteala.
4. Ejecuta una instalacion frozen/immutable limpia con esa politica y verifica que los paquetes requeridos aun compilen.

**Snapshot punto-en-el-tiempo:** Los defaults de los package managers y los nombres de comandos cambian rapido. Verifica esta matriz contra la documentacion oficial actual del cliente fijado antes de depender de ella.

| Version del manager | Politica nativa |
|---|---|
| npm sin aprobaciones granulares verificadas | Bootstrap con `npm ci --ignore-scripts`, o persiste `ignore-scripts=true` cuando se pretende un bloqueo a nivel de proyecto. Mantene los scripts deshabilitados o actualizalos deliberadamente antes de permitir cualquier script de dependencia revisado. |
| npm 11.18.x (verificado en 11.18.0) | Los scripts de dependencia no revisados se ejecutan con una advertencia por default. Fuerza `strict-allow-scripts=true` antes de una instalacion normal, luego usa el `npm install-scripts ls` que no es consciente del workspace desde el limite de instalacion; mantene las aprobaciones fijadas por version y las denegaciones por nombre. |
| npm 12.x (verificado en 12.0.1) | Los scripts de dependencia no revisados se omiten por default; `strict-allow-scripts=true` hace que su presencia falle la instalacion antes de la ejecucion. Usa el mismo flujo de revision y aprobacion de `npm install-scripts`. |
| pnpm 11+ | Usa `pnpm approve-builds` y commitea las decisiones de `allowBuilds`; `strictDepBuilds` es `true` por default, asi que los builds no revisados fallan. |
| pnpm 10.26-10.x | Configura `allowBuilds` explicitamente, o usa `pnpm approve-builds` con las listas legacy `onlyBuiltDependencies` / `ignoredBuiltDependencies`. Establece `strictDepBuilds: true`; su default en v10 es `false`. |
| pnpm 10.1-10.25 | `pnpm approve-builds` registra las listas legacy; habilita `strictDepBuilds` donde sea soportado (10.3+). |
| pnpm viejo o desconocido | Bootstrap con `pnpm install --frozen-lockfile --ignore-scripts`. Mantene los scripts deshabilitados salvo que la version fijada documente una politica ejecutable. |
| Yarn 4.14+ | Los postinstalls de dependencias estan deshabilitados por default. Otorga solo las excepciones requeridas con `dependenciesMeta.<package>.built: true` de nivel superior. |
| Yarn 2-4.13 | Establece `enableScripts: false` en `.yarnrc.yml`, luego otorga solo las excepciones requeridas con `dependenciesMeta.<package>.built: true` de nivel superior; no habilites scripts globalmente. |
| Yarn 1 | Bootstrap con `yarn install --ignore-scripts`; mantene los scripts deshabilitados salvo que cada excepcion requerida se revise bajo el flujo de trabajo documentado del cliente fijado. |

Chequeos autoritativos: [npm install-scripts](https://docs.npmjs.com/cli/v11/commands/npm-install-scripts/), [install policy](https://docs.npmjs.com/cli/v11/commands/npm-install/) y [CLI releases](https://github.com/npm/cli/releases); [pnpm approve-builds](https://pnpm.io/cli/approve-builds) y [build settings](https://pnpm.io/settings#allowbuilds); [Yarn security](https://yarnpkg.com/features/security) y [manifest](https://yarnpkg.com/configuration/manifest#dependenciesMeta).

**Higiene de la supply chain** (las auditorias de advisories no detectan paquetes recientemente maliciosos):
- [ ] Exactamente un lockfile autoritativo por raiz de proyecto/workspace se commitea y CI nunca lo reescribe
- [ ] Los hallazgos criticos/altos se triagean por alcanzabilidad; los diferimientos tienen una razon y una fecha de revision
- [ ] La remediacion forzada de auditoria (`npm audit fix --force` o equivalente) nunca es automatica; los diffs y changelogs de remediacion se revisan
- [ ] Las firmas/provenance del registry se verifican donde el manager lo soporte
- [ ] Los scripts de ciclo de vida de las dependencias estan bloqueados antes de la primera ejecucion y se aprueban solo a traves de la politica nativa del manager fijado
- [ ] Las dependencias nuevas se revisan por propiedad, mantenimiento, antiguedad del release, provenance, grafo transitorio y typosquatting

## Seguridad de IA / LLM

Para cualquier funcion que llame a un LLM (chatbots, summarizers, agents, RAG):

- [ ] El output del modelo se trata como no confiable: nunca en `eval`/SQL/shell/`innerHTML`/rutas de archivo
- [ ] Se asume la inyeccion de prompts; los permisos se aplican en codigo, no en el system prompt
- [ ] Los secretos, los datos cross-tenant y los system prompts completos se mantienen fuera de la ventana de contexto
- [ ] Los permisos de herramientas/agents estan acotados; las acciones destructivas o irreversibles requieren confirmacion
- [ ] Limites de tokens, rate y recursion/loop configurados (acotar el consumo)

## Manejo de Errores

```typescript
// Produccion: error generico, sin internals
res.status(500).json({
  error: { code: 'INTERNAL_ERROR', message: 'Something went wrong' }
});

// NUNCA en produccion:
res.status(500).json({
  error: err.message,
  stack: err.stack,         // Expone internals
  query: err.sql,           // Expone detalles de la base de datos
});
```

## Referencia Rapida OWASP Top 10

| # | Vulnerabilidad | Prevencion |
|---|---|---|
| 1 | Broken Access Control | Chequeos de auth en cada endpoint, verificacion de propiedad |
| 2 | Cryptographic Failures | HTTPS, hashing fuerte, sin secretos en el codigo |
| 3 | Injection | Consultas parametrizadas, validacion de entrada |
| 4 | Insecure Design | Threat modeling, spec-driven development |
| 5 | Security Misconfiguration | Security headers, permisos minimos, auditar deps |
| 6 | Vulnerable Components | La auditoria de dependencias del ecosistema (`npm audit`, `pip-audit`, ...), mantene las deps actualizadas, deps minimas |
| 7 | Auth Failures | Contrasenas fuertes, rate limiting, gestion de sesiones |
| 8 | Data Integrity Failures | Verifica updates/dependencias, artefactos firmados |
| 9 | Logging Failures | Loguea eventos de seguridad, no loguees secretos |
| 10 | SSRF | Valida/allowlista URLs, restringe las solicitudes salientes |

## Referencia Rapida OWASP Top 10 para LLMs

Para apps con funciones de LLM. Ver el [OWASP GenAI Security Project](https://genai.owasp.org/llm-top-10/).

| ID | Riesgo | Prevencion |
|---|---|---|
| LLM01 | Prompt Injection | No confies en el system prompt como limite; aplica permisos en codigo |
| LLM02 | Sensitive Information Disclosure | Mantene secretos/PII fuera de los prompts; filtra los outputs |
| LLM03 | Supply Chain | Evalua modelos, datasets y plugins como cualquier dependencia |
| LLM04 | Data and Model Poisoning | Usa fuentes de modelos confiables, verifica la integridad; evalúa el fine-tuning y los datos de RAG |
| LLM05 | Improper Output Handling | Trata el output del modelo como no confiable; valida, parametriza, codifica |
| LLM06 | Excessive Agency | Acota los permisos de las herramientas; confirma las acciones destructivas |
| LLM07 | System Prompt Leakage | Asume que el system prompt puede filtrarse; no pongas secretos en el |
| LLM08 | Vector and Embedding Weaknesses | Particiona los embeddings de RAG por tenant; valida los documentos antes de indexar |
| LLM09 | Misinformation | Fundamenta las respuestas con citas; valida las afirmaciones criticas; mantene a un humano en el loop |
| LLM10 | Unbounded Consumption | Acota tokens, tasa de solicitudes y profundidad de loop/recursion |
