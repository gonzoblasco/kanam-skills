---
name: pdf-tool
metadata:
  category: "Tools"
  tags:
    - pdf
    - ocr
    - documents
    - markdown
description: "Local PDF handling: read (extract text, metadata, OCR) and generate (export markdown to PDF). Uses poppler + tesseract for reading and md-to-pdf for export. 100% local, no cloud services."
user-invocable: false
---

# PDF Tool

Process PDFs locally: extract text, OCR scanned documents, and **export markdown to PDF**. 100% local, no sending documents to the cloud.

## When to use

- Reading/extracting text from specs, documents or articles in PDF.
- OCR of scanned documents (no native text) or images with text.
- Getting metadata from a PDF (pages, size).
- Searching a term inside a PDF.
- **Exporting the markdown we generate (daily notes, HANDOFF, README) to PDF.**

## How to use it

```bash
./scripts/pdf-tool.sh check                    # verify installed tools
./scripts/pdf-tool.sh info <pdf>               # metadata (pages, size, title)
./scripts/pdf-tool.sh text <pdf>               # extract all text
./scripts/pdf-tool.sh pages <pdf> <n>          # text of page N
./scripts/pdf-tool.sh search <pdf> <term>      # search a term
./scripts/pdf-tool.sh ocr <pdf>                # OCR a scanned PDF
./scripts/pdf-tool.sh pdfimages <pdf> [out]    # render pages to PNG
./scripts/pdf-tool.sh md2pdf <md> [out.pdf]    # EXPORT markdown to PDF
```

## Interpreting results

- **`text`**: plain extracted text (best for PDFs with native text).
- **`ocr`**: for scanned PDFs (images). Tesseract recognizes the text. Slower, less exact.
- **`md2pdf`**: converts a .md file to .pdf (same name by default, or specify the output). Good for tables, code blocks and headers - uses md-to-pdf (Puppeteer/Chromium under the hood).

## Exporting MD to PDF (md2pdf)

To export workspace markdown (daily notes, HANDOFF, README, docs) to PDF:

```bash
./scripts/pdf-tool.sh md2pdf memory/2026-08-24.md /tmp/daily.pdf
./scripts/pdf-tool.sh md2pdf HANDOFF.md                 # -> HANDOFF.pdf (default)
```

- The default output is the same name with .pdf.
- Generates a PDF with decent styling (headers, tables, highlighted code blocks).
- Uses npx md-to-pdf (downloads Puppeteer the first time, then cached).

## Requirements

- **poppler**: `brew install poppler` (pdftotext, pdfinfo, pdftoppm) - for reading.
- **tesseract**: `brew install tesseract` (OCR).
- **node/npx**: for md2pdf (npm). Puppeteer downloads on first use.

## Rules

- **100% local** - documents are never sent to external services.
- For large documents, extract the text and read it in parts (pages).
- For scanned PDFs, use `ocr`.

## Limits

- OCR is not perfect (depends on resolution).
- md2pdf requires node/npx (downloads Chromium the first time, ~170MB).

## Related

- [Technical Docs](../tech-docs): technical documentation (may include PDFs).
- [Knowledge Management](../knowledge-management): consolidate what was extracted from PDFs into memory.
