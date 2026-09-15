---
name: "calorie-counter"
description: "Daily calorie and protein tracking in local SQLite"
---

# calorie-counter

## Description
Tracks daily calorie and protein intake using a local SQLite database. Accepts food entries by name with calorie and protein values, estimates protein when not specified, and shows accumulated totals after each entry. Also logs body weight and keeps history across days.

## When to use it
- To log meals during the day without opening an app
- To check how many calories remain before dinner
- To set a new calorie goal before starting a diet
- To track weight changes over the last month
- To delete a food entry logged by mistake

## Workflow
1. Set daily goals (calories, protein)
2. During the day, log each meal with name and values
3. Review accumulated totals after each entry
4. At the end of the day, log body weight
5. Review weekly/monthly history

## Related tooling

| Skill / Script | Usage |
|---|---|
| `sql-insight/scripts/sql_query_helper.py` | Query and analyze the SQLite calorie/weight history. |
| `db-readonly` | Safe read-only queries against the local SQLite. |

## Notes
- Everything local, no account or subscription
- Estimates protein automatically when not specified
- Local SQLite, data never leaves the machine
