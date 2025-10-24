---
name: implement-and-verify
description: Implement tasks from plans with test-first approach, user-story-centric execution, and AC verification. Use proactively when executing implementation plans. Enforces quality gates, MVP-first delivery, and Article VII story-by-story implementation.
degree-of-freedom: low
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

@.claude/shared-imports/constitution.md
@.claude/templates/verification-report.md
@.claude/templates/quality-checklist.md

# Implementation & Verification Skill

## Overview

This skill executes implementation plans following Specification-Driven Development (SDD) principles: quality gates, test-driven development (TDD), user-story-centric execution, and progressive delivery.

**Constitutional Authority**: Article III (Test-First), Article V (Template-Driven Quality), Article VII (User-Story-Centric Organization)

**Core Principles**:
1. **Quality Gates First**: Validate readiness before implementation (Article V)
2. **Story-by-Story**: Implement user stories in priority order (Article VII)
3. **Test-First**: Tests BEFORE implementation, ALL ACs verified (Article III)
4. **Progressive Delivery**: Each story is shippable when complete (Article VII)

**Announce at start:** "I'm using the implement-and-verify skill to execute this plan with SDD quality gates."

## Quick Reference

| Phase | Key Activities | Output | Article |
|-------|---------------|--------|---------|
| **0. Quality Gates** | Validate spec readiness, check constitution | Gate pass/fail | Article V |
| **1. Story Selection** | Load tasks by story (P1, P2, P3) | Story tasks | Article VII |
| **2. Progressive Delivery** | Define MVP, plan incremental shipping | Delivery plan | Article VII |
| **3. Load Tasks** | Read plan, verify dependencies per story | Task selected | Article IV |
| **4. Write Tests** | Create tests from ACs (should FAIL) | Test files | Article III |
| **5. Implement** | Write code to make tests pass | Implementation | Article III |
| **6. Verify** | Run all tests, lint, build | verification-report.md | Article V |
| **7. Update** | Mark complete, handover if needed | Updated plan | Article V |

## Templates You Will Use

- **@.claude/shared-imports/constitution.md** - Architectural principles (all phases)
- **@.claude/templates/quality-checklist.md** - Pre-implementation gates (Phase 0)
- **@.claude/templates/plan.md** - Input plan with tasks and ACs (Phase 3)
- **@.claude/templates/verification-report.md** - Verification results (Phase 6)
- **@.claude/templates/handover.md** - For blocked tasks or agent transitions (Phase 7)

## The Process

Copy this checklist to track progress:

```
SDD Implementation Progress:
- [ ] Phase 0: Quality Gates Validated (constitution check + audit PASS)
- [ ] Phase 1: Story Tasks Loaded (by priority)
- [ ] Phase 2: Progressive Delivery Planned (MVP defined)
- [ ] Phase 3: Tasks Loaded (dependencies verified)
- [ ] Phase 4: Tests Written (from ACs, should FAIL)
- [ ] Phase 5: Implementation Complete
- [ ] Phase 6: Verification Complete (ALL ACs pass)
- [ ] Phase 7: Plan Updated (story marked complete)
```

---

## Phase 0: Quality Gate Validation

**MANDATORY**: Check quality checklists before implementation.

**Constitutional Authority**: Article V (Template-Driven Quality)

### Step 0.1: Load Quality Checklist

Read `.claude/templates/quality-checklist.md`

### Step 0.2: Validate Feature Readiness

Check:
- [ ] All [NEEDS CLARIFICATION] markers resolved (max 0)
- [ ] All user stories have ≥2 acceptance criteria
- [ ] All ACs are testable and measurable
- [ ] Technical plan exists with constitution check
- [ ] Tasks organized by user story

**Example Validation**:
```markdown
Feature: 003-user-authentication

✓ Content Quality: PASS (no tech details in spec.md)
✓ Requirement Completeness: PASS (all ACs in Given/When/Then format)
✗ Feature Readiness: FAIL
  - User Story P2 has only 1 AC (need ≥2)
  - 2 [NEEDS CLARIFICATION] markers in spec.md
```

### Step 0.3: Audit Validation (MANDATORY)

**CRITICAL**: Verify /audit has been run and PASSED before implementation.

**Constitutional Authority**: Article V (Template-Driven Quality) - Quality gates enforce minimum standards

#### Check 1: Audit Report Exists

```bash
# Check for audit report in feature directory
if [ -f "specs/###-feature-name/audit-report.md" ]; then
    echo "✓ Audit report found"
else
    echo "✗ Audit report NOT FOUND"
fi
```

