---
name: code-review-and-quality
description: Realiza revisión de código multieje con quality gates (puertas de calidad). Integra la revisión de cinco ejes (correctitud, legibilidad, arquitectura, seguridad, rendimiento), detección de anti-patrones y feedback de mentoría. Usar al revisar código escrito por vos, por otro agente o por un humano antes de mergear cualquier cambio a la rama principal.
---

# Code Review and Quality: La Inspección de Cinco Ejes

## Resumen

Revisión de código multidimensional con quality gates. Cada cambio se revisa antes del merge - **sin excepciones**. Esta skill combina la **revisión de cinco ejes**, la **detección de anti-patrones** y el **feedback de mentoría** para evaluar la calidad del código en correctitud, legibilidad, arquitectura, seguridad y rendimiento.

**El estándar de aprobación:** Aprobá un cambio cuando definitivamente mejora la salud general del código, incluso si no es perfecto. El objetivo es la mejora continua, no la perfección.

---

## 🎯 Fase 1: Framework de Revisión de Cinco Ejes

### Eje 1: Correctitud (¿Está bien?)
**Checklist de verificación:**
- [ ] ¿Coincide exactamente con el spec/requerimientos?
- [ ] ¿Pasan todos los tests? (unit, integración, E2E)
- [ ] ¿Se manejan los casos límite?
- [ ] ¿El manejo de errores es completo?
- [ ] ¿Las firmas de tipos son correctas (si es TypeScript)?

**Problemas comunes:**
```tsx
// ✗ MAL - Falta el check de null
function getUser(id) {
  return users.find(u => u.id === id); // Devuelve undefined, no null
}

// ✓ CORRECTO - Manejo explícito
function getUser(id) {
  const user = users.find(u => u.id === id);
  if (!user) throw new NotFoundError('User not found');
  return user;
}
```

---

### Eje 2: Legibilidad (¿Está claro?)
**Checklist de verificación:**
- [ ] ¿Un miembro nuevo del equipo lo entendería en menos de 5 minutos?
- [ ] ¿Las variables/funciones tienen nombres significativos?
- [ ] ¿La profundidad de anidamiento es ≤ 3 niveles?
- [ ] ¿Los comentarios explican POR QUÉ, no QUÉ?
- [ ] ¿Sigue un formato y convenciones consistentes?

**Problemas comunes:**
```tsx
// ✗ MAL - Nombre de función ilegible
function processTransformOptimizeData(data, flag) {
  return data.filter(d => d.active).map(d => d.value).reduce((a,b)=>a+b);
}

// ✓ BIEN - Intención clara
function calculateTotalActiveValues(items) {
  return items
    .filter(item => item.isActive)
    .map(item => item.value)
    .reduce((sum, val) => sum + val, 0);
}
```

---

### Eje 3: Arquitectura (¿Está bien estructurado?)
**Checklist de verificación:**
- [ ] ¿Sigue el Principio de Responsabilidad Única?
- [ ] ¿Las dependencias se manejan/inyectan correctamente?
- [ ] ¿Hay una separación apropiada de responsabilidades?
- [ ] ¿Encaja con la arquitectura existente?
- [ ] ¿Los límites están claros (componente/módulo)?

---

### Eje 4: Seguridad (¿Es seguro?)
**Checklist de verificación:**
- [ ] ¿La entrada del usuario se valida/sanea en los límites?
- [ ] ¿Los secretos nunca se loguean ni exponen?
- [ ] ¿Hay checks de autenticación/autorización?
- [ ] ¿Se previenen ataques de SQL injection/XSS/CSRF?
- [ ] ¿Las dependencias se chequean por vulnerabilidades?

---

### Eje 5: Rendimiento (¿Es rápido?)
**Checklist de verificación:**
- [ ] ¿Las queries de base de datos están optimizadas (sin N+1)?
- [ ] ¿Se previenen re-renders innecesarios (React keys, memo)?
- [ ] ¿Se monitorea el tamaño del bundle?
- [ ] ¿Las operaciones pesadas se descargan a web workers/background?
- [ ] ¿Los estados de carga se manejan correctamente?

---

## 🚫 Fase 2: Detección de Anti-Patrones (Del Anti-Pattern Czar)

### Anti-Patrones Críticos a Detectar

#### Patrón #1: Optimización Prematura
```tsx
// ✗ ANTI-PATRÓN - Optimizando demasiado temprano
const results = cache.get(key) || fetchData().then(res => res.cache.set(key, res));

// ✓ CORRECTO - Lazy loading con estrategia de cache definida después
const results = useLazyDataFetching({ key, onCache: (val) => cache.set(key, val) });
```

