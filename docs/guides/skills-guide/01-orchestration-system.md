# The Claude Code Orchestration System

**Target Audience**: AI coding agents
**Purpose**: Understand the complete orchestration ecosystem and how components interact

## Overview

Claude Code is an orchestration system that enables AI agents to perform complex, repeatable workflows through modular, composable components. Think of it as a "developer experience layer" that transforms Claude from a general-purpose assistant into a specialized coding agent with domain-specific capabilities.

## Core Components

The system consists of six primary components that work together:

### 1. Skills
**Nature**: Auto-discovered, model-invoked SOPs (Standard Operating Procedures)
**Trigger**: Automatically loaded when relevant to task
**Scope**: User-level (`~/.claude/skills`) or project-level (`.claude/skills`)
**Purpose**: Reusable workflows, patterns, and domain knowledge

### 2. Slash Commands
**Nature**: User-invoked prompt shortcuts
**Trigger**: Manually activated by user (e.g., `/orchestrate`)
**Scope**: User-level (`~/.claude/commands`) or project-level (`.claude/commands`)
**Purpose**: Task-specific workflows and common operations

### 3. Subagents
**Nature**: Isolated Claude instances with specialized contexts
**Trigger**: Dispatched by main agent or skills
**Scope**: Ephemeral execution contexts
**Purpose**: Task isolation, parallel execution, fresh context

### 4. Hooks
**Nature**: Event-driven automation scripts
**Trigger**: Tool invocation events (PreToolUse, PostToolUse)
**Scope**: User-level or project-level
**Purpose**: Validation, transformation, side effects

### 5. Memory (CLAUDE.md)
**Nature**: Project-specific context and instructions
**Trigger**: Always loaded in project context
**Scope**: Project root (`.claude/CLAUDE.md` or `CLAUDE.md`)
**Purpose**: Project conventions, codebase-specific rules

### 6. MCP (Model Context Protocol)
**Nature**: External tool integrations
**Trigger**: Tool invoked by agent
**Scope**: System-level configuration
**Purpose**: Database access, API calls, external services

## Component Interaction Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        User Request                          │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────┐
│                   Main Claude Agent                         │
│  • Loads: Skills (auto), CLAUDE.md, MCP tools              │
│  • Processes: User intent, context, available components   │
└─┬──────────┬──────────┬──────────┬──────────┬─────────────┘
  │          │          │          │          │
  ▼          ▼          ▼          ▼          ▼
┌───────┐ ┌──────┐  ┌─────────┐ ┌──────┐  ┌──────┐
│Skills │ │Slash │  │Subagents│ │Hooks │  │  MCP │
│       │ │Cmds  │  │         │ │      │  │Tools │
└───┬───┘ └──┬───┘  └────┬────┘ └──┬───┘  └──┬───┘
    │        │           │          │         │
    │        └─────┐     │     ┌────┘         │
    └──────────────┴─────┴─────┴──────────────┘
                    │
                    ▼
        ┌───────────────────────┐
        │   Orchestration       │
        │   (Composed Workflow) │
        └───────────────────────┘
