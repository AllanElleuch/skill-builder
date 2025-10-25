# Component Relationship Analysis - Tree of Thought

**Generated**: 2025-10-25
**Purpose**: Comprehensive mapping of component relationships across all major workflows
**Version**: 1.0

---

## Overview

This document provides deep recursive tree-of-thought diagrams showing how skills, slash commands, subagents, templates, hooks, and shared imports interact across all major workflows in the Intelligence Toolkit.

**Legend**:
- `→` Invokes/calls
- `├─>` Direct dependency
- `└─>` Terminal dependency
- `⊕` Parallel composition
- `∘` Sequential composition
- `[auto]` Automatically invoked
- `[manual]` User-triggered

---

## Workflow 1: Project Definition & Bootstrap

**Entry Point**: `/init` (slash command)

```
/init (slash command) [manual]
│
├─> Creates: CLAUDE.md
│   └─> Content: Project guidance, architecture overview
│
├─> Creates: Bootstrap Templates (4 files)
│   ├─> planning-template.md (8.8 KB)
│   │   └─> Structure: Master plan, CoD^Σ architecture, phases
│   ├─> todo-template.md (5.4 KB)
│   │   └─> Structure: Task tracking, ACs, phase organization
│   ├─> event-stream-template.md (3.6 KB)
│   │   └─> Structure: Chronological logging, CoD^Σ compression
│   └─> workbook-template.md (7.1 KB)
│       └─> Structure: Context notepad, 300-line limit
│
└─> Constitution Import Chain
    └─> CLAUDE.md references @.claude/shared-imports/constitution.md
        └─> constitution.md (7 Articles)
            ├─> Article I: Intelligence-First (project-intel.mjs)
            ├─> Article II: Evidence-Based (CoD^Σ traces)
            ├─> Article III: Test-First (TDD, ≥2 ACs)
            ├─> Article IV: Specification-First (spec → plan → tasks)
            ├─> Article V: Template-Driven (quality gates)
            ├─> Article VI: Simplicity (anti-abstraction)
            └─> Article VII: User-Story-Centric (MVP-first)
```

**Components Involved**:
- **Slash Commands**: /init (1)
- **Templates**: 4 bootstrap templates
- **Shared Imports**: constitution.md

**Documentation References**:
- `.claude/templates/BOOTSTRAP_GUIDE.md` - Bootstrap process
- `.claude/shared-imports/constitution.md` - Constitutional principles

---

## Workflow 2: Constitution Governance

**Purpose**: Enforce constitutional principles across all components

```
constitution.md (shared-import)
├─> Imported by: All 4 Agents
│   ├─> code-analyzer.md
│   │   └─> Uses: Article I (intelligence-first debugging)
│   ├─> implementation-planner.md
│   │   └─> Uses: Article IV (specification-first planning)
│   ├─> workflow-orchestrator.md
│   │   └─> Uses: All articles (routing validation)
│   └─> executor-implement-verify.md
│       └─> Uses: Article III (TDD), Article VII (story-centric)
│
├─> Imported by: Core Skills (4+)
│   ├─> specify-feature/SKILL.md
│   │   └─> Enforces: Article IV (spec before plan)
│   ├─> clarify-specification/SKILL.md
│   │   └─> Enforces: Article IV (ambiguity resolution)
│   ├─> create-implementation-plan/SKILL.md
│   │   └─> Enforces: Article IV (tech stack after spec)
│   └─> generate-tasks/SKILL.md
│       └─> Enforces: Article VII (user-story organization)
│
└─> Enforced by: Hooks
    ├─> validate-workflow.sh (PreToolUse hook)
    │   ├─> Validates: Article IV order (spec → plan → tasks)
    │   ├─> Decision: allow (exit 0) | deny (exit 2)
    │   └─> Feedback: JSON with guidance
    └─> session-start.sh (SessionStart hook)
        └─> Reports: Workflow state, missing artifacts
```

**Components Involved**:
- **Shared Imports**: constitution.md (1)
- **Agents**: 4 (all import constitution)
- **Skills**: 4+ core SDD skills
- **Hooks**: 2 (validate-workflow, session-start)

**Key Insight**: Constitution is the architectural foundation - all major components reference it for governance.

---

## Workflow 3: SDD Feature Development (Highly Automated)

**Entry Point**: `/feature` (slash command) [manual]

