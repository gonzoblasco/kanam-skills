# Checklist de Rendimiento

Checklist de referencia rapida para el rendimiento de aplicaciones web. Usala junto con la skill `performance-optimization`.

## Tabla de Contenidos

- [Objetivos de Core Web Vitals](#objetivos-de-core-web-vitals)
- [Diagnostico de TTFB](#diagnostico-de-ttfb)
- [Checklist de Frontend](#checklist-de-frontend)
- [Checklist de Backend](#checklist-de-backend)
- [Comandos de Medicion](#comandos-de-medicion)
- [Anti-Patrones Comunes](#anti-patrones-comunes)

## Objetivos de Core Web Vitals

| Metrica | Bueno | Necesita Trabajo | Pobre |
|---------|-------|------------------|-------|
| LCP (Largest Contentful Paint) | <= 2.5s | <= 4.0s | > 4.0s |
| INP (Interaction to Next Paint) | <= 200ms | <= 500ms | > 500ms |
| CLS (Cumulative Layout Shift) | <= 0.1 | <= 0.25 | > 0.25 |

## Diagnostico de TTFB

Cuando el TTFB es lento (> 800ms), revisa cada componente en la cascada de Network de DevTools:

- [ ] **Resolucion de DNS** lenta -> agrega `<link rel="dns-prefetch">` o `<link rel="preconnect">` para origenes conocidos
- [ ] **Handshake TCP/TLS** lento -> habilita HTTP/2, considera el despliegue en el edge, verifica el keep-alive
- [ ] **Procesamiento del servidor** lento -> perfila el backend, revisa las consultas lentas, agrega caching

## Checklist de Frontend

### Imagenes
- [ ] Las imagenes usan formatos modernos (WebP, AVIF)
- [ ] Las imagenes estan dimensionadas de forma responsiva (`srcset` y `sizes`)
- [ ] Las imagenes y los elementos `<source>` tienen `width` y `height` explicitos (previene CLS en art direction)
- [ ] Las imagenes debajo del fold usan `loading="lazy"` y `decoding="async"`
- [ ] Las imagenes Hero/LCP usan `fetchpriority="high"` y no lazy loading

### JavaScript
- [ ] Tamano del bundle por debajo de 200KB gzipped (carga inicial)
- [ ] Code splitting con `import()` dinamico para rutas y funciones pesadas
- [ ] Tree shaking habilitado (verifica que la dependencia publique ESM y marque `sideEffects: false`)
- [ ] Sin JavaScript bloqueante en `<head>` (usa `defer` o `async`)
- [ ] Computo pesado descargado a Web Workers (si aplica)
- [ ] `React.memo()` en componentes caros que se re-renderizan con las mismas props
- [ ] `useMemo()` / `useCallback()` solo donde el profiling muestra beneficio
- [ ] Tareas largas (> 50ms) divididas para mantener libre el hilo principal: la palanca principal para INP
- [ ] Patron `yieldToMain` usado dentro de loops de larga duracion para que los eventos de entrada puedan ejecutarse entre chunks
- [ ] APIs de scheduling modernas usadas donde esten disponibles: `scheduler.yield()` (preferido), `scheduler.postTask()` con prioridades, `isInputPending()` para hacer yield solo cuando sea necesario
- [ ] `requestIdleCallback` para trabajo diferible y no urgente (flush de analiticas, prefetch, warmup)
- [ ] Trabajo no critico diferido fuera de los event handlers (ej: analiticas, logging) para que la respuesta a la interaccion no se retrase
- [ ] Scripts de terceros cargados con `async` / `defer`, auditados por tamano, y con una facade cuando son pesados (widgets de chat, embeds)

### CSS
- [ ] CSS critico inline o preload
- [ ] Sin CSS bloqueante de render para estilos no criticos
- [ ] Sin costo de runtime de CSS-in-JS en produccion (usa extraccion)

### Fuentes
- [ ] Limitado a 2-3 familias de fuentes, 2-3 pesos cada una (cada peso adicional es otra solicitud)
- [ ] Solo formato WOFF2 (el mas chico, soporte universal: saltea WOFF/TTF/EOT)
- [ ] Self-hosted cuando sea posible (los CDNs de fuentes de terceros agregan round-trips de DNS + TCP + TLS)
- [ ] Fuentes criticas para LCP preload: `<link rel="preload" as="font" type="font/woff2" crossorigin>`
- [ ] `font-display: swap` (o `optional` para las no criticas) para evitar que el FOIT bloquee el render
- [ ] Subsetted via `unicode-range` para enviar solo los glyphs que cada pagina necesita
- [ ] Se consideran las fuentes variables cuando se requieren multiples pesos/estilos (un archivo reemplaza muchos)
- [ ] Metricas de las fuentes de fallback ajustadas con `size-adjust`, `ascent-override`, `descent-override` para reducir CLS en el swap de fuentes
- [ ] Se considera el stack de fuentes del sistema antes de cualquier fuente personalizada

### Red
- [ ] Assets estaticos cacheados con `max-age` largo + hashing de contenido
- [ ] Respuestas de API cacheadas donde sea apropiado (`Cache-Control`)
- [ ] HTTP/2 o HTTP/3 habilitado
- [ ] Recursos preconnectados (`<link rel="preconnect">`) para origenes conocidos
- [ ] `fetchpriority` usado en recursos no-imagen criticos (ej: `<link rel="preload">` clave, `<script>` above-the-fold), no solo en `<img>`
- [ ] Sin redirects innecesarios

### Renderizado
- [ ] Sin layout thrashing (layouts sincronicos forzados)
- [ ] Las animaciones usan `transform` y `opacity` (aceleradas por GPU)
- [ ] Las listas largas usan virtualizacion (ej: `react-window`)
- [ ] Sin re-renders innecesarios de pagina completa
- [ ] Las secciones fuera de pantalla usan `content-visibility: auto` con `contain-intrinsic-size` para saltear el layout/paint de areas no visibles
- [ ] Sin event handlers `unload` y sin `Cache-Control: no-store` en respuestas HTML: preserva la elegibilidad del cache back/forward (bfcache)

## Checklist de Backend

### Base de Datos
- [ ] Sin patrones de consulta N+1 (usa eager loading / joins)
- [ ] Las consultas tienen indices apropiados
- [ ] Los endpoints de listas estan paginados (nunca `SELECT * FROM table`)
- [ ] Connection pooling configurado
- [ ] Logging de consultas lentas habilitado

### API
- [ ] Tiempos de respuesta < 200ms (p95)
- [ ] Sin computo pesado sincronico en los request handlers
- [ ] Operaciones en lote en lugar de loops de llamadas individuales
- [ ] Compresion de respuesta (gzip/brotli)
- [ ] Caching apropiado (in-memory, Redis, CDN)

### Infraestructura
- [ ] CDN para assets estaticos
- [ ] Servidor ubicado cerca de los usuarios (o despliegue en el edge)
- [ ] Scaling horizontal configurado (si es necesario)
- [ ] Endpoint de health check para el load balancer

## Comandos de Medicion

### Datos de campo de INP y flujo de trabajo en DevTools

1. **Primero los datos de campo** - revisa [CrUX Vis](https://developer.chrome.com/docs/crux/vis) o tu herramienta RUM para el INP de usuarios reales antes de optimizar
2. **Identifica las interacciones lentas** - abre DevTools -> panel de Performance -> graba mientras interactuas; busca tareas largas disparadas por clics/teclas
3. **Prueba en un Android de gama media** - los problemas de INP suelen aparecer solo en hardware mas lento; usa un dispositivo real o el CPU throttling de DevTools (desaceleracion de 4x-6x)

```bash
# Lighthouse CLI
npx lighthouse https://localhost:3000 --output json --output-path ./report.json

# Analisis de bundle
npx webpack-bundle-analyzer stats.json
# o para Vite:
npx vite-bundle-visualizer

# Chequea el tamano del bundle
npx bundlesize

# Web Vitals en codigo
import { onLCP, onINP, onCLS } from 'web-vitals';
onLCP(console.log);
onINP(console.log);
onCLS(console.log);

# INP con detalle a nivel de interaccion (build de attribution)
import { onINP } from 'web-vitals/attribution';
onINP(({ value, attribution }) => {
  const { interactionTarget, inputDelay, processingDuration, presentationDelay } = attribution;
  console.log({ value, interactionTarget, inputDelay, processingDuration, presentationDelay });
});
```

## Anti-Patrones Comunes

| Anti-Patron | Impacto | Solucion |
|---|---|---|
| Consultas N+1 | Crecimiento lineal de la carga de la DB | Usa joins, includes o batch loading |
| Consultas sin limite | Agotamiento de memoria, timeouts | Pagina siempre, agrega LIMIT |
| Indices faltantes | Lecturas lentas a medida que crecen los datos | Agrega indices para las columnas filtradas/ordenadas |
| Layout thrashing | Jank, frames caidos | Agrupa las lecturas de DOM, luego agrupa las escrituras |
| Imagenes no optimizadas | LCP lento, ancho de banda desperdiciado | Usa WebP, tamanos responsivos, lazy load |
| Bundles grandes | Time to Interactive lento | Code split, tree shake, audita las deps |
| Hilo principal bloqueado | INP pobre, UI que no responde | Divide las tareas largas con `scheduler.yield()` / `yieldToMain`, descarga a Web Workers |
| Fugas de memoria | Memoria creciente, crash eventual | Limpia listeners, intervals, refs |
