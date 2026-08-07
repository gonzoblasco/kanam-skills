---
name: security-and-hardening
description: Endurece el código contra vulnerabilidades. Usar al manejar entrada de usuario, autenticación, almacenamiento de datos o integraciones externas. Usar al construir cualquier funcionalidad que acepte datos no confiables, administre sesiones de usuario o interactúe con servicios de terceros.
---

# Seguridad y endurecimiento

## Descripción general

Prácticas de desarrollo que priorizan la seguridad para aplicaciones web. Trata cada entrada externa como hostil, cada secreto como sagrado y cada verificación de autorización como obligatoria. La seguridad no es una fase: es una restricción en cada línea de código que toca datos de usuario, autenticación o sistemas externos.

## Cuándo usar

- Al construir cualquier cosa que acepte entrada de usuario
- Al implementar autenticación o autorización
- Al almacenar o transmitir datos sensibles
- Al integrarse con APIs o servicios externos
- Al agregar subidas de archivos, webhooks o callbacks
- Al manejar datos de pago o PII

## Proceso: modelo de amenazas primero

Los controles añadidos sin un modelo de amenazas son conjeturas. Antes de endurecer, dedica cinco minutos a pensar como un atacante:

1. **Mapea los límites de confianza.** ¿Dónde cruza la entrada no confiable hacia tu sistema? Peticiones HTTP, campos de formulario, subidas de archivos, webhooks, APIs de terceros, colas de mensajes y **salida de LLM**. Cada límite es superficie de ataque.
2. **Nombra los activos.** ¿Qué vale la pena robar o romper? Credenciales, PII, datos de pago, acciones de administrador, movimiento de dinero.
3. **Ejecuta STRIDE sobre cada límite**, una lente rápida, no una ceremonia:

| Amenaza | Pregunta | Mitigación típica |
|---|---|---|
| **S**poofing (suplantación) | ¿Puede alguien hacerse pasar por un usuario/servicio? | Autenticación, verificación de firmas |
| **T**ampering (manipulación) | ¿Pueden alterarse los datos en tránsito o en reposo? | Comprobaciones de integridad, consultas parametrizadas, HTTPS |
| **R**epudiation (repudio) | ¿Puede negarse una acción después? | Registro de auditoría de eventos de seguridad |
| **I**nformation disclosure (divulgación de información) | ¿Pueden filtrarse los datos? | Cifrado, listas blancas de campos, errores genéricos |
| **D**enial of service (denegación de servicio) | ¿Puede verse sobrecargado? | Límite de peticiones, límites de tamaño de entrada, timeouts |
| **E**levation of privilege (elevación de privilegios) | ¿Puede un usuario obtener derechos que no debería? | Verificaciones de autorización, mínimo privilegio |

4. **Escribe casos de abuso junto a los casos de uso.** Para cada funcionalidad, pregúntate "¿cómo abusaría yo de esto?" y haz de eso tu primera prueba.

Si no puedes nombrar los límites de confianza de una funcionalidad, no estás listo para asegurarla. Esto es OWASP **A04: Diseño inseguro**; la mayoría de las brechas comienzan en el diseño, no en el código.

## El sistema de límites de tres niveles

### Siempre hacer (sin excepciones)

- **Valida toda la entrada externa** en el límite del sistema (rutas de API, manejadores de formularios)
- **Parametriza todas las consultas de base de datos**; nunca concatenes entrada de usuario en SQL
- **Codifica la salida** para prevenir XSS (usa el escape automático del framework, no lo eludas)
- **Usa HTTPS** para toda la comunicación externa
- **Hashea las contraseñas** con bcrypt/scrypt/argon2 (nunca almacenes texto plano)
- **Configura las cabeceras de seguridad** (CSP, HSTS, X-Frame-Options, X-Content-Type-Options)
- **Usa cookies httpOnly, secure, sameSite** para las sesiones
- **Ejecuta la auditoría nativa del gestor de paquetes detectado** contra el lockfile confirmado antes de cada release

### Preguntar primero (requiere aprobación humana)

