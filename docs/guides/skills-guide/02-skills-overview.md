# Skills Overview

**Target Audience**: AI coding agents
**Purpose**: Deep understanding of skills as SOPs within the orchestration system

## What Are Skills?

Skills are **Standard Operating Procedures (SOPs)** for AI coding agents. They are automatically discovered, progressively loaded, and provide domain-specific workflows, patterns, and knowledge that no language model inherently possesses.

Think of skills as "onboarding documentation" that transforms a general-purpose Claude agent into a specialized expert in specific domains.

### Key Characteristics

1. **Auto-Discovered**: Agents find skills through description matching
2. **Progressively Loaded**: Metadata → Instructions → Resources (on demand)
3. **Reusable**: Apply across multiple projects and contexts
4. **Testable**: Validated using subagent testing (TDD for docs)
5. **Shareable**: Easily distributed via directories, plugins, or git
6. **Composable**: Can reference other skills and components

## Skills vs Other Components

### Skills vs Slash Commands

| Aspect | Skills | Slash Commands |
|--------|--------|---------------|
| **Invocation** | Automatic (model decides) | Manual (user types) |
| **Discovery** | Description matching | Listed in `/help` |
| **Parameters** | Inferred from context | Explicit `$1`, `$2` |
| **Use Case** | Repeatable workflows | Deterministic operations |
| **Loading** | Progressive | Full on invocation |

**Example**:
- **Skill**: `pdf` - Auto-loads when task involves PDF processing
- **Command**: `/commit` - User explicitly requests git commit

### Skills vs Subagents

| Aspect | Skills | Subagents |
|--------|--------|-----------|
| **Purpose** | Capability extension | Task isolation |
| **Context** | Shared (progressive) | Isolated (fresh) |
| **Persistence** | Reusable documentation | Ephemeral execution |
| **Testing** | Subagents test skills | Skills dispatch subagents |
| **Composition** | References other skills | Receives isolated instructions |

**Relationship**: Skills orchestrate subagents for isolated tasks

### Skills vs Hooks

| Aspect | Skills | Hooks |
|--------|--------|-------|
| **Trigger** | Task type match | Tool invocation event |
| **Scope** | Domain workflows | Event automation |
| **Complexity** | Can be extensive | Should be simple |
| **Async** | Synchronous execution | Event-driven |

**Relationship**: Skills can instruct hook usage; hooks can trigger skills

### Skills vs CLAUDE.md

| Aspect | Skills | CLAUDE.md |
|--------|--------|-----------|
| **Scope** | Reusable patterns | Project-specific |
| **Distribution** | User/project-agnostic | Single project |
| **Loading** | Progressive | Always full |
| **Purpose** | Technique/workflow | Context/conventions |
| **Shareable** | Highly | Low |

**Relationship**: CLAUDE.md provides project context; skills provide reusable workflows

### Skills vs MCP

| Aspect | Skills | MCP |
|--------|--------|-----|
| **Nature** | Documentation/workflow | Tool integration |
| **Execution** | Instructions to agent | External operations |
| **Purpose** | How to do things | Access to external services |
| **Complexity** | Can wrap MCP usage | Atomic operations |

**Relationship**: Skills orchestrate MCP tools into workflows

## Skill Types

### 1. Technique Skills

**Purpose**: Step-by-step procedures for specific operations

**Characteristics**:
- Clear sequential steps
- Decision points with criteria
- Error handling guidance
- Success verification

**Examples**:
- `condition-based-waiting`: Polling patterns instead of timeouts
- `root-cause-tracing`: Systematic debugging approach
- `defensive-programming`: Error handling patterns

**Structure**:
```
## Overview
Core principle + when to use

## The Process
Step-by-step workflow with decision points

## Implementation
Code examples and patterns

## Common Mistakes
What goes wrong + fixes
```

### 2. Pattern Skills

**Purpose**: Mental models and architectural approaches

**Characteristics**:
- Conceptual frameworks
- When/why to apply
- Trade-offs and alternatives
- Recognition criteria

**Examples**:
- `flatten-with-flags`: Data structure simplification
- `reducing-complexity`: Architectural simplification
- `information-hiding`: Encapsulation principles

**Structure**:
```
## Overview
Core principle + underlying philosophy

## When to Use
Recognition criteria + counter-examples

## Core Pattern
Before/after transformation

## Trade-offs
Costs and benefits
```

### 3. Reference Skills

**Purpose**: Documentation, APIs, and command references

**Characteristics**:
- Comprehensive coverage
- Searchable structure
- Quick reference tables
- Heavy references in separate files

**Examples**:
- `pdf`: PDF processing toolkit documentation
- `xlsx`: Spreadsheet manipulation reference
- `pptx`: Presentation creation guide
- `mcp-builder`: MCP server development docs