**If audit report missing**:
```markdown
# ❌ Quality Gate Blocked: Audit Required

**Missing**: audit-report.md

**Why Blocked**: Article V requires /audit validation before implementation.

The /audit command validates:
- Cross-artifact consistency (spec.md ↔ plan.md ↔ tasks.md)
- Constitution compliance (Articles I-VII)
- Requirement coverage and traceability
- Missing or duplicate requirements
- Terminology drift across artifacts

**Required Action**:
1. Run: `/audit ###-feature-name`
2. Review audit report for CRITICAL issues
3. Fix any CRITICAL issues
4. Re-run /audit until PASS
5. Then re-run /implement

**Status**: ❌ BLOCKED - Cannot proceed without audit validation
```

**BLOCK implementation** - Do not proceed to Phase 1.

#### Check 2: Audit Result Status

Read `audit-report.md` and extract overall result:
- **PASS**: ✓ Proceed to implementation
- **PASS WITH WARNINGS**: ✓ Proceed (address warnings during development)
- **FAIL**: ❌ BLOCK implementation

**Example audit-report.md check**:
```markdown
## Overall Assessment

**Status**: [PASS | PASS WITH WARNINGS | FAIL]
**Overall Score**: X.X / 10.0
**Critical Issues**: [X]
```

**If Status = FAIL**:
```markdown
# ❌ Quality Gate Blocked: Audit Failed

**Audit Status**: FAIL
**Overall Score**: X.X / 10.0
**Critical Issues**: [X]

**Why Blocked**: /audit identified CRITICAL issues that must be fixed before implementation:

[List critical issues from audit report]

**Required Actions**:
1. Fix CRITICAL issues in [artifact(s)]
2. Re-run /audit to validate fixes
3. Ensure audit status = PASS or PASS WITH WARNINGS
4. Then re-run /implement

**Status**: ❌ BLOCKED - Cannot implement with failing audit
```

**BLOCK implementation** - Do not proceed to Phase 1.

#### Check 3: Critical Issue Count

Extract from audit report:
```markdown
**Critical Issues**: [X]
```

**If Critical Issues > 0**:
```markdown
# ❌ Quality Gate Blocked: Critical Issues Present

**Critical Issue Count**: [X]

Critical issues identified by audit:
[List each critical issue with location and description]

**Why Blocked**: Critical issues represent:
- Constitution violations (blocking)
- Missing requirement coverage
- Contradictory requirements
- Ambiguities preventing implementation

**Required Actions**:
1. Address each CRITICAL issue:
   - [Issue 1]: [Fix action]
   - [Issue 2]: [Fix action]
2. Re-run /audit to validate fixes
3. Ensure Critical Issues = 0
4. Then re-run /implement

**Status**: ❌ BLOCKED - Cannot implement with unresolved critical issues
```

**BLOCK implementation** - Do not proceed to Phase 1.

#### Success Criteria

**PROCEED to Phase 1 only if**:
- ✓ audit-report.md exists
- ✓ Audit Status = PASS or PASS WITH WARNINGS
- ✓ Critical Issues = 0

**Example PASS**:
```markdown
# ✅ Audit Validation: PASSED

**Audit Report**: specs/003-user-authentication/audit-report.md
**Status**: PASS WITH WARNINGS
**Overall Score**: 8.5 / 10.0
**Critical Issues**: 0
**Warnings**: 2 (non-blocking)

Quality gate cleared. Proceeding to implementation...
```

### Step 0.4: User Override Option

**NOTE**: User override is NOT AVAILABLE for audit validation. Audit PASS is mandatory (Article V).

For other quality checks (non-audit):

If validation fails:
```
⚠ Quality checklist incomplete:
- User Story P2 has only 1 AC (need ≥2)

Proceed anyway? (yes/no)
```

**If no**: Block implementation, suggest fixes
**If yes**: Log override, continue with warning

**Enforcement**:
- [ ] Quality checklist loaded
- [ ] All gates checked
- [ ] Audit validation MANDATORY (no override)
- [ ] User override logged if bypassed (non-audit checks only)

---

## Phase 1: Story-by-Story Execution

**Article VII Mandate**: Implement user stories in priority order, verify each independently.

### Step 1.1: Load Tasks by Story

From tasks.md:
- Phase 3: User Story P1 tasks
- Phase 4: User Story P2 tasks
- Phase 5: User Story P3 tasks

**Example**:
```markdown
## Phase 3: User Story P1 - Email/Password Registration

**Story Goal**: Users can create accounts with email and password

**Independent Test**: Can register new user, receive session token, login with credentials

**Dependencies**: Phase 2 (foundational) complete

### Tests
- [ ] T008 [P] [US1] Write test for AC-P1-001
- [ ] T009 [P] [US1] Write test for AC-P1-002

