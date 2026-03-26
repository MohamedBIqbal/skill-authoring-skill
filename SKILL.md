---
name: skill-authoring
description: Create, review, optimize Claude Code skills. Covers frontmatter, progressive disclosure, description budgets, scaling patterns, and cross-skill collaboration.
---

# Skill Authoring Guide

Create skills that follow Anthropic's guidelines and scale without blowing the context budget.

## Skill Structure

```
skill-name/
├── SKILL.md              # Required: YAML frontmatter + markdown instructions
└── Bundled Resources      # Optional:
    ├── scripts/           # Executable code (zero token cost — executed, not loaded)
    ├── references/        # Docs loaded into context as needed (on-demand tokens)
    └── assets/            # Files used in output (templates, icons)
```

## YAML Frontmatter

All fields are optional. Only `description` is recommended.

```yaml
---
name: skill-name
description: What the skill does and when to use it.
---
```

### Complete Frontmatter Reference

Source: `code.claude.com/docs/en/skills#frontmatter-reference`

**Linter-safe fields** (no IDE warnings):

| Field | Type | Purpose |
|-------|------|---------|
| `name` | string | Display name. Max 64 chars, lowercase/numbers/hyphens. No "anthropic" or "claude". Defaults to directory name. |
| `description` | string | Triggering mechanism. Max 1024 chars. Third person. Include WHAT + WHEN. |
| `argument-hint` | string | Autocomplete hint shown after `/skill-name` (e.g. `[issue-number]`) |
| `disable-model-invocation` | boolean | Prevents Claude from auto-loading. User must invoke via `/name`. |
| `user-invocable` | boolean | Controls `/` menu visibility. `false` = Claude-only (background knowledge). Default: `true`. |
| `compatibility` | string | Agent Skills standard — declare tool/dependency requirements. |
| `license` | string | Agent Skills standard — skill licensing. |
| `metadata` | map | Agent Skills standard — arbitrary string-to-string metadata. |