**Structure**:
```
## Quick Start
Minimal working example

## Reference
Comprehensive API/command coverage
(often in separate reference files)

## Examples
Real-world use cases

## Decision Trees
Which approach for which scenario
```

### 4. Discipline-Enforcing Skills

**Purpose**: Enforce processes and quality standards

**Characteristics**:
- **Explicit rules with "no exceptions"**
- Rationalization tables (common excuses + rebuttals)
- Red flags lists
- Pressure-tested with subagents

**Examples**:
- `test-driven-development`: TDD workflow enforcement
- `writing-skills`: TDD for documentation
- `verification-before-completion`: Quality checks

**Structure**:
```
## Overview
Core principle + "violating letter = violating spirit"

## The Iron Law
The rule with no exceptions

## Red Flags
Warning signs of violation

## Rationalization Table
| Excuse | Reality |
Common rationalizations + counters

## Process
Step-by-step with checkpoints
```

**Critical**: These skills must be **bulletproofed against rationalization** through iterative testing with subagents under pressure.

## Progressive Disclosure in Skills

Skills use a three-level loading strategy:

### Level 1: Metadata (Always in Context)

**Location**: YAML frontmatter in SKILL.md

```yaml
---
name: skill-name-here
description: Use when [triggering conditions] - [what it does, third person]
---
```

**Content**:
- `name`: Kebab-case identifier (letters, numbers, hyphens only)
- `description`: Third-person, includes triggers and purpose (<500 chars)

**Token Cost**: ~50-100 tokens per skill

**Purpose**: Agent knows skill exists and when to load it

### Level 2: Instructions (Loaded on Match)

**Location**: Main body of SKILL.md

**Content**:
- Overview and core principles
- Workflows and decision trees
- Key patterns and examples (inline)
- References to Level 3 resources

**Token Cost**: 200-2000 tokens depending on complexity

**Purpose**: Agent can execute the workflow

**Guidelines**:
- Keep concise (prefer tables over prose)
- Inline simple examples (<50 lines)
- Link to external files for heavy content
- Use cross-references to other skills

### Level 3: Resources (Loaded on Reference)

**Location**: Separate files in skill directory

**Scripts** (`scripts/`):
- Executed externally, only output loaded
- Deterministic operations (validation, transformation)
- Zero tokens until executed

**References** (`references/`):
- Loaded via @reference when needed
- API docs, comprehensive examples
- Long-form documentation

**Assets** (`assets/`):
- Templates, images, data files
- Loaded when explicitly needed

**Token Cost**: Variable, only when accessed

**Purpose**: Heavy content loaded lazily

### Example Flow

```
Task: "Extract fields from this PDF form"
  ↓
Level 1: Agent scans all skill descriptions
  → Finds "pdf" skill (matches "PDF" + "form")
  → Cost: 50 tokens

Level 2: Agent loads pdf skill SKILL.md
  → Reads workflow section
  → Finds script reference: scripts/extract_form_field_info.py
  → Cost: 500 tokens

Level 3: Agent executes script
  → Runs extract_form_field_info.py on PDF
  → Reads only output (JSON with field data)
  → Cost: 200 tokens (output only, not script source)

Optional: If needs OOXML details
  → @references/ooxml.md (loaded only if needed)
  → Cost: 2000 tokens

Total: 750 tokens (or 2750 if reference needed)
vs 3000+ if everything loaded upfront
```

## Skill Discovery Process

How agents find and use skills:

### Step 1: Task Analysis
```
Agent receives: "Help me generate a PDF report"
  → Identifies keywords: "generate", "PDF", "report"
  → Identifies task type: Document generation
```

### Step 2: Description Matching
```
Agent scans skill descriptions (Level 1):
  - pdf: "...PDF manipulation toolkit..."  ✅ Match
  - xlsx: "...spreadsheets..."             ❌
  - docx: "...Word documents..."           ❌
  - algorithmic-art: "...generative art..." ❌
```

### Step 3: Relevance Scoring
```
pdf skill description:
"Comprehensive PDF manipulation toolkit for extracting text and
tables, creating new PDFs, merging/splitting documents, and
handling forms. When Claude needs to fill in a PDF form or
programmatically process, generate, or analyze PDF documents..."

Match score: HIGH
- "PDF" → Direct match
- "generate" → Mentioned in description
- "report" → Covered by "creating new PDFs"
```

### Step 4: Load Instructions
```
Agent loads pdf SKILL.md (Level 2)
  → Reads ## Creating New PDF section
  → Finds recommended approach
  → Notes available scripts
```

