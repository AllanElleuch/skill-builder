# Claude Code: Output Styles Guide

**Adapt Claude Code for different use cases beyond software engineering**

📖 **Official Documentation:** https://docs.anthropic.com/en/docs/claude-code/output-styles

---

## Table of Contents

1. [Overview](#overview)
2. [Built-in Output Styles](#built-in-output-styles)
3. [How Output Styles Work](#how-output-styles-work)
4. [Change Your Output Style](#change-your-output-style)
5. [Create a Custom Output Style](#create-a-custom-output-style)
6. [Comparisons to Related Features](#comparisons-to-related-features)

---

## Overview

Output styles allow you to use Claude Code as any type of agent while keeping its core capabilities, such as running local scripts, reading/writing files, and tracking TODOs.

### What Output Styles Do

Output styles **directly modify Claude Code's system prompt** to change how Claude behaves and communicates with you.

---

## Built-in Output Styles

### Default

Claude Code's standard output style, designed to help you complete software engineering tasks efficiently.

**Characteristics**:
- Concise, direct responses
- Code-focused
- Efficient output
- Verifies code with tests
- Minimal explanation unless asked

### Explanatory

Provides educational "Insights" between helping you complete software engineering tasks.

**Characteristics**:
- Helps you understand implementation choices
- Explains codebase patterns
- Educational focus
- Still completes engineering tasks
- Adds learning context

**Use When**:
- Learning a new codebase
- Understanding design patterns
- Want to learn while coding

### Learning

Collaborative, learn-by-doing mode where Claude shares "Insights" while coding and asks you to contribute small, strategic pieces of code yourself.

**Characteristics**:
- Interactive learning
- Claude adds `TODO(human)` markers for you to implement
- Asks you to write specific code sections
- Explains the reasoning behind each task
- Hands-on learning approach

**Use When**:
- Learning to code
- Understanding specific techniques
- Want hands-on practice
- Prefer interactive development

---

## How Output Styles Work

Output styles directly modify Claude Code's system prompt:

1. **Non-default styles exclude**:
   - Instructions specific to code generation
   - Efficiency-focused output guidelines
   - Conciseness requirements
   - Automatic test verification

2. **Non-default styles add**:
   - Custom instructions specific to the style
   - New behavior patterns
   - Different communication guidelines

---

## Change Your Output Style

### Option 1: Use the Menu

```bash
> /output-style
# Opens menu to select your output style
# Also accessible from /config menu
```

### Option 2: Direct Switch

```bash
> /output-style explanatory
> /output-style learning
> /output-style default
```

### Configuration File

Changes apply to the local project level and are saved in `.claude/settings.local.json`:

```json
{
  "outputStyle": "explanatory"
}
```

---

## Create a Custom Output Style

### Quick Creation with Claude's Help

```bash
> /output-style:new I want an output style that focuses on performance optimization and explains trade-offs
```

Claude will help you create a custom output style with appropriate instructions.

### File Structure

By default, output styles created through `/output-style:new` are saved at the user level in `~/.claude/output-styles` and can be used across projects.

**File Format**:

```markdown
---
name: My Custom Style
description: A brief description of what this style does, displayed to the user
---

# Custom Style Instructions

You are an interactive CLI tool that helps users with software engineering
tasks. [Your custom instructions here...]

## Specific Behaviors

[Define how the assistant should behave in this style...]
```

### Manual Creation

You can create your own output style Markdown files and save them at either level:

**User Level**: `~/.claude/output-styles/` (available across all projects)  
**Project Level**: `.claude/output-styles/` (project-specific)

### Example Custom Styles

#### Performance Optimization Style

```markdown
---
name: Performance Optimizer
description: Focuses on performance analysis and optimization with detailed explanations
---

# Performance Optimization Style

You are a performance optimization expert helping users write efficient code.

## Core Behaviors

1. **Always consider performance implications**
   - Analyze time complexity
   - Consider memory usage
   - Evaluate scalability

2. **Explain trade-offs**
   - Performance vs readability
   - Speed vs maintainability
   - Optimization vs premature optimization

3. **Provide benchmarks**
   - Suggest profiling approaches
   - Recommend benchmarking tools
   - Explain measurement methods

4. **Progressive optimization**
   - Start with correct code
   - Measure before optimizing
   - Optimize bottlenecks first

## Response Format

When suggesting optimizations:
1. Current performance characteristics
2. Proposed optimization
3. Expected improvement
4. Trade-offs and considerations
5. How to measure the improvement
```

#### Security-Focused Style

```markdown
---
name: Security Analyst
description: Security-focused code review and implementation with threat analysis
---

# Security-Focused Development Style

You are a security expert helping users write secure code.

## Core Behaviors

1. **Security-first mindset**
   - Identify potential vulnerabilities
   - Suggest secure alternatives
   - Follow security best practices

2. **Threat modeling**
   - Consider attack vectors
   - Analyze trust boundaries
   - Evaluate input validation

3. **Defense in depth**
   - Multiple layers of security
   - Fail securely
   - Principle of least privilege

## Security Checklist

For every code change, consider:
- Input validation and sanitization
- Authentication and authorization
- Encryption of sensitive data
- SQL injection prevention
- XSS prevention
- CSRF protection
- Secure session management
- Error handling (no information leakage)
```

#### Teaching Style

```markdown
---
name: Patient Teacher
description: Educational style that explains concepts thoroughly and checks understanding
---

# Patient Teacher Style

You are a patient, thorough teacher helping users learn programming concepts.

## Core Behaviors

1. **Explain before implementing**
   - Describe what you're about to do
   - Explain why this approach
   - Connect to broader concepts

2. **Check understanding**
   - Ask if explanations are clear
   - Provide examples
   - Offer analogies

3. **Build progressively**
   - Start with simple concepts
   - Add complexity gradually
   - Reinforce previous learning

4. **Encourage questions**
   - Welcome clarifications
   - No question is too basic
   - Create safe learning environment

## Response Format

When implementing features:
1. **Concept**: Explain the underlying concept
2. **Approach**: Describe the approach we'll take
3. **Implementation**: Write the code with inline comments
4. **Review**: Summarize what we did and why
5. **Practice**: Suggest exercises for reinforcement
```

---

## Comparisons to Related Features

### Output Styles vs CLAUDE.md

| Output Styles | CLAUDE.md |
|---------------|-----------|
| Modifies system prompt | Adds user message after system prompt |
| Changes core behavior | Adds context and instructions |
| Replaces default instructions | Supplements existing instructions |
| Choose one style at a time | Multiple memory files can coexist |

**Key Difference**: Output styles "turn off" parts of Claude Code's default system prompt specific to software engineering. CLAUDE.md doesn't edit the default system prompt.

### Output Styles vs `--append-system-prompt`

| Output Styles | --append-system-prompt |
|---------------|------------------------|
| Replaces default instructions | Appends to system prompt |
| Stored in settings | Provided at runtime |
| Persistent across sessions | One-time use |
| File-based | Command-line flag |

**Key Difference**: Output styles completely modify the system prompt, while `--append-system-prompt` adds to the existing prompt.

### Output Styles vs Subagents

| Output Styles | Subagents |
|---------------|-----------|
| Affects main agent behavior | Separate agent instances |
| One active at a time | Multiple can be used |
| Changes system prompt only | Includes tools, model, prompt, and invocation rules |
| Session-wide | Task-specific |
| Persistent | Invoked as needed |

**Key Difference**: Output styles directly affect the main agent loop and only affect the system prompt. Subagents are invoked for specific tasks and can include additional settings like model and tool permissions.

### Output Styles vs Custom Slash Commands

| Output Styles | Slash Commands |
|---------------|----------------|
| "Stored system prompts" | "Stored prompts" |
| Changes how Claude behaves | Executes specific prompt |
| Persistent throughout session | One-time execution |
| Modifies all interactions | Scoped to command execution |

**Key Difference**: Think of output styles as "stored system prompts" and custom slash commands as "stored prompts."

---

## When to Use Output Styles

### Use Output Styles When

1. **Changing overall behavior**
   - Want different communication style across entire session
   - Need specialized focus (security, performance, learning)
   - Adapting Claude Code for non-engineering tasks

2. **Consistent approach needed**
   - Every interaction should follow specific guidelines
   - Need persistent behavioral changes
   - Want different default assumptions

3. **Educational purposes**
   - Learning mode for new developers
   - Explanatory mode for understanding codebases
   - Patient teaching style

### Use Other Features When

- **CLAUDE.md**: Adding project context, conventions, or supplemental instructions
- **Subagents**: Task-specific specialized behavior
- **Slash Commands**: Reusable specific prompts
- **`--append-system-prompt`**: One-time prompt modifications

---

## Best Practices

### 1. Start with Built-in Styles

Try the built-in styles (Default, Explanatory, Learning) before creating custom ones.

### 2. Define Clear Behaviors

When creating custom styles, explicitly define:
- What Claude should do differently
- How Claude should communicate
- What Claude should prioritize
- What Claude should avoid

### 3. Test Your Style

Create and test custom styles with various tasks to ensure they behave as expected.

### 4. Document Your Styles

Include clear descriptions in the frontmatter so you remember what each style does.

### 5. Share Useful Styles

Project-level styles (`.claude/output-styles/`) can be shared with your team via version control.

---

## Related Documentation

- **[Configuration Guide](claude-code_configuration.md)** - Settings and configuration
- **[Subagents Guide](claude-code_subagents.md)** - Specialized AI assistants
- **[Slash Commands](claude-code_slash-commands.md)** - Custom commands
- **[Workflows Guide](claude-code_workflows.md)** - Common development workflows

---

*Part of the Claude Code Documentation Series. See [claude-code_manifest.md](claude-code_manifest.md) for all available guides.*
