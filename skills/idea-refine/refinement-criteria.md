# Criterios de Refinamiento y Evaluacion

Usa esta rubrica durante la Fase 2 (Evaluar y Converger) para poner a prueba las direcciones de la idea. No todos los criterios aplican a todas las ideas: usa tu criterio sobre que dimensiones importan mas para el contexto especifico.

## Dimensiones Centrales de Evaluacion

### 1. Valor para el Usuario

La dimension mas importante. Si el valor no esta claro, nada mas importa.

**Calmante del dolor vs. Vitamina:**
- **Calmante del dolor:** Resuelve un problema agudo y frecuente. Los usuarios lo buscaran activamente. Cambiaran de su solucion actual. Senales: la gente describe el problema con emocion, ha construido workarounds, pagara por una solucion.
- **Vitamina:** Agradable de tener. Hace algo marginalmente mejor. Los usuarios no se van a esforzar. Senales: la gente asiente cortesmente, dice "que copado", y luego no cambia su comportamiento.

**Preguntas para hacer:**
- Podes nombrar 3 personas especificas que tienen este problema ahora mismo?
- Que estan haciendo hoy en su lugar? (El competidor real es siempre el workaround actual.)
- Cambiarian de su enfoque actual? Que los haria cambiar?
- Con que frecuencia se encuentran con este problema? (Los problemas diarios > los mensuales.)
- Es un problema de "pull" (los usuarios lo estan pidiendo) o de "push" (vos crees que deberian quererlo)?

**Senales de alerta:**
- "Todos podrian usar esto" - si no podes nombrar un usuario especifico, el valor no esta claro
- "Es como X pero mejor" - las mejoras marginales rara vez impulsan la adopcion
- El problema es real pero raro: alta intensidad pero baja frecuencia rara vez justifica un producto

### 2. Viabilidad

Podes construir esto realmente? No solo tecnicamente, sino practicamente.

**Viabilidad tecnica:**
- La tecnologia central existe y funciona de forma confiable?
- Cual es el problema tecnico mas dificil? Es un problema conocido-dificil o uno novedoso?
- Hay dependencias de terceros, APIs o fuentes de datos que no controlas?
- Cual es el stack tecnico minimo necesario? (Si la respuesta es "mucho", eso es una senal.)

**Viabilidad de recursos:**
- Cual es el equipo/esfuerzo minimo para construir un MVP?
- Requiere experiencia especializada que no tenes?
- Hay requisitos regulatorios, legales o de cumplimiento?

**Tiempo-hasta-valor:**
- Que tan rapido podes poner algo frente a los usuarios?
- Hay una version que entregue valor en dias/semanas, no meses?
- Cual es el camino critico? Que tiene que pasar primero?

**Senales de alerta:**
- "Solo necesitamos resolver [problema de investigacion muy dificil] primero"
- Multiples dependencias que necesitan funcionar todas simultaneamente
- El MVP aun requiere meses de trabajo, probablemente no es lo suficientemente minimo

### 3. Diferenciacion

Que lo hace genuinamente diferente? No mejor: *diferente*.

**Preguntas para hacer:**
- Si un usuario le describiera esto a un amigo, que diria? Esa descripcion es convincente?
- Que es la unica cosa que esto hace que nada mas hace? (Si no podes nombrar una, eso es un problema.)
- Esta diferenciacion es duradera? Puede un competidor copiarla en una semana?
- Es la diferencia algo que a los usuarios realmente les importa, o solo algo que a los constructores les resulta interesante?

**Tipos de diferenciacion (de mas fuerte a mas debil):**
1. **Nueva capacidad:** Hace algo que antes era imposible
2. **Mejora 10x:** Tan mejor en una dimension clave que cambia el comportamiento
3. **Nueva audiencia:** Lleva una capacidad existente a personas que estaban excluidas
4. **Nuevo contexto:** Funciona en una situacion donde las soluciones existentes fallan
5. **Mejor UX:** Misma capacidad, experiencia dramaticamente mas simple
6. **Mas barato:** Lo mismo, menor costo (la mas debil: facil de competir en contra)

**Senales de alerta:**
- La diferenciacion es enteramente sobre tecnologia, no sobre experiencia del usuario
- "Somos mas rapidos/baratos/lindos" sin una razon estructural
- La funcion que diferencia no es la funcion que mas les importa a los usuarios

## Auditoria de Suposiciones

Para cada direccion de la idea, lista explicitamente las suposiciones en tres categorias:

### Debe Ser Verdad (Rompe-acuerdos)
Suposiciones que, si estan equivocadas, matan la idea por completo. Estas necesitan validacion antes de construir.

Ejemplo: "Los usuarios compartiran sus datos con nosotros" - si no lo hacen, el producto entero no funciona.

### Deberia Ser Verdad (Importante)
Suposiciones que impactan significativamente el exito pero no matan la idea. Podes ajustar el enfoque si estan equivocadas.

Ejemplo: "Los usuarios prefieren el autoservicio a hablar con una persona" - si esta equivocada, necesitas un go-to-market diferente, pero el producto central aun puede funcionar.

### Podria Ser Verdad (Agradable de Tener)
Suposiciones sobre funciones secundarias u optimizaciones. No las valides hasta que el nucleo este probado.

Ejemplo: "Los usuarios querran compartir sus resultados con companeros" - una funcion de crecimiento, no una propuesta de valor central.

## Marco de Decision

Cuando elijas entre direcciones, clasificalas en esta matriz:

|                    | Alta Viabilidad | Baja Viabilidad |
|--------------------|-----------------|-----------------|
| **Alto Valor**     | Hace esto primero | Vale la pena el riesgo |
| **Bajo Valor**     | Solo si es trivial | No hagas esto |

Luego usa la diferenciacion como desempate entre opciones en el mismo cuadrante.

## Principios de Alcance del MVP

Cuando definas el alcance del MVP para la direccion elegida:

1. **Un solo trabajo, bien hecho.** El MVP deberia clavar exactamente un trabajo de usuario. No tres trabajos hechos parcialmente.
2. **La suposicion mas riesgosa primero.** El proposito principal del MVP es probar la suposicion con mas probabilidad de estar equivocada.
3. **Time-box, no lista de funciones.** "Que podemos construir y probar en [periodo]?" es mejor que "Que funciones necesitamos?"
4. **La lista de 'Lo que no se va a hacer' es obligatoria.** Nombra explicitamente lo que estas recortando y por que. Esto previene el scope creep y fuerza una priorizacion honesta.
5. **Si no es vergonzoso, esperaste demasiado.** La primera version deberia sentirse incompleta para el constructor. Si no lo es, sobre-construiste.
