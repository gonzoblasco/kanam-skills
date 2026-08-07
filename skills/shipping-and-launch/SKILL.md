---
name: shipping-and-launch
description: Prepara lanzamientos de produccion. Usalo cuando te prepares para desplegar a produccion. Usalo cuando necesites una checklist previa al lanzamiento, cuando configures monitoreo, cuando planifiques un rollout por etapas, o cuando necesites una estrategia de rollback.
---

# Despliegue y Lanzamiento

## Resumen

Desplega con confianza. La meta no es solo desplegar: es desplegar de forma segura, con monitoreo en su lugar, un plan de rollback listo y una comprension clara de como se ve el exito. Cada lanzamiento deberia ser reversible, observable e incremental.

## Cuando Usarlo

- Desplegar una funcion a produccion por primera vez
- Publicar un cambio significativo a los usuarios
- Migrar datos o infraestructura
- Abrir un programa beta o de acceso temprano
- Cualquier despliegue que conlleve riesgo (todos)

## La Checklist Previa al Lanzamiento

### Calidad del Codigo

- [ ] Todas las pruebas pasan (unit, integracion, e2e)
- [ ] El build tiene exito sin advertencias
- [ ] El lint y el type checking pasan
- [ ] Codigo revisado y aprobado
- [ ] No hay comentarios TODO que deberian resolverse antes del lanzamiento
- [ ] No hay declaraciones de debug `console.log` en el codigo de produccion
- [ ] El manejo de errores cubre los modos de falla esperados

### Seguridad

- [ ] No hay secretos en el codigo ni en el control de versiones
- [ ] La auditoria de dependencias del ecosistema (`npm audit`, `pip-audit`, `cargo audit`, ...) no muestra vulnerabilidades criticas ni altas
- [ ] Validacion de entrada en todos los endpoints orientados al usuario
- [ ] Chequeos de autenticacion y autorizacion en su lugar
- [ ] Headers de seguridad configurados (CSP, HSTS, etc.)
- [ ] Rate limiting en los endpoints de autenticacion
- [ ] CORS configurado para origenes especificos (no wildcard)

### Rendimiento

- [ ] Core Web Vitals dentro de los umbrales "Bueno"
- [ ] No hay consultas N+1 en los caminos criticos
- [ ] Imagenes optimizadas (compresion, tamanos responsivos, lazy loading)
- [ ] Tamano del bundle dentro del presupuesto
- [ ] Las consultas de la base de datos tienen indices apropiados
- [ ] Cache configurado para assets estaticos y consultas repetidas

### Accesibilidad

- [ ] La navegacion por teclado funciona para todos los elementos interactivos
- [ ] El lector de pantalla puede transmitir el contenido y la estructura de la pagina
- [ ] El contraste de color cumple con WCAG 2.1 AA (4.5:1 para texto)
- [ ] La gestion del foco es correcta para modales y contenido dinamico
- [ ] Los mensajes de error son descriptivos y estan asociados con los campos del formulario
- [ ] No hay advertencias de accesibilidad en axe-core ni Lighthouse

### Infraestructura

- [ ] Variables de entorno configuradas en produccion
- [ ] Migraciones de la base de datos aplicadas (o listas para aplicar)
- [ ] DNS y SSL configurados
- [ ] CDN configurado para assets estaticos
- [ ] Logging y reporte de errores configurados
- [ ] Existe un endpoint de health check y responde

### Documentacion

- [ ] README actualizado con cualquier nuevo requisito de configuracion
- [ ] Documentacion de la API al dia
- [ ] ADRs escritos para cualquier decision arquitectonica
- [ ] Changelog actualizado
- [ ] Documentacion orientada al usuario actualizada (si aplica)

## Estrategia de Feature Flags

Desplega detras de feature flags para desacoplar el despliegue del lanzamiento:

```typescript
// Chequeo de feature flag
const flags = await getFeatureFlags(userId);

if (flags.taskSharing) {
  // Nueva funcion: compartir tareas
  return <TaskSharingPanel task={task} />;
}

// Default: comportamiento existente
return null;
```

**Ciclo de vida del feature flag:**

