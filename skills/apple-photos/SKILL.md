---
name: "apple-photos"
description: "Terminal access to Photos.app: search, list and export photos"
---

# apple-photos

## Description
Terminal access to macOS Photos.app through direct queries to the Photos SQLite database. Allows listing albums and people, searching photos by date range, person name or visual content, and exporting photos to JPEG. Results in under 100ms.

## When to use it
- To find all photos of a specific person
- To export a photo by UUID for use in another script
- To search for photos taken during a specific date range
- To list all albums and audit the library organization
- To check library statistics (total photo count)

## Workflow
1. Request a search (by person, date, album, or visual content)
2. apple-photos queries the Photos SQLite DB
3. Returns results with UUIDs and metadata
4. If export is needed, specify UUID and format
5. The file is exported to the requested directory

## Related tooling

| Skill / Script | Use |
|---|---|
| `sql-insight/scripts/sql_query_helper.py` | Optimize and audit SQLite queries against the Photos DB. |
| `db-readonly` | Run safe read-only queries to the Photos SQLite if reports are needed. |

## Notes
- Requires Full Disk Access for Terminal in System Settings > Privacy & Security
- Direct SQLite queries are very fast (<100ms)
- Does not modify the Photos library, read-only