### Implementation
- [ ] T010 [US1] Enhance User model with password_hash
- [ ] T011 [US1] Create AuthService.register()
- [ ] T012 [US1] Implement POST /api/auth/register

### Verification
- [ ] T015 [US1] Run AC tests (must pass 100%)
- [ ] T016 [US1] Test registration flow end-to-end
- [ ] T017 [US1] Verify story works independently
```

### Step 1.2: Implement P1 Story

Execute all tasks for User Story P1:
1. Tests (Article III: tests first)
2. Implementation (minimal code to pass tests)
3. Verification (all P1 ACs pass)

### Step 1.3: Validate P1 Independently

**Independent Test**: Can P1 be demoed without P2/P3?

Verify:
- All P1 tests pass
- P1 can be used standalone
- No dependencies on incomplete stories

### Step 1.4: Report P1 Completion and Verify Story

**After completing P1 implementation**, report status and automatically verify the story:

```
✓ User Story P1 Complete

Tasks: 10 of 10 (100%)
Tests: 2 of 2 passing (100%)
ACs: 2 of 2 verified (100%)

Independent Test: PASS
- Can register new user
- Can login with credentials
- Feature works standalone
```

**Automatic Story Verification**:

Instruct Claude to run: `/verify $PLAN_FILE --story P1`

This validates (Article VII - Progressive Delivery):
- All P1 tests pass independently (100%)
- P1 can be demoed standalone (no dependencies on P2/P3)
- No blocking dependencies on incomplete stories
- Independent test criteria met

**Expected Verification Output**:
```
✓ Story P1 Verification PASSED

Tests: 8/8 passing (100%)
ACs: 4/4 verified (100%)
Independent Test: PASS (story works standalone)
Can Ship: YES

Next: Implement P2 story or ship P1 as MVP
```

**If Verification Fails**:
```
✗ Story P1 Verification FAILED

Tests: 6/8 passing (75%)
ACs: 3/4 verified (75%)
Failures:
- AC-P1-003: Weak password validation failing

Action:
1. Fix failing tests using debug-issues skill
2. Re-run /verify plan.md --story P1
3. Only proceed to P2 after P1 passes
```

**Only proceed to next story after P1 verification passes** (Article VII mandate)

### Step 1.5: Repeat for P2, P3, etc.

**Same process for each story**:
1. Implement all story tasks
2. Verify story independently (run `/verify $PLAN_FILE --story P2`, `/verify $PLAN_FILE --story P3`, etc.)
3. Report completion
4. Only proceed to next story after current story verification passes

**Example for P2**:
```
✓ User Story P2 Complete

Automatic verification: /verify plan.md --story P2

✓ Story P2 Verification PASSED
Tests: 12/12 passing (100%)
ACs: 5/5 verified (100%)
Independent Test: PASS

Next: Implement P3 story
```

**Progressive Delivery Pattern** (Article VII):
- P1 verified → ship MVP or continue to P2
- P2 verified → ship enhancement or continue to P3
- P3 verified → ship final feature or iterate

Each story must pass verification before proceeding to the next

**Enforcement**:
- [ ] Stories implemented in priority order
- [ ] Each story verified independently
- [ ] No story marked complete without 100% ACs passing

---

## Phase 2: Progressive Delivery

**Article VII Principle**: Each story is shippable when complete.

### Step 2.1: MVP Definition

**MVP = User Story P1 complete and verified**

At P1 completion:
- Feature has minimum viable value
- Can be shipped to users
- Independent of P2/P3 stories

### Step 2.2: Incremental Value

Each story adds incremental value:
- P1: Core functionality (MVP)
- P2: Enhancement to P1 (better, not necessary)
- P3: Nice-to-have (future iteration)

### Step 2.3: Ship-When-Ready

After each story verification:
- Option to ship (if P1)
- Option to demo (any story)
- Option to continue (next story)

**Example**:
```
✓ User Story P1 verified independently

Options:
1. Ship MVP now (P1 is complete and working)
2. Continue to P2 (add enhancements)
3. Demo P1 to stakeholders first

