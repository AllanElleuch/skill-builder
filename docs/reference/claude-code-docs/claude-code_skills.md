# Claude Code Agent Skills

**Extend Claude's capabilities with modular, discoverable skill packages**

📖 **Official Documentation:** https://docs.claude.com/en/docs/claude-code/skills
🗂️ **Last Updated:** 2025-10-18
📦 **Version:** v0.3.3+

---

## Table of Contents

- [Overview](#overview)
- [What are Agent Skills?](#what-are-agent-skills)
- [Skills vs Slash Commands](#skills-vs-slash-commands)
- [Creating Skills](#creating-skills)
  - [File Structure](#file-structure)
  - [SKILL.md Format](#skillmd-format)
  - [Frontmatter Options](#frontmatter-options)
  - [Storage Locations](#storage-locations)
- [Skill Examples](#skill-examples)
- [Supporting Files](#supporting-files)
- [Tool Restrictions](#tool-restrictions)
- [Team Sharing](#team-sharing)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Advanced Topics](#advanced-topics)

---

## Overview

Agent Skills extend Claude's capabilities through modular, discoverable packages. Unlike slash commands (user-invoked), Skills are **model-invoked**—Claude autonomously decides when to use them based on your request and the Skill's description.

### Key Benefits

- **Extend functionality** for specific workflows
- **Share expertise** across teams via git
- **Reduce repetitive prompting** with reusable capabilities
- **Compose multiple Skills** for complex tasks
- **Automatic discovery** based on context

---

## What are Agent Skills?

Skills consist of a `SKILL.md` file containing instructions that Claude automatically invokes when relevant. They differ from slash commands in several key ways:

| Aspect | Skills | Slash Commands |
|--------|--------|----------------|
| **Invocation** | Automatic (Claude decides) | Manual (user types `/command`) |
| **Discovery** | Based on description matching | Listed in `/help` |
| **Complexity** | Can include multiple files | Single .md file |
| **Use Case** | Reusable capabilities | Quick prompt snippets |

---

## Skills vs Slash Commands

### Use Skills For

**Comprehensive capabilities with structure:**
- Complex workflows with multiple steps
- Capabilities requiring scripts or utilities
- Knowledge organized across multiple files
- Team workflows you want to standardize

**Examples:**
- PDF processing Skill with form-filling scripts and validation
- Data analysis Skill with reference docs for different data types
- Documentation Skill with style guides and templates

### Use Slash Commands For

**Quick, frequently-used prompts:**
- Simple prompt snippets you use often
- Quick reminders or templates
- Frequently-used instructions that fit in one file

**Examples:**
- `/review` → "Review this code for bugs and suggest improvements"
- `/explain` → "Explain this code in simple terms"
- `/optimize` → "Analyze this code for performance issues"

---

## Creating Skills

### File Structure

Skills are organized as directories containing a required `SKILL.md` file plus optional supporting files:

```
skill-name/
├── SKILL.md           # Required: main skill definition
├── reference.md       # Optional: reference documentation
├── examples.md        # Optional: usage examples
├── scripts/           # Optional: helper scripts
│   ├── helper.py
│   └── validator.sh
└── templates/         # Optional: template files
    └── template.txt
```

### SKILL.md Format

Each Skill requires a `SKILL.md` file with YAML frontmatter and markdown content:

```yaml
---
name: Your Skill Name
description: Brief description of what this Skill does and when to use it
allowed-tools: Tool1, Tool2, Tool3  # Optional
---

# Your Skill Name

## Overview
Detailed description of the Skill's capabilities and purpose.

## Instructions
Step-by-step guidance for Claude on how to use this Skill effectively.

## Usage Patterns
When and how this Skill should be invoked.
```

### Frontmatter Options

| Field | Required | Description | Example |
|-------|----------|-------------|---------|
| `name` | Yes | Display name for the Skill | `PDF Form Processor` |
| `description` | Yes | What this does and when to use it | `Process PDF forms, fill fields, validate. Use for PDF processing tasks.` |
| `allowed-tools` | No | Comma-separated list of allowed tools | `Read, Write, Bash` |

**Critical**: The `description` field should include both **functionality** and **trigger terms** users would mention.

### Storage Locations

**Personal Skills** (`~/.claude/skills/`):
- Available across all your projects
- Ideal for individual workflows
- Not shared with team

**Project Skills** (`.claude/skills/`):
- Shared via git with team members
- Project-specific expertise
- Committed to source control

**Plugin Skills**:
- Bundled with installed plugins
- Automatically available when plugin is enabled
- See [Plugins documentation](claude-code_plugins.md)

---

## Skill Examples

### Example 1: PDF Processing Skill

```
.claude/skills/pdf-processor/
├── SKILL.md
├── scripts/
│   ├── fill_form.py
│   └── validate_pdf.sh
└── templates/
    └── form_template.json
```

**SKILL.md:**
```yaml
---
name: PDF Form Processor
description: Process PDF forms, fill fields, extract data, validate PDFs. Use when working with PDF files, forms, or document processing.
allowed-tools: Read, Write, Bash
---

# PDF Form Processor

## Overview
This Skill handles PDF form processing including filling, validation, and extraction.

## Instructions

When processing PDFs:

1. **Identify the PDF file** to process
2. **Determine the operation** (fill, extract, validate)
3. **Use appropriate script** from scripts/ directory:
   - `fill_form.py` for filling forms
   - `validate_pdf.sh` for validation
4. **Follow templates** in templates/ for data structure

## Supported Operations

### Fill PDF Form
```bash
python scripts/fill_form.py input.pdf data.json output.pdf
```

### Validate PDF
```bash
bash scripts/validate_pdf.sh input.pdf
```

### Extract Data
```bash
python scripts/fill_form.py --extract input.pdf output.json
```

## Data Format
See `templates/form_template.json` for the expected data structure.
```

### Example 2: Code Review Skill

```
~/.claude/skills/code-reviewer/
└── SKILL.md
```

**SKILL.md:**
```yaml
---
name: Code Reviewer
description: Review code for quality, security, performance, and best practices. Use for code review requests, pull requests, or quality checks.
allowed-tools: Read, Grep, Glob, Bash
---

# Code Reviewer

## Overview
Expert code reviewer analyzing code for quality, security, and maintainability.

## Review Checklist

### Code Quality
- [ ] Clear and descriptive naming
- [ ] No code duplication
- [ ] Proper error handling
- [ ] Adequate comments
- [ ] Follows project conventions

### Security
- [ ] Input validation
- [ ] No exposed secrets
- [ ] Proper authentication/authorization
- [ ] SQL injection prevention
- [ ] XSS prevention

### Performance
- [ ] Efficient algorithms
- [ ] No unnecessary computations
- [ ] Proper resource management
- [ ] Database query optimization

## Review Process

1. **Read recent changes**: Use `git diff` or read modified files
2. **Analyze code**: Check against review checklist
3. **Categorize findings**:
   - **Critical**: Security issues, bugs (must fix)
   - **Important**: Performance, maintainability (should fix)
   - **Minor**: Style, optimization (nice to fix)
4. **Provide specific feedback** with code examples
5. **Suggest improvements** with implementation details
```

---

## Supporting Files

Skills can include additional resources beyond SKILL.md:

### Reference Documentation
Add `.md` files for reference material:
- `reference.md` - Technical references
- `api-docs.md` - API documentation
- `examples.md` - Usage examples

### Scripts and Utilities
Include executable scripts:
- Python scripts (`.py`)
- Shell scripts (`.sh`)
- JavaScript/Node.js scripts (`.js`)

### Templates
Provide templates for common formats:
- JSON templates
- Configuration templates
- Code templates

### Referencing Files

Reference files from SKILL.md using relative paths:

```markdown
See [API Reference](api-docs.md) for complete API documentation.

Use the template at [templates/config.json](templates/config.json).

Run the validation script: `bash scripts/validate.sh`
```

---

## Tool Restrictions

Use `allowed-tools` to limit Claude's capabilities within a Skill for security and focus:

### Syntax

```yaml
allowed-tools: Tool1, Tool2, Tool3
```

### Examples

**Read-only Skill:**
```yaml
allowed-tools: Read, Grep, Glob
```

**Analysis Skill:**
```yaml
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git log:*)
```

**Full File Operations:**
```yaml
allowed-tools: Read, Write, Edit, Bash
```

### Available Tools

See the [Settings documentation](claude-code_settings.md#tools-available-to-claude) for a complete list of available tools.

**Note**: If `allowed-tools` is omitted, the Skill inherits all tools from the main conversation.

---

## Team Sharing

### Share via Git

1. Create Skill in `.claude/skills/` directory
2. Commit to your repository
3. Team members get Skills automatically after pulling

**Example:**
```bash
# Create project skill
mkdir -p .claude/skills/deployment
cat > .claude/skills/deployment/SKILL.md << 'EOF'
---
name: Deployment Manager
description: Handle deployment workflows for staging and production
allowed-tools: Bash, Read
---

# Deployment Manager
[Skill content...]
EOF

# Commit and share
git add .claude/skills/
git commit -m "Add deployment skill"
git push
```

### Distribution via Plugins

Skills can also be distributed through the plugin system:
- Bundle Skills in plugin `skills/` directory
- Share entire plugin via marketplace
- Users get Skills when installing plugin

See [Plugin documentation](claude-code_plugins.md) for details.

---

## Best Practices

### 1. Write Specific Descriptions

**Good:**
```yaml
description: Analyze Excel spreadsheets, generate pivot tables, create charts. Use when working with Excel files, .xlsx files, or spreadsheet analysis tasks.
```

**Bad:**
```yaml
description: Helps with data
```

The description should include **what** the Skill does and **when** to use it (trigger terms).

### 2. Keep Skills Focused

**Do**: Create separate Skills for distinct capabilities
- `pdf-processor` for PDF operations
- `excel-analyzer` for spreadsheet analysis
- `code-reviewer` for code review

**Don't**: Create one giant "document-processor" Skill that tries to do everything

### 3. Use Tool Restrictions Wisely

Limit tools to prevent unintended actions:
- Read-only Skills: `Read, Grep, Glob`
- Analysis Skills: Add `Bash(git:*)` for git commands
- Processing Skills: Add `Write, Edit` when modification needed

### 4. Include Clear Instructions

Provide step-by-step guidance:
```markdown
## Instructions

1. **Identify input files** using Grep or Glob
2. **Read file contents** to understand structure
3. **Process data** according to requirements
4. **Generate output** in specified format
5. **Validate results** before completion
```

### 5. Document Dependencies

List required tools, packages, or configurations:
```markdown
## Prerequisites

- Python 3.8+ required
- Install: `pip install pandas openpyxl`
- Excel files must be .xlsx format
```

### 6. Version Your Skills

Track changes in the SKILL.md content:
```markdown
## Version History

- v1.2.0 (2025-10-18): Added chart generation
- v1.1.0 (2025-09-15): Support for pivot tables
- v1.0.0 (2025-08-01): Initial release
```

### 7. Test with Team

Before committing:
1. Test Skill with various inputs
2. Verify description triggers correctly
3. Check tool restrictions work as expected
4. Get feedback from team members

---

## Troubleshooting

### Skill Not Being Used

**Problem**: Claude doesn't use your Skill when expected

**Solutions**:
1. **Check description**: Ensure it includes trigger terms users would mention
2. **Verify file location**: Skills must be in `skills/` directory
3. **Validate YAML**: Use a YAML validator to check frontmatter syntax
4. **Test invocation**: Explicitly mention the Skill: "Use the PDF processor Skill"

### YAML Syntax Errors

**Problem**: Skill doesn't load due to frontmatter errors

**Solutions**:
1. **Use proper YAML format**: Triple dashes before and after
2. **Quote special characters**: Use quotes around values with colons or special chars
3. **Check indentation**: YAML is indent-sensitive
4. **Validate syntax**: Use online YAML validators

**Example of correct syntax:**
```yaml
---
name: My Skill
description: "Process files: read, analyze, report"
allowed-tools: Read, Write
---
```

### Path Issues

**Problem**: Scripts or references don't work

**Solutions**:
1. **Use forward slashes**: Even on Windows: `scripts/tool.py`
2. **Relative paths**: All paths relative to Skill directory
3. **Check file permissions**: Scripts need execute permissions
   ```bash
   chmod +x scripts/tool.sh
   ```

### Tool Restrictions Not Working

**Problem**: Claude uses tools not in `allowed-tools`

**Solutions**:
1. **Restart Claude Code**: Tool restrictions apply when Skill loads
2. **Check syntax**: Tools are comma-separated: `Tool1, Tool2`
3. **Verify tool names**: Use exact tool names (case-sensitive)

---

## Advanced Topics

### Combining Skills

Multiple Skills can work together for complex workflows:

```
User: "Process the Excel data and create a PDF report"

Claude:
1. Uses 'excel-analyzer' Skill to process Excel data
2. Uses 'pdf-generator' Skill to create PDF report
```

### Skill Priority

When multiple Skills could apply:
- **More specific descriptions** get priority
- **Recently used** Skills may be preferred
- **Explicit mentions** always take precedence

### Dynamic Skill Selection

Claude chooses Skills based on:
1. **User request keywords** matching description
2. **Current context** (files, task type)
3. **Available tools** needed for the task

### Plugin Integration

Skills from plugins integrate seamlessly:
- Show up automatically when plugin enabled
- Can reference plugin resources
- Use `${CLAUDE_PLUGIN_ROOT}` for plugin paths

See [Plugin Skills documentation](claude-code_plugins.md#skills) for details.

---

## Related Documentation

- **[Plugins](claude-code_plugins.md)** - Distribute Skills via plugins
- **[Slash Commands](claude-code_slash-commands.md)** - User-invoked commands
- **[Subagents](claude-code_subagents.md)** - Specialized AI agents
- **[Settings](claude-code_settings.md)** - Tool and permission configuration

---

## Additional Resources

- **Official Skills Documentation**: https://docs.claude.com/en/docs/claude-code/skills
- **Agent Skills Overview**: https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview
- **GitHub Examples**: Search for "claude-code-skills" on GitHub

---

**Ready to create your first Skill?** Start with a simple use case and iteratively improve based on how Claude uses it!