#### Patrón #2: God Component/Service (Componente/Servicio Dios)
```tsx
// ✗ ANTI-PATRÓN - 400+ líneas que hacen de todo
function Dashboard() { // 450 líneas de lógica... }

// ✓ CORRECTO - Descompuesto
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

#### Patrón #3: Feature Envy (Envidia de Feature)
```tsx
// ✗ ANTI-PATRÓN - El método pertenece a una clase nueva
class Order {
  applyPromoCode(code) { // ¡Esto debería estar en PromoCodeService!
    // ...
  }
}

// ✓ CORRECTO - Responsabilidad separada
class Order { /* solo lógica de Order */ }
class PromoCodeService {
  apply(code, amount) { /* lógica de promo acá */ }
}
```

#### Patrón #4: Condiciones Espagueti
```tsx
// ✗ ANTI-PATRÓN - 50+ condiciones if en un solo archivo
function handleAction(type) {
  if (type === 'A') return ...;
  if (type === 'B') return ...;
  // ... 45 condiciones más
}

// ✓ CORRECTO - Patrón strategy o map
function handleAction(type) {
  const handlers = {
    A: handleTypeA,
    B: handleTypeB,
    // ...
  };
  return handlers[type]?.() ?? defaultHandler();
}
```

#### Patrón #5: Números/Cadenas Mágicas
```tsx
// ✗ ANTI-PATRÓN - Constantes ocultas
const MAX_RETRIES = 5;
const API_TIMEOUT = 3000;
const ERROR_CODES = { INVALID_USER: 401, NOT_FOUND: 404 };

// ✓ CORRECTO - Constantes con nombre en archivo de config
// api-config.ts
export const RETRIES = 5;
export const TIMEOUTS = { API: 3000 };
export const ERROR_CODES = { ... };
```

---

## 📋 Fase 3: Etiquetas de Severidad de Revisión

### 🟢 Nit (Prioridad Baja)
**Definición:** Problemas cosméticos, inconsistencias menores de estilo, mejoras opcionales.

**Ejemplos:**
- Coma final faltante
- Espaciado inconsistente en un archivo
- Se podría usar un nombre de variable más descriptivo pero es comprensible
- Falta un comentario JSDoc que estaría bueno pero no es crítico

**Acción:** Comentá inline, no bloquees el merge (salvo que la acumulación sea problemática)

---

### 🟡 FYI (Para Tu Información - Prioridad Media)
**Definición:** Contexto importante, mejoras futuras potenciales, conciencia de arquitectura.

**Ejemplos:**
- Este enfoque podría convertirse en un cuello de botella de rendimiento a escala
- Considerá extraerlo a una utilidad compartida para reutilizarlo en otros módulos
- Buen patrón pero vale la pena documentarlo como decisión de diseño

**Acción:** Agregá un comentario anotando la observación, considerá mencionarlo en el ADR si tiene impacto arquitectónico

---

### 🔴 Blocker (Crítico - Debe Corregirse Antes del Merge)
**Definición:** Bugs funcionales, vulnerabilidades de seguridad, violaciones críticas de arquitectura.

**Ejemplos:**
```tsx
// 🔴 BLOCKER - Vulnerabilidad de seguridad
const userInput = req.body.email;
// Sin validación, sin saneamiento - ¡potencial XSS/injection!

