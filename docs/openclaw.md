# Installing kanam-skills in OpenClaw

**This is the differentiator.** The mainstream skills collections
(Addy, Google, Anthropic) don't cover OpenClaw. These skills were adapted for
and verified on OpenClaw — this is the only port you'll find.

## How OpenClaw loads skills

OpenClaw discovers skills from `<workspace>/skills` (highest precedence) and a
few other roots. Each skill is a folder containing a `SKILL.md` file with YAML
frontmatter. See the
[OpenClaw skills docs](https://docs.openclaw.ai/tools/skills) for details.

## Install

From your OpenClaw workspace:

```bash
# Clone once (anywhere)
git clone git@github.com:gonzoblasco/kanam-skills.git /tmp/kanam-skills

# Copy every skill into your workspace
cp -R /tmp/kanam-skills/skills/* skills/

# Clean up
rm -rf /tmp/kanam-skills
```

Restart your OpenClaw session (or start a new one). Skills are discovered
automatically.

## Install a subset

Copy only the skills you want:

```bash
cp -R /tmp/kanam-skills/skills/spec-driven-development skills/
cp -R /tmp/kanam-skills/skills/adhd-assistant skills/
```

## Verify

After restart, run:

```
openclaw skills list
```

or just ask your agent "what skills do you have?" — the installed skills
should appear in the `<available_skills>` context.

## Keep in sync

To pull updates later:

```bash
git -C /tmp/kanam-skills pull
cp -R /tmp/kanam-skills/skills/* skills/
```
