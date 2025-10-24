---
name: create-plan
description: Create detailed implementation plans from feature specs or bug reports with testable acceptance criteria. Use proactively when planning features, refactors, or fixes. Every task MUST have minimum 2 testable ACs and map to requirements.
---

# Implementation Planning Skill

## Overview

This skill transforms feature specifications and bug reports into detailed, executable implementation plans with testable acceptance criteria.

**Core principle:** Every task has minimum 2 ACs. Every requirement maps to task(s). Use intel to identify dependencies.

**Announce at start:** "I'm using the create-plan skill to build an implementation plan."

## Quick Reference

| Phase | Key Activities | Output |
|-------|---------------|--------|
| **1. Load Spec** | Extract requirements and constraints | Requirements list |
| **2. Task Breakdown** | Create granular tasks (2-8 hours each) | Task list with 2+ ACs each |
| **3. Dependencies** | Identify file & task dependencies | Dependency graph |
| **4. Validate** | Verify 100% requirement coverage | Complete plan.md |

## Templates You Will Use

- **@.claude/templates/feature-spec.md** - Input spec (already created or create if missing)
- **@.claude/templates/plan.md** - Output plan with tasks and ACs
- **@.claude/templates/bug-report.md** - Alternative input for bug fixes

## Intelligence Tool Guide

- **@.claude/shared-imports/project-intel-mjs-guide.md** - For dependency analysis

## The Process

Copy this checklist to track progress:

```
Planning Progress:
- [ ] Phase 1: Spec Loaded (requirements extracted)
- [ ] Phase 2: Tasks Broken Down (2+ ACs per task)
- [ ] Phase 3: Dependencies Identified (via project-intel.mjs)
- [ ] Phase 4: Plan Validated (100% requirement coverage)
```

### Phase 1: Load Input Spec

**Input Options:**
1. **feature-spec.md** - For new features
2. **bug-report.md** - For bug fixes
3. **Natural language** - Create spec first if needed

**Extract:**
- Requirements (REQ-001, REQ-002, etc.)
- Constraints (technical, timeline, scope)
- Success criteria

**If no spec exists**, create one first using **@.claude/templates/feature-spec.md**

**Example:**
```markdown
## Requirements from feature-spec-oauth.md
- REQ-001: Users can log in with Google OAuth
- REQ-002: Sessions persist for 7 days
- REQ-003: Users can log out

## Constraints
- Must work with existing auth system
- No breaking changes to current users
- Deploy incrementally
```

**Enforcement:**
- [ ] All requirements identified
- [ ] Constraints documented
- [ ] Success criteria clear

### Phase 2: Task Breakdown

Break each requirement into **granular, testable tasks**.

#### Task Sizing Guidelines
- **Ideal:** 2-8 hours per task
- **Too large:** "Implement authentication system" (break it down!)
- **Just right:** "Add google_id column to users table"

#### AC Requirements

**CRITICAL:** Every task MUST have minimum 2 testable acceptance criteria.

**AC Format:**
```markdown
### Task 1: Add OAuth Database Schema
- **ID:** T1
- **Owner:** executor-agent
- **Estimated:** 2 hours
- **Dependencies:** None

**Acceptance Criteria:**
- [ ] AC1: users table has google_id VARCHAR(255) column
- [ ] AC2: Migration runs without errors
- [ ] AC3: google_id is nullable (existing users don't have it)
```

**Testable means:**
- Can verify pass/fail objectively
- No ambiguity
- Specific enough to implement

**Examples:**

❌ **Bad ACs (vague):**
- "OAuth works"
- "System is secure"
- "Code is clean"

✓ **Good ACs (testable):**
- "OAuth redirect returns 302 with correct Google URL"
- "Session token expires after exactly 7 days"
- "Logout endpoint returns 200 and clears session cookie"

#### Use CoD^Σ for Task Breakdown

```markdown
**Input:** REQ-001: Users can log in with Google OAuth

**Breakdown Process (CoD^Σ):**
```
Step 1: → IntelQuery("existing auth")
  ↳ Query: project-intel.mjs --search "auth" --type ts
  ↳ Data: Found src/auth/session.ts, src/auth/middleware.ts

