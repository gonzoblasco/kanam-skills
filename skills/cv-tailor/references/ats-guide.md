# Guía ATS - CV Tailor

Guía de compatibilidad con Applicant Tracking Systems.

## Compatibilidad de formato

| Check | Aprobado | Problemas comunes |
|---|---|---|
| Formato de archivo | PDF o DOCX | Basado en imágenes = no parseable |
| Layout | Una sola columna, headings estándar | Multi-columna = errores de parseo |
| Fuentes | Arial, Calibri, Times New Roman | Decorativas = problemas de render |
| Tablas | Evitar layouts complejos | Texto en tablas = se omite |
| Headers/footers | Mantener info crítica fuera | Algunos ATS los omiten |
| Imágenes/íconos | No usarlos para info clave | El ATS no puede leer texto en imágenes |
| Caracteres especiales | Solo bullets estándar | Bullets Unicode = errores de parseo |

## Estructura de contenido

| Check | Estándar |
|---|---|
| Títulos de sección | "Work Experience", "Education", "Projects", "Skills" |
| Formato de fechas | Consistente: "Jan 2023 – Jun 2024" |
| Nombres de empresa | Nombres completos, no abreviaturas |
| Info de contacto | Nombre, teléfono, email arriba |
| Nombre de archivo | "FirstName_LastName_Role_Resume.pdf" |

## Densidad de keywords

- Keywords centrales: aparecer 2-3 veces en diferentes secciones
- Evitar keyword stuffing (misma keyword en un párrafo)
- Usar la redacción exacta del JD (si el JD dice "data analysis", no escribir "data mining")

## Relacionados

- [SKILL.md](../SKILL.md) - Workflow principal
- [STAR Method](./star-method.md) - Guía STAR
