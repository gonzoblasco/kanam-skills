---
name: "support-response-writer"
metadata:
  category: "Customer"
  tags:
    - support
    - customer-service
    - customer-care
    - de-escalation
description: "Generate professional customer support responses: pre-sale, after-sale, complaints and returns, with emotional de-escalation strategies."
user-invocable: false
---

# Workflow: Support Response Writer

## Purpose

Generate professional customer support responses for different scenarios: pre-sale, after-sale, complaints and returns. Includes emotional de-escalation strategies based on the customer's intensity level.

## When to Use It

- Drafting a support response
- Angry or frustrated customer
- Handling a return or exchange
- Answering a pre-sale inquiry
- Managing a complaint

## Scenarios

### Pre-Sale Inquiry
1. Warm greeting
2. Precise answer
3. Value reinforcement
4. Concern removal
5. Call to action

### After-Sale Support
1. Identity confirmation
2. Empathy expression
3. Problem diagnosis
4. Solution (step-by-step)
5. Follow-up

### Complaint Handling
1. Sincere apology
2. Emotional validation
3. Fact confirmation
4. Compensation plan
5. Improvement commitment
6. Continued care

### Returns & Exchanges
1. Positive attitude
2. Policy explanation
3. Process guidance
4. Streamlined handling
5. Retention & care

## Emotional De-Escalation

| Level | Strategy | Key Phrases |
|---|---|---|
| Calm | Professional, efficient | Answer directly |
| Anxious | Empathy + clear timeline | "Let me look into this right away" |
| Dissatisfied | Validate + ownership + compensation | "I'd feel the same way" |
| Angry | Listen + deep empathy + escalate | "I'm escalating this immediately" |
| Disappointed | Warm care + exceed expectations | "We feel terrible about letting you down" |

## Outputs

- Initial response script
- Follow-up response
- Escalation response
- De-escalation strategy
- Communication tips

## Helper Scripts

Scripts in `skills/support-response-writer/scripts/`:

| Script | Usage |
|---|---|
| `sentiment-check.sh <file>` | Detects the tone/emotion of a support message and suggests a de-escalation level. Use before drafting the response. |

Also see [copy-editing/scripts/readability-check.sh](../copy-editing/scripts/readability-check.sh) to polish readability and [word-count.sh](../copy-editing/scripts/word-count.sh) to control length.

## Related Skills

- [Copy Editing](../copy-editing): To polish the tone of responses
