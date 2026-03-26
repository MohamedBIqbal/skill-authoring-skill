# skill-authoring

A skill that teaches AI coding assistants how to create, improve, and optimize other skills — structured for discovery, quality, and portability.

## What It Does

When installed, this skill activates whenever you ask your AI assistant to create or improve a skill. It provides:

- **Skill structure** — directory layout, YAML frontmatter requirements, bundled resources
- **Frontmatter reference** — linter-safe vs extended fields, workarounds for validator bugs
- **Context budget management** — formula for max skills, description length targets at scale
- **Authoring principles** — conciseness, progressive disclosure, degrees of freedom, writing style
- **Description optimization** — how to write descriptions that trigger reliably
- **Scaling patterns** — heavy skills, domain scoping, cross-skill collaboration, compaction resilience
- **Content patterns** — templates, examples, conditional workflows, domain organization
- **Quality checklist** — validation criteria for naming, structure, scaling, and security

## Installation

### Project scope (one repo)

```bash
# From your project root
mkdir -p .claude/skills/skill-authoring
cp SKILL.md .claude/skills/skill-authoring/SKILL.md
```

### Personal scope (all projects)

```bash
mkdir -p ~/.claude/skills/skill-authoring
cp SKILL.md ~/.claude/skills/skill-authoring/SKILL.md
```

### One-liner

```bash
# Personal scope
mkdir -p ~/.claude/skills/skill-authoring && curl -fsSL https://raw.githubusercontent.com/MohamedBIqbal/skill-authoring-skill/main/SKILL.md -o ~/.claude/skills/skill-authoring/SKILL.md
```

## Usage

Once installed, the skill automatically activates when you:

- Ask to "create a new skill"
- Ask to "review this skill" or "improve this skill"
- Ask to "optimize the description" of a skill
- Work on any `.claude/skills/*/SKILL.md` file

You can also invoke it directly:

```
/skill-authoring
```

## Example

```
> Create a skill for managing Docker containers

The AI will use skill-authoring guidelines to:
1. Choose a good name (e.g., docker-management)
2. Write an effective description for triggering
3. Structure the SKILL.md with progressive disclosure
4. Check context budget (description length vs formula)
5. Apply the quality checklist
```

## Compatibility

Write once as `SKILL.md`, then convert to any AI coding tool's format:

| Tool | Format | Command |
|------|--------|---------|
| Claude Code | `.claude/skills/*/SKILL.md` | Native — no conversion needed |
| Cursor | `.cursorrules` | `./convert.sh SKILL.md cursor` |
| Windsurf | `.windsurfrules` | `./convert.sh SKILL.md windsurf` |
| GitHub Copilot | `.github/copilot-instructions.md` | `./convert.sh SKILL.md copilot` |
| Aider | `.aider.prompt.md` | `./convert.sh SKILL.md aider` |
| All at once | All of the above | `./convert.sh SKILL.md all` |

### Convert any SKILL.md

The converter works with any skill, not just this one:

```bash
# Convert your own skill to Cursor format
./convert.sh path/to/your/SKILL.md cursor

# Convert to all formats, output to a specific directory
./convert.sh path/to/your/SKILL.md all ./my-project
```

## License

MIT
