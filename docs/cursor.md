# Instalar kanam-skills en Cursor

## Opción 1: skills.sh (recomendada)

```bash
npx skills add gonzoblasco/kanam-skills
```

El CLI detecta Cursor e instala en `.cursor/skills/`.

## Opción 2: manual

Desde la raíz de tu proyecto (o `~/.cursor` para global):

```bash
git clone git@github.com:gonzoblasco/kanam-skills.git
cp -r skills/* .cursor/skills/
```

## Verificar

Reiniciá Cursor y pedile al agente que use una skill (ej: "aplica
test-driven development"). Cursor debería reconocerla.
