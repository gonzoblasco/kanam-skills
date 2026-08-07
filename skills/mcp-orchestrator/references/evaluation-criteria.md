# Criterios de evaluación de MCP

Puntuar cada candidato con estas preguntas. Responder sí/no/desconocido.

1. **Cobertura nativa**: ¿OpenClaw ya provee funcionalidad equivalente?
   - browser, web_search, web_fetch, db_query, db_execute, image, exec, etc.
2. **Open source**: ¿El código fuente está disponible y es inspeccionable?
3. **Mantenimiento**: ¿Último commit dentro de 3 meses? ¿Responden los issues?
4. **Free tier**: ¿El free tier funciona de verdad con nuestras keys?
5. **Modelo de auth**: ¿API key, OAuth, login por browser, QR o cuenta personal?
   - API key en `~/.openclaw/secrets/` está OK.
   - OAuth/QR/cuenta personal → pausar y preguntar.
6. **Estabilidad**: ¿Funciona `tools/list`? ¿Funciona una llamada de muestra a una tool?
7. **Redundancia**: ¿Se superpone con una skill existente?
8. **Riesgo**: ¿Puede publicar públicamente, enviar mensajes, gastar dinero o acceder a datos privados?

Matriz de decisión:

| Condición | Decisión |
|---|---|
| Existe cobertura nativa | Descartar |
| Riesgo de cuenta personal | Descartar (preguntar primero) |
| Solo pago / free tier roto | Descartar |
| Buena idea, implementación frágil | Absorber en skill nativa |
| Útil, estable, local-first, sin equivalente nativo | Instalar + envolver |
| Útil pero no ahora | Standby / backlog |