### Step 5: Execute Workflow
```
Agent follows skill instructions:
  1. Decides on library (pdf-lib vs pypdf)
  2. Structures PDF generation
  3. May execute scripts if needed
  4. May @reference documentation if complex
```

### Optimization: Claude Search Optimization (CSO)

Skills must be optimized for discovery:

**Good Description**:
```yaml
description: Use when tests have race conditions, timing dependencies,
  or pass/fail inconsistently - replaces arbitrary timeouts with
  condition polling for reliable async tests
```
✅ Keywords: "race conditions", "timing", "async tests", "flaky"
✅ Symptoms: "pass/fail inconsistently"
✅ Solution: "condition polling"

**Bad Description**:
```yaml
description: For async testing
```
❌ Too vague
❌ No triggering conditions
❌ Missing searchable terms

**See**: `03-creating-skills-fundamentals.md` for CSO best practices

## Skill Composition Patterns

Skills can reference and compose with other skills:

### 1. REQUIRED SUB-SKILL Pattern

```markdown
## Phase 4: Worktree Setup

**REQUIRED SUB-SKILL:** Use using-git-worktrees

Follow that skill's process for directory selection and setup.
Return here when worktree ready.
```

**Purpose**: Explicit dependency, agent knows to load other skill

**Note**: Use skill name only, NOT @path (avoids force-loading)

### 2. Optional Reference Pattern

```markdown
## Advanced Usage

For complex forms, see form-processing-advanced skill for
additional patterns.
```

**Purpose**: Suggests related skill without requiring it

### 3. Conditional Dispatch Pattern

```markdown
## Implementation Path

If using Next.js:
  Use nextjs-routing skill for route setup

If using React Router:
  Use react-router-patterns skill
```

**Purpose**: Context-dependent skill selection

### 4. Subagent Dispatch Pattern

```markdown
## Phase 2: Research

Dispatch subagent with research-analyst skill:
  - Query: [user's technical question]
  - Focus: [specific domain]
  - Output: Synthesis document
```

**Purpose**: Skill orchestrates subagent with another skill

### 5. Sequential Workflow Pattern

```markdown
## Complete Workflow

1. **Design Phase**
   Use brainstorming skill → produces design

2. **Worktree Setup**
   Use using-git-worktrees → isolated workspace

3. **Planning Phase**
   Use writing-plans skill → implementation plan

4. **Execution Phase**
   Use executing-plans skill → implementation
```

**Purpose**: Multi-skill orchestration sequence

## Skill Testing Philosophy

Skills are **documented processes** and must be tested like code:

### TDD for Documentation

**Core Principle**: If you didn't watch an agent fail without the skill, you don't know if the skill teaches the right thing.

**Process** (from `writing-skills`):

1. **RED**: Write pressure scenarios, run WITHOUT skill
   - Document exact rationalizations (verbatim)
   - Identify violation patterns

2. **GREEN**: Write minimal skill addressing those violations
   - Add explicit counters to rationalizations
   - Re-test, verify agents now comply

3. **REFACTOR**: Close loopholes iteratively
   - Find new rationalizations
   - Add to rationalization table
   - Build red flags list

### Pressure Testing

**Technique Skills**: Apply to new scenarios, check gaps

**Discipline Skills**: Combine pressures:
- Time pressure ("it's urgent")
- Sunk cost ("already wrote the code")
- Authority ("I know this is right")
- Exhaustion ("just this once")

**Pattern Skills**: Recognition and counter-example tests

**Reference Skills**: Retrieval and application tests

**See**: `advanced/skill-testing-methodology.md` for complete methodology

## Common Skill Patterns

### Documentation Workflow Skill

```markdown
---
name: api-documentation-workflow
description: Use when documenting APIs - ensures consistency...
---

## Overview
[Process description]

## Workflow
1. Extract API signatures
2. Document parameters
3. Add examples
4. Validate completeness

## Templates
See references/api-doc-template.md
```

### Tool Wrapper Skill

```markdown
---
name: pdf-processing
description: Use when working with PDF files...
---

## Decision Tree
Choose path based on operation type

## Scripts
- extract_text.py: Text extraction
- fill_form.py: Form filling
- merge_pdf.py: Document merging

## Reference
See references/pdf-lib-api.md for complete API
```

### Process Enforcement Skill

```markdown
---
name: test-driven-development
description: Use when implementing features or bugfixes...
---

## The Iron Law
Write test first. Watch it fail. Write minimal code.

## Red Flags
- Code before test
- "I'll test after"
- "Too simple to test"

## Rationalization Table
| Excuse | Reality |
| "It's obvious" | Obvious code breaks. Test takes 30 sec. |
```

### Orchestration Skill

