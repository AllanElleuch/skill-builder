# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

This is the **Claude Code Intelligence Toolkit** - a meta-system for building intelligence-first AI agent workflows. It's a development framework for creating skills, agents, slash commands, and SOPs that work with Claude Code.

**Core Innovation:** Intelligence-first architecture that queries lightweight indexes (project-intel.mjs, MCP tools) before reading full files, achieving 80%+ token savings.

---

## Architecture

**Complete System Architecture**: @docs/architecture/system-overview.md

### Quick Component Reference

1. **Agents** (.claude/agents/) - Specialized subagents: orchestrator, code-analyzer, planner, executor

2. **Skills** (.claude/skills/) - Auto-invoked workflows: analyze-code, debug-issues, create-plan, implement-and-verify

3. **Slash Commands** (.claude/commands/) - User-facing triggers (all SlashCommand tool compatible): /analyze, /bug, /feature, /plan, /implement, /verify, /audit

4. **Templates** (.claude/templates/) - Structured outputs (22 templates: 4 bootstrap + 18 workflow, all use CoD^Σ traces)

5. **Shared Imports** (.claude/shared-imports/) - Core frameworks: CoD_Σ.md, project-intel-mjs-guide.md

**See @docs/architecture/system-overview.md for**:
- Complete dependency graphs (@ imports, data flow, call dependencies)
- Detailed process flows for all 5 workflows
- System hierarchy diagrams
- Token efficiency architecture (80%+ savings)
- End-to-end implementation examples
- System invariants and quality gates

---

## Intelligence-First Workflow

**Critical Pattern:** Always query intelligence sources BEFORE reading full files:

```
1. project-intel.mjs queries (symbols, dependencies, search)
2. MCP tool queries (library docs, DB schema)
3. Read targeted file sections only
```

### Why This Matters
- **Token Efficiency:** 1-2% of tokens vs reading full files
- **Faster Analysis:** Get exactly what you need
- **Better Context:** More room for reasoning

### Example Workflow
```bash
# 1. Get project overview (always do this first in new session)
project-intel.mjs --overview --json

# 2. Search for relevant files
project-intel.mjs --search "auth" --type tsx --json

# 3. Get symbols from candidate files
project-intel.mjs --symbols src/auth/login.tsx --json

# 4. Trace dependencies if needed
project-intel.mjs --dependencies src/auth/login.tsx --direction downstream --json

# 5. NOW read specific files with context
Read src/auth/login.tsx  # Only after intel queries
```

---

## Development Workflows

### Creating New Skills
1. Study the guide: `docs/guides/developing-agent-skills.md`
2. Follow SKILL.md structure: YAML frontmatter + instructions
3. Create supporting scripts in `scripts/`, references in `references/`
4. Progressive disclosure: metadata → instructions → resources
5. Skill templates will be created as specific patterns are validated

### Creating New Agents
1. Start with orchestrator routing rules (.claude/agents/orchestrator.md)
2. Create agent file with YAML frontmatter and persona
3. Import relevant templates via @ syntax (e.g., @.claude/templates/report.md)
4. Reference relevant skills (e.g., @.claude/skills/analyze-code/SKILL.md)
5. Define coordination workflow using CoD^Σ operators

### Creating New Slash Commands
1. Create .md file in .claude/commands/ with YAML frontmatter
2. Include `description` field for SlashCommand tool integration
3. Add `allowed-tools` for tool permission control
4. Use `!` prefix for bash pre-execution
5. Command expands to full prompt when invoked
6. Can be invoked by agents/skills via SlashCommand tool

### Bootstrapping New Projects
Use the 4 bootstrap templates to quickly set up a new project:

```bash
# Copy bootstrap templates to project root
cp .claude/templates/planning-template.md planning.md
cp .claude/templates/todo-template.md todo.md
cp .claude/templates/event-stream-template.md event-stream.md
cp .claude/templates/workbook-template.md workbook.md
```

**Templates**:
- **planning-template.md** (8.8 KB) - Master plan with architecture (CoD^Σ), components, phases
- **todo-template.md** (5.4 KB) - Task tracking with acceptance criteria and phase organization
- **event-stream-template.md** (3.6 KB) - Chronological event logging with CoD^Σ compression
- **workbook-template.md** (7.1 KB) - Context notepad for active sessions (300-line limit)

**See**: @.claude/templates/BOOTSTRAP_GUIDE.md for complete bootstrap guide
**See**: @.claude/templates/README.md for all templates reference

---

## Chain of Density Σ (CoD^Σ) Reasoning

All analysis, planning, and implementation MUST include CoD^Σ traces with evidence.

### Composition Operators
- `⊕` Direct Sum - parallel composition
- `∘` Function Composition - sequential pipeline
- `→` Delegation - handover
- `≫` Transformation - data reshaping
- `⇄` Bidirectional - iterative exchange
- `∥` Parallel - simultaneous execution

### Evidence Requirements
Every claim needs traceable evidence:
- File:line references (e.g., `ComponentA.tsx:45`)
- MCP query results
- project-intel.mjs output
- Test output or logs

**Bad:** "The component re-renders because of state"
**Good:** "Component re-renders due to useEffect([state]) at ComponentA.tsx:45 causing state mutation at ComponentA.tsx:52"

---

## File Organization

```
.claude/
├── agents/           # Subagent definitions with @ imports
├── commands/         # Slash command definitions (complete prompts)
├── skills/           # SKILL.md workflow files (auto-invoked by Claude)
├── templates/        # Structured output templates (referenced via @)
└── shared-imports/   # Core frameworks (CoD_Σ.md, project-intel-mjs-guide.md)
```

**Generated Files** (created by skills in project root or designated folders):
All follow timestamp naming: `YYYYMMDD-HHMM-{type}-{id}.md`