Recommendation: Ship P1 as MVP, iterate with P2/P3 based on feedback
```

**Enforcement**:
- [ ] MVP defined (P1 complete = shippable)
- [ ] Each story independently demostrable
- [ ] Shipping options presented after each story

---

## Phase 3: Load Tasks

Read **@.claude/templates/plan.md** file and:

1. **Verify dependencies met:**
   ```markdown
   Task T2 depends on T1
   - [ ] Check T1 status = "completed"
   - [ ] If not complete: BLOCK T2, notify user
   ```

2. **Select next task:**
   - Pick lowest-numbered pending task with dependencies met
   - Or user-specified task

3. **Extract ACs:**
   ```markdown
   ### Task 1: Add OAuth Database Schema
   **Acceptance Criteria:**
   - [ ] AC1: users table has google_id VARCHAR(255) column
   - [ ] AC2: Migration runs without errors
   - [ ] AC3: google_id is nullable
   ```

**Enforcement:**
- [ ] All task dependencies verified
- [ ] Task has minimum 2 ACs
- [ ] ACs are testable

### Phase 4: Write Tests FIRST

**CRITICAL:** Write tests from ACs BEFORE implementing. Tests should FAIL initially.

#### Test-First Workflow

```
For each AC → Write test → Test FAILS → Implement → Test PASSES
```

**Example:**

**AC1:** "users table has google_id VARCHAR(255) column"

**Test (should FAIL initially):**
```typescript
// migrations/002_add_google_id.test.ts
describe('Add google_id column migration', () => {
  it('AC1: adds google_id VARCHAR(255) column to users table', async () => {
    await runMigration('002_add_google_id')

    const schema = await db.getTableSchema('users')
    const googleIdCol = schema.columns.find(c => c.name === 'google_id')

    expect(googleIdCol).toBeDefined()
    expect(googleIdCol.type).toBe('VARCHAR(255)')
  })
})
```

**Run test (should FAIL):**
```bash
npm test migrations/002_add_google_id.test.ts
# FAIL: Column 'google_id' not found
```

✓ **Test failure proves test is valid** - if it passed without implementation, test would be useless!

#### Test Coverage Requirement

**1:1 mapping between ACs and tests:**
```markdown
AC1 → Test 1 (testAddGoogleIdColumn)
AC2 → Test 2 (testMigrationRunsWithoutErrors)
AC3 → Test 3 (testGoogleIdNullable)

Coverage: 3/3 ACs = 100% ✓
```

**Enforcement:**
- [ ] Every AC has corresponding test
- [ ] All tests initially FAIL
- [ ] Tests are specific (not generic)

### Phase 5: Implement

Now implement code to make tests pass.

#### Implementation Guidelines

**Minimal implementation:**
- Write simplest code to pass tests
- Don't over-engineer
- Follow YAGNI (You Aren't Gonna Need It)

**Example:**

```sql
-- migrations/002_add_google_id.sql
ALTER TABLE users ADD COLUMN google_id VARCHAR(255) NULL;
```

```bash
# Run tests again (should PASS now)
npm test migrations/002_add_google_id.test.ts
# PASS: All 3 tests pass ✓
```

**If tests still fail:**
1. Debug using analyze-code skill
2. Fix implementation
3. Re-run tests
4. Repeat until all pass

**Enforcement:**
- [ ] Implementation is minimal (YAGNI)
- [ ] Follows project conventions
- [ ] All tests pass

### Phase 6: Verify Against ACs

Run complete verification using **@.claude/templates/verification-report.md**

#### Verification Checklist

```markdown
## AC Verification

### Task 1: Add OAuth Database Schema

#### AC1: users table has google_id VARCHAR(255) column
- **Test:** testAddGoogleIdColumn
- **Status:** ✓ PASS
- **Evidence:** Test output shows column exists with correct type

#### AC2: Migration runs without errors
- **Test:** testMigrationRunsWithoutErrors
- **Status:** ✓ PASS
- **Evidence:** Migration completes with exit code 0

#### AC3: google_id is nullable
- **Test:** testGoogleIdNullable
- **Status:** ✓ PASS
- **Evidence:** Schema shows NULL constraint

**Coverage:** 3/3 ACs = 100% ✓
```

#### Additional Checks

Beyond AC tests, also run:

```bash
# Lint checks
npm run lint

# Type checks (if TypeScript)
npm run type-check

# Build
npm run build

# Integration tests
npm run test:integration
```

#### Handling Failures

**If ANY AC fails:**

```markdown
Status: BLOCKED ❌

Failing: AC2 (Migration runs without errors)
Error: "Column google_id already exists"

Action:
1. Use analyze-code skill to debug
2. Fix issue
3. Re-run verification
4. DO NOT mark task complete until 100% pass
```

**If unfixable after debugging:**
1. Create **@.claude/templates/handover.md**
2. Document blocker
3. Mark task as "blocked"
4. Handover to appropriate agent

**Enforcement:**
- [ ] ALL ACs verified (100% coverage)
- [ ] All ACs pass
- [ ] Lint passes
- [ ] Build succeeds
- [ ] No task marked complete with failures

### Phase 7: Update Plan & Handover

#### Update plan.md

```markdown
### Task 1: Add OAuth Database Schema
- **ID:** T1
- **Status:** ✓ completed  # ← Update this
- **Completed:** 2025-10-19T15:30:00Z
- **Verified by:** executor-agent

