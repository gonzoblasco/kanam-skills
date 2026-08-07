# Lista de verificación de seguridad

Referencia rápida para la seguridad de aplicaciones web. Úsala junto con la skill `security-and-hardening`.

## Tabla de contenidos

- [Modelado de amenazas (empezar aquí)](#modelado-de-amenazas-empezar-aquí)
- [Verificaciones previas al commit](#verificaciones-previas-al-commit)
- [Autenticación](#autenticación)
- [Autorización](#autorización)
- [Validación de entrada](#validación-de-entrada)
- [Cabeceras de seguridad](#cabeceras-de-seguridad)
- [Configuración de CORS](#configuración-de-cors)
- [Protección de datos](#protección-de-datos)
- [Seguridad de dependencias](#seguridad-de-dependencias)
- [Seguridad de IA / LLM](#seguridad-de-ia--llm)
- [Manejo de errores](#manejo-de-errores)
- [Referencia rápida del OWASP Top 10](#referencia-rápida-del-owasp-top-10)
- [Referencia rápida del OWASP Top 10 para LLMs](#referencia-rápida-del-owasp-top-10-para-llms)

## Modelado de amenazas (empezar aquí)

Antes de llegar a los controles, dedica cinco minutos a pensar como un atacante:

- [ ] Límites de confianza mapeados (peticiones, subidas, webhooks, APIs de terceros, salida de LLM)
- [ ] Activos nombrados (credenciales, PII, datos de pago, acciones de administrador, movimiento de dinero)
- [ ] STRIDE ejecutado por límite (Spoofing, Tampering, Repudiation, divulgación de info, DoS, Elevación)
- [ ] Casos de abuso escritos junto a los casos de uso ("¿cómo abusaría yo de esto?")

## Verificaciones previas al commit

- [ ] Sin secretos en código (`git diff --cached | grep -i "password\|secret\|api_key\|token"`)
- [ ] `.gitignore` cubre: `.env`, `.env.local`, `*.pem`, `*.key`
- [ ] `.env.example` usa valores de ejemplo (no secretos reales)

## Autenticación

- [ ] Contraseñas hasheadas con bcrypt (≥12 rounds), scrypt o argon2
- [ ] Cookies de sesión: `httpOnly`, `secure`, `sameSite: 'lax'`
- [ ] Caducidad de sesión configurada (max-age razonable)
- [ ] Límite de peticiones en el endpoint de login (≤10 intentos por 15 minutos)
- [ ] Tokens de reset de contraseña: con límite de tiempo (≤1 hora), de un solo uso
- [ ] Bloqueo de cuenta tras fallos repetidos (opcional, con notificación)
- [ ] MFA soportado para operaciones sensibles (opcional pero recomendado)

## Autorización

- [ ] Cada endpoint protegido verifica la autenticación
- [ ] Cada acceso a recurso verifica propiedad/rol (previene IDOR)
- [ ] Los endpoints de admin requieren verificación de rol de admin
- [ ] API keys limitadas a los permisos mínimos necesarios
- [ ] Tokens JWT validados (firma, expiración, emisor)

## Validación de entrada

- [ ] Toda la entrada de usuario validada en los límites del sistema (rutas de API, manejadores de formularios)
- [ ] La validación usa listas blancas (no listas negras)
- [ ] Longitudes de cadenas restringidas (min/max)
- [ ] Rangos numéricos validados
- [ ] Formatos de email, URL y fecha validados con librerías apropiadas
- [ ] Subidas de archivos: tipo restringido, tamaño limitado, contenido verificado
- [ ] Consultas SQL parametrizadas (sin concatenación de cadenas)
- [ ] Salida HTML codificada (usa el escape automático del framework)
- [ ] URLs validadas antes de redirigir (previene open redirect)
- [ ] Obtenciones de URL del lado del servidor en lista blanca; IPs privadas/reservadas bloqueadas (previene SSRF)

## Cabeceras de seguridad

```
Content-Security-Policy: default-src 'self'; script-src 'self'
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 0  (desactivado, confía en CSP)
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

## Configuración de CORS

```typescript
// Restrictivo (recomendado)
cors({
  origin: ['https://yourdomain.com', 'https://app.yourdomain.com'],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
})

// NUNCA usar en producción:
cors({ origin: '*' })  // Permite cualquier origen
```

## Protección de datos

- [ ] Campos sensibles excluidos de las respuestas de API (`passwordHash`, `resetToken`, etc.)
- [ ] Datos sensibles no registrados (contraseñas, tokens, números completos de tarjeta de crédito)
- [ ] PII cifrada en reposo (si lo exige la regulación)
- [ ] HTTPS para toda la comunicación externa
- [ ] Backups de base de datos cifrados

## Seguridad de dependencias

Primero localiza el **límite de instalación**. Si el paquete coincide con una declaración `workspaces` padre, usa esa raíz de workspace; de lo contrario, usa la raíz del proyecto más cercana que posea tanto su manifest como su grafo de dependencias. En ese límite, corrobora `packageManager` (cuando esté presente), el lockfile y los comandos de CI. Detente si no coinciden o si existen lockfiles de gestores en competencia allí. Un proyecto anidado es independiente solo cuando está fuera del workspace padre; los subproyectos independientes pueden usar legítimamente gestores distintos.

| Señal de gestor/versión | Instalación CI frozen/inmutable | Auditoría de advisory conocidos |
|---|---|---|
| npm (`package-lock.json` o `npm-shrinkwrap.json`) | `npm ci` | `npm audit` |
| pnpm | `pnpm install --frozen-lockfile` | `pnpm audit` |
| Yarn 2+ | `yarn install --immutable` | `yarn npm audit -A -R` |
| Yarn 1 | `yarn install --frozen-lockfile` | `yarn audit` |

Para un gestor o versión no listado, consulta su documentación oficial; no sustituyas los comandos de otro gestor ni los defaults más nuevos.

### Puerta de scripts de instalación

Nunca descubras los scripts de ciclo de vida de las dependencias ejecutando primero una instalación ordinaria en un cliente cuyos defaults no se hayan verificado.

1. Inicializa con scripts de dependencias desactivados, o con una política documentada de denegación por defecto más una aplicación con fallo cerrado.
2. Inspecciona el código fuente exacto del script y la versión del paquete antes de aprobar.
3. Registra la política nativa más restringida de permitir/denegar en el límite de instalación y confírmala.
4. Ejecuta una instalación limpia frozen/inmutable con esa política y verifica que los paquetes requeridos aún compilan.

**Instantánea puntual:** los defaults de los gestores de paquetes y los nombres de comandos cambian rápido. Verifica esta matriz contra la documentación oficial actual del cliente fijado antes de confiar en ella.

| Versión del gestor | Política nativa |
|---|---|
| npm sin aprobaciones granulares verificadas | Inicializa con `npm ci --ignore-scripts`, o persiste `ignore-scripts=true` cuando se pretenda bloquear a nivel de proyecto. Mantén los scripts desactivados o actualiza deliberadamente antes de permitir cualquier script de dependencia revisado. |
| npm 11.18.x (verificado en 11.18.0) | Los scripts de dependencias sin revisar se ejecutan con una advertencia por defecto. Aplica `strict-allow-scripts=true` antes de una instalación normal, luego usa el `npm install-scripts ls` que no conoce el workspace desde el límite de instalación; mantén las aprobaciones fijadas por versión y las denegaciones por nombre. |
| npm 12.x (verificado en 12.0.1) | Los scripts de dependencias sin revisar se omiten por defecto; `strict-allow-scripts=true` hace que su presencia falle la instalación antes de la ejecución. Usa el mismo flujo de revisión y aprobación `npm install-scripts`. |
| pnpm 11+ | Usa `pnpm approve-builds` y confirma las decisiones `allowBuilds`; `strictDepBuilds` es `true` por defecto, así que los builds sin revisar fallan. |
| pnpm 10.26–10.x | Configura `allowBuilds` explícitamente, o usa `pnpm approve-builds` con las listas legacy `onlyBuiltDependencies` / `ignoredBuiltDependencies`. Define `strictDepBuilds: true`; su default en v10 es `false`. |
| pnpm 10.1–10.25 | `pnpm approve-builds` registra las listas legacy; habilita `strictDepBuilds` donde se soporte (10.3+). |
| pnpm más viejo o desconocido | Inicializa con `pnpm install --frozen-lockfile --ignore-scripts`. Mantén los scripts desactivados salvo que la versión fijada documento una política aplicable. |
| Yarn 4.14+ | Los postinstalls de dependencias están desactivados por defecto. Otorga solo las excepciones requeridas con `dependenciesMeta.<package>.built: true` a nivel superior. |
| Yarn 2–4.13 | Define `enableScripts: false` en `.yarnrc.yml`, luego otorga solo las excepciones requeridas con `dependenciesMeta.<package>.built: true` a nivel superior; no habilites los scripts globalmente. |
| Yarn 1 | Inicializa con `yarn install --ignore-scripts`; mantén los scripts desactivados salvo que cada excepción requerida se revise bajo el flujo documentado del cliente fijado. |

Verificaciones autoritativas: [npm install-scripts](https://docs.npmjs.com/cli/v11/commands/npm-install-scripts/), [política de instalación](https://docs.npmjs.com/cli/v11/commands/npm-install/) y [releases de CLI](https://github.com/npm/cli/releases); [pnpm approve-builds](https://pnpm.io/cli/approve-builds) y [configuración de build](https://pnpm.io/settings#allowbuilds); [seguridad de Yarn](https://yarnpkg.com/features/security) y [manifest](https://yarnpkg.com/configuration/manifest#dependenciesMeta).

**Higiene de la cadena de suministro** (las auditorías de advisory no detectan paquetes recién maliciosos):
- [ ] Exactamente un lockfile autoritativo por raíz de proyecto/workspace confirmado y CI nunca lo reescribe
- [ ] Hallazgos críticos/altos con triaje por alcanzabilidad; los diferimientos tienen motivo y fecha de revisión
- [ ] La remediación de auditoría forzada (`npm audit fix --force` o equivalente) nunca es automática; se revisan los diffs de remediación y los changelogs
- [ ] Firmas/procedencia del registro verificadas donde el gestor lo soporte
- [ ] Scripts de ciclo de vida de dependencias bloqueados antes de la primera ejecución y aprobados solo a través de la política nativa del gestor fijado
- [ ] Nuevas dependencias revisadas por propiedad, mantenimiento, antigüedad del release, procedencia, grafo transitivo y typosquatting

## Seguridad de IA / LLM

Para cualquier funcionalidad que llame a un LLM (chatbots, resumidores, agentes, RAG):

- [ ] Salida del modelo tratada como no confiable; nunca hacia `eval`/SQL/shell/`innerHTML`/rutas de archivo
- [ ] Inyección de prompts asumida; permisos aplicados en código, no en el system prompt
- [ ] Secretos, datos entre tenants y system prompts completos fuera de la ventana de contexto
- [ ] Permisos de herramientas/agentes limitados; las acciones destructivas o irreversibles requieren confirmación
- [ ] Límites de tokens, tasa y recursión/loop establecidos (consumo acotado)

## Manejo de errores

```typescript
// Producción: error genérico, sin internos
res.status(500).json({
  error: { code: 'INTERNAL_ERROR', message: 'Algo salió mal' }
});

// NUNCA en producción:
res.status(500).json({
  error: err.message,
  stack: err.stack,         // Expone internos
  query: err.sql,           // Expone detalles de la base de datos
});
```

## Referencia rápida del OWASP Top 10

| # | Vulnerabilidad | Prevención |
|---|---|---|
| 1 | Control de acceso roto | Verificaciones de auth en cada endpoint, verificación de propiedad |
| 2 | Fallos criptográficos | HTTPS, hash fuerte, sin secretos en código |
| 3 | Inyección | Consultas parametrizadas, validación de entrada |
| 4 | Diseño inseguro | Modelado de amenazas, desarrollo guiado por especificación |
| 5 | Mala configuración de seguridad | Cabeceras de seguridad, permisos mínimos, auditoría de deps |
| 6 | Componentes vulnerables | La auditoría de dependencias del ecosistema (`npm audit`, `pip-audit`, ...), mantener deps actualizadas, deps mínimas |
| 7 | Fallos de autenticación | Contraseñas fuertes, límite de peticiones, gestión de sesiones |
| 8 | Fallos de integridad de datos | Verificar actualizaciones/dependencias, artefactos firmados |
| 9 | Fallos de registro | Registrar eventos de seguridad, no registrar secretos |
| 10 | SSRF | Validar/lista blanca de URLs, restringir peticiones salientes |

## Referencia rápida del OWASP Top 10 para LLMs

Para apps con funcionalidades de LLM. Ver el [Proyecto de seguridad GenAI de OWASP](https://genai.owasp.org/llm-top-10/).

| ID | Riesgo | Prevención |
|---|---|---|
| LLM01 | Inyección de prompts | No confíes en el system prompt como límite; aplica permisos en código |
| LLM02 | Divulgación de información sensible | Mantén secretos/PII fuera de los prompts; filtra las salidas |
| LLM03 | Cadena de suministro | Evalúa modelos, datasets y plugins como cualquier dependencia |
| LLM04 | Envenenamiento de datos y modelos | Usa fuentes de modelos confiables, verifica integridad; evalúa el fine-tuning y los datos RAG |
| LLM05 | Manejo inadecuado de la salida | Trata la salida del modelo como no confiable; valida, parametriza, codifica |
| LLM06 | Agencia excesiva | Limita los permisos de las herramientas; confirma las acciones destructivas |
| LLM07 | Fuga del system prompt | Asume que el system prompt puede filtrarse; no pongas secretos en él |
| LLM08 | Debilidades de vectores y embeddings | Particiona los embeddings RAG por tenant; valida documentos antes de indexar |
| LLM09 | Desinformación | Fundamenta las respuestas con citas; valida afirmaciones críticas; mantén un humano en el bucle |
| LLM10 | Consumo ilimitado | Limita tokens, tasa de peticiones y profundidad de loop/recursión |
