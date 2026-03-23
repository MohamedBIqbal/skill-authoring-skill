---
name: skill-authoring
description: Create, improve, and optimize Claude Code skills following Anthropic's official guidelines. Use when creating new skills, reviewing existing skills for quality, optimizing skill descriptions for triggering, or preparing skills for official submission and approval.
---

# Skill Authoring Guide

Create skills that follow Anthropic's official guidelines for discovery, quality, and potential approval.

## Skill Structure

```
skill-name/
├── SKILL.md              # Required: YAML frontmatter + markdown instructions
└── Bundled Resources      # Optional:
    ├── scripts/           # Executable code for deterministic tasks
    ├── references/        # Docs loaded into context as needed
    └── assets/            # Files used in output (templates, icons)
```

## YAML Frontmatter (Required)

```yaml
---
name: skill-name
description: What the skill does and when to use it.
---
```

### Field Requirements

| Field | Required | Constraints |
|-------|----------|-------------|
| `name` | Yes | Max 64 chars, lowercase letters/numbers/hyphens only. No XML tags. Cannot contain "anthropic" or "claude" |
| `description` | Yes | Max 1024 chars, non-empty, no XML tags. Third person ("Processes files..." not "I process files..."). Include WHAT it does AND WHEN to use it |

### Optional Frontmatter

| Field | Purpose |
|-------|---------|
| `disable-model-invocation: true` | Only user can invoke (for side-effect workflows like deploy, commit) |
| `user-invocable: false` | Only Claude can invoke (background knowledge) |
| `allowed-tools` | Restrict tool access: `Read, Grep, Glob` |
| `context: fork` | Run in isolated subagent context |
| `agent` | Subagent type when forked: `Explore`, `Plan`, `general-purpose` |
| `model` | Override model for this skill |
| `effort` | Effort level: `low`, `medium`, `high`, `max` |

## Core Authoring Principles

### 1. Concise is Key

Claude is already very smart. Only add context Claude doesn't already have.

Challenge each piece of information:
- "Does Claude really need this explanation?"
- "Can I assume Claude knows this?"
- "Does this paragraph justify its token cost?"

**Good** (~50 tokens):
```markdown
## Extract PDF text
Use pdfplumber for text extraction:
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

**Bad** (~150 tokens):
```markdown
## Extract PDF text
PDF (Portable Document Format) files are a common file format that contains
text, images, and other content. To extract text from a PDF, you'll need to
use a library. There are many libraries available...
```

### 2. Progressive Disclosure (Three-Level Loading)

| Level | Content | Token Budget |
|-------|---------|--------------|
| **Metadata** | name + description (always in context) | ~100 tokens |
| **SKILL.md body** | Loaded when skill triggers | < 500 lines |
| **Bundled resources** | Loaded as needed | Unlimited |

- Keep SKILL.md under 500 lines
- Move detailed references to separate files
- Reference files should be one level deep from SKILL.md (no nested references)
- For reference files > 100 lines, include a table of contents

### 3. Set Appropriate Degrees of Freedom

| Freedom Level | Use When | Example |
|---------------|----------|---------|
| **High** (text instructions) | Multiple approaches valid, context-dependent | Code review guidelines |
| **Medium** (pseudocode with params) | Preferred pattern exists, some variation OK | Report generation template |
| **Low** (exact scripts) | Operations are fragile, consistency critical | Database migrations |

### 4. Writing Style

- Use imperative form in instructions
- Explain **why** things are important rather than heavy-handed MUSTs
- Use theory of mind — make skills general, not overfit to specific examples
- Write a draft, then review with fresh eyes and improve
- If you find yourself writing ALWAYS or NEVER in caps, reframe and explain the reasoning instead

## Writing Effective Descriptions

The description is the primary triggering mechanism. Claude uses it to choose the right skill from potentially 100+ available skills.

**Rules:**
- Write in third person ("Processes files..." not "I process files...")
- Include WHAT it does AND specific WHEN/contexts to use it
- Be specific, include key terms users would naturally say
- Make descriptions slightly "pushy" to combat undertriggering

**Good examples:**
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

```yaml
description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when analyzing Excel files, spreadsheets, tabular data, or .xlsx files.
```

**Bad examples:**
```yaml
description: Helps with documents
description: Processes data
description: Does stuff with files
```

## Naming Conventions

Prefer **gerund form** (verb + -ing) for skill names:
- `processing-pdfs`, `analyzing-spreadsheets`, `managing-databases`

Acceptable alternatives:
- Noun phrases: `pdf-processing`, `spreadsheet-analysis`
- Action-oriented: `process-pdfs`, `analyze-spreadsheets`

Avoid: `helper`, `utils`, `tools`, `documents`, `data`

## Content Patterns

### Template Pattern
```markdown
## Report structure
ALWAYS use this exact template:
# [Title]
## Executive summary
## Key findings
## Recommendations
```

### Examples Pattern (input/output pairs)
```markdown
## Commit message format
**Example 1:**
Input: Added user authentication with JWT tokens
Output: feat(auth): implement JWT-based authentication
```

### Conditional Workflow Pattern
```markdown
## Workflow
1. Determine type:
   **Creating new?** → Follow "Creation workflow" below
   **Editing existing?** → Follow "Editing workflow" below