**Acceptance Criteria:**
- [x] AC1: users table has google_id column ✓
- [x] AC2: Migration runs without errors ✓
- [x] AC3: google_id is nullable ✓
```

#### Generate Verification Report

Use **@.claude/templates/verification-report.md**:

```markdown
---
plan_id: "plan-oauth-implementation"
status: "pass"
verified_by: "executor-agent"
timestamp: "2025-10-19T15:30:00Z"
---

# Verification Report: Task T1 Complete

## Test Summary
- Total ACs: 3
- Passed: 3 ✓
- Failed: 0
- Coverage: 100%

## AC Coverage
[Detailed results for each AC]

## Recommendations
None - all ACs passed, ready for next task
```

**File naming:** `YYYYMMDD-HHMM-verification-<task-id>.md`

#### Generate Handover (if needed)

**When to create handover:**
- Task blocked on external dependency
- Need different agent (e.g., analyzer for debugging)
- Phase complete, moving to next phase

Use **@.claude/templates/handover.md**:

```markdown
---
from_agent: "executor-agent"
to_agent: "code-analyzer"
chain_id: "oauth-implementation"
timestamp: "2025-10-19T15:30:00Z"
---

# Handover: Task T1 Complete → T2 Ready

## Essential Context
- Completed: T1 (OAuth database schema)
- Next: T2 (OAuth flow implementation)
- Blocker: Need to analyze existing session.ts before implementing

## Pending
- T2: Implement OAuth flow
- T3-T7: Remaining tasks

## Blockers
None for T1. T2 needs analysis of existing auth system.

## Intel Links
- src/auth/session.ts (existing session management)
- migrations/002_add_google_id.sql (just created)
```

**Enforcement:**
- [ ] Plan updated with task status
- [ ] Verification report generated
- [ ] Handover created if transitioning
- [ ] Handover ≤ 600 tokens

## Few-Shot Examples

### Example 1: Successful Implementation

**Input:** Task T1 from plan.md
```markdown
### Task 1: Add email validation to login form
**Acceptance Criteria:**
- AC1: Email field rejects invalid formats
- AC2: Email field shows error message
- AC3: Form submission blocked until valid
```

**Execution (CoD^Σ):**
```
Step 1: → WriteTests (from ACs, should FAIL)
  ↳ File: src/components/LoginForm.test.tsx
  ↳ Tests:
    - testRejectsInvalidEmail (AC1)
    - testShowsErrorMessage (AC2)
    - testBlocksSubmission (AC3)

Step 2: → RunTests (expect FAIL)
  ↳ Command: npm test LoginForm.test.tsx
  ↳ Result: 3 failed ✗ (expected - not implemented yet)

Step 3: → Implement
  ↳ File: src/components/LoginForm.tsx:45
  ↳ Code: validateEmail regex + error display + disabled submit

Step 4: → RunTests (expect PASS)
  ↳ Command: npm test LoginForm.test.tsx
  ↳ Result: 3 passed ✓

Step 5: ∘ VerifyACs
  ↳ AC1: ✓ Test passes
  ↳ AC2: ✓ Test passes
  ↳ AC3: ✓ Test passes
  ↳ Coverage: 100%
  ↳ Status: TASK COMPLETE ✓
```

### Example 2: Failing AC → Debug → Fix

**Input:** Task T2 with AC failure
```markdown
### Task 2: Database migration for OAuth
**Acceptance Criteria:**
- AC1: Migration creates google_id column
- AC2: Migration runs without errors
```

**Execution:**
```
Step 1: → Implement
  ↳ File: migrations/002_add_google_id.sql
  ↳ Code: ALTER TABLE users ADD COLUMN google_id VARCHAR(255);

Step 2: → RunMigration
  ↳ Command: npm run migrate
  ↳ Result: ERROR - column google_id already exists ❌

Step 3: → VerifyACs
  ↳ AC1: ✗ FAIL (column exists but migration errored)
  ↳ AC2: ✗ FAIL (migration errored)
  ↳ Status: BLOCKED

Step 4: → Debug (use analyze-code skill)
  ↳ Query: project-intel.mjs --search "google_id"
  ↳ Data: Found in migrations/001_initial.sql (already added!)

Step 5: ∘ Fix
  ↳ Resolution: Migration 002 is duplicate
  ↳ Action: Mark task as "not needed (already done in 001)"
  ↳ Update plan status

