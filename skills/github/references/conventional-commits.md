# Conventional Commits

## Formato

```
<type>(#<issue>): <descripcion>
```

## Tipos

| Tipo | Cuando |
|------|--------|
| `feat` | Nueva funcion |
| `fix` | Correccion de bug |
| `chore` | Mantenimiento, CI, deps |
| `docs` | Solo documentacion |
| `refactor` | Cambio de codigo, sin feature/fix |
| `test` | Agregar o corregir pruebas |
| `style` | Formateo, puntos y comas, etc. |
| `perf` | Mejora de rendimiento |
| `ci` | Cambios de CI/CD |

## Ejemplos

```
feat(#3): timeline page with reverse-chronological entry list
fix(#12): prevent double submit on login form
chore(#11): add GitHub Actions CI workflow
docs(#7): update README with setup instructions
refactor(#15): extract auth logic to useAuth hook
```

## Reglas

- **Siempre en ingles** para los repos que usan ingles
- **Un commit por issue/tarea** - commits atomicos
- **Guion comun (-), nunca guion largo (—)**
- El numero de issue referencia el issue de GitHub
- Descripcion en modo imperativo ("add" no "added" ni "adds")