```
User: /feature "description" [manual]
│
├─> specify-feature skill [auto-invoked by description match]
│   ├─> Imports: constitution.md, CoD_Σ.md
│   ├─> Uses: project-intel.mjs (find existing patterns)
│   ├─> Template: feature-spec.md
│   ├─> Creates: specs/{id}/spec.md
│   │   └─> Sections: Requirements, User Stories (P1/P2/P3), Success Criteria
│   └─> [auto] → Invokes: /plan
│       │
│       ├─> create-implementation-plan skill [auto-invoked]
│       │   ├─> Imports: constitution.md, CoD_Σ.md
│       │   ├─> Uses: project-intel.mjs (architecture analysis)
│       │   ├─> Uses: MCP tools (Ref for framework docs)
│       │   ├─> Templates: plan.md, research.md, data-model.md
│       │   ├─> Creates: specs/{id}/plan.md (with CoD^Σ traces)
│       │   ├─> Creates: specs/{id}/research.md (MCP findings)
│       │   ├─> Creates: specs/{id}/data-model.md (schema)
│       │   └─> [auto] → Invokes: generate-tasks skill
│       │       │
│       │       ├─> generate-tasks skill [auto-invoked]
│       │       │   ├─> Imports: constitution.md, tasks.md template
│       │       │   ├─> Organizes: By user story (P1, P2, P3...)
│       │       │   ├─> Creates: specs/{id}/tasks.md
│       │       │   │   └─> Structure: Setup → Foundational → P1 → P2 → P3 → Polish
│       │       │   └─> [auto] → Invokes: /audit
│       │       │       │
│       │       │       └─> /audit command [auto-invoked]
│       │       │           ├─> Template: quality-checklist.md
│       │       │           ├─> Validates:
│       │       │           │   ├─> Constitution violations (CRITICAL)
│       │       │           │   ├─> Missing requirement coverage
│       │       │           │   ├─> Ambiguities ([NEEDS CLARIFICATION])
│       │       │           │   ├─> Duplications/inconsistencies
│       │       │           │   └─> Terminology drift
│       │       │           ├─> Decision: PASS | WARN | FAIL
│       │       │           └─> If FAIL → Blocks /implement
│       │       │
│       │       └─> Output: "Ready for /implement"
│       │
│       └─> (All above steps happen automatically after /plan invocation)
│
└─> (All above steps happen automatically after /feature invocation)

Result: User performed 1 manual action (/feature), system automatically:
1. Created spec.md
2. Invoked /plan → created plan.md, research.md, data-model.md
3. Invoked generate-tasks → created tasks.md
4. Invoked /audit → validated quality
5. Reported readiness status
```

**Components Involved**:
- **Slash Commands**: /feature, /plan, /audit (3)
- **Skills**: specify-feature, create-implementation-plan, generate-tasks (3)
- **Templates**: feature-spec.md, plan.md, research.md, data-model.md, tasks.md, quality-checklist.md (6)
- **Shared Imports**: constitution.md, CoD_Σ.md (2)
- **Intelligence**: project-intel.mjs queries
- **MCP Tools**: Ref (framework documentation)

**User Actions**: 1 (type `/feature "description"`)
**Automated Actions**: 6 (spec creation, /plan, plan creation, generate tasks, /audit, validation)

**Key Insight**: 85% workflow automation - user types one command, system produces 5-6 validated artifacts.

---

## Workflow 4: Analysis & Debugging

**Entry Point**: `/analyze` or `/bug` (slash commands) [manual]

```
User: /analyze "what's causing X?" [manual]
│
├─> workflow-orchestrator agent [routes based on request type]
│   ├─> Model: inherit
│   ├─> Imports: constitution.md
│   ├─> Tool Access: All tools (orchestration role)
│   └─> Routes to → code-analyzer agent
│       ├─> Model: inherit
│       ├─> Imports: constitution.md
│       ├─> MCP Decision Tree: Debugging-focused
│       │   ├─> React issues → Ref MCP
│       │   ├─> Database issues → Supabase MCP
│       │   ├─> Browser issues → Chrome MCP
│       │   └─> General info → Brave MCP
│       └─> Invokes skill (based on problem type):
│           │
│           ├─> analyze-code/SKILL.md [for analysis requests]
│           │   ├─> Imports: CoD_Σ.md, project-intel-mjs-guide.md
│           │   ├─> Step 1: project-intel.mjs --overview
│           │   ├─> Step 2: project-intel.mjs --search "pattern"
│           │   ├─> Step 3: project-intel.mjs --symbols file.ts
│           │   ├─> Step 4: project-intel.mjs --dependencies file.ts
│           │   ├─> Step 5: Read targeted files (with context)
│           │   ├─> Step 6: MCP queries (if needed)
│           │   ├─> Template: report.md
│           │   └─> Output: YYYYMMDD-HHMM-report-{id}.md
│           │       └─> Contains: CoD^Σ traces, file:line evidence
│           │
│           └─> debug-issues/SKILL.md [for bug diagnosis]
│               ├─> Imports: CoD_Σ.md, project-intel-mjs-guide.md
│               ├─> Step 1: Intelligence queries (as above)
│               ├─> Step 2: Symptom analysis
│               ├─> Step 3: Root cause tracing (CoD^Σ)
│               ├─> Step 4: MCP validation (Ref/Supabase)
│               ├─> Step 5: Fix recommendation
│               ├─> Template: bug-report.md
│               └─> Output: YYYYMMDD-HHMM-bug-{id}.md
│                   └─> Contains: Symptom → Root Cause → Fix (with evidence)
│
└─> If analysis reveals need for implementation:
    └─> Handover to implementation-planner agent
        └─> Template: handover.md (600 token limit)
```