```

## Decision Matrix: When to Use Each Component

### Use Skills When:
✅ Workflow should auto-trigger based on task type
✅ Pattern applies across multiple projects
✅ Need progressive disclosure (load details on demand)
✅ Want reusable SOPs for common patterns
✅ Documentation should be searchable/discoverable

❌ **Don't use for**: Project-specific rules, one-time operations

**Example**: TDD workflow, document processing, API integration patterns

### Use Slash Commands When:
✅ User needs to explicitly invoke a workflow
✅ Workflow requires parameters or arguments
✅ Operation is deterministic and well-defined
✅ Want keyboard-driven productivity
✅ Need to compose multiple operations

❌ **Don't use for**: Auto-triggered workflows, complex decision trees

**Example**: `/orchestrate feature`, `/commit`, `/search codebase`

### Use Subagents When:
✅ Need isolated context (no cross-contamination)
✅ Task can run in parallel with others
✅ Want fresh perspective without accumulated context
✅ Need specialized instructions for subtask
✅ Testing or validating other components

❌ **Don't use for**: Simple linear tasks, shared state requirements

**Example**: Parallel code analysis, skill testing, research synthesis

### Use Hooks When:
✅ Need automatic validation on every tool use
✅ Want to transform tool inputs/outputs
✅ Require side effects (logging, notifications)
✅ Enforce project-wide policies
✅ Auto-format or validate before execution

❌ **Don't use for**: Complex workflows, conditional logic

**Example**: Pre-commit validation, automatic formatting, safety checks

### Use CLAUDE.md When:
✅ Rules are project-specific
✅ Codebase conventions and patterns
✅ Team-agreed standards
✅ Context needed in EVERY conversation
✅ Overrides to default behavior

❌ **Don't use for**: Reusable patterns, workflows, technique documentation

**Example**: Code style, architecture decisions, project structure

### Use MCP When:
✅ Need external service integration
✅ Database queries and updates
✅ API calls to third-party services
✅ File system operations beyond local
✅ Real-time data access

❌ **Don't use for**: Pure logic, in-context operations

**Example**: Supabase queries, web search, browser automation

## Progressive Disclosure Architecture

Claude Code uses **progressive disclosure** to manage context window efficiently:

### Level 1: Metadata Only (Always Loaded)
- Skill names and descriptions (~100 tokens per skill)
- Command names and descriptions
- Available MCP tools

**Purpose**: Agent knows what's available without loading full content

### Level 2: Instructions (Loaded on Demand)
- Full SKILL.md content when skill triggers
- Full slash command content when invoked
- Subagent instructions when dispatched

**Purpose**: Load detailed instructions only when relevant

### Level 3: Resources (Loaded on Reference)
- scripts/ (executed, output read)
- references/ (loaded when @referenced)
- assets/ (loaded when needed)

**Purpose**: Heavy content loaded only when explicitly required

### Example Flow:
```
1. Agent sees task "analyze PDF document"
   → Loads: pdf skill description (50 tokens)

2. Determines skill is relevant
   → Loads: SKILL.md content (500 tokens)

3. Needs form field extraction
   → Executes: scripts/extract_form_field_info.py (only output loaded)

4. Needs OOXML reference
   → Reads: references/ooxml.md (2000 tokens)
```

**Total**: 2,550 tokens vs 3,000+ if everything loaded upfront

## Orchestration Hierarchy

Components can be composed into multi-level orchestration chains:

### Simple Chain
```
User → Slash Command → Skill → MCP Tool → Result
```

### Complex Chain
```
User Request
  → Slash Command (/orchestrate)
    → Hook (PreToolUse: validation)
      → Skill (research-analyst)
        → Subagent 1 (web search)
          → MCP (brave-search)
        → Subagent 2 (doc analysis)
          → Skill (document-skills)
            → MCP (supabase)
      → Hook (PostToolUse: logging)
  → Aggregated Result
```

### Execution Principles:
1. **Topological ordering**: Dependencies resolved before execution
2. **Parallelization**: Independent operations run concurrently
3. **Error propagation**: Failures bubble up with context
4. **Token efficiency**: Shared context via @references
5. **Progressive depth**: Start shallow, go deeper as needed

## Component Comparison Table

| Aspect | Skills | Slash Cmds | Subagents | Hooks | CLAUDE.md | MCP |
|--------|--------|-----------|-----------|-------|-----------|-----|
| **Trigger** | Auto | Manual | Dispatched | Event | Always | Invoked |
| **Scope** | Global/Project | Global/Project | Ephemeral | Global/Project | Project | System |
| **Context** | Progressive | Full | Isolated | Current | Always | N/A |
| **Discovery** | Searchable | Listed | Created | Config | Root file | Config |
| **Reusable** | ✅ High | ✅ High | ⚠️ Medium | ✅ High | ❌ Low | ✅ High |
| **Composable** | ✅ Yes | ✅ Yes | ✅ Yes | ⚠️ Limited | ❌ No | ✅ Yes |
| **Testable** | ✅ w/Subagents | ✅ Direct | ✅ Direct | ⚠️ Complex | ⚠️ Manual | ✅ Direct |
| **Shareable** | ✅ Easy | ✅ Easy | ❌ No | ✅ Easy | ⚠️ Per-project | ✅ Easy |

## Integration Patterns Overview

Components can be integrated in multiple ways:

### 1. **Skills ↔ Slash Commands**
- Skills reference commands for specific operations
- Commands load skill context for workflows
- Commands with `!` execute scripts, output feeds skills

### 2. **Skills ↔ Subagents**
- Skills dispatch subagents for isolated tasks
- Subagents test skill behavior (TDD approach)
- REQUIRED SUB-SKILL pattern for dependencies

### 3. **Skills ↔ Hooks**
- Skills instruct when to use hooks
- Hooks validate skill requirements
- Event-driven skill activation

### 4. **Skills ↔ MCP**
- Skills leverage MCP tools for external data
- MCP enhances skill capabilities
- Skills wrap MCP complexity with workflows

### 5. **Skills ↔ Memory**
- Skills provide reusable patterns
- CLAUDE.md provides project context
- @references for cross-loading

### 6. **Multi-Level Orchestration**
- Slash command → Skill → Subagent → MCP
- Hook → Skill → Multiple subagents in parallel
- Skill → Multiple skills (sub-skill pattern)

**See**: `integration/` directory for detailed patterns on each integration type

## Real-World Orchestration Example

**Task**: Generate PDF report with data from Supabase and upload to S3

### Orchestration Chain:
```
User: "Generate quarterly report PDF"
  ↓