// Debería ser:
const userInput = sanitize(req.body.email); // validador OWASP
if (!isEmail(userInput)) {
  return res.status(400).json({ error: 'Invalid email' });
}
```

---

## 📊 Fase 4: Dimensionamiento del Cambio y Profundidad de Revisión

### Cambios Pequeños (< 100 líneas)
**Foco de revisión:**
- Correctitud solamente (tests unitarios + verificación manual)
- Check de legibilidad
- Básicos de seguridad (validación de entrada, secretos)

**Revisores necesarios:** mínimo 1 par

---

### Cambios Medianos (100-500 líneas)
**Foco de revisión:**
- Los cinco ejes cubiertos
- Tests de integración requeridos
- Check de alineación de arquitectura

**Revisores necesarios:** mínimo 2 pares

---

### Cambios Grandes (> 500 líneas o múltiples archivos)
**Foco de revisión:**
- Revisión completa de cinco ejes
- Perfilado de rendimiento (si aplica)
- Auditoría de seguridad (checks de OWASP Top 10)
- Actualización de documentación de arquitectura (ADR)

**Revisores necesarios:** 3+ pares, posiblemente incluyendo un ingeniero senior

**Entregables requeridos:**
- [ ] Todos los tests pasando
- [ ] ADR documentando la decisión arquitectónica
- [ ] Comparación de línea base de rendimiento
- [ ] Aprobación de la revisión de seguridad

---

## ⏱️ Fase 5: Normas de Velocidad de Revisión

### Expectativas de Tiempo de Respuesta
- **Issues Nit:** 48 horas (cosmético, puede esperar)
- **Observaciones FYI:** 72 horas (contextual, vale la pena pensarlo)
- **Blockers:** El mismo día (debe corregirse antes de poder mergear)

**Objetivos SLA:**
- Cambios pequeños: Revisión dentro de 24h
- Cambios medianos: Revisión dentro de 48h
- Cambios grandes: Revisión dentro de 72h o dividirlos en PRs más pequeños

---

## 🧠 Fase 6: Integración de Feedback de Mentoría (Del Code Mentor)

### Framework de Feedback Constructivo

#### El Método Sandwich (Actualizado)
1. **Lo que funcionó bien** - Reconocé primero las partes buenas
2. **Lo que puede mejorar** - Sugerencias accionables con antes/después
3. **Por qué importa** - Conectalo con el impacto en el negocio/costo de mantenimiento

#### Ejemplo de Feedback:
```
✅ Lo que funcionó:
- Separación limpia de responsabilidades en este componente
- Buen uso de React Query para la obtención de datos
- Los tests cubren bien el happy path

💡 Sugerencia:
Considerá extraer la lógica de validación a un archivo de utilidad separado.

ANTES:
function handleFormSubmit(e) {
  const email = e.target.email;
  if (!isValidEmail(email)) return;
  if (!hasMinimumLength(email)) return;
  // ... submit
}

DESPUÉS (extraído):
import { validateEmail } from './form-validation-utils';

function handleFormSubmit(e) {
  const email = e.target.email;
  if (!validateEmail(email)) return; // ¡Mucho más claro!
  // ... submit
}

🎯 Por qué importa:
Este patrón va a aparecer en múltiples formularios de la app. Centralizar la validación lo hace:
1. Más fácil de mantener (una única fuente de verdad)
2. Más testeable (tests unitarios en vez de checks inline)
3. Consistente en todos los inputs de formularios
4. Más seguro (si necesitamos validación más estricta después, cambiamos en un solo lugar)
```

---

## 🔍 Fase 7: Heurísticas de Detección de Severidad

### Evaluación Automática de Severidad

**Crítico de Seguridad (Blocker):**
- Secretos/API keys hardcodeados
- Autenticación faltante en rutas sensibles
- Patrones de SQL injection detectados
- Vulnerabilidades XSS vía entrada sin sanear

**Crítico de Arquitectura (Blocker):**
- Viola severamente el principio de responsabilidad única
- Crea dependencias circulares
- Rompe los límites de arquitectura existentes
- Introduce acoplamiento fuerte que requiere refactoring downstream

**Advertencia de Rendimiento (FYI → Blocker si se confirma la escala):**
- Patrones de query N+1 sin confirmación de volumen
- Re-renders excesivos en componentes de producción
- Aumentos de tamaño de bundle sin optimizar (>20%)

**Issues de Estilo (Nit):**
- Inconsistencias de formato
- Preferencias de nombres
- Diferencias en el orden de imports

---

## ✅ Checklist de Puerta de Verificación

Antes de aprobar cualquier merge request, verificá:

### Checklist Pre-Merge
- [ ] Todos los tests pasando localmente y en CI
- [ ] El estilo del código coincide con las convenciones del proyecto
- [ ] Los cinco ejes revisados (aunque sea superficial para cambios pequeños)
- [ ] Básicos de seguridad validados (validación de entrada, sin secretos expuestos)

### Validación Post-Merge
- [ ] Ningún test de regresión nuevo falló
- [ ] El deployment se completó con éxito
- [ ] Los dashboards de monitoreo muestran métricas estables
- [ ] El feedback de usuarios no indica funcionalidad rota

---

## 🚨 Red Flags que Requieren Atención Inmediata

- Cualquier PR que introduzca lógica de autenticación/autorización → Auditoría de seguridad obligatoria
- Cambios de migración de base de datos → Validación de esquema requerida
- Cambios breaking de API → Estrategia de versionado documentada
- Rutas de código críticas para rendimiento → Perfilado requerido
- Adiciones de librerías de terceros → Check de vulnerabilidades + revisión de licencia

---

## 📚 Referencias

Ver `references/security-checklist.md` para patrones de prevención de OWASP Top 10.
Ver `references/testing-patterns.md` para guías de estructura de tests.
Ver `references/definition-of-done.md` para estándares de calidad a nivel de proyecto.
