# MCP evaluation criteria

Score every candidate with these questions. Answer yes/no/unknown.

1. **Native coverage**: Does OpenClaw already provide equivalent functionality?
   - browser, web_search, web_fetch, db_query, db_execute, image, exec, etc.
2. **Open source**: Is the source code available and inspectable?
3. **Maintenance**: Last commit within 3 months? Issues responded?
4. **Free tier**: Does the free tier actually work with our keys?
5. **Auth model**: API key, OAuth, browser login, QR, or personal account?
   - API key in `~/.openclaw/secrets/` is OK.
   - OAuth/QR/personal account → pause and ask.
6. **Stability**: Does `tools/list` work? Does a sample tool call work?
7. **Redundancy**: Overlaps with an existing skill?
8. **Risk**: Can it post publicly, send messages, spend money, or access private data?

Decision matrix:

| Condition | Decision |
|---|---|
| Native coverage exists | Discard |
| Personal account risk | Discard (ask first) |
| Paid-only / free tier broken | Discard |
| Good idea, fragile implementation | Absorb into native skill |
| Useful, stable, local-first, no native equivalent | Install + wrap |
| Useful but not now | Standby / backlog |