Examples:
- `20250119-1430-report-bug-auth-loop.md` - Analysis report
- `20250119-1445-plan-implement-2fa.md` - Implementation plan
- `20250119-1502-verification-task-5.md` - AC verification report
- `20250119-1520-handover-analyzer-to-planner.md` - Agent handover
- `20250119-1530-bug-checkout-error.md` - Bug report
- `20250119-1545-feature-spec-oauth.md` - Feature specification

---

## MCP Tools Available

This project is configured to use several MCP servers (.mcp.json):

- **Ref** - Query library documentation (React, Next.js, etc.)
- **Supabase** - Database schema, RLS policies, edge functions
- **Shadcn** - Component search and installation
- **Chrome** - Browser automation, E2E testing
- **Brave** - Web search
- **21st-dev** - Design ideation and inspiration

Use MCP queries for authoritative external information before making assumptions.

---

## Documentation Structure

Key documentation files:
- `planning.md` - Complete system architecture and deliverables
- `docs/guides/developing-agent-skills.md` - Comprehensive skill creation guide
- `docs/guides/skills-guide/` - Multi-part skills development guide
- `docs/reference/claude-code-docs/` - Claude Code feature documentation

---

## Common Patterns

### When to Use What
- **Skill (SKILL.md)** - Comprehensive workflow documentation that Claude auto-invokes (e.g., analyze-code skill for intel-first analysis)
- **Agent** - Specialized subagent with isolated context for routing workflows (e.g., code-analyzer agent routes to analyze-code or debug-issues skills)
- **Slash Command** - User-triggered workflow that expands to complete prompt invoking skills (e.g., /analyze invokes analyze-code skill)
- **Template** - Structured output format ensuring consistency (e.g., bug-report.md template for bug diagnosis output)
- **Shared Import** - Core framework imported via @ syntax (e.g., CoD_Σ.md for reasoning, project-intel-mjs-guide.md for intelligence queries)

### SDD Workflow Order

The Specification-Driven Development workflow is **highly automated** - users perform 2 manual steps, the rest happens automatically:

#### User Actions (Manual)
1. **/feature** - Create technology-agnostic specification (spec.md)
2. **/implement** - Execute implementation with test-first approach

#### Automatic Workflow (No User Action Required)

**After /feature**:
- specify-feature skill **automatically invokes** `/plan`
- create-implementation-plan skill **automatically invokes** generate-tasks skill
- generate-tasks skill **automatically invokes** `/audit`
- Workflow progression: `/feature` → `/plan` → `/tasks` → `/audit` → ready for `/implement`

**After /implement (per story)**:
- implement-and-verify skill **automatically invokes** `/verify --story P1`, `/verify --story P2`, etc.
- Each story verified independently before proceeding to next
- Progressive delivery: P1 verified → ship MVP → P2 verified → ship enhancement

#### Complete Flow

```
User: /feature "I want user authentication"
    ↓ (automatic)
specify-feature skill creates spec.md
    ↓ (automatic - invokes /plan)
create-implementation-plan skill creates plan.md, research.md, data-model.md
    ↓ (automatic - invokes generate-tasks)
generate-tasks skill creates tasks.md
    ↓ (automatic - invokes /audit)
/audit validates consistency
    ↓ (if PASS)
Ready for /implement
    ↓
User: /implement plan.md
    ↓ (automatic per story)
implement-and-verify skill implements P1 → invokes /verify --story P1
    ↓ (if PASS)
implement-and-verify skill implements P2 → invokes /verify --story P2
    ↓ (if PASS)
Complete implementation verified
```

**Key Quality Gates**:
1. **Pre-Implementation**: `/audit` runs AFTER task generation but BEFORE implementation to catch:
   - Constitution violations (always CRITICAL)
   - Missing requirement coverage
   - Ambiguities and underspecification
   - Duplications and inconsistencies
   - Terminology drift across artifacts

2. **Progressive Delivery**: `/verify --story <id>` runs AFTER each story to catch:
   - Story-specific test failures
   - Dependencies on incomplete stories
   - Independent demo failures
   - Prevents moving to next story until current story passes

### Best Practices
1. **Always import CoD_Σ.md** in agents - ensures rigorous reasoning traces
2. **Use templates** - consistency and token efficiency for all outputs
3. **Query intel first** - never read files before querying project-intel.mjs
4. **Reference templates** - use @ syntax to import templates (e.g., @.claude/templates/report.md)
5. **File evidence** - every claim needs file:line or MCP source
6. **Invoke skills** - let skills handle workflows, don't reinvent processes

---

## Troubleshooting

### Issue: Agent reads full files instead of using intel
**Solution:** Verify agent invokes the correct skill (analyze-code or debug-issues) which enforce intel-first approach. Check that project-intel.mjs is available and indexed. Review @.claude/shared-imports/project-intel-mjs-guide.md.

### Issue: Claims without evidence
**Solution:** Verify CoD^Σ trace exists with file:line or MCP sources. Review @.claude/shared-imports/CoD_Σ.md for reasoning patterns. Ensure skills are being used (they enforce evidence requirements).

### Issue: Token usage too high
**Solution:** Use analyze-code or debug-issues skills which enforce intel queries BEFORE reading files. Verify project-intel.mjs queries are executed first. Check skill workflow is being followed.

### Issue: Skills not triggering
**Solution:** Check SKILL.md description contains trigger phrases. Verify skill is in .claude/skills/ with correct YAML frontmatter. Skills are auto-invoked based on description matching task context.

### Issue: Templates not being used
**Solution:** Verify agents and slash commands reference templates via @ syntax. Check @.claude/templates/ directory. Skills enforce template usage in their workflows.