**Components Involved**:
- **Slash Commands**: /analyze, /bug (2)
- **Agents**: workflow-orchestrator, code-analyzer (2)
- **Skills**: analyze-code, debug-issues (2)
- **Templates**: report.md, bug-report.md, handover.md (3)
- **Shared Imports**: CoD_Σ.md, project-intel-mjs-guide.md, constitution.md (3)
- **Intelligence**: project-intel.mjs (--overview, --search, --symbols, --dependencies)
- **MCP Tools**: Ref, Supabase, Chrome, Brave (4)

**Key Pattern**: Intelligence-First → 80%+ token savings by querying before reading.

---

## Workflow 5: Implementation & Verification (Progressive Delivery)

**Entry Point**: `/implement` (slash command) [manual]

```
User: /implement specs/{id}/plan.md [manual]
│
├─> implement-and-verify skill [auto-invoked]
│   ├─> Imports: constitution.md, CoD_Σ.md
│   ├─> Can delegate to → executor-implement-verify agent
│   │   ├─> Model: inherit
│   │   ├─> Imports: constitution.md
│   │   ├─> MCP Decision Tree: Implementation-focused
│   │   │   ├─> Need API docs → Ref MCP
│   │   │   ├─> Web scraping feature → Firecrawl MCP
│   │   │   ├─> Architecture decision → Handover to planner
│   │   │   └─> Debugging mystery → Handover to analyzer
│   │   └─> Templates: verification-report.md, handover.md
│   │
│   └─> Per-Story Workflow (Article VII: User-Story-Centric):
│       │
│       ├─> Phase 1: Implement Story P1 (Highest Priority)
│       │   ├─> Step 1: Write tests for P1 ACs [TDD - Article III]
│       │   ├─> Step 2: Run tests (expect FAIL - red phase)
│       │   ├─> Step 3: Implement P1 code (minimal to pass)
│       │   ├─> Step 4: Run tests (expect PASS - green phase)
│       │   ├─> Step 5: [auto] → Invoke: /verify --story P1
│       │   │   ├─> Template: verification-report.md
│       │   │   ├─> Validates: All P1 ACs passing
│       │   │   ├─> Evidence: Test output, file:line references
│       │   │   └─> Output: YYYYMMDD-HHMM-verification-P1.md
│       │   └─> Decision:
│       │       ├─> If PASS → Proceed to P2
│       │       └─> If FAIL → Debug with code-analyzer, re-verify
│       │
│       ├─> Phase 2: Implement Story P2 (Medium Priority)
│       │   ├─> Step 1: Write tests for P2 ACs
│       │   ├─> Step 2-4: TDD cycle (red → implement → green)
│       │   ├─> Step 5: [auto] → Invoke: /verify --story P2
│       │   │   └─> Output: YYYYMMDD-HHMM-verification-P2.md
│       │   └─> Decision: PASS → Proceed to P3 | FAIL → Debug
│       │
│       └─> Phase 3: Implement Story P3 (Lower Priority)
│           ├─> Step 1-4: TDD cycle for P3
│           ├─> Step 5: [auto] → Invoke: /verify --story P3
│           │   └─> Output: YYYYMMDD-HHMM-verification-P3.md
│           └─> If PASS → All stories complete ✓
│
└─> Result: Progressive delivery with per-story verification
    ├─> P1 verified → Can ship MVP
    ├─> P2 verified → Can ship enhancement
    └─> P3 verified → Full feature complete
```