```
1. DESPLEGAR con el flag OFF     -> El codigo esta en produccion pero inactivo
2. HABILITAR para equipo/beta    -> Pruebas internas en el entorno de produccion
3. ROLLOUT GRADUAL               -> 5% -> 25% -> 50% -> 100% de los usuarios
4. MONITOREAR en cada etapa      -> Observa tasas de error, rendimiento, feedback de usuarios
5. LIMPIEZA                      -> Elimina el flag y el camino de codigo muerto despues del rollout completo
```

**Reglas:**
- Cada feature flag tiene un dueno y una fecha de expiracion
- Limpia los flags dentro de 2 semanas del rollout completo
- No anides feature flags (crea combinaciones exponenciales)
- Prueba ambos estados del flag (on y off) en CI

## Rollout por Etapas

### La Secuencia de Rollout

```
1. DESPLEGAR a staging
   |-- Suite de pruebas completa en el entorno de staging
   |-- Smoke test manual de los flujos criticos

2. DESPLEGAR a produccion (feature flag OFF)
   |-- Verifica que el despliegue tuvo exito (health check)
   |-- Chequea el monitoreo de errores (sin errores nuevos)

3. HABILITAR para el equipo (flag ON para usuarios internos)
   |-- El equipo usa la funcion en produccion
   |-- Ventana de monitoreo de 24 horas

4. Rollout CANARY (flag ON para el 5% de los usuarios)
   |-- Monitorea tasas de error, latencia, comportamiento del usuario
   |-- Compara metricas: canary vs. baseline
   |-- Ventana de monitoreo de 24-48 horas
   |-- Avanza solo si todos los umbrales pasan (ver tabla abajo)

5. AUMENTO gradual (25% -> 50% -> 100%)
   |-- Mismo monitoreo en cada paso
   |-- Capacidad de volver al porcentaje anterior en cualquier momento

6. ROLLOUT completo (flag ON para todos los usuarios)
   |-- Monitorea durante 1 semana
   |-- Limpia el feature flag
```

### Umbrales de Decision de Rollout

Usa estos umbrales para decidir si avanzar, mantener o volver atras en cada etapa:

| Metrica | Avanzar (verde) | Mantener e investigar (amarillo) | Volver atras (rojo) |
|---------|-----------------|----------------------------------|---------------------|
| Tasa de error | Dentro del 10% del baseline | 10-100% por encima del baseline | >2x el baseline |
| Latencia P95 | Dentro del 20% del baseline | 20-50% por encima del baseline | >50% por encima del baseline |
| Errores JS del cliente | Sin tipos de error nuevos | Errores nuevos en <0.1% de las sesiones | Errores nuevos en >0.1% de las sesiones |
| Metricas de negocio | Neutrales o positivas | Decline <5% (puede ser ruido) | Decline >5% |

### Cuando Volver Atras

Volve atras inmediatamente si:
- La tasa de error aumenta mas de 2x el baseline
- La latencia P95 aumenta mas del 50%
- Los problemas reportados por usuarios suben de golpe
- Se detectan problemas de integridad de datos
- Se descubre una vulnerabilidad de seguridad

## Monitoreo y Observabilidad

### Que Monitorear

```
Metricas de la aplicacion:
|-- Tasa de error (total y por endpoint)
|-- Tiempo de respuesta (p50, p95, p99)
|-- Volumen de solicitudes
|-- Usuarios activos
|-- Metricas de negocio clave (conversion, engagement)

Metricas de infraestructura:
|-- Utilizacion de CPU y memoria
|-- Uso del pool de conexiones de la base de datos
|-- Espacio en disco
|-- Latencia de red
|-- Profundidad de la cola (si aplica)

Metricas del cliente:
|-- Core Web Vitals (LCP, INP, CLS)
|-- Errores de JavaScript
|-- Tasas de error de API desde la perspectiva del cliente
|-- Tiempo de carga de la pagina
```

### Reporte de Errores