[Auto-triggers] pdf skill (description match)
  ↓
pdf skill → /orchestrate report-generation
  ↓
/orchestrate → Dispatches:
  ├→ Subagent 1: Data gathering
  │    └→ MCP (supabase): Execute queries
  │    └→ Skill (data-processing): Transform
  ├→ Subagent 2: PDF generation
  │    └→ Skill (pdf): Create document
  │    └→ scripts/generate_report.py
  └→ Subagent 3: Upload
       └→ MCP (s3): Upload file
  ↓
[PostToolUse Hook]: Log operation, notify team
  ↓
Result: PDF generated, uploaded, logged
```

**Token Efficiency**:
- Skills load progressively (only relevant portions)
- Subagents have isolated contexts (no cross-contamination)
- Scripts execute externally (only output in context)
- Hooks run without loading full skill content
- MCP tools invoked directly

## Key Design Principles

### 1. Progressive Disclosure
Load only what's needed, when needed. Never load entire skill libraries upfront.

### 2. Composability
Every component should work standalone and in combination. Avoid tight coupling.

### 3. Separation of Concerns
- Skills: Reusable patterns
- Commands: User operations
- Subagents: Task isolation
- Hooks: Event automation
- CLAUDE.md: Project context
- MCP: External services

### 4. Token Efficiency
Optimize for context window. Use @references, scripts, and lazy loading.

### 5. Testability
All components should be testable. Skills use subagent testing (TDD approach).

### 6. Discoverability
Agents should easily find relevant components through descriptions and metadata.

## Common Anti-Patterns

### ❌ Overloading CLAUDE.md
```
# Bad: Putting reusable patterns in CLAUDE.md
"When processing PDFs, always..."
→ This should be a skill
```

### ❌ Force-Loading with @
```
# Bad: Force-loading skills
@~/.claude/skills/pdf/SKILL.md
→ Use skill name reference only, let auto-discovery work
```

### ❌ Slash Commands for Auto-Workflows
```
# Bad: Manual command for auto-pattern
/check-for-tests  # Should be a skill that auto-triggers
→ Use skills for auto-discovery
```

### ❌ Skills for Project-Specific Rules
```
# Bad: Skill for project conventions
skill: our-team-code-style
→ Use CLAUDE.md for project-specific rules
```

### ❌ Complex Logic in Hooks
```
# Bad: Multi-step workflow in hook
if tool == 'Write':
  validate()
  transform()
  execute_workflow()
→ Hooks should be simple, dispatch to skills for complexity
```

## Next Steps

1. **Understand Skills Deeply** → Read `02-skills-overview.md`
2. **Learn to Create Skills** → Read `03-creating-skills-fundamentals.md`
3. **Study Integration Patterns** → Explore `integration/` directory
4. **See Real Examples** → Review `examples/` directory
5. **Master Code Intelligence** → Study `examples/code-intelligence/`

## References

- **Anthropic Skills Docs**: https://github.com/anthropics/skills
- **Claude Code Docs**: https://docs.claude.com/claude-code
- **MCP Documentation**: https://modelcontextprotocol.io
- **Installed Skills**: `~/.claude/skills/`
- **Slash Commands**: `~/.claude/commands/`

---

**Navigation**:
- [← README](../README.md)
- [Next: Skills Overview →](02-skills-overview.md)