**Components Involved**:
- **Slash Commands**: /implement, /verify (2)
- **Skills**: implement-and-verify (1)
- **Agents**: executor-implement-verify (1)
- **Templates**: verification-report.md, handover.md (2)
- **Shared Imports**: constitution.md, CoD_Σ.md (2)
- **MCP Tools**: Ref, Firecrawl (2)

**Key Pattern**: Progressive delivery per Article VII - each story independently verified before proceeding.

**User Actions**: 1 (type `/implement plan.md`)
**Automated Actions**: 3+ (per-story implementation + verification for each P1, P2, P3...)

---

## Workflow 6: Session Management (Hooks)

**Purpose**: Automatic context loading and workflow validation

```
Session Start → SessionStart Hook [auto]
│
├─> session-start.sh (SessionStart hook)
│   ├─> Uses: $CLAUDE_PROJECT_DIR (portable path)
│   ├─> Detects: SPECIFY_FEATURE env var
│   ├─> Checks: specs/{id}/spec.md exists?
│   ├─> Checks: specs/{id}/plan.md exists?
│   ├─> Checks: specs/{id}/tasks.md exists?
│   ├─> Determines Workflow State:
│   │   ├─> needs_spec (no spec.md)
│   │   ├─> needs_plan (spec.md but no plan.md)
│   │   ├─> needs_tasks (plan.md but no tasks.md)
│   │   └─> ready (all artifacts present)
│   ├─> Output: JSON with workflow state
│   └─> Action: JSON added to Claude's context (visible at session start)
│
└─> Example Output:
    {
      "feature": "001-auth-system",
      "workflow_state": "needs_plan",
      "next_action": "Run /plan to create implementation plan",
      "artifacts": {
        "spec": { "exists": true, "path": "specs/001-auth-system/spec.md" },
        "plan": { "exists": false, "path": "specs/001-auth-system/plan.md" },
        "tasks": { "exists": false, "path": "specs/001-auth-system/tasks.md" }
      }
    }


File Write → PreToolUse Hook [auto]
│
└─> validate-workflow.sh (PreToolUse hook)
    ├─> Uses: $CLAUDE_PROJECT_DIR (portable path)
    ├─> Triggers on: Write tool for plan.md or tasks.md
    ├─> Validates: Article IV (Specification-First Development)
    │   ├─> Creating plan.md? → Check spec.md exists
    │   ├─> Creating tasks.md? → Check plan.md exists
    │   └─> Missing prerequisite? → Block operation
    ├─> Decision Logic:
    │   ├─> Prerequisites met → Exit 0 (allow)
    │   └─> Prerequisites missing → Exit 2 (block)
    ├─> Blocking Output (exit 2):
    │   └─> stderr JSON:
    │       {
    │         "feedback": "Cannot create plan without specification. Article IV requires spec.md before plan.md.",
    │         "next_action": "Create specification first using /feature command"
    │       }
    └─> Result: Feedback shown to Claude, tool call blocked
```

**Components Involved**:
- **Hooks**: session-start.sh, validate-workflow.sh (2)
- **Shared Imports**: constitution.md (referenced for Article IV)
- **Environment**: $CLAUDE_PROJECT_DIR

**Key Pattern**: Hooks enforce constitutional order deterministically (no LLM required for validation).

---

## Cross-Cutting Concerns

### Intelligence-First Architecture (Article I)

```
All Analysis/Planning/Implementation Workflows:
│
├─> Step 0: Always Query Intelligence First
│   ├─> project-intel.mjs --overview (project structure)
│   ├─> project-intel.mjs --search "term" (find relevant files)
│   ├─> project-intel.mjs --symbols file.ts (available symbols)
│   ├─> project-intel.mjs --dependencies file.ts (dependencies)
│   └─> MCP tools (external intelligence)
│       ├─> Ref MCP (library documentation)
│       ├─> Supabase MCP (database schema)
│       └─> Other MCPs as needed
│
└─> Step 1: Read Targeted Files (only after intelligence queries)
    └─> Token savings: 80-95% vs reading full files
```

### Evidence-Based Reasoning (Article II - CoD^Σ)

```
All Outputs Must Include:
│
├─> CoD^Σ Traces (symbolic reasoning)
│   ├─> Operators: →, ⊕, ∘, ∥, ≫, ⇄
│   └─> Example: intel-query ≫ targeted-read ∘ CoD^Σ-trace → evidence-backed-conclusion
│
└─> Evidence Sources
    ├─> file:line references (ComponentA.tsx:45)
    ├─> project-intel.mjs JSON outputs
    ├─> MCP query results
    └─> Test execution results
```