Step 2: ∘ BreakdownByLayer
  ↳ Database: T1 (add schema)
  ↳ Backend: T2 (OAuth flow), T3 (session management)
  ↳ Frontend: T4 (login button), T5 (callback handler)
  ↳ Testing: T6 (E2E test)

Step 3: → DefineACs
  ↳ T1-AC1: google_id column added
  ↳ T1-AC2: Migration succeeds
  ↳ T2-AC1: OAuth redirect works
  ↳ T2-AC2: Token validation passes
  ↳ T3-AC1: Session stored for 7 days
  ↳ T3-AC2: Session retrieval works
  ↳ ... (2-3 ACs per task)
```
```

**Enforcement:**
- [ ] Each task is 2-8 hours
- [ ] Each task has minimum 2 ACs
- [ ] All ACs are testable (pass/fail clear)
- [ ] Tasks are granular (not "implement entire feature")

### Phase 3: Identify Dependencies

Use project-intel.mjs to identify both **file dependencies** and **task dependencies**.

#### File Dependencies

```bash
# Find what files we'll need to modify
project-intel.mjs --search "auth|session" --json

# Check dependencies of key files
project-intel.mjs --dependencies src/auth/session.ts --direction upstream --json

# Check what depends on files we'll modify (impact analysis)
project-intel.mjs --dependencies src/auth/session.ts --direction downstream --json
```

**Example:**
```
Found existing files:
- src/auth/session.ts (stores sessions)
- src/auth/middleware.ts (validates sessions)

T2 (OAuth flow) will import from session.ts
T3 (session management) will modify session.ts
→ T2 depends on T3 being completed first
```

#### Task Dependencies

Map out which tasks must complete before others:

```markdown
## Task Dependency Graph

**Sequential:**
- T1 (DB schema) → T2 (OAuth backend) → T3 (UI)

**Parallel after T1:**
- T4 (session storage) can run parallel to T2
- T5 (logout endpoint) needs T2 complete

**Final:**
```
T1 (DB)
 ├→ T2 (OAuth) ─→ T3 (UI) ─→ T6 (E2E test)
 └→ T4 (Session) ─→ T5 (Logout) ─┘
```
```

**Enforcement:**
- [ ] All file dependencies identified via project-intel.mjs
- [ ] Task dependencies mapped (no circular deps!)
- [ ] Parallel vs sequential tasks identified
- [ ] Critical path identified

### Phase 4: Validate Plan

Final validation before plan is complete:

#### Validation Checklist

```markdown
## Plan Validation

### Requirement Coverage
- [ ] REQ-001 → T1, T2, T3 ✓
- [ ] REQ-002 → T4, T5 ✓
- [ ] REQ-003 → T6, T7 ✓
- [ ] Coverage: 100% ✓

### Task Quality
- [ ] All tasks have 2+ ACs
- [ ] All ACs are testable
- [ ] No vague tasks ("make it work")

### Dependencies
- [ ] All dependencies identified
- [ ] No circular dependencies
- [ ] Critical path defined

### Completeness
- [ ] Risks identified
- [ ] Testing strategy defined
- [ ] Rollback plan considered
```

#### Generate plan.md

Use **@.claude/templates/plan.md** with:

1. **Goal:** High-level objective
2. **Tasks:** Each with ID, owner, ACs, dependencies
3. **Dependencies:** Dependency graph
4. **Risks:** Potential blockers
5. **Verification:** How to verify completion

**File Naming:**
`YYYYMMDD-HHMM-plan-<id>.md`

Example: `20250119-1440-plan-oauth-implementation.md`

**Enforcement:**
- [ ] Template structure followed
- [ ] All sections populated
- [ ] File named correctly

## Planning Patterns

### Pattern 1: Feature Planning

**Characteristics:**
- Multiple requirements
- Cross-cutting changes (DB, backend, frontend)
- Phased rollout possible

**Strategy:**
1. Group by layer (DB, backend, frontend, testing)
2. Start with schema/infrastructure
3. Build up to user-facing features
4. End with E2E tests

**Example:** See Few-Shot Example 1 in planner agent