```markdown
---
name: brainstorming
description: Use when creating or developing anything...
---

## Phase 1: Understanding
[Gather context]

## Phase 2: Exploration
[Generate alternatives]

## Phase 3: Design
[Present in sections]

## Phase 4: Worktree Setup
**REQUIRED SUB-SKILL:** Use using-git-worktrees

## Phase 5: Planning
**REQUIRED SUB-SKILL:** Use writing-plans
```

## Real-World Skill Examples

### Example 1: `test-driven-development`

**Type**: Discipline-enforcing
**Pattern**: Process enforcement with rationalization table

**Key Features**:
- Explicit Iron Law: "No code without test first"
- Comprehensive rationalization table
- Red flags list
- Pressure-tested to be bulletproof

**Structure**:
- Single SKILL.md (self-contained)
- ~1000 words
- High token efficiency

### Example 2: `writing-skills`

**Type**: Meta-skill (TDD for documentation)
**Pattern**: Orchestration + discipline + subagent testing

**Key Features**:
- Maps TDD concepts to skill creation
- Requires `test-driven-development` background
- Dispatches subagents for pressure testing
- Includes CSO (Claude Search Optimization) guide

**Structure**:
- Single SKILL.md
- References `test-driven-development` and `testing-skills-with-subagents`
- ~3000 words

### Example 3: `pdf`

**Type**: Reference + technique
**Pattern**: Heavy reference files, executable scripts

**Key Features**:
- Decision trees for different operations
- Multiple scripts for common tasks
- Extensive API documentation in references/
- Progressive disclosure (overview → scripts → API docs)

**Structure**:
- SKILL.md (~1000 words)
- scripts/ directory (10+ Python scripts)
- references/ (optional heavy docs)

### Example 4: `brainstorming`

**Type**: Orchestration workflow
**Pattern**: Multi-phase with sub-skill dispatch

**Key Features**:
- Structured 5-phase workflow
- Dispatches `using-git-worktrees` and `writing-plans`
- Uses AskUserQuestion tool for structured choices
- Allows backward iteration

**Structure**:
- Single SKILL.md
- Sub-skill references (not @includes)
- ~1200 words

## Anti-Patterns to Avoid

### ❌ Narrative Documentation

```markdown
# Bad: Story-telling
In session 2024-10-03, we discovered that empty projectDir
caused the build to fail. We fixed it by adding a check...
```
→ **Use**: Generalized pattern without session narrative

### ❌ Multi-Language Dilution

```
scripts/
  example.js
  example.py
  example.go
  example.rs
```
→ **Use**: One excellent example in most relevant language

### ❌ Force-Loading Dependencies

```markdown
# Bad
Read @~/.claude/skills/other-skill/SKILL.md for background
```
→ **Use**: "Use other-skill" or "REQUIRED SUB-SKILL: other-skill"

### ❌ Project-Specific Content

```markdown
# Bad skill
---
name: our-team-conventions
---
In our codebase, always use camelCase...
```
→ **Use**: CLAUDE.md for project-specific rules

### ❌ Untested Skills

```markdown
# Bad
[Writes skill, deploys without testing]
```
→ **Use**: TDD approach (RED-GREEN-REFACTOR with subagent testing)

## Skill Lifecycle

### 1. Creation
- Identify reusable pattern
- Run baseline tests (RED)
- Write minimal skill (GREEN)
- Close loopholes (REFACTOR)

### 2. Deployment
- User-level: `~/.claude/skills/`
- Project-level: `.claude/skills/`
- Plugin: Bundled with other skills

### 3. Discovery
- Auto-loaded via description matching
- CSO ensures findability

### 4. Maintenance
- Update based on real usage
- Re-test after changes
- Close new rationalization loopholes

### 5. Sharing
- Git repository
- Plugin distribution
- Anthropic skills repo (PR)

## Next Steps

1. **Learn to Create Skills** → Read `03-creating-skills-fundamentals.md`
2. **Study Code Intelligence** → Explore `examples/code-intelligence/`
3. **Review Integration Patterns** → Browse `integration/` directory
4. **See Real Examples** → Examine `~/.claude/skills/`
5. **Understand Testing** → Read `advanced/skill-testing-methodology.md`

## References

- **Anthropic Skills Best Practices**: `~/.claude/skills/skill-creator/anthropic-best-practices.md`
- **Writing Skills (TDD for Docs)**: `~/.claude/skills/writing-skills/SKILL.md`
- **Test-Driven Development**: `~/.claude/skills/test-driven-development/SKILL.md`
- **Real Skills**: `~/.claude/skills/*/SKILL.md`

---

**Navigation**:
- [← Orchestration System](01-orchestration-system.md)
- [Next: Creating Skills Fundamentals →](03-creating-skills-fundamentals.md)
