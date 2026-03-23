# skill-authoring

A skill that teaches AI coding assistants how to create, improve, and optimize other skills — structured for discovery, quality, and portability.

## What It Does

When installed, this skill activates whenever you ask your AI assistant to create or improve a skill. It provides:

- **Skill structure** — directory layout, YAML frontmatter requirements, bundled resources
- **Authoring principles** — conciseness, progressive disclosure, degrees of freedom, writing style
- **Description optimization** — how to write descriptions that trigger reliably
- **Content patterns** — templates, examples, conditional workflows, domain organization
- **Quality checklist** — validation criteria for naming, structure, testing, and security
- **Evaluation methodology** — how to test skills across model tiers

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
4. Include the quality checklist
```

## Compatibility

Skills follow an open standard — the same `SKILL.md` format works across any AI coding tool that supports it.

## License

MIT