Step 6: → ReVerifyACs
  ↳ AC1: ✓ Column exists (from migration 001)
  ↳ AC2: ✓ No errors (skip duplicate migration)
  ↳ Status: COMPLETE ✓
```

### Example 3: Rollback on Breaking Change

**Input:** Task T5 causing test failures
```markdown
### Task 5: Refactor API response format
**Acceptance Criteria:**
- AC1: New format includes { data, meta }
- AC2: All existing API tests pass
- AC3: No breaking changes to clients
```

**Execution:**
```
Step 1: → Implement
  ↳ File: src/api/format.ts
  ↳ Change: Return { data: result, meta: {...} }

Step 2: → RunTests
  ↳ Command: npm test
  ↳ Result: 15 tests FAILED ✗

Step 3: → VerifyACs
  ↳ AC1: ✓ New format works
  ↳ AC2: ✗ FAIL - 15 tests expect old format
  ↳ AC3: ✗ FAIL - breaking change detected
  ↳ Status: BLOCKED (ACs failed)

Step 4: → Rollback
  ↳ Command: git checkout src/api/format.ts
  ↳ Reason: Breaking change violates AC3

Step 5: → UpdatePlan
  ↳ Add task T5.1: Update all tests FIRST
  ↳ Add task T5.2: Then change API format
  ↳ Dependencies: T5.1 → T5.2

Step 6: ∘ Handover
  ↳ Create handover.md to planner
  ↳ Reason: Plan needs revision (missed dependency)
```

## Enforcement Rules

### Rule 1: No Completion Without Passing ACs

**❌ Violation:**
```markdown
Task: Add login feature
Status: ✓ Complete
Test Results: 2 passed, 1 failed
```

**✓ Correct:**
```markdown
Task: Add login feature
Status: BLOCKED
Test Results: 2 passed, 1 failed
Action:
1. Debug failing test
2. Fix implementation
3. Re-run tests
4. Mark complete ONLY when all pass
```

### Rule 2: Test-First Mandatory

**❌ Violation:**
```
1. Implement feature
2. Write tests after
3. Tests pass (but might not be testing the right thing)
```

**✓ Correct:**
```
1. Write tests from ACs (tests FAIL)
2. Implement feature
3. Tests PASS (proves implementation works)
```

### Rule 3: 100% AC Coverage

**❌ Violation:**
```markdown
Total ACs: 3
Tested ACs: 2
Coverage: 67%  # Not acceptable!
```

**✓ Correct:**
```markdown
Total ACs: 3
Tested ACs: 3
Coverage: 100% ✓
```

## Common Pitfalls

| Pitfall | Impact | Solution |
|---------|--------|----------|
| Implementing before tests | Can't verify correctness | Write tests FIRST always |
| Skipping lint/build | Broken code deployed | Run full verification suite |
| Marking complete with failures | Incomplete implementation | Block until 100% pass |
| No verification report | Can't track progress | Generate report every time |

## When to Use This Skill

**Use implement-and-verify when:**
- User has a plan ready to execute
- User wants to implement tasks with TDD
- User needs AC verification
- User says "implement the plan"

**Don't use when:**
- No plan exists yet (use create-plan skill)
- User just wants to analyze code (use analyze-code skill)
- User wants to debug (use debugging skill)

## Related Skills & Commands

- **Create-plan skill** - Creates the plan this skill executes
- **Debugging skill** - For debugging failed ACs
- **Analyze-code skill** - For understanding existing code before implementation
- **/implement command** - User-invoked implementation (can invoke this skill)
- **/verify command** - User-invoked verification (part of this skill)

## Success Metrics

**Verification Quality:**
- 100% AC coverage required
- All ACs must pass
- No task complete without verification

**Implementation Quality:**
- Tests written first
- Minimal implementation (YAGNI)
- Lint and build pass

## Prerequisites

Before using this skill:
- ✅ tasks.md exists (Article IV: tasks before implementation)
- ✅ plan.md exists with ≥2 ACs per user story
- ✅ spec.md exists with user stories and priorities
- ✅ All [NEEDS CLARIFICATION] markers resolved (or override approved)
- ✅ Audit has passed (or CRITICAL issues resolved)
- ⚠️ Optional: quality-checklist.md validated (Article V quality gate)
- ⚠️ Optional: Test framework set up (for TDD)

## Dependencies

**Depends On**:
- **specify-feature skill** - Provides spec.md with user stories
- **create-implementation-plan skill** - Provides plan.md with ACs and tech stack
- **generate-tasks skill** - MUST run before this skill (Article IV)
- **/audit command** - Should have passed before implementation starts

**Integrates With**:
- **debug-issues skill** - Use when tests fail or ACs don't pass
- **analyze-code skill** - Use when understanding existing code before modifying
- **/verify command** - Automatically invoked after each story completes

**Tool Dependencies**:
- Read, Write, Edit tools (code implementation)
- Bash tool (running tests, builds, linters)
- Grep, Glob tools (finding files and code patterns)

## Next Steps

After implementation completes, **automatic workflow progression per story**:

**Automatic Chain** (per User Story):
```
implement-and-verify (implements story P1)
    ↓ (auto-invokes /verify)