**Extended fields** (valid per official docs, but cause IDE linter warnings due to validator bug — GitHub #25380, #26795, #23330). Avoid using in frontmatter until the validator is fixed. Instead, achieve the same effect through skill body instructions or project conventions:

| Field | Purpose | Workaround Without Frontmatter |
|-------|---------|-------------------------------|
| `context: fork` | Isolated subagent, zero main-context cost | Instruct in body: "Run this analysis in a subagent via Agent tool" |
| `agent` | Subagent type (`Explore`, `Plan`) | Specify in body instructions |
| `paths` | Auto-activate only for matching files | Use description keywords to scope triggering |
| `allowed-tools` | Auto-approve tools | Configure in settings.json permissions |
| `model` | Model override | Specify in body instructions |
| `effort` | Effort level | Specify in body instructions |
| `hooks` | Skill-scoped hooks | Configure in settings.json hooks with matchers |
| `shell` | Shell for `!command` blocks | Default bash works for most cases |

### Scaling Decision Tree

```
Does it modify files/infra/external systems?
  YES → disable-model-invocation: true (user invokes explicitly)
  NO →
    Is it background knowledge Claude should auto-trigger?
      YES → user-invocable: false
      NO → Default (user and Claude can both invoke)
```

## Context Budget Management

Skill descriptions are always in context. Budget: **2% of context window (~16,000 chars)**.

**Budget formula per skill:** `description_length + 109 chars overhead`

| Avg Description | Max Skills |
|-----------------|-----------|
| 263 chars | ~42 |
| 200 chars | ~52 |
| 130 chars | ~67 |

**When exceeded:** Skills silently disappear. No error. Check with `/context`.

**Override:** `SLASH_COMMAND_TOOL_CHAR_BUDGET` env var.

**At scale (25+ skills):** Target <=200 chars. Front-load trigger keywords in first 50 chars.

## Core Authoring Principles

### 1. Concise is Key

Claude is smart. Only add context Claude doesn't already have. Challenge each paragraph: "Does this justify its token cost?"

### 2. Progressive Disclosure (Three-Tier Loading)

| Tier | Content | Token Cost | Loaded When |
|------|---------|-----------|-------------|
| **1. Metadata** | name + description | ~100 tokens (always) | Session start |
| **2. SKILL.md body** | Instructions | < 5,000 tokens | Skill triggers |
| **3. Bundled resources** | References, scripts | Unlimited | Claude reads them |

- Keep SKILL.md under 500 lines
- Move detailed references to `references/` (one level deep, no nesting)
- For reference files >100 lines, include a table of contents
- Scripts in `scripts/` execute without loading into context (zero token cost)

### 3. Managing Heavy Skills (>200 lines)

For skills with heavy reference material, keep the SKILL.md lean and move content to `references/`:

```
heavy-skill/
├── SKILL.md              # Under 500 lines — overview + navigation
└── references/
    ├── detailed-guide.md  # Loaded only when Claude reads it
    └── examples.md        # Loaded only when Claude reads it
```

When the validator bug is fixed, `context: fork` + `agent: Explore` in frontmatter will isolate heavy skills in subagents (zero main-context cost). Until then, achieve this by instructing in the skill body: "For deep analysis, delegate to a subagent via the Agent tool."

### 4. Domain-Scoped Skills

Scope skills to their domain through precise description keywords rather than `paths:` frontmatter (which causes linter warnings until the validator is updated):

```yaml
---
name: vision
description: Computer vision — VLMs, YOLO, OpenCV pipelines, Metal optimization. Use for vision pipelines, object/face detection.
---
```

Include file patterns and module names in the description so Claude associates the skill with the right context.

### 5. Cross-Skill Collaboration

Skills can't call each other directly — Claude coordinates. Design for composability:

- Each skill must be useful independently
- Define explicit input/output interfaces
- Orchestrator skills invoke lower-order skills sequentially
- Avoid conflicting instructions across composed skills

### 6. Compaction Resilience

Skill bodies are NOT re-injected after context compaction:

- Keep critical rules in first 100 lines of SKILL.md
- Use PostCompact hook to remind about active skills (see [skill-gate](https://github.com/MohamedBIqbal/skill-gate))
- For long-running tasks, delegate to subagents to avoid compaction risk

### 7. Degrees of Freedom

| Level | Use When | Example |
|-------|----------|---------|
| **High** (text) | Multiple approaches valid | Code review guidelines |
| **Medium** (pseudocode) | Preferred pattern exists | Report generation |
| **Low** (exact scripts) | Fragile operations | Database migrations |

### 8. Writing Style

- Imperative form in instructions
- Explain **why** rather than heavy-handed MUSTs
- General, not overfit to specific examples

## Writing Effective Descriptions

The description is the sole triggering mechanism. Claude reads all descriptions every request.

- Third person ("Processes files..." not "I process files...")
- WHAT it does AND specific WHEN/contexts
- Front-load trigger keywords in first 50 characters
- Specific key terms users would naturally say
- Slightly "pushy" to combat undertriggering
- At scale: <=200 chars without losing trigger terms

## Naming Conventions

Prefer **gerund form**: `processing-pdfs`, `analyzing-data`

Acceptable: noun phrases (`pdf-processing`), action-oriented (`process-pdfs`)

Avoid: `helper`, `utils`, `tools`, `documents`, `data`

## Content Patterns

**Template** — exact structure to follow
**Examples** — input/output pairs for formatting
**Conditional Workflow** — decision tree routing
**Domain Organization** — SKILL.md overview + references/ subdirectory

## Authoring Checklist

### Core Quality
- [ ] Name: lowercase, hyphens, max 64 chars, matches folder name
- [ ] Description: third person, what AND when, <=200 chars at scale
- [ ] SKILL.md body under 500 lines
- [ ] References in separate files (one level deep)
- [ ] No time-sensitive information
- [ ] Consistent terminology
- [ ] No external URLs in SKILL.md

### Scaling
- [ ] Heavy reference material moved to `references/` (>200 lines?)
- [ ] `disable-model-invocation: true` assessed (side-effect skill?)
- [ ] `user-invocable: false` assessed (background knowledge?)
- [ ] Description scoped with domain keywords (for triggering precision)
- [ ] Description length vs budget formula
- [ ] Cross-skill: no conflicting instructions
- [ ] Compaction-resilient: critical rules in first 100 lines

### Scripts
- [ ] Handle errors explicitly
- [ ] No magic constants
- [ ] Required packages listed

### Security
- [ ] No malware or exploit code
- [ ] Contents would not surprise user if described