- Agregar nuevos flujos de autenticación o cambiar la lógica de auth
- Almacenar nuevas categorías de datos sensibles (PII, información de pago)
- Agregar nuevas integraciones con servicios externos
- Cambiar la configuración de CORS
- Agregar manejadores de subida de archivos
- Modificar el límite de peticiones o el throttling
- Otorgar permisos o roles elevados

### Nunca hacer

- **Nunca confirmes secretos** en el control de versiones (API keys, contraseñas, tokens)
- **Nunca registres datos sensibles** (contraseñas, tokens, números completos de tarjeta de crédito)
- **Nunca confíes en la validación del lado del cliente** como límite de seguridad
- **Nunca desactives las cabeceras de seguridad** por conveniencia
- **Nunca uses `eval()` o `innerHTML`** con datos proporcionados por el usuario
- **Nunca almacenes sesiones en almacenamiento accesible por el cliente** (localStorage para tokens de autenticación)
- **Nunca expongas stack traces** ni detalles internos de errores a los usuarios

## Patrones de prevención del OWASP Top 10

Estos son patrones de prevención, no un ranking. Para el ordenamiento de 2021, consulta la tabla de referencia rápida en `references/security-checklist.md`.

### Inyección (SQL, NoSQL, comando de SO)

```typescript
// MAL: inyección SQL mediante concatenación de cadenas
const query = `SELECT * FROM users WHERE id = '${userId}'`;

// BIEN: consulta parametrizada
const user = await db.query('SELECT * FROM users WHERE id = $1', [userId]);

// BIEN: ORM con entrada parametrizada
const user = await prisma.user.findUnique({ where: { id: userId } });
```

### Autenticación rota

```typescript
// Hash de contraseñas
import { hash, compare } from 'bcrypt';

const SALT_ROUNDS = 12;
const hashedPassword = await hash(plaintext, SALT_ROUNDS);
const isValid = await compare(plaintext, hashedPassword);

// Gestión de sesiones
app.use(session({
  secret: process.env.SESSION_SECRET,  // Desde el entorno, no del código
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,     // No accesible vía JavaScript
    secure: true,       // Solo HTTPS
    sameSite: 'lax',    // Protección CSRF
    maxAge: 24 * 60 * 60 * 1000,  // 24 horas
  },
}));
```

### Cross-Site Scripting (XSS)

```typescript
// MAL: renderizar entrada de usuario como HTML
element.innerHTML = userInput;

// BIEN: usar el escape automático del framework (React lo hace por defecto)
return <div>{userInput}</div>;

// Si DEBES renderizar HTML, sanitiza primero
import DOMPurify from 'dompurify';
const clean = DOMPurify.sanitize(userInput);
```

### Control de acceso roto

```typescript
// Siempre verifica la autorización, no solo la autenticación
app.patch('/api/tasks/:id', authenticate, async (req, res) => {
  const task = await taskService.findById(req.params.id);

  // Verifica que el usuario autenticado es dueño de este recurso
  if (task.ownerId !== req.user.id) {
    return res.status(403).json({
      error: { code: 'FORBIDDEN', message: 'No autorizado para modificar esta tarea' }
    });
  }

  // Continúa con la actualización
  const updated = await taskService.update(req.params.id, req.body);
  return res.json(updated);
});
```

### Mala configuración de seguridad

```typescript
// Cabeceras de seguridad (usa helmet para Express)
import helmet from 'helmet';
app.use(helmet());

// Content Security Policy
app.use(helmet.contentSecurityPolicy({
  directives: {
    defaultSrc: ["'self'"],
    scriptSrc: ["'self'"],
    styleSrc: ["'self'", "'unsafe-inline'"],  // Aprieta si es posible
    imgSrc: ["'self'", 'data:', 'https:'],
    connectSrc: ["'self'"],
  },
}));

// CORS: restringe a orígenes conocidos
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || 'http://localhost:3000',
  credentials: true,
}));
```

### Exposición de datos sensibles