/verify plan.md --story P1 (validates P1 independently)
    ↓ (if PASS)
Ready for P2 OR ship MVP
    ↓ (if user continues)
implement-and-verify (implements story P2)
    ↓ (auto-invokes /verify)
/verify plan.md --story P2 (validates P2 independently)
    ↓ (if PASS)
Ready for P3 OR ship enhancement
    ↓ (continues for all stories)
```

**User Action Required**:
- **After P1 verification passes**: Decision to ship MVP or continue to P2
- **After any story passes**: Can ship incrementally (Article VII progressive delivery)
- **If verification fails**: Debug with debug-issues skill, fix, re-verify

**Outputs Created** (per story):
- `YYYYMMDD-HHMM-verification-P#.md` - Story verification report
- `YYYYMMDD-HHMM-handover-*.md` - If blocked or transitioning agents
- Updated `tasks.md` with completed tasks marked
- Test files (created before implementation per Article III)

**Commands**:
- **/verify plan.md --story P#** - Automatically invoked after each story
- **/bug** - If tests fail and debugging needed
- **/analyze** - If existing code analysis needed

## Agent Integration

This skill is designed to run within the executor-implement-verify agent's isolated context.

### Executor Agent Execution

**When**: User runs `/implement plan.md` (manual action)

**Agent**: executor-implement-verify

**Delegation Method**: The `/implement` slash command can launch the executor agent with this skill

**Task Tool Invocation** (by orchestrator or user):
```python
Task(
    subagent_type="executor-implement-verify",
    description="Implement tasks from plan with TDD",
    prompt="""
    @.claude/agents/executor-implement-verify.md

    Implement the tasks in plan.md following test-driven development:
    1. Read plan.md and tasks.md
    2. Implement user stories in priority order (P1 → P2 → P3)
    3. Follow TDD: write tests first, implement to pass
    4. Verify each story independently with /verify --story P#
    5. Create handover if blocked

    Target: specs/[feature]/plan.md
    Expected: Progressive delivery with AC verification per story
    """
)
```

**What Executor Receives**:
- plan.md (implementation plan with tech stack)
- tasks.md (user-story-organized task breakdown)
- spec.md (for context on requirements)
- Constitution (Article III TDD, Article VII progressive delivery)
- Templates: verification-report.md, handover.md