### Pattern 2: Refactor Planning

**Characteristics:**
- Improve existing code
- Must maintain behavior
- Risk of breaking changes

**Strategy:**
1. Use intel to understand current implementation
2. Create comprehensive tests FIRST
3. Small, incremental refactors
4. Verify no regressions at each step

**Example:** See Few-Shot Example 2 in planner agent

### Pattern 3: Migration Planning

**Characteristics:**
- Large-scale change
- Must support both old and new
- Gradual rollout

**Strategy:**
1. Run both systems in parallel
2. Migrate incrementally
3. Feature flags for gradual rollout
4. Only deprecate old after 100% migration

**Example:** See Few-Shot Example 3 in planner agent

## Few-Shot Example: Feature Planning

**Input:** feature-spec-oauth.md
```
Requirements:
- REQ-001: Users can log in with Google OAuth
- REQ-002: Sessions persist for 7 days
- REQ-003: Users can log out
```

**Planning Process (CoD^Σ):**
```
Step 1: → LoadSpec
  ↳ Source: feature-spec-oauth.md
  ↳ Requirements: 3

Step 2: ∘ BreakdownTasks
  ↳ REQ-001 → T1 (DB schema), T2 (OAuth flow), T3 (UI)
  ↳ REQ-002 → T4 (Session storage), T5 (Expiry logic)
  ↳ REQ-003 → T6 (Logout endpoint), T7 (Clear session)

Step 3: ⇄ IntelQuery("dependencies")
  ↳ Query: project-intel.mjs --search "auth|session"
  ↳ Data: Existing: src/auth/session.ts (can reuse)

Step 4: → DefineACs
  ↳ T1-AC1: users.google_id column exists
  ↳ T1-AC2: Migration runs successfully
  ↳ T2-AC1: OAuth redirect works
  ↳ T2-AC2: Google token validates
  ↳ ... (2+ ACs per task)

Step 5: ∘ Validate
  ↳ REQ-001 → T1, T2, T3 ✓
  ↳ REQ-002 → T4, T5 ✓
  ↳ REQ-003 → T6, T7 ✓
  ↳ All tasks have 2+ ACs ✓
```

**Output:** plan.md with 7 tasks, each with 2-3 ACs

## Enforcement Rules

### Rule 1: Minimum 2 ACs Per Task

**❌ Violation:**
```markdown
### Task: Add login button
**Acceptance Criteria:**
- Button exists
```

**✓ Correct:**
```markdown
### Task: Add login button
**Acceptance Criteria:**
- [ ] AC1: Button renders with "Log in with Google" text
- [ ] AC2: Button click triggers OAuth redirect to Google
- [ ] AC3: Button shows loading state during authentication
```

### Rule 2: All Requirements → Tasks

**❌ Violation:**
```markdown
Requirements: REQ-001, REQ-002, REQ-003
Tasks: T1 (for REQ-001), T2 (for REQ-001)
# Missing REQ-002 and REQ-003!
```

**✓ Correct:**
```markdown
Requirements: REQ-001, REQ-002, REQ-003
Tasks:
- T1, T2 (REQ-001)
- T3, T4 (REQ-002)
- T5 (REQ-003)
Coverage: 100% ✓
```

### Rule 3: No Vague Tasks

**❌ Violation:**
```markdown
### Task: Fix the auth system
### Task: Make it work
### Task: Improve performance
```

**✓ Correct:**
```markdown
### Task: Add missing setState dependency to useEffect
### Task: Validate OAuth token expiry
### Task: Replace N+1 query with single JOIN query
```

## Common Pitfalls

| Pitfall | Impact | Solution |
|---------|--------|----------|
| Tasks too large | Can't estimate, hard to verify | Break into 2-8 hour chunks |
| Vague ACs | Can't verify completion | Make testable (pass/fail clear) |
| Missing dependencies | Blocked tasks | Use project-intel.mjs to find deps |
| No requirement coverage | Incomplete implementation | Validate 100% coverage |

## When to Use This Skill

**Use create-plan when:**
- User has a feature spec or bug report ready
- User asks "how should I implement X?"
- User wants to plan before coding
- User wants task breakdown with estimates

