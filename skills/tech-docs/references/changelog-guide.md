# CHANGELOG Guide - Technical Documentation Reference

Guía para mantener un CHANGELOG útil.

## Format (Keep a Changelog)

```markdown
# Changelog

## [Unreleased]

### Added
- New feature A

### Changed
- Updated dependency X

### Fixed
- Bug in component Y

### Removed
- Deprecated function Z

## [1.0.0] - 2026-07-23

### Added
- Initial release
```

## When to Update

- **New feature:** Add to `[Unreleased]` under `Added`
- **Bug fix:** Add under `Fixed`
- **Breaking change:** Add under `Changed` with migration note
- **Deprecation:** Add under `Removed` or `Deprecated`

## Release Process

1. Move `[Unreleased]` to new version
2. Add date
3. Create git tag
4. Push

## Related

- [SKILL.md](../SKILL.md) - Workflow principal
- [ADR Patterns](./adr-patterns.md) - Patrones de ADRs
- [Architecture Diagrams](./architecture-diagrams.md) - Diagramas C4