**What Executor Returns**:
- Implemented code (tests + implementation)
- Verification reports per story (YYYYMMDD-HHMM-verification-P#.md)
- Handover documents if blocked (YYYYMMDD-HHMM-handover-*.md)
- Updated tasks.md with completion status

### Supporting Agents (When Needed)

**Code Analyzer** - For understanding existing code:
```python
# Executor can delegate to analyzer if needed
Task(
    subagent_type="code-analyzer",
    description="Analyze existing auth module before modification",
    prompt="""
    @.claude/agents/code-analyzer.md

    Analyze src/auth/*.ts to understand current implementation
    before adding OAuth support. Use project-intel.mjs first.
    Output: analysis report with architecture and dependencies.
    """
)
```

**Debugger** - For test failures:
```python
# Executor can delegate to analyzer in debug mode
Task(
    subagent_type="code-analyzer",
    description="Debug failing OAuth integration test",
    prompt="""
    @.claude/agents/code-analyzer.md

    Debug why OAuth callback test is failing with 401 error.
    Use debug-issues skill workflow.
    Output: bug-report.md with root cause and fix.
    """
)
```

### Handover Protocols

**To Planner** (if requirements unclear):
- Create handover.md documenting ambiguity
- Planner clarifies or updates plan
- Resume implementation after resolution

**To Orchestrator** (if blocked by external dependency):
- Create handover.md documenting blocker
- Orchestrator coordinates resolution
- Resume implementation after unblocked

### Verification Workflow

**Automatic /verify Invocation**:
```
implement-and-verify skill (completes story P1)
    ↓ invokes
/verify plan.md --story P1 (SlashCommand tool)
    ↓ runs
AC validation for story P1 only
    ↓ produces
verification-P1.md (PASS/FAIL report)
```

**Progressive Delivery** (Article VII):
- P1 verified → Ship MVP or continue to P2
- P2 verified → Ship enhancement or continue to P3
- Each story independently testable and shippable

## Failure Modes

### Common Failures & Solutions

**1. Quality gates not validated before implementation**
- **Symptom**: Starting implementation without checking quality-checklist.md
- **Solution**: Run Phase 0 quality gate validation (Article V)
- **Prevention**: Skill enforces quality-checklist.md check at start

**2. Tests written after implementation (Article III violation)**
- **Symptom**: Code exists, then tests written (tests might not catch issues)
- **Solution**: Delete code, write tests first, watch them FAIL, then implement
- **Enforcement**: Tests must FAIL initially to prove they're valid

**3. Acceptance criteria coverage < 100%**
- **Symptom**: Some ACs not tested, verification incomplete
- **Solution**: Create test for EVERY AC (1:1 mapping)
- **Requirement**: No task marked complete unless all ACs have passing tests

**4. Tests passing without implementation (false positives)**
- **Symptom**: Tests pass immediately when written (before code exists)
- **Solution**: Tests are broken (not testing anything); rewrite tests to FAIL first
- **Prevention**: Always verify tests FAIL before implementing

**5. Story verification skipped**
- **Symptom**: Moving to P2 without verifying P1 independently
- **Solution**: MUST run /verify plan.md --story P1 before continuing to P2
- **Enforcement**: Article VII requires each story verified standalone

**6. Story depends on incomplete stories (violates independence)**
- **Symptom**: P2 tests fail because P3 not implemented yet
- **Solution**: Refactor P2 to be independent; update spec.md if dependency is valid
- **Requirement**: Each story must pass "Independent Test" criteria

**7. Marking tasks complete with failing tests**
- **Symptom**: Task status = "completed" but tests show failures
- **Solution**: NEVER mark task complete with failures; status MUST be "blocked"
- **Enforcement**: 100% AC pass rate required before completion

**8. Skipping lint, type-check, or build verification**
- **Symptom**: Tests pass but lint errors or build fails
- **Solution**: Run full verification suite (lint, type-check, build, tests)
- **Requirement**: ALL checks must pass, not just AC tests

**9. Over-engineering implementation (YAGNI violation)**
- **Symptom**: Code implements features not in ACs, unnecessary abstractions
- **Solution**: Write minimal code to pass tests, nothing more
- **Prevention**: Follow YAGNI (You Aren't Gonna Need It) principle

**10. No handover created for blocked tasks**
- **Symptom**: Task blocked but no documentation of blocker
- **Solution**: Create handover.md (≤600 tokens) with blocker details
- **Pattern**: Use debug-issues skill if technical block, handover to appropriate agent

**11. Progressive delivery not followed (implementing all stories at once)**
- **Symptom**: Implementing P1, P2, P3 together instead of verifying P1 first
- **Solution**: Complete P1 → verify → decide to ship or continue (Article VII)
- **Benefit**: MVP can ship after P1 passes, faster time-to-value

## Related Skills & Commands

**Direct Integration**:
- **specify-feature skill** - Provides spec.md with user stories (workflow start)
- **create-implementation-plan skill** - Provides plan.md with ACs (workflow predecessor)
- **generate-tasks skill** - Provides tasks.md with task breakdown (required predecessor)
- **debug-issues skill** - Use when tests fail or blockers occur
- **analyze-code skill** - Use when existing code needs understanding
- **/implement command** - User-facing command that invokes this skill
- **/verify command** - Automatically invoked after each story (per P1, P2, P3)

**Workflow Context**:
- Position: **Phase 4** of SDD workflow (final execution phase)
- Triggers: User runs /implement plan.md after audit passes
- Output: Implemented code + verification reports per story

**Quality Gates**:
- **Pre-Implementation**: quality-checklist.md validation (Article V)
- **Per-Story**: /verify --story P# automatic validation (Article VII)
- **Test-First**: Tests written before implementation (Article III)
- **100% AC Coverage**: Every AC must have passing test

**Progressive Delivery Pattern** (Article VII):
```
P1 implemented → /verify --story P1 → PASS → Ship MVP or Continue
P2 implemented → /verify --story P2 → PASS → Ship Enhancement or Continue
P3 implemented → /verify --story P3 → PASS → Ship Complete Feature
```

Each story is independently shippable, enabling faster value delivery.

## Version

**Version:** 1.1.0
**Last Updated:** 2025-10-23
**Owner:** Claude Code Intelligence Toolkit

**Change Log**:
- v1.1.0 (2025-10-23): Added Phase 0 Step 0.3 - Mandatory audit validation enforcement
- v1.0.0 (2025-10-22): Initial version with cross-skill references