```typescript
// Nunca devuelvas campos sensibles en respuestas de API
function sanitizeUser(user: UserRecord): PublicUser {
  const { passwordHash, resetToken, ...publicFields } = user;
  return publicFields;
}

// Usa variables de entorno para los secretos
const API_KEY = process.env.STRIPE_API_KEY;
if (!API_KEY) throw new Error('STRIPE_API_KEY no configurada');
```

### Server-Side Request Forgery (SSRF)

Cada vez que el servidor obtiene una URL influenciada por el usuario, ya sean webhooks, "importar desde URL", proxies de imágenes o vistas previas de enlaces, un atacante puede apuntarla a servicios internos (metadata de la nube, `localhost`, IPs privadas).

```typescript
// MAL: obtener lo que sea que el usuario te dé
await fetch(req.body.webhookUrl);

// BIEN: lista blanca de esquema + host, rechaza si CUALQUIER IP resuelta es privada, prohíbe redirecciones
import { lookup } from 'node:dns/promises';
import ipaddr from 'ipaddr.js';

const ALLOWED_HOSTS = new Set(['hooks.example.com']);

async function assertSafeUrl(raw: string): Promise<URL> {
  const url = new URL(raw);
  if (url.protocol !== 'https:') throw new Error('solo https');
  if (!ALLOWED_HOSTS.has(url.hostname)) throw new Error('host no permitido');
  // Resuelve TODOS los registros; una sola dirección privada/reservada falla la verificación.
  const addrs = await lookup(url.hostname, { all: true });
  if (addrs.some((a) => ipaddr.parse(a.address).range() !== 'unicast')) {
    throw new Error('IP privada/reservada');
  }
  return url;
}

await fetch(await assertSafeUrl(req.body.webhookUrl), { redirect: 'error' });
```