```typescript
// Configura el error boundary con reporte
class ErrorBoundary extends React.Component {
  componentDidCatch(error: Error, info: React.ErrorInfo) {
    // Reporta al servicio de seguimiento de errores
    reportError(error, {
      componentStack: info.componentStack,
      userId: getCurrentUser()?.id,
      page: window.location.pathname,
    });
  }

  render() {
    if (this.state.hasError) {
      return <ErrorFallback onRetry={() => this.setState({ hasError: false })} />;
    }
    return this.props.children;
  }
}

// Reporte de errores del lado del servidor
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  reportError(err, {
    method: req.method,
    url: req.url,
    userId: req.user?.id,
  });

  // No expongas los internals a los usuarios
  res.status(500).json({
    error: { code: 'INTERNAL_ERROR', message: 'Something went wrong' },
  });
});
```

### Verificacion Post-Lanzamiento

En la primera hora despues del lanzamiento:

```
1. Chequea que el endpoint de salud devuelve 200
2. Chequea el dashboard de monitoreo de errores (sin tipos de error nuevos)
3. Chequea el dashboard de latencia (sin regresiones)
4. Prueba el flujo critico del usuario manualmente
5. Verifica que los logs fluyen y son legibles
6. Confirma que el mecanismo de rollback funciona (dry run si es posible)
```

## Estrategia de Rollback

Cada despliegue necesita un plan de rollback antes de que ocurra:

```markdown
## Plan de Rollback para [Funcion/Lanzamiento]

### Condiciones de Activacion
- Tasa de error > 2x el baseline
- Latencia P95 > [X]ms
- Reportes de usuarios de [problema especifico]

### Pasos de Rollback
1. Deshabilita el feature flag (si aplica)
   O
1. Despliega la version anterior: `git revert <commit> && git push`
2. Verifica el rollback: health check, monitoreo de errores
3. Comunica: notifica al equipo del rollback

### Consideraciones de la Base de Datos
- La migracion [X] tiene un rollback: `npx prisma migrate rollback`
- Los datos insertados por la nueva funcion: [conservados / limpiados]

### Tiempo hasta el Rollback
- Feature flag: < 1 minuto
- Redesplegar la version anterior: < 5 minutos
- Rollback de la base de datos: < 15 minutos
```
## Ver Tambien

- Para la Definition of Done de todo el proyecto que cada cambio debe superar antes de esta checklist, ver `references/definition-of-done.md`
- Para los chequeos de seguridad previos al lanzamiento, ver `references/security-checklist.md`
- Para la checklist de rendimiento previa al lanzamiento, ver `references/performance-checklist.md`
- Para la verificacion de accesibilidad antes del lanzamiento, ver `references/accessibility-checklist.md`

## Racionalizaciones Comunes

| Racionalizacion | Realidad |
|---|---|
| "Funciona en staging, funcionara en produccion" | Produccion tiene datos, patrones de trafico y casos borde diferentes. Monitorea despues del despliegue. |
| "No necesitamos feature flags para esto" | Toda funcion se beneficia de un kill switch. Incluso los cambios "simples" pueden romper cosas. |
| "El monitoreo es overhead" | No tener monitoreo significa que descubris los problemas por quejas de usuarios en lugar de por dashboards. |
| "Agregaremos el monitoreo despues" | Agregalo antes del lanzamiento. No podes depurar lo que no podes ver. |
| "Volver atras es admitir el fracaso" | Volver atras es ingenieria responsable. Publicar una funcion rota es el fracaso. |

## Senales de Alerta

- Desplegar sin un plan de rollback
- Sin monitoreo ni reporte de errores en produccion
- Lanzamientos big-bang (todo a la vez, sin staging)
- Feature flags sin expiracion ni dueno
- Nadie monitoreando el despliegue durante la primera hora
- Configuracion del entorno de produccion hecha de memoria, no por codigo
- "Es viernes a la tarde, larguemos"

## Verificacion

Antes de desplegar:

- [ ] Checklist previa al lanzamiento completada (todas las secciones en verde)
- [ ] Feature flag configurado (si aplica)
- [ ] Plan de rollback documentado
- [ ] Dashboards de monitoreo configurados
- [ ] Equipo notificado del despliegue

Despues de desplegar:

- [ ] El health check devuelve 200
- [ ] La tasa de error es normal
- [ ] La latencia es normal
- [ ] El flujo critico del usuario funciona
- [ ] Los logs fluyen
- [ ] El rollback fue probado o verificado como listo