```

### Domain Organization Pattern
```
skill-name/
├── SKILL.md (overview + navigation)
└── references/
    ├── domain-a.md
    ├── domain-b.md
    └── domain-c.md
```
Claude reads only the relevant reference file.

## Workflows and Feedback Loops

### Use Checklists for Complex Tasks
```markdown
## Workflow
Copy this checklist and track progress:
- [ ] Step 1: Analyze input
- [ ] Step 2: Create mapping
- [ ] Step 3: Validate mapping
- [ ] Step 4: Execute
- [ ] Step 5: Verify output
```

### Implement Feedback Loops
Run validator → fix errors → repeat. This pattern greatly improves output quality.

```markdown
1. Make edits
2. Validate immediately: `python scripts/validate.py`
3. If validation fails → fix → validate again
4. Only proceed when validation passes
```

## Anti-Patterns to Avoid

| Anti-Pattern | Fix |
|-------------|-----|
| Time-sensitive info ("after August 2025, use new API") | Use "Current method" / "Old patterns" sections |
| Inconsistent terminology (mix "API endpoint", "URL", "route") | Choose one term, use it throughout |
| Too many options ("use pypdf, or pdfplumber, or PyMuPDF...") | Provide one default, mention alternatives only for specific cases |
| Windows-style paths (`scripts\helper.py`) | Always use forward slashes |
| Deeply nested references (SKILL.md → file1 → file2) | Keep references one level deep |
| Vague names (`helper`, `utils`) | Descriptive names (`pdf-processing`, `form-validation`) |
| Over-explaining what Claude already knows | Challenge every paragraph's token cost |
| Rigid ALWAYS/NEVER instructions | Explain the reasoning instead |

## Scripts Best Practices (If Applicable)

- Handle errors explicitly in scripts — don't punt to Claude
- Document all constants with reasoning (no "voodoo constants")
- List required packages with install instructions
- Make execution intent clear: "Run script.py" (execute) vs "See script.py" (read as reference)
- Create verifiable intermediate outputs for complex operations
- Use the plan-validate-execute pattern for batch/destructive operations

## Evaluation and Iteration

### Build Evaluations First
1. Run Claude on representative tasks WITHOUT the skill
2. Document specific failures or missing context
3. Create 3+ test scenarios that test these gaps
4. Establish baseline performance
5. Write minimal skill content to address gaps
6. Test, compare, iterate

### Test With Multiple Models
- **Haiku**: Does the skill provide enough guidance?
- **Sonnet**: Is the skill clear and efficient?
- **Opus**: Does the skill avoid over-explaining?

What works for Opus might need more detail for Haiku.

### Iterative Development Pattern
1. Work with Claude A to design/refine the skill
2. Test with Claude B (fresh instance with skill loaded) on real tasks
3. Observe behavior: where does it struggle, succeed, or surprise?
4. Return to Claude A with observations for improvements
5. Repeat until stable

## Checklist for Effective Skills

### Core Quality
- [ ] Name: lowercase, hyphens, max 64 chars, no reserved words
- [ ] Description: third person, specific, includes what AND when, max 1024 chars
- [ ] SKILL.md body under 500 lines
- [ ] Additional details in separate reference files (if needed)
- [ ] No time-sensitive information
- [ ] Consistent terminology throughout
- [ ] Examples are concrete, not abstract
- [ ] File references one level deep
- [ ] Progressive disclosure used appropriately
- [ ] Workflows have clear steps with checklists

### Code and Scripts (If Applicable)
- [ ] Scripts handle errors explicitly
- [ ] No unexplained magic constants
- [ ] Required packages listed
- [ ] No Windows-style paths
- [ ] Validation/verification steps for critical operations
- [ ] Feedback loops for quality-critical tasks

### Testing
- [ ] At least 3 evaluation scenarios created
- [ ] Tested with Haiku, Sonnet, and Opus
- [ ] Tested with real usage scenarios
- [ ] Baseline comparison (with vs without skill)
- [ ] Team feedback incorporated (if applicable)

### Security
- [ ] No malware, exploit code, or security-compromising content
- [ ] Skill contents would not surprise user if described
- [ ] No misleading skills or unauthorized access facilitation

## Publishing and Distribution

Skills can be distributed via:
- **Project scope**: `.claude/skills/skill-name/SKILL.md` in repo
- **Personal scope**: `~/.claude/skills/skill-name/SKILL.md` for all projects
- **Claude.ai upload**: Settings > Capabilities > Skills (individual)
- **Organization deployment**: Admin-managed workspace-wide skills
- **Open standard**: Skills are portable across tools and platforms

Agent Skills are published as an open standard — the same skill should work whether used in Claude Code, Claude.ai, or other AI platforms.