### Template-Driven Quality (Article V)

```
All Workflows Produce Structured Outputs:
│
├─> Bootstrap Templates (4)
│   ├─> planning-template.md
│   ├─> todo-template.md
│   ├─> event-stream-template.md
│   └─> workbook-template.md
│
├─> SDD Workflow Templates (6)
│   ├─> feature-spec.md (technology-agnostic requirements)
│   ├─> clarification-checklist.md (ambiguity resolution)
│   ├─> plan.md (implementation plan with CoD^Σ)
│   ├─> research.md (MCP findings)
│   ├─> data-model.md (schema and contracts)
│   └─> tasks.md (user-story-organized tasks)
│
├─> Analysis/Debug Templates (2)
│   ├─> report.md (analysis results with CoD^Σ)
│   └─> bug-report.md (symptom → root cause → fix)
│
├─> Verification Templates (2)
│   ├─> verification-report.md (AC results with evidence)
│   └─> quality-checklist.md (pre-implementation validation)
│
└─> Coordination Templates (2)
    ├─> handover.md (agent delegation, 600 token limit)
    └─> mcp-query.md (external knowledge queries)
```

---

## Component Dependency Graph

### Agents ⇄ Skills ⇄ Commands

```
workflow-orchestrator (agent)
├─> Routes to: code-analyzer (agent)
│   └─> Invokes: analyze-code (skill) or debug-issues (skill)
│       └─> Produces: report.md or bug-report.md
│
├─> Routes to: implementation-planner (agent)
│   └─> Invokes: create-implementation-plan (skill)
│       └─> Produces: plan.md, research.md, data-model.md
│
└─> Routes to: executor-implement-verify (agent)
    └─> Invokes: implement-and-verify (skill)
        └─> Produces: verification-report.md per story

Slash Commands Invoke Skills:
├─> /feature → specify-feature (skill)
├─> /plan → create-implementation-plan (skill)
├─> /tasks → generate-tasks (skill)
├─> /implement → implement-and-verify (skill)
├─> /verify → implement-and-verify (skill, verification mode)
├─> /analyze → analyze-code (skill via orchestrator)
└─> /bug → debug-issues (skill via orchestrator)
```

### All Components → Constitution

```
constitution.md (shared-import)
├─> Imported by: All 4 agents
├─> Imported by: 4+ core skills
├─> Enforced by: 2 hooks (session-start, validate-workflow)
└─> Referenced in: templates (quality gates, verification criteria)
```

### All Outputs → Templates

```
Every workflow produces structured output:
├─> SDD artifacts: feature-spec, plan, tasks, etc.
├─> Analysis artifacts: reports, bug-reports
├─> Verification artifacts: verification-report per story
└─> Coordination artifacts: handovers, mcp-queries
```

---

## Summary Statistics

**Total Components**: 51+
- Agents: 4
- Skills: 10
- Slash Commands: 13
- Templates: 24 (4 bootstrap + 20 workflow)
- Hooks: 8
- Shared Imports: 2 (constitution, CoD_Σ)

**Workflow Automation Rates**:
- SDD Feature Development: 85% automated (1 user command → 6 automated actions)
- Implementation: 66% automated (1 user command → per-story auto-verification)
- Analysis: 50% automated (orchestrator routes, intelligence queries automatic)

**Token Efficiency**:
- Intelligence-First: 80-95% savings vs naive file reading
- Progressive Disclosure: Skills keep files <500 lines via subdirectories
- Template Reuse: 24 templates standardize all outputs

**Quality Gates**:
- Pre-Planning: /feature → specify-feature → quality checks
- Pre-Implementation: /audit validates constitution compliance
- Progressive Delivery: /verify per story before proceeding

---

## Key Insights

1. **Constitution is Central**: All major components import and enforce constitutional principles
2. **High Automation**: SDD workflow requires only 2 manual user actions (/feature, /implement)
3. **Intelligence-First**: All workflows query project-intel.mjs before reading files
4. **Progressive Delivery**: Article VII enforced - each story verified independently
5. **Evidence-Based**: All outputs include CoD^Σ traces with file:line references
6. **Template-Driven**: 24 templates ensure consistency across all outputs
7. **Hooks Enable Determinism**: Workflow validation happens automatically without LLM

---

**End of Component Relationship Analysis**
