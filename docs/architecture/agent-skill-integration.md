# Agent-Skill-Command Integration Guide

**Purpose**: Comprehensive reference for understanding how agents, skills, slash commands, and templates integrate in the Intelligence Toolkit.

**Version**: 1.0.0
**Last Updated**: 2025-10-23

---

## Table of Contents

1. [Component Overview](#component-overview)
2. [Component × Template Usage Matrix](#component--template-usage-matrix)
3. [Agent → Skill → Command Call Chains](#agent--skill--command-call-chains)
4. [Workflow Diagrams](#workflow-diagrams)
5. [Integration Patterns](#integration-patterns)
6. [MCP Tool Integration](#mcp-tool-integration)

---

## Component Overview

The Intelligence Toolkit consists of 5 primary component types that work together:

### 1. Agents (4 total)

**Location**: `.claude/agents/`

| Agent | Role | Key Skills |
|-------|------|------------|
| **workflow-orchestrator** | Meta-agent routing to specialists | Coordinator (context allocation) |
| **code-analyzer** | Bug diagnosis & architecture analysis | analyze-code, debug-issues |
| **implementation-planner** | Spec → Plan transformation | create-implementation-plan, generate-tasks |
| **executor-implement-verify** | TDD implementation & AC verification | implement-and-verify |

### 2. Skills (10 core)

**Location**: `.claude/skills/`

Skills are auto-invoked workflows that Claude triggers based on description matching.

| Skill | Agent | Purpose |
|-------|-------|---------|
| **specify-feature** | Main context | Technology-agnostic specification creation |
| **clarify-specification** | Main context | Resolve ambiguities through Q&A |
| **create-implementation-plan** | implementation-planner | HOW planning with tech stack |
| **generate-tasks** | implementation-planner | User-story-organized task breakdown |
| **implement-and-verify** | executor-implement-verify | TDD implementation + AC verification |
| **analyze-code** | code-analyzer | Intelligence-first code analysis |
| **debug-issues** | code-analyzer | Systematic bug diagnosis |
| **create-plan** (legacy) | implementation-planner | Original planning skill |
| **define-product** | Main context | Product specification creation |
| **generate-constitution** | Main context | Constitutional article generation |

### 3. Slash Commands (7 core)

**Location**: `.claude/commands/`

All commands are SlashCommand tool compatible (YAML frontmatter with `description` field).

| Command | Expands To | Agent/Skill |
|---------|-----------|-------------|
| **/feature** | specify-feature skill | Main → auto-invokes /plan |
| **/plan** | create-implementation-plan skill | implementation-planner |
| **/tasks** | generate-tasks skill | implementation-planner (auto-invoked by /plan) |
| **/implement** | implement-and-verify skill | executor-implement-verify |
| **/verify** | Verification workflow | executor-implement-verify (auto-invoked by /implement) |
| **/analyze** | analyze-code skill | code-analyzer |
| **/bug** | debug-issues skill | code-analyzer |
| **/audit** | Cross-artifact validation | Main context (auto-invoked by /tasks) |

### 4. Templates (8 core)

**Location**: `.claude/templates/`

All templates use CoD^Σ traces for evidence-based reasoning.

| Template | Used By | Purpose |
|----------|---------|---------|
| **feature-spec.md** | specify-feature | Technology-agnostic requirements |
| **clarification-checklist.md** | clarify-specification | Ambiguity scanning |
| **plan.md** | create-implementation-plan | Implementation plan with constitutional gates |
| **tasks.md** | generate-tasks | User-story-organized tasks |
| **report.md** | analyze-code | Analysis reports |
| **bug-report.md** | debug-issues | Bug diagnosis |
| **verification-report.md** | implement-and-verify | AC verification results |
| **handover.md** | All agents | Agent-to-agent delegation (600 token limit) |

### 5. Shared Imports (2 core)

**Location**: `.claude/shared-imports/`

| Import | Purpose | Used By |
|--------|---------|---------|
| **CoD_Σ.md** | Chain of Density Sigma reasoning framework | All agents |
| **constitution.md** | 7-article architectural governance | All agents |

---

## Component × Template Usage Matrix

This matrix shows which components create or consume which templates:

| Template | Created By | Consumed By | Auto-Invoked |
|----------|-----------|-------------|--------------|
| **feature-spec.md** | specify-feature | create-implementation-plan, /audit | After /feature |
| **clarification-checklist.md** | clarify-specification | clarify-specification | As needed |
| **plan.md** | create-implementation-plan | implement-and-verify, /audit | Auto by /feature |
| **tasks.md** | generate-tasks | implement-and-verify, /audit | Auto by /plan |
| **report.md** | analyze-code | Main context, orchestrator | On /analyze |
| **bug-report.md** | debug-issues | Main context, orchestrator | On /bug |
| **verification-report.md** | implement-and-verify | Main context | Auto by /implement |
| **handover.md** | All agents | orchestrator, target agent | When blocked |

### Template Flow Through SDD Workflow

```
/feature (user)
    ↓ creates
feature-spec.md (specify-feature)
    ↓ auto-invokes /plan
plan.md (create-implementation-plan)
    ↓ auto-invokes generate-tasks
tasks.md (generate-tasks)
    ↓ auto-invokes /audit
audit-report.md (/audit)
    ↓ if PASS
/implement plan.md (user)
    ↓ creates per story
verification-report-P1.md, verification-report-P2.md, ...
```

---

## Agent → Skill → Command Call Chains

### Chain 1: Feature Development (Fully Automated)

**User Action**: `/feature "I want user authentication"`

```
User invokes: /feature
    ↓ expands to
specify-feature skill (main context)
    ↓ creates
specs/[number]-[name]/spec.md (feature-spec.md template)
    ↓ auto-invokes
/plan command
    ↓ expands to
create-implementation-plan skill
    ↓ delegates to
implementation-planner agent (Task tool)
    ↓ creates
plan.md, research.md, data-model.md (plan.md template)
    ↓ auto-invokes
generate-tasks skill (within planner agent)
    ↓ creates
tasks.md (tasks.md template)
    ↓ auto-invokes
/audit command
    ↓ expands to
Cross-artifact validation workflow
    ↓ creates
audit-report.md
    ↓ if PASS
Ready for /implement
```

**Total User Actions**: 1 (/feature)
**Total Auto-Invocations**: 3 (/plan, generate-tasks, /audit)
**Artifacts Created**: 6 files (spec.md, plan.md, research.md, data-model.md, tasks.md, audit-report.md)

### Chain 2: Implementation (Per-Story Verification)

**User Action**: `/implement plan.md`

```
User invokes: /implement plan.md
    ↓ expands to
implement-and-verify skill
    ↓ delegates to
executor-implement-verify agent (Task tool)
    ↓ for each story (P1, P2, P3...)
    ├─ Write tests for ACs (TDD)
    ├─ Implement minimal code
    ├─ Auto-invoke /verify --story P#
    │   ↓ expands to
    │   Verification workflow
    │   ↓ creates
    │   verification-report-P#.md (verification-report.md template)
    │   ↓ if PASS
    │   ✓ Story complete
    └─ Proceed to next story
```

**Total User Actions**: 1 (/implement)
**Total Auto-Invocations**: 1 per story (/verify --story P#)
**Artifacts Created**: N verification reports (1 per story)

### Chain 3: Bug Diagnosis

**User Action**: `/bug` or "This function is broken"

```
User describes bug OR invokes /bug
    ↓ triggers
debug-issues skill (auto-invoked or via /bug)
    ↓ delegates to
code-analyzer agent (Task tool)
    ↓ workflow
    ├─ Query project-intel.mjs (symbols, dependencies)
    ├─ Query MCP tools (Ref, Brave, Supabase) if needed
    ├─ Read targeted file sections
    ├─ Trace root cause with CoD^Σ
    └─ Create bug-report.md (bug-report.md template)
```

**Total User Actions**: 1 (/bug or description)
**Artifacts Created**: 1 file (bug-report.md)

### Chain 4: Code Analysis

**User Action**: `/analyze` or "Analyze the auth module"

```
User invokes /analyze OR describes analysis task
    ↓ triggers
analyze-code skill (auto-invoked or via /analyze)
    ↓ delegates to
code-analyzer agent (Task tool)
    ↓ workflow
    ├─ Query project-intel.mjs (overview, search, symbols)
    ├─ Query MCP tools (Ref, Supabase) if needed
    ├─ Read targeted file sections
    ├─ Analyze architecture with CoD^Σ
    └─ Create report.md (report.md template)
```

**Total User Actions**: 1 (/analyze or description)
**Artifacts Created**: 1 file (report.md)

---

## Workflow Diagrams

### Complete SDD Workflow (Specification-Driven Development)

```
┌─────────────────────────────────────────────────────────────────┐
│ Phase 1: Specification (WHAT/WHY)                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  User: /feature "I want user authentication"                    │
│    ↓                                                             │
│  specify-feature skill                                           │
│    ↓ creates                                                     │
│  specs/001-auth/spec.md (technology-agnostic)                   │
│    ↓                                                             │
│  [Clarification if needed via clarify-specification]            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
            ↓ automatic
┌─────────────────────────────────────────────────────────────────┐
│ Phase 2: Planning (HOW with Tech)                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  /plan command (auto-invoked by specify-feature)                │
│    ↓                                                             │
│  create-implementation-plan skill                                │
│    ↓ delegates to                                                │
│  implementation-planner agent                                    │
│    ↓ creates                                                     │
│  - plan.md (tech stack, architecture, user stories P1-P3)       │
│  - research.md (MCP query results)                              │
│  - data-model.md (schema, migrations, RLS)                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
            ↓ automatic
┌─────────────────────────────────────────────────────────────────┐
│ Phase 3: Task Breakdown                                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  generate-tasks skill (auto-invoked by planner)                 │
│    ↓ creates                                                     │
│  tasks.md (user-story-organized, Article VII compliant)         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
            ↓ automatic
┌─────────────────────────────────────────────────────────────────┐
│ Phase 4: Pre-Implementation Quality Gate                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  /audit command (auto-invoked by generate-tasks)                │
│    ↓ validates                                                   │
│  - Constitution compliance (Articles I-VII)                     │
│  - Requirement coverage (all FRs mapped to tasks)               │
│  - Ambiguity check (≤3 [NEEDS CLARIFICATION] markers)          │
│  - Consistency (spec ⇄ plan ⇄ tasks)                           │
│    ↓ creates                                                     │
│  audit-report.md                                                 │
│    ↓                                                             │
│  PASS? → Ready for /implement                                   │
│  FAIL? → Fix issues, re-run /audit                             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
            ↓ if PASS
┌─────────────────────────────────────────────────────────────────┐
│ Phase 5: Implementation (Progressive Delivery)                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  User: /implement plan.md                                        │
│    ↓                                                             │
│  implement-and-verify skill                                      │
│    ↓ delegates to                                                │
│  executor-implement-verify agent                                 │
│                                                                  │
│  For each story (P1 → P2 → P3):                                 │
│    ├─ Write tests for ACs FIRST                                 │
│    ├─ Implement minimal code to pass                            │
│    ├─ Auto-invoke /verify --story P#                            │
│    │   ↓ creates verification-report-P#.md                      │
│    └─ PASS? → Ship MVP / Continue to next story                 │
│                                                                  │
│  Result: Progressive delivery (P1=MVP, P2=Enhanced, P3=Full)    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Agent Delegation Flow

```
┌──────────────────────────────────────────────────────────┐
│                  workflow-orchestrator                    │
│                  (meta-agent routing)                     │
└──────────────────┬──────────────┬──────────────┬─────────┘
                   │              │              │
        ┌──────────┘              │              └──────────┐
        │                         │                         │
        ▼                         ▼                         ▼
┌──────────────┐         ┌──────────────┐        ┌──────────────┐
│code-analyzer │         │planner agent │        │executor agent│
└──────┬───────┘         └──────┬───────┘        └──────┬───────┘
       │                        │                        │
       ├─ analyze-code          ├─ create-plan           ├─ implement
       │  (intelligence-first)  │  (spec → plan)         │  (TDD + AC)
       │                        │                        │
       └─ debug-issues          └─ generate-tasks        └─ verify
          (symptom → root)          (plan → tasks)           (AC check)

Each agent:
- Imports constitution.md (7 articles)
- Imports CoD_Σ.md (reasoning framework)
- Uses project-intel.mjs FIRST
- Creates handover.md if blocked (≤600 tokens)
- References templates via @ syntax
```

### MCP Tool Coordination

```
                    ┌──────────────────────┐
                    │  User Task Request   │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │ workflow-orchestrator │
                    │  (MCP coordination)   │
                    └──────────┬───────────┘
                               │
            ┌──────────────────┼──────────────────┐
            │                  │                  │
            ▼                  ▼                  ▼
    ┌──────────────┐   ┌──────────────┐  ┌──────────────┐
    │code-analyzer │   │planner agent │  │executor agent│
    │              │   │              │  │              │
    │ MCP: Ref,    │   │ MCP: Ref,    │  │ MCP: None    │
    │ Brave,       │   │ Brave,       │  │ (uses plan)  │
    │ Supabase,    │   │ Supabase,    │  │              │
    │ Chrome       │   │ Shadcn,      │  │              │
    │              │   │ 21st-dev     │  │              │
    └──────────────┘   └──────────────┘  └──────────────┘

Orchestrator:
1. Identifies task type (bug, planning, implementation)
2. Routes to appropriate agent
3. Specifies which MCP tools to use in Task tool prompt
4. Agents make final MCP decisions based on findings
```

---

## Integration Patterns

### Pattern 1: Auto-Invocation Chain

**Description**: Skills automatically invoke subsequent slash commands to create complete workflows.

**Example**: `/feature` → `/plan` → generate-tasks → `/audit`

**Implementation**:
```markdown
# In specify-feature/SKILL.md

After spec.md is created, automatically invoke:
1. /plan command (SlashCommand tool)
2. Which triggers create-implementation-plan skill
3. Which invokes generate-tasks skill
4. Which invokes /audit command
```

**Benefits**:
- User performs 1 action, gets 6 artifacts
- Consistent workflow enforcement
- Automatic quality gates

### Pattern 2: Agent Delegation with Isolated Context

**Description**: Orchestrator delegates tasks to specialist agents using Task tool with isolated context.

**Example**: Delegating bug analysis to code-analyzer

**Implementation**:
```python
Task(
    subagent_type="code-analyzer",
    description="Analyze payment processing performance",
    prompt="""
    @.claude/agents/code-analyzer.md

    [Task details with MCP guidance]
    """
)
```

**Benefits**:
- Isolated context prevents pollution
- Specialist expertise applied
- Handover protocol for blocking scenarios

### Pattern 3: Template-Driven Consistency

**Description**: All outputs use standardized templates with @ imports for consistent structure.

**Example**: All agents import templates at the top

**Implementation**:
```markdown
# In agent file
**Templates:**
@.claude/templates/report.md
@.claude/templates/bug-report.md
```

**Benefits**:
- Consistent output structure
- CoD^Σ traces enforced
- Easy to update centrally

### Pattern 4: Progressive Disclosure

**Description**: Skills reference detailed content in separate files, loaded only when needed.

**Example**: specify-feature/SKILL.md references additional guides

**Implementation**:
```markdown
# In SKILL.md
**Basic usage**: [instructions in SKILL.md]
**Advanced features**: See [advanced.md](advanced.md)
**API reference**: See [reference.md](reference.md)
```

**Benefits**:
- Main SKILL.md stays under 500 lines
- Token efficiency (load only what's needed)
- Clear organization

### Pattern 5: Constitutional Compliance

**Description**: All agents import and enforce constitutional articles.

**Example**: All agents reference constitution.md

**Implementation**:
```markdown
# In agent file
**Reasoning Framework:**
@.claude/shared-imports/CoD_Σ.md
@.claude/shared-imports/constitution.md
```

**Benefits**:
- Consistent governance across agents
- Automatic enforcement of 7 articles
- Centralized updates

---

## MCP Tool Integration

### MCP Tool Matrix by Agent

| Agent | Primary MCP Tools | Use Cases |
|-------|-------------------|-----------|
| **code-analyzer** | Ref, Brave, Supabase, Chrome | Library docs, error search, DB schema, browser debugging |
| **implementation-planner** | Ref, Brave, Supabase, Shadcn, 21st-dev | Framework research, patterns, DB design, components, UI patterns |
| **executor-implement-verify** | None (uses plan) | Implementation doesn't need MCP (all info in plan.md) |
| **workflow-orchestrator** | None (coordinates only) | Routes tasks and specifies which MCP tools agents should use |

### MCP Decision Flow

```
1. project-intel.mjs queries (ALWAYS FIRST)
   ↓ Get codebase intelligence

2. Identify knowledge gaps
   ↓ What external info is needed?

3. Choose MCP tool based on gap type:
   - Library/framework API → Ref MCP
   - Error messages/patterns → Brave MCP
   - Database schema/RLS → Supabase MCP
   - UI components → Shadcn MCP
   - Design patterns → 21st-dev MCP
   - Browser/E2E testing → Chrome MCP

4. Execute MCP queries and save to research.md
   ↓ Document sources

5. Use MCP results in analysis/planning
   ↓ Evidence-based decisions
```

### Integration Example: Planning with MCP

```
User: /feature "Multi-tenant SaaS with team management"
    ↓
specify-feature creates spec.md
    ↓ auto-invokes /plan
create-implementation-plan skill
    ↓ delegates to implementation-planner agent
    ↓
Agent workflow:
1. project-intel.mjs --overview (existing patterns)
2. Supabase MCP: Query existing schema
3. Ref MCP: Next.js multi-tenancy patterns
4. Brave MCP: Multi-tenant architecture best practices
5. Shadcn MCP: Team management UI components
6. Synthesize findings → plan.md, research.md, data-model.md
```

---

## Summary

### Key Integration Points

1. **Automatic Workflow Progression**: `/feature` → `/plan` → tasks → `/audit` (4 artifacts)
2. **Agent Specialization**: Each agent has specific skills and MCP tools
3. **Template Consistency**: All outputs use standardized templates with CoD^Σ
4. **Constitutional Governance**: All agents enforce 7 articles automatically
5. **Intelligence-First**: project-intel.mjs before MCP before file reads (80%+ token savings)
6. **Progressive Delivery**: Article VII enforced by per-story verification

### Integration Success Metrics

- **Auto-invocation rate**: 90%+ of workflow steps happen automatically
- **Template compliance**: 100% of outputs use templates
- **Token efficiency**: 80%+ savings via intelligence-first architecture
- **Constitutional adherence**: 100% of agents enforce all 7 articles
- **MCP precision**: MCP tools used only when external/authoritative info needed

---

**Last Updated**: 2025-10-23
**Related Documentation**:
- System Overview: @docs/architecture/system-overview.md
- CoD^Σ Framework: @docs/architecture/cod-sigma-framework.md
- Constitution: @.claude/shared-imports/constitution.md
