# skill-authoring

A Claude Code skill that teaches Claude how to create, improve, and optimize other skills following Anthropic's official guidelines.

## What It Does

When installed, this skill activates whenever you ask Claude Code to create or improve a skill. It provides:

- **Skill structure** — directory layout, YAML frontmatter requirements, bundled resources
- **Authoring principles** — conciseness, progressive disclosure, degrees of freedom, writing style
- **Description optimization** — how to write descriptions that trigger reliably
- **Content patterns** — templates, examples, conditional workflows, domain organization
- **Quality checklist** — validation criteria for naming, structure, testing, and security
- **Evaluation methodology** — how to test skills across Haiku, Sonnet, and Opus

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

Once installed, Claude Code automatically activates this skill when you:

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

Claude will use skill-authoring guidelines to:
1. Choose a good name (e.g., docker-management)
2. Write an effective description for triggering
3. Structure the SKILL.md with progressive disclosure
4. Include the quality checklist
```

## License

MIT
