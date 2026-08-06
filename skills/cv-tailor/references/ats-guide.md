# ATS Guide — CV Tailor

Guía de compatibilidad con Applicant Tracking Systems.

## Format Compatibility

| Check | Passing | Common Issues |
|---|---|---|
| File format | PDF or DOCX | Image-based = unparseable |
| Layout | Single-column, standard headings | Multi-column = parse errors |
| Fonts | Arial, Calibri, Times New Roman | Decorative = render issues |
| Tables | Avoid complex layouts | Text in tables = skipped |
| Headers/footers | Keep critical info out | Some ATS skip these |
| Images/icons | Don't use for key info | ATS can't read text in images |
| Special chars | Standard bullets only | Unicode bullets = parse errors |

## Content Structure

| Check | Standard |
|---|---|
| Section titles | "Work Experience", "Education", "Projects", "Skills" |
| Date format | Consistent: "Jan 2023 – Jun 2024" |
| Company names | Full names, not abbreviations |
| Contact info | Name, phone, email at top |
| File naming | "FirstName_LastName_Role_Resume.pdf" |

## Keyword Density

- Core keywords: appear 2-3 times across different sections
- Avoid keyword stuffing (same keyword in one paragraph)
- Use exact phrasing from JD (if JD says "data analysis", don't write "data mining")

## Related

- [SKILL.md](../SKILL.md) — Workflow principal
- [STAR Method](./star-method.md) — Guía STAR