**Don't use when:**
- User wants to start coding immediately (use execution skill)
- User needs to analyze code first (use analyze-code skill)
- User just has a rough idea (use brainstorming skill first)

## Related Skills & Commands

- **Brainstorming skill** - For refining rough ideas before planning
- **Analyze-code skill** - For understanding existing code before refactor planning
- **Execution skill** - For implementing the plan after creation
- **/plan command** - User-invoked planning (can invoke this skill)

## Success Metrics

**Plan Quality:**
- 100% requirement coverage
- 100% of tasks have 2+ ACs
- No circular dependencies

**Estimating:**
- Tasks sized to 2-8 hours
- Critical path identified
- Parallel work opportunities noted

## Prerequisites

Before using this skill:
- ✅ spec.md OR bug report exists (input requirement)
- ✅ project-intel.mjs exists and is executable
- ✅ PROJECT_INDEX.json exists (run `/index` if missing)
- ⚠️ Optional: Feature directory structure exists: specs/<feature>/
- ⚠️ Optional: clarification-checklist.md for ambiguity validation
- ⚠️ Optional: MCP tools configured (Ref for library docs)

**Note**: For the main SDD workflow, use **create-implementation-plan skill** instead, which provides:
- Constitutional pre/post-design gates (Article VI)
- Automatic research.md and data-model.md generation
- Enhanced intelligence-first architecture queries
- Automatic generate-tasks invocation

This skill (create-plan) is for simpler planning use cases or legacy compatibility.

## Dependencies

**Depends On**:
- **specify-feature skill** - Provides spec.md (for feature planning)
- **debug-issues skill** - Provides bug diagnosis (for bug fix planning)
- project-intel.mjs - For codebase intelligence queries

**Integrates With**:
- **generate-tasks skill** - Uses plan.md output to create tasks.md
- **implement-and-verify skill** - Uses plan.md for implementation guidance
- **/audit command** - Validates plan against spec for consistency

**Modern Alternative**:
- **create-implementation-plan skill** - Preferred for SDD workflow (more comprehensive)

**Tool Dependencies**:
- project-intel.mjs (codebase intelligence)
- Read tool (to load spec.md or bug-report.md)
- Write tool (to create plan.md)

## Next Steps

After plan creation completes, typical progression:

**Simple Workflow** (using this skill):
```
create-plan (creates plan.md)
    ↓ (manual invocation)
generate-tasks (user runs /tasks plan.md)
    ↓ (automatic)
/audit (auto-invoked by generate-tasks)
    ↓ (if PASS)
/implement plan.md
```

**Recommended SDD Workflow** (using create-implementation-plan):
```
specify-feature (creates spec.md)
    ↓ (auto-invokes /plan)
create-implementation-plan (creates plan.md, research.md, data-model.md)
    ↓ (auto-invokes generate-tasks)
generate-tasks (creates tasks.md)
    ↓ (auto-invokes /audit)
/audit (validates consistency)
    ↓ (if PASS)
/implement plan.md
```

**User Action Required**:
- Review plan.md for completeness
- Run `/tasks plan.md` to generate task breakdown (if using simple workflow)
- Resolve any [NEEDS CLARIFICATION] markers before implementation

