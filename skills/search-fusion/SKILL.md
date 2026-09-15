---
name: search-fusion
metadata:
  category: "Web"
  tags:
    - search
    - research
    - web
description: "Effective search by intent: pick the strategy and tools based on the kind of search (research, keyword, answer, news) and fuse sources. Adapted to web_search + web_fetch + browser."
user-invocable: false
---

# Search Fusion

Search effectively by **choosing the strategy by intent** and fusing results from multiple sources. Adapted to a key-free search tool + `web_fetch` + a browser.

## When to use it

- Any web search that needs more than a single result.
- Researching APIs, specs, docs, prices.
- When you need to cross several sources to confirm something.

## Choose the strategy by intent

| Intent | What it is | Strategy |
|---|---|---|
| **research** | Deep investigation of a topic | Several searches + read full sources (web_fetch) |
| **keyword** | Classic search for a term/page | Direct web search |
| **answer** | Direct answer to a question | Search + extract the specific answer from the source |
| **news** | Recent news/events | Recent search (freshness) + verify the date |
| **code/spec** | API docs, technical specs | Search + web_fetch the official doc |

## How to fuse (multi-source)

For serious research, don't settle for the first result:

1. **Search** with the web search tool.
2. **Read** the 2-3 most relevant sources with web_fetch (not just the snippet).
3. **Cross-check** - if the sources agree, it's reliable; if they contradict, note the discrepancy.
4. **Dedupe** - don't repeat the same fact from multiple sources; synthesize.

## Suggested flow per intent

### Research
```
web_search "<topic>" (2-3 different queries)
  -> web_fetch the top 2-3 sources
  -> synthesize, citing the source
```

### API doc / spec
```
web_search "<library> <api> <doc>"
  -> web_fetch the official doc (prefer the official site over blogs)
  -> extract the spec/parameters
```

### Answering a fact (answer)
```
web_search "<concrete question>"
  -> verify in 1-2 reliable sources
  -> answer with the source
```

### News
```
web_search "<topic> <date or 'news'>"
  -> verify freshness (that it's recent)
  -> cross 2 outlets if it matters
```

## Rules

- **Verify before answering** - don't trust a single snippet; read the source if the fact matters (prices, dates, specs).
- **Prefer the official site** for specs/APIs (official docs over blogs).
- **Dedupe**: don't repeat the same info from several sources; synthesize once.
- **100% with local tools** (key-free search, web_fetch, browser) - no paid APIs.

## Limits

- It does not automatically fuse N providers (only one key-free search backend). The "fusion" is manual: search + read + cross-check.
- If more search engines are configured later (Brave, Tavily), the fan-out could be automated.

## Related

- [Deep Research](../deepwiki): deep investigation of topics.
- [Knowledge Management](../knowledge-management): consolidate search findings into memory.