La verificación `range() !== 'unicast'` cubre loopback, link-local `169.254.169.254` (metadata de la nube, el objetivo SSRF #1), privada y rangos unique-local en IPv4 e IPv6.

**Advertencia: esto aún tiene un hueco TOCTOU.** `fetch` resuelve DNS de nuevo después de la verificación, así que un atacante que use un registro de TTL corto puede reenlazarse a una IP interna entre la validación y la conexión. Para superficies de alto riesgo, resuelve una vez y conéctate a la IP fijada, o pon un agente de filtrado por delante (`request-filtering-agent` / `ssrf-req-filter`).

## Patrones de validación de entrada

### Validación de esquema en los límites

```typescript
import { z } from 'zod';

const CreateTaskSchema = z.object({
  title: z.string().min(1).max(200).trim(),
  description: z.string().max(2000).optional(),
  priority: z.enum(['low', 'medium', 'high']).default('medium'),
  dueDate: z.string().datetime().optional(),
});

// Valida en el manejador de ruta
app.post('/api/tasks', async (req, res) => {
  const result = CreateTaskSchema.safeParse(req.body);
  if (!result.success) {
    return res.status(422).json({
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Entrada inválida',
        details: result.error.flatten(),
      },
    });
  }
  // result.data ahora está tipado y validado
  const task = await taskService.create(result.data);
  return res.status(201).json(task);
});
```

### Seguridad en la subida de archivos

```typescript
// Restringe tipos y tamaños de archivos
const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp'];
const MAX_SIZE = 5 * 1024 * 1024; // 5MB

function validateUpload(file: UploadedFile) {
  if (!ALLOWED_TYPES.includes(file.mimetype)) {
    throw new ValidationError('Tipo de archivo no permitido');
  }
  if (file.size > MAX_SIZE) {
    throw new ValidationError('Archivo demasiado grande (máx 5MB)');
  }
  // No confíes en la extensión del archivo: verifica los magic bytes si es crítico
}
```

## Triaje de los resultados de auditoría de dependencias

Las auditorías de gestores de paquetes reportan advisory conocidos; no prueban que un paquete sea confiable ni que el código vulnerable sea alcanzable. Usa este árbol de decisiones:

```
La auditoría nativa del gestor de paquetes reporta una vulnerabilidad
├── Severidad: crítica o alta
│   ├── ¿Es alcanzable el código vulnerable en rutas de runtime, build, test o despliegue?
│   │   ├── SÍ --> Arreglar de inmediato (actualizar, parchear o reemplazar la dependencia)
│   │   └── NO (confirmado sin uso en esas rutas) --> Arreglar pronto, pero no es bloqueante
│   └── ¿Hay un arreglo disponible?
│       ├── SÍ --> Actualizar a la versión parcheada
│       └── NO --> Revisar workarounds, considerar reemplazar la dependencia, o añadir a la lista blanca con una fecha de revisión
├── Severidad: moderada
│   ├── ¿Alcanzable en producción? --> Arreglar en el próximo ciclo de release
│   └── ¿Solo dev? --> Arreglar cuando convenga, registrar en el backlog
└── Severidad: baja
    └── Rastrear y arreglar durante las actualizaciones regulares de dependencias
```

**Preguntas clave:**
- ¿La función vulnerable se llama realmente en tu ruta de código?
- ¿La dependencia es de runtime o solo de dev?
- ¿Es explotable la vulnerabilidad dado tu contexto de despliegue (por ejemplo, una vulnerabilidad del lado del servidor en una app solo de cliente)?

Cuando difieras un arreglo, documenta el motivo y fija una fecha de revisión.

### Higiene de la cadena de suministro

No asumas npm ni trates el manifest más cercano como la raíz de instalación. Aplica este orden:

1. **Encuentra el límite de instalación y el gestor.** Usa la raíz del workspace que posee el lockfile, o un proyecto anidado independiente solo cuando esté fuera de ese workspace. Allí, corrobora `packageManager` (cuando esté presente), el lockfile y CI; detente ante desacuerdos o lockfiles en competencia. Fija la versión del gestor y usa la matriz en `references/security-checklist.md`.
2. **Bloquea los scripts de dependencias antes de la primera ejecución.** Inicializa con scripts desactivados o una política documentada de fallo cerrado, inspecciona el código fuente de los scripts pendientes, aprueba solo los paquetes mínimos requeridos, confirma la política y luego verifica con una instalación limpia frozen/inmutable. Nunca apruebes scripts de forma generalizada.

Las auditorías solo encuentran advisory conocidos; no detectan un paquete recién malicioso o con typosquatting. Por lo tanto:

- **Nunca apliques remediación de auditoría forzada automáticamente** (`npm audit fix --force` o equivalente). Previsualiza la remediación, lee los changelogs y prueba cada actualización resultante; los arreglos forzados pueden cruzar los rangos de dependencias declarados.
- **Verifica firmas y procedencia del registro donde se soporte** (`npm audit signatures`, `pnpm audit signatures`) y trata su ausencia como una señal para investigar, no como prueba automática de compromiso.
- **Revisa las nuevas dependencias, los diffs del lockfile y los cambios de política de scripts juntos**: propiedad, mantenimiento, antigüedad del release, procedencia, grafo transitivo y typosquats como `cross-env` vs `crossenv` (OWASP **A06**, **LLM03**).

## Límite de peticiones

```typescript
import rateLimit from 'express-rate-limit';

// Límite de peticiones general de API
app.use('/api/', rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100,                   // 100 peticiones por ventana
  standardHeaders: true,
  legacyHeaders: false,
}));

// Límite más estricto para endpoints de auth
app.use('/api/auth/', rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,  // 10 intentos por 15 minutos
}));
```

## Gestión de secretos

```
Archivos .env:
  ├── .env.example  → Confirmado (plantilla con valores de ejemplo)
  ├── .env          → NO confirmado (contiene secretos reales)
  └── .env.local    → NO confirmado (overrides locales)

.gitignore debe incluir:
  .env
  .env.local
  .env.*.local
  *.pem
  *.key
```

**Siempre verifica antes de confirmar:**
```bash
# Revisa secretos subidos por accidente
git diff --cached | grep -i "password\|secret\|api_key\|token"
```

**Si algún secreto se confirma alguna vez, rótalo.** Borrar la línea o reescribir el historial no es suficiente: asume que está comprometido en el momento en que llega a un remoto. Revoca y reemite la clave primero, y luego elimínala del historial.

## Asegurar funcionalidades de IA / LLM

Si tu app llama a un LLM, ya sean chatbots, resumidores, agentes o RAG, hereda una nueva superficie de ataque. Mapéala al [OWASP Top 10 para aplicaciones LLM (2025)](https://genai.owasp.org/llm-top-10/):

- **Trata toda la salida del modelo como entrada no confiable (LLM05: manejo inadecuado de la salida).** Nunca pases salida de LLM directamente a `eval`, SQL, una shell, `innerHTML` o una ruta de archivo. Valídala y codifícala exactamente como lo harías con entrada de usuario cruda.
- **Asume que los prompts pueden ser secuestrados (LLM01: inyección de prompts).** Texto no confiable en la ventana de contexto, ya sea un mensaje de usuario, una página web obtenida o un PDF, puede portar instrucciones. El system prompt no es un límite de seguridad; aplica permisos en código, no en el prompt.
- **Mantén secretos y datos de otros usuarios fuera de los prompts (LLM02 / LLM07).** Cualquier cosa en el contexto puede repetirse. No pongas API keys, datos entre tenants ni el system prompt completo donde el modelo pueda repetirlos.
- **Restringe los permisos de herramientas y agentes (LLM06: agencia excesiva).** Limita las herramientas al mínimo, exige confirmación para acciones destructivas o irreversibles y valida cada argumento de herramienta.
- **Acota el consumo (LLM10: consumo ilimitado).** Limita tokens, tasa de peticiones y profundidad de loops/recursión para que una entrada manipulada no dispare costos ni cuelgue el sistema.
- **Aísla los datos de recuperación (LLM08: debilidades de vectores y embeddings).** En RAG, trata el vector store como un límite de confianza: particiona los embeddings por tenant para que un usuario no pueda recuperar datos de otro, y valida los documentos antes de indexarlos para que el contenido envenenado no dirija las respuestas.

```typescript
// MAL: confiar en la salida del modelo como comando o como markup
const sql = await llm.generate(`Escribe SQL para: ${userQuestion}`);
await db.query(sql);                                   // ejecución arbitraria de consultas
container.innerHTML = await llm.reply(userMessage);   // XSS almacenado, vía el modelo

// BIEN: la salida del modelo es dato: parsea defensivamente, luego valida, luego codifica
let intent;
try {
  intent = CommandSchema.parse(JSON.parse(await llm.replyJson(userMessage)));
} catch {
  throw new ValidationError('salida inesperada del modelo'); // JSON.parse o el esquema falló
}
await runAllowlistedAction(intent.action, intent.params);
container.textContent = await llm.reply(userMessage);
```

## Lista de verificación de revisión de seguridad

```markdown
### Autenticación
- [ ] Contraseñas hasheadas con bcrypt/scrypt/argon2 (salt rounds ≥ 12)
- [ ] Tokens de sesión httpOnly, secure, sameSite
- [ ] El login tiene límite de peticiones
- [ ] Los tokens de reset de contraseña expiran

### Autorización
- [ ] Cada endpoint verifica los permisos del usuario
- [ ] Los usuarios solo pueden acceder a sus propios recursos
- [ ] Las acciones de administrador requieren verificación de rol de admin

### Entrada
- [ ] Toda la entrada de usuario validada en el límite
- [ ] Las consultas SQL están parametrizadas
- [ ] La salida HTML está codificada/escapada
- [ ] Las obtenciones de URL del lado del servidor están en lista blanca (sin SSRF a servicios internos)

### Datos
- [ ] Sin secretos en código ni en control de versiones
- [ ] Campos sensibles excluidos de las respuestas de API
- [ ] PII cifrada en reposo (si aplica)

### Infraestructura
- [ ] Cabeceras de seguridad configuradas (CSP, HSTS, etc.)
- [ ] CORS restringido a orígenes conocidos
- [ ] Dependencias auditadas por vulnerabilidades
- [ ] Los mensajes de error no exponen internos

### Cadena de suministro
- [ ] Un lockfile autoritativo confirmado; CI usa la instalación frozen/inmutable de ese gestor
- [ ] Auditoría nativa con triaje por alcanzabilidad y riesgo de arreglo; scripts de instalación de dependencias bloqueados salvo aprobación explícita
- [ ] Nuevas dependencias revisadas (propiedad, procedencia, antigüedad del release, grafo transitivo)

### IA / LLM (si se usa)
- [ ] Salida del modelo tratada como no confiable (sin eval/SQL/innerHTML/shell)
- [ ] Secretos y datos de otros usuarios fuera de los prompts
- [ ] Permisos de herramientas/agentes limitados; las acciones destructivas requieren confirmación
```
## Ver también

Para listas de verificación de seguridad detalladas y pasos de verificación previos al commit, consulta `references/security-checklist.md`.

## Racionalizaciones comunes

| Racionalización | Realidad |
|---|---|
| "Es una herramienta interna, la seguridad no importa" | Las herramientas internas se ven comprometidas. Los atacantes apuntan al eslabón más débil. |
| "Añadiremos la seguridad después" | Readaptar la seguridad es 10 veces más difícil que construirla desde el inicio. Añádela ahora. |
| "Nadie intentaría explotar esto" | Los escáneres automatizados lo encontrarán. La seguridad por oscuridad no es seguridad. |
| "El framework maneja la seguridad" | Los frameworks proveen herramientas, no garantías. Aún necesitas usarlas correctamente. |
| "Es solo un prototipo" | Los prototipos se vuelven producción. Hábitos de seguridad desde el primer día. |
| "El modelado de amenazas es excesivo aquí" | Cinco minutos de "¿cómo atacaría yo esto?" previenen los defectos de diseño que ningún control puede parchear después. |
| "Es solo salida de LLM, es solo texto" | Ese "texto" puede ser un statement de SQL, una etiqueta de script o un comando de shell. Trátalo como cualquier entrada no confiable. |
| "La auditoría pasó, así que la dependencia es segura" | Las auditorías coinciden con advisory conocidos. No detectan un paquete recién malicioso ni hacen seguros de ejecutar los scripts de instalación sin revisar. |

## Red flags

- Entrada de usuario pasada directamente a consultas de base de datos, comandos de shell o renderizado HTML
- Secretos en código fuente o historial de commits
- Endpoints de API sin verificaciones de autenticación o autorización
- Configuración CORS faltante u orígenes wildcard (`*`)
- Sin límite de peticiones en endpoints de autenticación
- Stack traces o errores internos expuestos a los usuarios
- Dependencias con vulnerabilidades críticas conocidas, lockfiles en competencia en un mismo límite de instalación, instalaciones no reproducibles o scripts aprobados de forma generalizada
- El servidor obtiene URLs proporcionadas por el usuario sin lista blanca (SSRF)
- Salida de LLM/modelo pasada a una consulta, el DOM, una shell o `eval`
- Secretos, PII o el system prompt completo colocados dentro de una ventana de contexto de LLM

## Verificación

Después de implementar código relevante para la seguridad:

- [ ] La auditoría nativa no tiene hallazgos críticos/altos alcanzables sin mitigar; CI preserva el lockfile autoritativo y bloquea scripts de dependencias sin revisar
- [ ] Sin secretos en código fuente o historial de git
- [ ] Toda la entrada de usuario validada en los límites del sistema
- [ ] Autenticación y autorización verificadas en cada endpoint protegido
- [ ] Cabeceras de seguridad presentes en la respuesta (verifica con DevTools del navegador)
- [ ] Las respuestas de error no exponen detalles internos
- [ ] Límite de peticiones activo en endpoints de auth
- [ ] Obtenciones de URL del lado del servidor validadas contra una lista blanca (sin SSRF)
- [ ] Salida de LLM/modelo validada y codificada antes de usarla (si hay funcionalidades de IA)