**Outputs Modified**:
- `plan.md` (or `specs/$FEATURE/plan.md`) - Implementation plan with ACs
- May suggest creating research.md, data-model.md (but doesn't auto-generate)

**Commands**:
- **/tasks plan.md** - After creating plan, generate user-story-organized tasks
- **/implement plan.md** - After tasks and audit, begin implementation
- **/audit [feature-id]** - Validate cross-artifact consistency

## Failure Modes

### Common Failures & Solutions

**1. No input specification or bug report**
- **Symptom**: Skill has no requirements to plan against
- **Solution**: Create spec.md with specify-feature skill OR provide bug report
- **Prevention**: Always start with /feature for features, /bug for bugs

**2. Acceptance Criteria fewer than 2 per task (Article III violation)**
- **Symptom**: Tasks have 0 or 1 AC, not independently testable
- **Solution**: Add minimum 2 testable ACs per task
- **Enforcement**: Article III: Test-First Imperative requires ≥2 ACs
- **Pattern**: Each AC should be verifiable without implementation knowledge

**3. Plan created without intelligence queries (Article I violation)**
- **Symptom**: Plan references files/functions without file:line evidence
- **Solution**: Query project-intel.mjs before making architectural decisions
- **Prevention**: Skill should enforce intel queries in Phase 1

**4. Missing CoD^Σ evidence traces**
- **Symptom**: Plan claims "similar pattern exists" without file:line reference
- **Solution**: Add CoD^Σ trace with file:line (e.g., `auth.tsx:45`)
- **Enforcement**: Article II: Evidence-Based Reasoning requires traces

**5. No user story organization (Article VII violation)**
- **Symptom**: Tasks not organized by user story priority (P1, P2, P3)
- **Solution**: Group tasks by user story, mark priorities
- **Prevention**: generate-tasks skill enforces this, but plan should structure for it

**6. Complexity not justified (Article VI potential violation)**
- **Symptom**: Plan introduces abstraction without simplicity justification
- **Solution**: Add "Pre-Design Constitution Check" (gates before design)
- **Better**: Use create-implementation-plan skill which enforces this

**7. Plan doesn't map to spec requirements**
- **Symptom**: /audit reports missing requirement coverage
- **Solution**: Ensure every spec requirement has corresponding plan tasks
- **Prevention**: Reference spec.md sections explicitly in plan

**8. Ambiguities not flagged**
- **Symptom**: Plan proceeds despite specification gaps
- **Solution**: Add [NEEDS CLARIFICATION] markers for ambiguities
- **Article IV**: Max 3 markers, trigger clarify-specification skill

**9. Tasks not independently testable**
- **Symptom**: Task A depends on Task B to be testable
- **Solution**: Restructure tasks to be independently verifiable
- **Article VII**: Each user story must be independently testable

**10. plan.md doesn't follow template structure**
- **Symptom**: Missing sections, inconsistent format
- **Solution**: Reference @.claude/templates/plan.md template
- **Article V**: Template-Driven Quality requires template adherence

**11. No parallel work identified**
- **Symptom**: All tasks marked sequential when some could run parallel
- **Solution**: Review dependency graph, mark independent tasks with [P]
- **Article VIII**: Parallelization markers enable concurrent execution

**12. Estimates too optimistic or missing**
- **Symptom**: Tasks lack time estimates OR all marked "1 hour"
- **Solution**: Realistic 2-8 hour estimates per task
- **Prevention**: Review historical task completion times

## Related Skills & Commands

**Direct Integration**:
- **specify-feature skill** - Creates spec.md input for this skill (feature planning)
- **debug-issues skill** - Creates bug diagnosis input for this skill (bug fix planning)
- **generate-tasks skill** - Uses plan.md output to create tasks.md (successor)
- **/plan command** - User-facing command that invokes create-implementation-plan (NOT this skill)

**Modern Replacement**:
- **create-implementation-plan skill** - Enhanced version for SDD workflow:
  - Includes constitutional pre/post-design gates
  - Auto-generates research.md, data-model.md
  - Auto-invokes generate-tasks
  - Enforces Article VI simplicity checks

**Workflow Context**:
- Position: **Phase 2** of SDD workflow (after specification, before tasks)
- Triggers: User mentions "plan" OR "how to implement" (but /plan invokes create-implementation-plan)
- Output: plan.md with implementation strategy and ACs

**Quality Gates**:
- **Article III**: ≥2 testable ACs per task
- **Article IV**: Specification must exist before plan
- **Article V**: Must follow plan.md template structure

**Workflow Comparison**:
```
Legacy/Simple:
specify-feature → create-plan (this skill) → manual /tasks → /implement

Current SDD:
specify-feature → create-implementation-plan → generate-tasks (auto) → /audit (auto) → /implement
```

**Recommendation**: For new development, prefer create-implementation-plan skill for comprehensive planning with automatic workflow progression.

## Version

**Version:** 1.0
**Last Updated:** 2025-10-22
**Owner:** Claude Code Intelligence Toolkit
