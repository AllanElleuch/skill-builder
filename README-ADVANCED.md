# Claude Code Intelligence Toolkit - Advanced Reference

**Complete documentation of hooks, subagents, and slash commands**

This document provides detailed reference for advanced features of the Intelligence Toolkit including automated workflow hooks, specialized AI subagents, and powerful slash commands.

---

## Table of Contents

1. [Hooks System](#hooks-system)
2. [Subagents](#subagents)
3. [Slash Commands](#slash-commands)
4. [Integration Patterns](#integration-patterns)

---

## Hooks System

The Intelligence Toolkit uses hooks to automate workflows, enforce quality gates, and maintain system integrity. All hooks are configured in `.claude/settings.json` and executed automatically at key lifecycle events.

### Overview

| Hook Event | When It Fires | Purpose | Script |
|------------|--------------|---------|--------|
| **SessionStart** | Session startup/resume | Load feature context, validate artifacts, report workflow state | `session-start.sh` |
| **PreToolUse** | Before Write tool execution | Validate workflow compliance, enforce SDD order | `validate-workflow.sh` |
| **PostToolUse** | After Write/Edit/MultiEdit | Check code quality, run linting | `lint-check.sh` |
| **Stop** | Agent finishes responding | Verify task completion, check acceptance criteria | `completion-check.sh` |
| **SubagentStop** | Subagent completes task | Create handover documents, log agent transitions | `subagent-handover.sh` |

### Active Hooks

#### 1. SessionStart Hook

**File**: `.claude/hooks/session-start.sh`
**Trigger**: Every session startup or resume
**Purpose**: Auto-detect current feature branch, validate SDD artifacts, report workflow state

**Functionality**:
- Detects feature branch (pattern: `###-feature-name`)
- Checks for spec.md, plan.md, tasks.md existence
- Determines workflow state: `needs_spec`, `needs_plan`, `needs_tasks`, or `ready`
- Provides next action recommendation
- Outputs context message to Claude with artifact status

**Example Output**:
```
## SDD Workflow Status

**Feature**: 001-user-authentication
**Directory**: /project/specs/001-user-authentication

**Artifacts**:
- spec.md: ✓ EXISTS (specs/001-user-authentication/spec.md)
- plan.md: ✓ EXISTS (specs/001-user-authentication/plan.md)
- tasks.md: ❌ MISSING (specs/001-user-authentication/tasks.md)

**Workflow State**: needs_tasks
**Next Action**: Generate tasks with generate-tasks skill
```

**Configuration**:
```json
{
  "SessionStart": [{
    "hooks": [{
      "type": "command",
      "command": ".claude/hooks/session-start.sh"
    }]
  }]
}
```

---

#### 2. PreToolUse Hook (Workflow Validation)

**File**: `.claude/hooks/validate-workflow.sh`
**Trigger**: Before Write tool executes
**Purpose**: Enforce Specification-Driven Development (SDD) workflow order

**Validation Rules**:
- Prevents creating plan.md before spec.md exists
- Prevents creating tasks.md before plan.md exists
- Prevents writing code before tasks.md exists
- Ensures constitutional compliance (Article IV: Specification-First Development)

**Blocks Tool If**:
- Writing to `plan.md` when `spec.md` doesn't exist
- Writing to `tasks.md` when `plan.md` doesn't exist
- Writing implementation code when `tasks.md` doesn't exist

**Configuration**:
```json
{
  "PreToolUse": [{
    "matcher": "Write",
    "hooks": [{
      "type": "command",
      "command": ".claude/hooks/validate-workflow.sh"
    }]
  }]
}
```

---

#### 3. PostToolUse Hook (Code Quality)

**File**: `.claude/hooks/lint-check.sh`
**Trigger**: After Write, Edit, or MultiEdit tool completes
**Purpose**: Automatically check code quality and formatting

**Functionality**:
- Runs linting checks on modified files
- Validates code style compliance
- Reports warnings/errors to Claude
- Non-blocking (warnings shown, execution continues)

**File Types Checked**:
- TypeScript/JavaScript (`.ts`, `.tsx`, `.js`, `.jsx`)
- Python (`.py`)
- Markdown documentation (`.md`)

**Configuration**:
```json
{
  "PostToolUse": [{
    "matcher": "Write|Edit|MultiEdit",
    "hooks": [{
      "type": "command",
      "command": ".claude/hooks/lint-check.sh"
    }]
  }]
}
```

---

#### 4. Stop Hook (Completion Check)

**File**: `.claude/hooks/completion-check.sh`
**Trigger**: When main Claude Code agent finishes responding (not on user interrupt)
**Purpose**: Verify task completion and acceptance criteria satisfaction

**Functionality**:
- Checks if todos are completed
- Verifies acceptance criteria marked as satisfied
- Validates output artifacts exist
- Reports incomplete items to Claude
- Can block completion if critical items missing

**Configuration**:
```json
{
  "Stop": [{
    "hooks": [{
      "type": "command",
      "command": ".claude/hooks/completion-check.sh"
    }]
  }]
}
```

---

#### 5. SubagentStop Hook (Handover Management)

**File**: `.claude/hooks/subagent-handover.sh`
**Trigger**: When a subagent completes its task (Task tool finishes)
**Purpose**: Create handover documents and log agent transitions

**Functionality**:
- Captures subagent execution context
- Creates handover document using `@.claude/templates/handover.md`
- Logs agent transition for traceability
- Saves handover to: `YYYYMMDD-HHMM-handover-{from}-to-{to}.md`

**Handover Document Contents**:
- Source agent and destination agent
- Task summary and completion status
- Key findings and decisions made
- Artifacts created/modified
- Context needed for next agent
- CoD^Σ reasoning trace

**Configuration**:
```json
{
  "SubagentStop": [{
    "hooks": [{
      "type": "command",
      "command": ".claude/hooks/subagent-handover.sh"
    }]
  }]
}
```

---

### Additional Hook Scripts

These hooks are available but not currently active in `.claude/settings.json`:

#### log-session-start.sh
Logs session start events to event-stream.md for audit trail.

#### log-user-prompt.sh
Logs user prompts to event-stream.md for conversation tracking.

#### system-integrity-check.sh
Validates system integrity: checks for component consistency, template availability, skill definitions, constitutional compliance.

---

## Subagents

The Intelligence Toolkit includes 4 specialized subagents for orchestrating complex workflows. Each subagent has isolated context and specialized expertise.

### Overview

| Agent | Purpose | Key Skills | Model |
|-------|---------|------------|-------|
| **workflow-orchestrator** | Route requests, coordinate multi-agent workflows | Routing, context allocation, handover management | inherit |
| **code-analyzer** | Deep code analysis, bug diagnosis, architecture understanding | analyze-code, debug-issues | inherit |
| **implementation-planner** | Create detailed implementation plans from specifications | create-implementation-plan, clarify-specification | inherit |
| **executor-implement-verify** | Test-driven implementation with AC verification | implement-and-verify, generate-tasks | inherit |

---

### 1. workflow-orchestrator

**File**: `.claude/agents/workflow-orchestrator.md`

**Description**: Meta-agent that routes user requests to specialized agents, coordinates multi-agent workflows, and manages context allocation across the Intelligence Toolkit.

**When Used**:
- User issues workflow commands (`/analyze`, `/bug`, `/plan`, `/implement`, `/verify`)
- Complex tasks require coordination between multiple specialist agents
- Context allocation and handover management needed
- Systematic workflows from Intelligence Toolkit should be followed

**Routing Rules**:

| User Request | Routes To | With SOP | With Template |
|-------------|-----------|----------|---------------|
| `/analyze` | code-analyzer | sop-analysis.md | analysis-spec.md, report.md |
| `/bug` | code-analyzer | sop-debugging.md | bug-report.md |
| `/plan <spec>` | implementation-planner | sop-planning.md | plan.md |
| `/implement <plan>` | executor-implement-verify | sop-execution.md | verification-report.md |
| `/verify <plan>` | executor-implement-verify | sop-verification.md | verification-report.md |

**Core Responsibilities**:
1. **Analyze Requests**: Parse commands and natural language to determine workflow type
2. **Route to Specialists**: Delegate to code-analyzer, planner, or executor based on rules
3. **Coordinate Context**: Allocate token budgets and manage context efficiently
4. **Ensure Proper Handovers**: Create handover documents when tasks transition
5. **Enforce Standards**: Verify agents receive required SOPs, templates, enforcement rules

**Available Resources**:
- Reasoning Framework: CoD^Σ for systematic decision-making
- Specialist Agents: code-analyzer, planner, executor
- SOPs: sop-analysis.md, sop-debugging.md, sop-planning.md, sop-execution.md
- Templates: All 22 templates available for delegation
- Skills: Can instruct specialists to use specific skills

**Tools**: Full access to all tools including `Task` (for delegation), `SlashCommand`, and MCP tools

**Example Delegation**:
```
User: "/analyze the authentication bug"
Orchestrator: Routes to code-analyzer agent
  - Provides: sop-debugging.md
  - Requires: bug-report.md template
  - Allocates: 50,000 token budget
  - Monitors: Intel-first compliance
```

---

### 2. code-analyzer

**File**: `.claude/agents/code-analyzer.md`

**Description**: Intelligence-first code analysis specialist for bugs, architecture understanding, dependency tracing, performance analysis, and security concerns.

**When Used**:
- Diagnosing bugs and unexpected behavior
- Understanding codebase architecture
- Tracing dependencies and call graphs
- Analyzing performance bottlenecks
- Security vulnerability assessment

**Core Capabilities**:
1. **Intelligence-First Analysis**: MUST query project-intel.mjs before reading files
2. **Bug Diagnosis**: Root cause analysis with CoD^Σ reasoning
3. **Architecture Understanding**: System design and component relationships
4. **Dependency Tracing**: Upstream/downstream impact analysis
5. **Performance Analysis**: Bottleneck identification and optimization
6. **Security Analysis**: Vulnerability detection and remediation

**Skills Used**:
- **analyze-code**: Comprehensive intelligence-first code analysis
- **debug-issues**: Systematic bug diagnosis with root cause tracing

**Intelligence Workflow**:
1. Query project-intel.mjs (overview, search, symbols, dependencies)
2. Query MCP tools if needed (Ref for library docs, Supabase for DB schema)
3. Read targeted file sections only (never full files)
4. Generate report with complete CoD^Σ trace

**Token Budget**: Target 1500-3000 tokens (vs 15000-30000 without intel-first)

**Outputs**:
- `YYYYMMDD-HHMM-analysis-spec-{id}.md` - Scope definition
- `YYYYMMDD-HHMM-report-{id}.md` - Analysis report with evidence
- `YYYYMMDD-HHMM-bug-report-{id}.md` - Bug diagnosis (if applicable)

**Example Analysis**:
```
User: "Why is the checkout page slow?"
code-analyzer:
  1. Queries project-intel.mjs for checkout components
  2. Analyzes symbols and dependencies
  3. Identifies N+1 query pattern at checkout.tsx:145
  4. Verifies with Supabase MCP schema query
  5. Generates report with optimization recommendations
  Token usage: 2,100 tokens (vs 18,000 without intel)
```

---

### 3. implementation-planner

**File**: `.claude/agents/implementation-planner.md`

**Description**: Transforms feature specifications into detailed implementation plans with intelligence-backed architectural decisions and testable acceptance criteria.

**When Used**:
- Feature specification exists and needs implementation plan
- User mentions tech stack, architecture, implementation approach
- User asks "how to implement" or "how to build" the feature
- After specification is complete (post-clarification)

**Core Capabilities**:
1. **Specification Analysis**: Deep understanding of requirements and constraints
2. **Architecture Design**: Intelligence-informed technology choices
3. **Task Breakdown**: User-story-centric task organization
4. **Acceptance Criteria**: Minimum 2 testable ACs per task
5. **Dependency Mapping**: Task dependencies and critical path identification
6. **Risk Assessment**: Technical risks and mitigation strategies

**Skills Used**:
- **create-implementation-plan**: Intelligence-first planning with architectural decisions
- **clarify-specification**: Identify and resolve spec ambiguities before planning

**Intelligence Sources**:
- project-intel.mjs for existing architecture patterns
- Ref MCP for library capabilities and best practices
- Supabase MCP for database design patterns
- GitHub MCP for repository structure and conventions

**Outputs**:
- `YYYYMMDD-HHMM-plan-{feature-id}.md` - Implementation plan
- `YYYYMMDD-HHMM-research-{topic}.md` - Technical research findings
- `YYYYMMDD-HHMM-data-model-{feature-id}.md` - Database schema design

**Plan Contents**:
1. **Summary**: Feature overview, technical approach, user stories
2. **Technical Context**: Architecture decisions, tech stack, dependencies
3. **Constitution Check**: Article compliance verification
4. **Architecture (CoD^Σ)**: System design with formal reasoning
5. **User Stories**: Independent, deliverable increments
6. **Tasks**: Detailed implementation tasks with ACs (≥2 per task)
7. **Dependencies**: Task dependencies and critical path
8. **Risks**: Technical risks and mitigation strategies
9. **Verification**: Acceptance testing strategy
10. **Progress Tracking**: Task completion checklist
11. **Handover Notes**: Context for executor agent

**Example Planning**:
```
User: "/plan specs/001-oauth/spec.md"
implementation-planner:
  1. Reads spec.md (technology-agnostic)
  2. Queries project-intel.mjs for existing auth patterns
  3. Queries Ref MCP for OAuth library best practices
  4. Designs architecture with CoD^Σ reasoning
  5. Creates 3 user stories (P1: Basic OAuth, P2: Profile sync, P3: Multi-provider)
  6. Breaks down into 12 tasks with 2-3 ACs each
  7. Maps dependencies and identifies critical path
  8. Generates plan.md (5-8KB)
  9. Automatically invokes generate-tasks skill
  10. Tasks.md created with story-organized tasks
  11. Automatically invokes /audit for validation
```

---

### 4. executor-implement-verify

**File**: `.claude/agents/executor-implement-verify.md`

**Description**: Implements planned tasks using test-driven development with rigorous acceptance criteria verification. Enforces story-by-story progressive delivery.

**When Used**:
- Implementation plan exists with tasks and acceptance criteria
- User mentions "implement", "build", "code", or specific task IDs
- After /audit passes (pre-implementation quality gate)
- For progressive story delivery (MVP → enhancements)

**Core Capabilities**:
1. **Test-First Development**: Write tests before implementation
2. **Story-by-Story Execution**: Complete P1 before P2, etc.
3. **AC Verification**: Verify ≥2 ACs per task satisfied
4. **Independent Demos**: Each story demonstrable independently
5. **Continuous Verification**: Run tests after each meaningful change
6. **Quality Gates**: Block progression on test failures

**Skills Used**:
- **implement-and-verify**: TDD implementation with AC verification
- **generate-tasks**: Task breakdown when plan lacks detail

**Implementation Workflow**:
1. **Story Selection**: Start with P1 (highest priority)
2. **Task Selection**: Choose next task in story
3. **Test Writing**: Write tests for acceptance criteria
4. **Implementation**: Implement to pass tests
5. **Verification**: Run tests, verify ACs satisfied
6. **Story Completion**: Verify story is independently demostrable
7. **Story Verification**: Invoke `/verify --story P1`
8. **Progression**: Move to P2 only after P1 verified

**Progressive Delivery**:
```
P1 (MVP) → /verify --story P1 → PASS → Ship MVP
  ↓
P2 (Enhancement) → /verify --story P2 → PASS → Ship Enhancement
  ↓
P3 (Advanced) → /verify --story P3 → PASS → Ship Advanced
```

**Outputs**:
- Implementation code (tests + source)
- `YYYYMMDD-HHMM-verification-task-{id}.md` - Per-task verification
- `YYYYMMDD-HHMM-verification-story-{id}.md` - Per-story verification
- `YYYYMMDD-HHMM-handover-{from}-to-{to}.md` - Handover if blocked

**Verification Report Contents**:
- Task/Story summary
- Acceptance criteria with PASS/FAIL status
- Test execution results
- Evidence (test output, file references)
- CoD^Σ reasoning trace
- Blockers if any
- Next steps

**Example Implementation**:
```
User: "/implement specs/001-oauth/plan.md"
executor-implement-verify:
  1. Reads plan.md, identifies 3 stories (P1, P2, P3)
  2. Starts with P1: Basic OAuth Login
  3. Task 1.1: Setup OAuth provider configuration
     - Writes tests: test_oauth_config.py
     - Implements: oauth_config.py
     - Verifies: 2 ACs satisfied ✓
  4. Task 1.2: Login endpoint
     - Writes tests: test_login_endpoint.py
     - Implements: login.py
     - Verifies: 3 ACs satisfied ✓
  5. Task 1.3: Callback handler
     - Writes tests: test_callback.py
     - Implements: callback.py
     - Verifies: 2 ACs satisfied ✓
  6. P1 complete, automatically invokes /verify --story P1
  7. Story verification: All P1 ACs satisfied ✓
  8. Creates verification report
  9. Progresses to P2
```

**Quality Gates**:
- Cannot skip stories (must complete P1 before P2)
- Cannot skip AC verification (must verify after each task)
- Cannot proceed if tests fail (must fix before continuing)
- Cannot ship story without independent demo

---

## Slash Commands

The Intelligence Toolkit provides 15 slash commands for triggering workflows. All commands are SlashCommand-tool compatible (can be invoked programmatically by agents/skills).

### Overview

| Command | Purpose | Skill/Agent Used | SlashCommand Tool |
|---------|---------|------------------|-------------------|
| `/analyze` | Intelligence-first code analysis | analyze-code skill | ✓ |
| `/audit [feature-id]` | Cross-artifact consistency validation | N/A (validation script) | ✓ |
| `/bootstrap` | Verify toolkit installation | N/A (system check) | ✓ |
| `/bug` | Systematic bug diagnosis | debug-issues skill | ✓ |
| `/constitution [amendment]` | Manage constitution amendments | N/A (governance tool) | ✓ |
| `/define-product` | Create product definition | define-product skill | ✓ |
| `/feature` | Create feature specification | specify-feature skill | ✓ |
| `/generate-constitution` | Derive constitution from product.md | generate-constitution skill | ✓ |
| `/implement <plan>` | TDD implementation with verification | implement-and-verify skill | ✓ |
| `/index` | Generate PROJECT_INDEX.json | N/A (indexing tool) | ✓ |
| `/plan <spec>` | Create implementation plan | create-implementation-plan skill | ✓ |
| `/system-integrity` | Validate system integrity | N/A (validation script) | ✓ |
| `/tasks <plan>` | Generate story-organized tasks | generate-tasks skill | ✓ |
| `/test-discovery` | Test command discovery | N/A (test command) | ✓ |
| `/verify <plan> [--story <id>]` | Verify AC satisfaction | implement-and-verify skill (verify mode) | ✓ |

---

### Workflow Commands (SDD)

These commands form the core Specification-Driven Development workflow:

#### /feature

**Description**: Create comprehensive feature specification through interactive dialogue using Socratic questioning and iterative refinement.

**Skill**: specify-feature

**Process**:
1. Interactive dialogue to understand requirements
2. Clarify ambiguities using Socratic questioning
3. Create technology-agnostic specification
4. **Automatically invokes** `/plan` when complete
5. Plan creation **automatically invokes** `generate-tasks`
6. Task generation **automatically invokes** `/audit`

**Output**: `specs/{feature-id}/spec.md`

**Usage**:
```bash
/feature "I want OAuth authentication"
```

**Automatic Workflow**:
```
/feature → specify-feature skill → spec.md
    ↓ (automatic)
/plan → create-implementation-plan skill → plan.md
    ↓ (automatic)
generate-tasks skill → tasks.md
    ↓ (automatic)
/audit → validation → PASS → Ready for /implement
```

---

#### /plan <spec-file>

**Description**: Create detailed implementation plan from specification using intelligence-first dependency analysis.

**Skill**: create-implementation-plan

**Process**:
1. Read specification (technology-agnostic)
2. Query intelligence sources (project-intel.mjs, MCP tools)
3. Design architecture with CoD^Σ reasoning
4. Create user stories (P1: MVP, P2+: enhancements)
5. Break down into tasks with ≥2 ACs each
6. Map dependencies and critical path
7. **Automatically invokes** generate-tasks skill
8. Task generation **automatically invokes** `/audit`

**Output**:
- `specs/{feature-id}/plan.md`
- `specs/{feature-id}/research-{topic}.md` (optional)
- `specs/{feature-id}/data-model.md` (optional)
- `specs/{feature-id}/tasks.md` (automatic)

**Usage**:
```bash
/plan specs/001-oauth/spec.md
```

**Automatic Chain**:
```
/plan → plan.md created
    ↓ (automatic)
generate-tasks skill → tasks.md created
    ↓ (automatic)
/audit → consistency validation
```

---

#### /tasks <plan-file>

**Description**: Generate user-story-organized task list from implementation plan.

**Skill**: generate-tasks

**Process**:
1. Parse plan.md for user stories and tasks
2. Organize by story (P1, P2, P3, etc.)
3. Ensure ≥2 ACs per task
4. Create story-scoped task list
5. **Automatically invokes** `/audit` when complete

**Output**: `specs/{feature-id}/tasks.md`

**Usage**:
```bash
/tasks specs/001-oauth/plan.md
```

**Automatic Chain**:
```
/tasks → tasks.md created
    ↓ (automatic)
/audit → validation
```

**Note**: Usually not invoked manually (automatically invoked by `/plan`)

---

#### /implement <plan-file>

**Description**: Implement tasks from plan using test-driven development (TDD) with mandatory AC verification.

**Skill**: implement-and-verify

**Process**:
1. Read plan.md and tasks.md
2. Start with P1 (highest priority story)
3. For each task:
   - Write tests first
   - Implement to pass tests
   - Verify ACs satisfied
4. After story complete:
   - **Automatically invokes** `/verify --story P1`
   - If PASS, progress to P2
   - If FAIL, fix issues before progressing
5. Progressive delivery: P1 → P2 → P3

**Output**:
- Implementation code (tests + source)
- `YYYYMMDD-HHMM-verification-task-{id}.md` (per task)
- `YYYYMMDD-HHMM-verification-story-{id}.md` (per story)

**Usage**:
```bash
/implement specs/001-oauth/plan.md
```

**Automatic Verification**:
```
/implement → P1 tasks implemented
    ↓ (automatic)
/verify --story P1 → PASS → P2 tasks implemented
    ↓ (automatic)
/verify --story P2 → PASS → P3 tasks implemented
    ↓ (automatic)
/verify --story P3 → PASS → Complete
```

---

#### /verify <plan-file> [--story <story-id>]

**Description**: Verify implementation satisfies all acceptance criteria from plan.

**Skill**: implement-and-verify (verification mode)

**Process**:
1. Read plan.md and tasks.md
2. If `--story` specified, verify only that story
3. Otherwise, verify all tasks
4. For each task:
   - Run tests
   - Check AC satisfaction
   - Document evidence
5. Generate verification report

**Output**: `YYYYMMDD-HHMM-verification-{story|task}-{id}.md`

**Usage**:
```bash
# Verify specific story
/verify specs/001-oauth/plan.md --story P1

# Verify all
/verify specs/001-oauth/plan.md
```

**Note**: Usually not invoked manually (automatically invoked by `/implement`)

---

#### /audit [feature-id] [focus-area]

**Description**: Perform cross-artifact consistency and quality analysis across spec.md, plan.md, and tasks.md to verify constitution compliance and implementation readiness.

**Process**:
1. Read spec.md, plan.md, tasks.md
2. Check consistency:
   - All requirements covered in plan
   - All plan items have tasks
   - All tasks have ≥2 ACs
   - No contradictions between artifacts
3. Verify constitutional compliance:
   - Article I: Intelligence-first queries present
   - Article III: Test-first approach documented
   - Article IV: Specification exists before plan
   - Article VII: User stories are independent
4. Check for:
   - Ambiguities requiring clarification
   - Missing requirements
   - Scope creep
   - Terminology drift
5. Generate audit report

**Output**: `YYYYMMDD-HHMM-audit-{feature-id}.md`

**Usage**:
```bash
# Audit entire feature
/audit 001-oauth

# Focus on specific area
/audit 001-oauth architecture
```

**Exit Codes**:
- PASS: No critical issues, ready for implementation
- WARN: Minor issues, proceed with caution
- FAIL: Critical issues, must resolve before implementation

**Note**: Automatically invoked after task generation before implementation begins

---

### Analysis Commands

#### /analyze

**Description**: Perform intelligence-first code analysis using analyze-code skill to understand bugs, architecture, dependencies, performance, or security concerns.

**Skill**: analyze-code

**Process**:
1. Define analysis scope
2. Execute intel queries (project-intel.mjs)
3. Query MCP tools for verification
4. Read targeted code sections only
5. Generate report with CoD^Σ trace

**Output**:
- `YYYYMMDD-HHMM-analysis-spec-{id}.md`
- `YYYYMMDD-HHMM-report-{id}.md`

**Usage**:
```bash
/analyze
```

**Token Budget**: 1500-3000 tokens (vs 15000-30000 without intel-first)

---

#### /bug

**Description**: Perform systematic bug diagnosis using intelligence-first approach to trace from symptom to root cause.

**Skill**: debug-issues

**Process**:
1. Capture error message and stack trace
2. Execute intel queries to locate relevant code
3. Trace execution path with CoD^Σ reasoning
4. Identify root cause
5. Propose minimal fix
6. Generate bug report

**Output**: `YYYYMMDD-HHMM-bug-report-{id}.md`

**Usage**:
```bash
/bug
```

---

### System Commands

#### /bootstrap

**Description**: Verify Intelligence Toolkit installation and system health.

**Process**:
1. Check toolkit components installed
2. Verify agents, skills, commands present
3. Test hook configurations
4. Validate template availability
5. Check constitutional compliance system

**Output**: Console report with status

**Usage**:
```bash
/bootstrap
```

---

#### /system-integrity [--verbose] [--fix]

**Description**: Validate Intelligence Toolkit system integrity including components, workflows, best practices, and constitutional compliance.

**Process**:
1. Check all components present (agents, skills, commands, templates)
2. Verify component consistency (imports resolve, references valid)
3. Validate hook configurations
4. Check constitutional compliance infrastructure
5. Verify intelligence-first tooling (project-intel.mjs)
6. Test workflow execution paths

**Flags**:
- `--verbose`: Detailed output with checks performed
- `--fix`: Attempt automatic repairs of issues found

**Output**: Console report with PASS/WARN/FAIL status

**Usage**:
```bash
/system-integrity
/system-integrity --verbose
/system-integrity --fix
```

---

#### /index

**Description**: Generate or regenerate PROJECT_INDEX.json for project intelligence queries.

**Process**:
1. Scan repository for files (respects .gitignore)
2. Parse code files for symbols (functions, classes, types)
3. Extract import/export relationships
4. Build call graph
5. Generate PROJECT_INDEX.json

**Output**: `PROJECT_INDEX.json` (gitignored)

**Usage**:
```bash
/index
```

**Note**: Automatically runs when files change, but can be invoked manually

---

### Product & Constitution Commands

#### /define-product

**Description**: Create user-centric product definition (product.md) by analyzing the repository and clarifying user needs.

**Skill**: define-product

**Process**:
1. Analyze repository structure and code
2. Infer product goals and user personas
3. Interactive dialogue to clarify user needs
4. Document pain points and user journeys
5. Create comprehensive product.md

**Output**: `product.md`

**Usage**:
```bash
/define-product
```

---

#### /generate-constitution

**Description**: Derive technical development principles (constitution.md) FROM user needs in product.md using evidence-based CoD^Σ reasoning.

**Skill**: generate-constitution

**Process**:
1. Read product.md (user needs, pain points)
2. Derive technical principles FROM user needs
3. Create architecture decisions traced to user needs
4. Define tech stack choices with justification
5. Document development constraints
6. Generate constitution.md with evidence trails

**Output**: `.claude/shared-imports/constitution.md`

**Usage**:
```bash
/generate-constitution
```

**Note**: Requires product.md to exist first

---

#### /constitution ["amendment text"] or empty for viewing

**Description**: Manage Intelligence Toolkit Constitution amendments with version tracking and dependency validation.

**Process**:
1. If no argument: Display current constitution
2. If amendment provided:
   - Parse amendment text
   - Validate against existing articles
   - Check for conflicts
   - Update constitution with version tracking
   - Notify affected components

**Output**: Updated constitution.md with amendment history

**Usage**:
```bash
# View current constitution
/constitution

# Add amendment
/constitution "Article VIII: Performance - All queries must complete within 2 seconds"
```

---

### Test Commands

#### /test-discovery

**Description**: Simple test command to verify command discovery works.

**Output**: Console message confirming command discovered

**Usage**:
```bash
/test-discovery
```

---

## Integration Patterns

### Pattern 1: Skill → Slash Command

Skills can instruct Claude to invoke slash commands via the SlashCommand tool.

**Example** (from implement-and-verify skill):
```markdown
When story P1 is complete, invoke /verify --story P1 to verify acceptance criteria.
```

### Pattern 2: Slash Command → Skill

Slash commands expand to prompts that instruct Claude to use specific skills.

**Example** (from /analyze command):
```markdown
Analyze this codebase using the **analyze-code skill** (@.claude/skills/analyze-code/SKILL.md).
```

### Pattern 3: Skill → Agent → Skill

Skills can delegate to agents which use other skills.

**Example** (from specify-feature skill):
```markdown
After specification is complete, delegate to implementation-planner agent which will use create-implementation-plan skill.
```

### Pattern 4: Automatic Workflow Chains

Commands automatically invoke subsequent commands to complete workflows.

**Example** (SDD workflow):
```
/feature → specify-feature skill creates spec.md
    ↓ (automatic invocation)
/plan → create-implementation-plan skill creates plan.md
    ↓ (automatic invocation)
generate-tasks skill creates tasks.md
    ↓ (automatic invocation)
/audit → validation runs
    ↓ (if PASS)
Ready for /implement
```

### Pattern 5: Hook → Command → Skill

Hooks can trigger workflows that use skills.

**Example** (SessionStart hook):
```
SessionStart hook → detects missing plan.md
    ↓ (recommendation)
User invokes /plan
    ↓ (expansion)
create-implementation-plan skill executes
```

### Pattern 6: Progressive Disclosure

Hooks provide context that guides workflow progression.

**Example** (from session-start.sh):
```
SessionStart hook outputs:
  "Workflow State: needs_plan"
  "Next Action: Create implementation plan with create-implementation-plan skill"

User sees recommendation → invokes /plan → workflow continues
```

---

## Component Interaction Diagrams

### SDD Workflow (Complete Chain)

```
User: /feature
    ↓
specify-feature skill
    ↓ (creates)
spec.md
    ↓ (auto-invokes)
/plan (slash command)
    ↓ (expands to)
create-implementation-plan skill
    ↓ (creates)
plan.md + research.md + data-model.md
    ↓ (auto-invokes)
generate-tasks skill
    ↓ (creates)
tasks.md
    ↓ (auto-invokes)
/audit (slash command)
    ↓ (validation)
PASS → Ready for /implement
    ↓
User: /implement
    ↓ (expands to)
implement-and-verify skill
    ↓ (story-by-story)
P1 implementation + tests
    ↓ (auto-invokes)
/verify --story P1
    ↓ (if PASS)
P2 implementation + tests
    ↓ (auto-invokes)
/verify --story P2
    ↓ (if PASS)
Complete ✓
```

### Hook Integration (Workflow Enforcement)

```
SessionStart hook
    ↓ (detects)
Feature branch: 001-oauth
    ↓ (checks)
Artifacts: spec.md ✓, plan.md ✓, tasks.md ❌
    ↓ (outputs)
"Workflow State: needs_tasks"
"Next Action: Generate tasks"
    ↓
PreToolUse hook (validate-workflow.sh)
    ↓ (validates)
User tries to write code
    ↓ (checks)
tasks.md exists? NO → BLOCK
    ↓ (stderr)
"Cannot write implementation before tasks.md exists"
"Run /tasks first to generate task breakdown"
    ↓
User: /tasks
    ↓
PostToolUse hook (lint-check.sh)
    ↓ (after tasks.md written)
Run linting checks → Report warnings
    ↓
Stop hook (completion-check.sh)
    ↓ (after /tasks completes)
Verify tasks.md has ≥2 ACs per task → PASS
```

### Agent Delegation (Multi-Agent Workflow)

```
User: /analyze "authentication bug"
    ↓
workflow-orchestrator agent
    ↓ (analyzes request)
Task: Bug diagnosis
Target: Authentication system
    ↓ (routes to)
code-analyzer agent
    - Receives: sop-debugging.md
    - Receives: bug-report.md template
    - Allocated: 50,000 token budget
    ↓ (uses skill)
debug-issues skill
    ↓ (intel queries)
project-intel.mjs --search "auth" --json
project-intel.mjs --symbols src/auth.ts --json
    ↓ (targeted reads)
Read src/auth.ts lines 45-67
    ↓ (generates)
YYYYMMDD-HHMM-bug-report-auth-loop.md
    ↓ (SubagentStop hook)
subagent-handover.sh creates handover document
    ↓ (returns to)
workflow-orchestrator
    ↓ (returns to)
User with bug report
```

---

## Advanced Usage Examples

### Example 1: Complete Feature Implementation

```bash
# 1. Start session (hook loads context)
claude

# SessionStart hook outputs:
# "Feature: 001-oauth"
# "Workflow State: needs_spec"
# "Next Action: Create specification with specify-feature skill"

# 2. Create specification (automatic workflow begins)
> /feature "Add OAuth authentication with Google and GitHub"

# specify-feature skill runs interactive dialogue
# Creates: specs/001-oauth/spec.md
# Automatically invokes /plan
# create-implementation-plan skill creates plan.md
# Automatically invokes generate-tasks skill
# Creates: specs/001-oauth/tasks.md
# Automatically invokes /audit
# Audit: PASS - Ready for implementation

# 3. Implement (progressive delivery)
> /implement specs/001-oauth/plan.md

# implement-and-verify skill:
# - Implements P1: Basic OAuth (Google)
# - Automatically invokes /verify --story P1
# - P1 PASS
# - Implements P2: GitHub OAuth
# - Automatically invokes /verify --story P2
# - P2 PASS
# - Complete ✓

# PostToolUse hooks run after each file write (linting)
# Stop hook verifies all ACs satisfied before completion
```

### Example 2: Bug Investigation

```bash
# 1. Start session
claude

# 2. Diagnose bug
> /bug

# /bug command expands, instructs to use debug-issues skill
# User provides: "Users getting logged out randomly"

# debug-issues skill:
# - Queries project-intel.mjs for auth/session code
# - Identifies session timeout at auth.ts:78
# - Verifies with Ref MCP (library docs)
# - Creates bug report with root cause

# 3. Fix bug
> Fix the session timeout issue identified in the bug report

# implement-and-verify skill:
# - Writes test: test_session_timeout.py
# - Implements fix: auth.ts line 78
# - Runs tests: PASS
# - Verifies AC satisfied

# PostToolUse hook runs linting after fix
# Stop hook verifies fix complete
```

### Example 3: Architecture Analysis

```bash
# 1. Analyze codebase
> /analyze

# /analyze command expands, instructs to use analyze-code skill

# analyze-code skill prompts:
"What would you like to analyze?"

> Analyze the authentication architecture

# analyze-code skill:
# - Queries project-intel.mjs --search "auth" --json
# - Queries symbols for each auth file
# - Traces dependencies upstream/downstream
# - Queries Ref MCP for OAuth best practices
# - Reads targeted code sections only
# - Generates report with CoD^Σ trace
# Token usage: 2,400 tokens (vs 22,000 without intel)

# Output: YYYYMMDD-HHMM-report-auth-architecture.md
```

### Example 4: Workflow Violation Prevention

```bash
# 1. User tries to skip workflow
> Write implementation code for OAuth

# PreToolUse hook (validate-workflow.sh):
# - Detects Write tool call
# - Checks: spec.md exists? NO
# - Blocks tool call (exit code 2)
# - stderr: "Cannot write implementation before spec.md exists"
#          "Run /feature first to create specification"

# 2. User follows workflow
> /feature "OAuth authentication"

# Workflow proceeds correctly:
# /feature → spec.md → /plan → plan.md → /tasks → tasks.md → /audit → PASS

# 3. Now implementation allowed
> /implement specs/001-oauth/plan.md

# PreToolUse hook:
# - Checks: spec.md ✓, plan.md ✓, tasks.md ✓
# - Allows tool call
# Implementation proceeds ✓
```

---

## Configuration Reference

### Hook Configuration (.claude/settings.json)

```json
{
  "hooks": {
    "SessionStart": [{
      "hooks": [{
        "type": "command",
        "command": ".claude/hooks/session-start.sh"
      }]
    }],
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": ".claude/hooks/validate-workflow.sh"
      }]
    }],
    "PostToolUse": [{
      "matcher": "Write|Edit|MultiEdit",
      "hooks": [{
        "type": "command",
        "command": ".claude/hooks/lint-check.sh"
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": ".claude/hooks/completion-check.sh"
      }]
    }],
    "SubagentStop": [{
      "hooks": [{
        "type": "command",
        "command": ".claude/hooks/subagent-handover.sh"
      }]
    }]
  }
}
```

### Agent Tool Access

All agents inherit full tool access by default. Tool restrictions can be added via `tools` field in agent frontmatter:

```yaml
---
name: code-analyzer
tools: Bash, Read, Grep, Glob, mcp__Ref__*
---
```

### Command Permissions

All commands support SlashCommand tool invocation by default. To disable:

```yaml
---
disable-model-invocation: true
---
```

---

## Token Efficiency Metrics

| Workflow | Traditional Approach | Intelligence-First | Savings |
|----------|---------------------|-------------------|---------|
| **Bug Analysis** | 18,000-25,000 tokens | 1,800-3,200 tokens | 85-88% |
| **Architecture Analysis** | 35,000-50,000 tokens | 3,500-7,000 tokens | 86-90% |
| **Implementation Planning** | 8,000-15,000 tokens | 1,200-2,500 tokens | 83-85% |
| **Code Review** | 12,000-20,000 tokens | 1,500-3,000 tokens | 85-88% |

**Average Savings**: **80-85%**

**Calculation**:
```
Traditional: Read full files → Search manually → Analyze
Intelligence-First: Query indexes → Read targeted sections → Analyze

Example (Bug Analysis):
  Traditional:
    - Read 15 full files: 12,000 tokens
    - Search context: 3,000 tokens
    - Analysis: 3,000 tokens
    Total: 18,000 tokens

  Intelligence-First:
    - Intel queries: 600 tokens
    - MCP verification: 400 tokens
    - Targeted reads (20 lines × 3 files): 800 tokens
    - Analysis: 1,200 tokens
    Total: 3,000 tokens

  Savings: 83%
```

---

## Troubleshooting

### Issue: Hook not firing

**Diagnosis**:
```bash
# 1. Check settings.json syntax
cat .claude/settings.json | jq .

# 2. Verify hook script exists and is executable
ls -la .claude/hooks/
chmod +x .claude/hooks/*.sh

# 3. Run hook manually with sample JSON
echo '{"session_id":"test"}' | .claude/hooks/session-start.sh

# 4. Check Claude Code logs
claude --debug
```

### Issue: Subagent not routing correctly

**Diagnosis**:
```bash
# 1. Check orchestrator description matches request
cat .claude/agents/workflow-orchestrator.md | grep "description:"

# 2. Verify agent file exists
ls .claude/agents/

# 3. Check agent tool access
cat .claude/agents/code-analyzer.md | grep "tools:"

# 4. Test delegation explicitly
> Use the code-analyzer subagent to analyze this bug
```

### Issue: Slash command not expanding

**Diagnosis**:
```bash
# 1. Check command file exists
ls .claude/commands/analyze.md

# 2. Verify YAML frontmatter valid
head -10 .claude/commands/analyze.md

# 3. Check description field present (required for SlashCommand tool)
grep "description:" .claude/commands/analyze.md

# 4. Test command manually
> /analyze
```

### Issue: Skill not triggering

**Diagnosis**:
```bash
# 1. Check skill file structure
ls .claude/skills/analyze-code/

# 2. Verify YAML frontmatter
head -10 .claude/skills/analyze-code/SKILL.md

# 3. Check description contains trigger phrases
grep "description:" .claude/skills/analyze-code/SKILL.md

# 4. Invoke explicitly
> Use the analyze-code skill to investigate this issue
```

### Issue: Intelligence-first not being followed

**Diagnosis**:
```bash
# 1. Check project-intel.mjs available
which project-intel.mjs
./project-intel.mjs --stats

# 2. Verify PROJECT_INDEX.json exists
ls PROJECT_INDEX.json

# 3. Regenerate index if stale
> /index

# 4. Check skill enforcement
grep "CRITICAL.*intel" .claude/skills/analyze-code/SKILL.md
```

---

## Related Documentation

- **Main README**: [README.md](README.md) - Project overview and quick start
- **Installation Guide**: [INSTALL.md](INSTALL.md) - Complete installation instructions
- **Bootstrap Guide**: [.claude/templates/BOOTSTRAP_GUIDE.md](.claude/templates/BOOTSTRAP_GUIDE.md) - New project setup
- **System Architecture**: [docs/architecture/system-overview.md](docs/architecture/system-overview.md) - Complete system documentation
- **Skills Development**: [docs/guides/developing-agent-skills.md](docs/guides/developing-agent-skills.md) - Creating custom skills

---

## Summary

The Intelligence Toolkit provides:

- **8 Active Hooks**: Automated workflow enforcement, quality gates, context loading
- **4 Specialized Agents**: Orchestration, analysis, planning, implementation
- **15 Slash Commands**: User-facing workflow triggers with automatic chaining
- **10 Skills**: Auto-invoked workflows with intelligence-first enforcement

**Key Innovations**:
1. **Intelligence-First Architecture**: 80%+ token savings via indexed queries
2. **Automatic Workflow Chaining**: One command triggers complete workflows
3. **Progressive Delivery**: Story-by-story implementation with AC verification
4. **Constitutional Governance**: Automated enforcement via hooks and skills
5. **Multi-Agent Coordination**: Specialized agents with proper handovers

**Getting Started**:
```bash
# 1. Verify installation
/bootstrap

# 2. Check system integrity
/system-integrity

# 3. Start a feature
/feature "Your feature description"

# Workflow runs automatically:
# spec.md → plan.md → tasks.md → audit → ready for /implement
```

For additional help, see [README.md](README.md) or run `/help` in Claude Code.
