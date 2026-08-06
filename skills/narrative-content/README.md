# Narrative Content

Planificación y escritura de ficción.

## ¿Para qué sirve?

Para **escribir novelas, cuentos y ficción** con estructura profesional. Incluye planificación (premisa, estructura, personajes, worldbuilding), redacción asistida, revisión de coherencia, y exportación a DOCX, EPUB o Markdown.

## ¿Cuándo usarlo?

- Cuando querés empezar a escribir una novela o cuento
- Cuando necesitás estructurar una historia existente
- Cuando querés exportar contenido narrativo a formato publicable

## ¿Cómo se usa?

### Workflow completo

1. **Premisa** — idea central, género, tono, audiencia, conflicto principal
2. **Estructura** — arco narrativo, capítulos, personajes, worldbuilding
3. **Redacción** — escritura de capítulos, escenas, diálogos
4. **Revisión** — coherencia narrativa, consistencia, plot holes
5. **Exportación** — DOCX, EPUB, Markdown

### Scripts útiles

```bash
# Generar outline desde premisa
./scripts/outline-generator.sh premisa.txt --structure hero

# Crear ficha de personaje
./scripts/character-sheet.sh "Arya Stark" --role protagonist

# Exportar capítulos a EPUB
python3 scripts/export-novel.py ./capitulos/ --format epub --output novela.epub
```

## Referencias

| Archivo | Qué contiene |
|---|---|
| `references/narrative-structures.md` | 4 estructuras: Three-Act, Hero's Journey, Save the Cat, Snowflake |
| `references/character-development.md` | Fichas de personaje, arquetipos, matriz de motivación |
| `references/worldbuilding.md` | Worldbuilding bible, consistency checklist, show don't tell |

## Skills relacionadas

- [Copy Editing](../copy-editing) — Para editar el texto narrativo
- [Technical Documentation](../tech-docs) — Para documentar estructura narrativa
