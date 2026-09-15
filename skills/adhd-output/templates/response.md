# Template: ADHD-friendly response

## Base

```
<concrete, imperative action, first line>

<minimum context, only if it changes the action - max 2 lines>

1. <step>
2. <step>
3. <step>

Next: <one action, the smallest and most verifiable>
```

## With state (long session)

```
<concrete action>

State: <what's running> | <what's left> | <what changed>
<estimate: N minutes>

1. <step>
2. <step>

Next: <action>
```

## With error

```
<what failed, in one line, with code and location>

Cause: <one line>

1. <diagnosis step>
2. <fix step>

Next: <what to paste / what to run>
```

## With decision

```
<recommendation, first line, with the reason in one sentence>

Options:
| Option | Cost | When it's worth it |
|---|---|---|
| A | ... | ... |
| B | ... | ... |

Next: <action to start with the recommended one>
```

## Output checklist

- [ ] First line is an action, not context
- [ ] Multi-step is numbered
- [ ] Ends on an executable next step
- [ ] Time estimates in minutes if applicable
- [ ] Lists of max 5 items (or a table if the list is the deliverable)
- [ ] No "Great question", "Hope this helps", "Let me know if..."
- [ ] Plain hyphen (-), never an em dash
- [ ] Errors with no drama or long apologies
