# Workflow Audit Checklist - Reference

## Single Responsibility

- [ ] Does the workflow do one thing?
- [ ] Does its name reflect exactly what it does?
- [ ] Are there mixed responsibilities?
- [ ] Does it depend on another workflow for something it should do on its own?

## Duplication

- [ ] Are there repeated checklists across multiple workflows?
- [ ] Are there identical phases in different workflows?
- [ ] Are there similar prompts that should be unified?
- [ ] Are there duplicated validations?

## Currency

- [ ] Does the SKILL.md reflect current practice?
- [ ] Are the references up to date?
- [ ] Are the templates still valid?
- [ ] Are the principles it references still in force?

## Engineering Principles

- [ ] Does it respect the engineering principles of the OS?
- [ ] Are there contradictions with other workflows?
- [ ] Does it promote good practices?
- [ ] Does it discourage bad practices?

## Size

- [ ] Is it too long? (>300 lines -> consider a split)
- [ ] Is it too short? (<30 lines -> is it really a workflow?)
- [ ] Does it have reference content that should live in `references/`?

## Related

- [SKILL.md](../SKILL.md) - Main workflow
