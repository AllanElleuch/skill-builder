# /audit Command Guide

**Purpose**: Cross-artifact consistency and quality analysis for Specification-Driven Development (SDD)

**Version**: 1.0.0
**Created**: 2025-10-19

---

## Overview

The `/audit` command is the critical **quality gate** in our SDD workflow that runs **after task generation** but **before implementation** begins. It performs comprehensive cross-artifact analysis to ensure:

1. **Constitution compliance** across all 7 Articles
2. **Requirement coverage** - every requirement has implementation tasks
3. **Zero ambiguities** - all specifications are testable and measurable
4. **No duplications** - requirements and tasks are unique
5. **Artifact consistency** - terminology, data models, and architecture align

---

## When to Use

### In the SDD Workflow

```
/feature (spec.md)
  ↓
/plan (plan.md)
  ↓
generate-tasks skill (tasks.md)
  ↓
/audit ← YOU ARE HERE (quality gate)
  ↓
/implement (if audit passes)
  ↓
/verify (post-implementation)
```

### Trigger Points

**Always run `/audit` when**:
- ✅ All three artifacts exist (spec.md, plan.md, tasks.md)
- ✅ Tasks have been generated from the plan
- ✅ BEFORE starting any implementation work

**Re-run `/audit` when**:
- 🔄 Spec updated after clarification
- 🔄 Plan revised based on new constraints
- 🔄 Tasks modified or regenerated
- 🔄 Previous audit found CRITICAL issues (after fixes)

---

## Usage

### Basic Usage

```bash
# Auto-detect feature from git branch
> /audit

# Specify feature explicitly
> /audit 001-user-authentication

# With focus area (emphasizes specific aspects)
> /audit 001-user-authentication "focus on security requirements"
> /audit 002-oauth "check Article III TDD compliance"
```

### Advanced Usage

**With focus area:**
```bash
# Focus on security aspects
> /audit 001-feature "focus on security requirements"

# Emphasize specific Article
> /audit 002-feature "check Article III TDD compliance"

# Performance-oriented review
> /audit 003-feature "verify performance NFRs coverage"
```

**Focus area effects:**
- Prioritizes relevant findings
- Adds context to analysis
- Emphasizes specific constitution articles
- Does NOT change pass/fail criteria

**Environment variables:**
```bash
# Override constitution path
> CONSTITUTION_PATH=./custom/constitution.md /audit 001-feature

# Use SPECIFY_FEATURE for automation
> SPECIFY_FEATURE=001-feature /audit
```

### Prerequisites

Before running `/audit`, ensure:
1. ✓ Feature directory exists: `specs/[feature-id]/`
2. ✓ `spec.md` is complete (no [NEEDS CLARIFICATION] markers)
3. ✓ `plan.md` exists with architecture and phases
4. ✓ `tasks.md` exists with user-story-organized tasks
5. ✓ Constitution exists: `.claude/shared-imports/constitution.md`

**If any artifact is missing**, `/audit` will abort with clear instructions on which command to run.

---

## What It Checks

### 1. Constitution Alignment (CRITICAL Priority)

Checks all 7 Articles:

**Article I: Intelligence-First Principle**
- Does plan reference project-intel.mjs queries?
- Are file reads preceded by intelligence queries in tasks?

**Article II: Evidence-Based Reasoning (CoD^Σ)**
- Does spec include file:line evidence for existing patterns?
- Does plan have CoD^Σ traces for architectural decisions?

**Article III: Test-First Imperative (TDD)**
- Each task has ≥2 testable acceptance criteria?
- Tests written BEFORE implementation in task order?

**Article IV: Specification-First Development**
- Spec complete (no [NEEDS CLARIFICATION])?
- Plan created AFTER spec?
- Tasks created AFTER plan?
- Spec is technology-agnostic (no HOW, only WHAT/WHY)?

**Article V: Template-Driven Quality**
- Spec follows feature-spec.md template?
- Plan follows plan.md template?
- Tasks follow tasks.md template?

**Article VI: Simplicity & Anti-Abstraction**
- No over-engineering in plan?
- Max 3 architectural patterns justified?
- Framework used directly?

**Article VII: User-Story-Centric Organization**
- Tasks grouped by user story (P1, P2, P3)?
- Each story has independent test criteria?
- MVP-first delivery order?

### 2. Coverage Analysis

**Requirements → Tasks Mapping:**
- Every requirement has ≥1 associated task
- Coverage percentage calculated
- Uncovered requirements flagged (especially P1)

**Tasks → Requirements Mapping:**
- Every task maps to ≥1 requirement
- Orphaned tasks flagged
- NFR implementation verified

### 3. Quality Issues Detection

**Ambiguity Detection:**
- Vague adjectives: "fast", "scalable", "secure" (no criteria)
- Unresolved placeholders: TODO, TKTK, ???, `<placeholder>`
- Missing acceptance criteria

**Duplication Detection:**
- Near-duplicate requirements (similar phrasing)
- Duplicate tasks (same action, different wording)

**Underspecification:**
- Requirements missing measurable outcomes
- User stories without acceptance criteria
- Tasks referencing undefined entities

**Inconsistency Detection:**
- Terminology drift (same concept, different names)
- Data entity conflicts (spec vs plan)
- Task ordering contradictions
- Architectural conflicts

### 4. Severity Classification

| Severity | Blocks Implementation? | Examples |
|----------|------------------------|----------|
| **CRITICAL** | ✗ YES | Constitution MUST violation, missing artifacts, zero coverage for P1 requirement |
| **HIGH** | ⚠ Risky | Ambiguous security/performance, untestable ACs, conflicting requirements |
| **MEDIUM** | ⚠ Proceed with caution | Terminology drift, missing NFR coverage, task ordering issues |
| **LOW** | ✓ OK | Style inconsistencies, minor redundancy, documentation gaps |

---

## Output

### Generated Report

Creates timestamped report: `YYYYMMDD-HHMM-audit-[feature-id].md`

**Report Structure:**

```markdown
# Specification Audit Report

**Feature**: 001-user-authentication
**Date**: 2025-10-19 14:30
**Audited Artifacts**: spec.md, plan.md, tasks.md
**Constitution Version**: 1.0.0

## Executive Summary
- Total Findings: 12
- Critical: 2 | High: 5 | Medium: 3 | Low: 2
- Implementation Ready: NO
- Constitution Compliance: FAIL

## Findings
| ID | Category | Severity | Location(s) | Summary | Recommendation |
|----|----------|----------|-------------|---------|----------------|
| C1 | Constitution | CRITICAL | spec.md:L45 | Article IV violated | Remove HOW, keep WHAT/WHY |
| A1 | Ambiguity | HIGH | spec.md:L120 | NFR "fast response" lacks criteria | Specify "< 200ms p95" |

## Coverage Analysis
- Requirements: 25 total
- Covered: 23 (92%)
- Uncovered: 2 (8%) ← **CRITICAL for P1**

## Constitution Alignment
| Article | Status | Violations | Notes |
|---------|--------|------------|-------|
| I: Intelligence-First | ✓ PASS | 0 | ... |
| II: Evidence-Based | ✗ FAIL | 2 | Missing CoD^Σ traces |
| ...

## Implementation Readiness
- ✗ NOT READY (resolve 2 CRITICAL issues first)

## Next Actions
1. Resolve CRITICAL findings:
   - Run clarify-specification skill
   - Re-run /plan with updated spec
2. Re-audit after fixes: `/audit 001-user-authentication`
```

### Remediation Offer

After generating the report, `/audit` asks:

> "I've identified 2 CRITICAL and 5 HIGH priority issues. Would you like me to:
> 1. Suggest specific edits to resolve CRITICAL issues?
> 2. Generate a remediation plan for all issues?
> 3. Proceed with current state (acknowledging risks)?"

**Important**: `/audit` is **read-only**. It never modifies files automatically. User must:
- Approve remediation suggestions explicitly
- Execute edits manually or via other commands
- Re-run `/audit` after fixes

---

## Success Criteria

### ✅ Audit Passes (Ready to Implement)

When audit shows:
- ✓ Zero CRITICAL findings
- ✓ Constitution compliance: PASS for all 7 Articles
- ✓ Coverage ≥ 95% for P1 requirements
- ✓ No [NEEDS CLARIFICATION] markers remain
- ✓ All P1 user stories have independent test criteria
- ✓ Implementation Ready: YES

**You can safely proceed with `/implement`**

### ❌ Audit Fails (Not Ready)

When audit shows:
- ✗ Any CRITICAL findings present
- ✗ Constitution violations (MUST statements)
- ✗ P1 requirements without coverage
- ✗ Ambiguities or placeholders in spec

**Must resolve issues and re-audit before implementation**

---

## Common Scenarios

### Scenario 1: First Audit After Task Generation

```bash
# Generate tasks
> generate-tasks skill invoked via natural language

# Run audit
> /audit 001-feature

# Audit finds: 3 CRITICAL (constitution violations)
# Fix spec.md and plan.md
> /feature  # Re-run specification
> /plan specs/001-feature/spec.md

# Re-audit
> /audit 001-feature

# Audit passes: 0 CRITICAL, ready to implement
> /implement specs/001-feature/plan.md
```

### Scenario 2: Audit Finds Coverage Gaps

```bash
> /audit 002-feature

# Report shows:
# - Uncovered: "User can reset password" (P1 requirement)
# - No tasks found for password reset flow

# Fix by regenerating tasks with updated plan
> /plan specs/002-feature/spec.md  # Ensure plan covers reset
# Manually invoke generate-tasks skill

# Re-audit
> /audit 002-feature
```

### Scenario 3: Audit Finds Ambiguities

```bash
> /audit 003-feature

# Report shows:
# - HIGH: NFR "system should be fast" lacks criteria
# - MEDIUM: "scalable" undefined

# Run clarification
> clarify-specification skill invoked
# Update spec.md with:
# - "Response time < 200ms p95"
# - "Support 10k concurrent users"

# Re-audit
> /audit 003-feature
```

---

## Integration Points

### With SDD Skills

**Upstream (generate input for audit):**
- `specify-feature` → creates spec.md
- `clarify-specification` → refines spec.md
- `create-implementation-plan` → creates plan.md
- `generate-tasks` → creates tasks.md

**Downstream (consume audit output):**
- `implement-and-verify` → executes tasks after audit passes
- All skills reference constitution → audit checks enforcement

### With Hooks

**Potential Integration** (not yet implemented):
- `PostToolUse:Write[tasks.md]` → auto-trigger `/audit`
- `PreToolUse:Task[implement-and-verify]` → require audit pass

### With Templates

Uses these templates for structured analysis:
- `feature-spec.md` → validates spec structure
- `plan.md` → validates plan structure
- Template validation is part of Article V compliance

---

## Comparison with Other Commands

### Command Comparison Matrix

| Command | Phase | Purpose | Input | Output | Modifies Files? |
|---------|-------|---------|-------|--------|----------------|
| **/feature** | 1. Specification | Create technology-agnostic spec | User requirements | spec.md | ✅ Yes (creates) |
| **/plan** | 2. Planning | Generate implementation plan | spec.md | plan.md | ✅ Yes (creates) |
| **generate-tasks** | 3. Task Generation | Create task list | spec.md + plan.md | tasks.md | ✅ Yes (creates) |
| **→ /audit** | **4. Quality Gate** | **Verify consistency** | **spec + plan + tasks** | **audit report** | **❌ No (read-only)** |
| **/implement** | 5. Implementation | Execute tasks with TDD | plan.md + tasks.md | Code changes | ✅ Yes (writes code) |
| **/verify** | 6. Verification | Check ACs met | spec.md + code | verification report | ❌ No (validation) |
| **/validate** | 6. Validation | Validate against requirements | spec.md + code | validation report | ❌ No (validation) |

### Key Distinctions

**`/audit` vs `/verify`:**
- **Audit**: Pre-implementation (checks artifacts for consistency)
- **Verify**: Post-implementation (checks code meets acceptance criteria)
- **Timing**: Audit BEFORE /implement, Verify AFTER /implement

**`/audit` vs `/validate`:**
- **Audit**: Checks spec/plan/tasks against constitution
- **Validate**: Checks implementation against spec requirements
- **Focus**: Audit = artifact consistency, Validate = code correctness

**`/audit` vs `/plan`:**
- **Audit**: Read-only verification of existing plan
- **Plan**: Creates or updates implementation plan
- **When**: Run /plan first, then /audit to verify

### Workflow Position

```
Specification → Planning → Task Generation
                                ↓
                          → /audit ← YOU ARE HERE
                                ↓
                    (If audit passes)
                                ↓
                    Implementation → Verification
```

**Critical Rule:** Never skip `/audit` between task generation and implementation. It's your quality gate that prevents costly rework.

---

## Detailed Command Workflow

### Full SDD Cycle with Audit

```
┌─────────────────────────────────────────────────────────┐
│  /feature: Create spec.md (WHAT/WHY)                    │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│  /plan: Create plan.md (HOW with tech stack)            │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│  generate-tasks: Create tasks.md (user-story tasks)     │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│  /audit: Check consistency ◄── QUALITY GATE             │
├──────────────────────┬──────────────────────────────────┤
│  PASS?               │  FAIL?                            │
└──────┬───────────────┴──────────┬───────────────────────┘
       │ YES                       │ NO
       ▼                           ▼
┌──────────────────┐      ┌──────────────────────────────┐
│  /implement      │      │  Fix artifacts               │
│  Write code      │      │  (spec/plan/tasks)           │
└─────┬────────────┘      └──────┬───────────────────────┘
      │                           │
      │                           └──────────┐
      ▼                                      │
┌──────────────────────────────────┐        │
│  /verify: Check ACs              │        │
├──────────────────┬───────────────┤        │
│  PASS?           │  FAIL?        │        │
└──────┬───────────┴───────┬───────┘        │
       │ YES               │ NO             │
       ▼                   ▼                │
    ✅ Complete      Fix code ──────────────┘
                     Re-verify
```

### When to Use Which Command

**Before Implementation:**
1. `/feature` - You have requirements but no spec
2. `/plan` - You have spec but no plan
3. `generate-tasks` - You have plan but no tasks
4. **`/audit`** - You have all artifacts, need verification
5. `/implement` - Audit passed, ready to code

**After Implementation:**
1. `/verify` - Check specific acceptance criteria
2. `/validate` - Comprehensive requirement validation
3. `/audit` - Re-check if requirements changed

**During Development:**
- `/audit` - After significant spec/plan/task changes
- `/verify` - After completing user story
- `/validate` - Before marking feature complete

---

## Best Practices

### Do's ✅

1. **Always run after task generation** - Don't skip the audit step
2. **Fix CRITICAL issues immediately** - Block implementation until resolved
3. **Re-audit after fixes** - Verify issues are actually resolved
4. **Use remediation suggestions** - Let Claude propose specific fixes
5. **Track audit reports** - Keep them for traceability

### Don'ts ❌

1. **Don't implement with CRITICAL findings** - High risk of rework
2. **Don't ignore constitution violations** - They're CRITICAL for a reason
3. **Don't skip re-audit after fixes** - Verify fixes worked
4. **Don't expect auto-fixes** - Audit is read-only by design
5. **Don't audit incomplete artifacts** - Wait until all 3 files exist

---

## Troubleshooting

### Issue: Audit Can't Find Feature

**Symptoms**: "Feature not found" or "FEATURE_DIR not detected"

**Solutions**:
1. Check git branch name: `git branch --show-current`
   - Should match pattern: `^[0-9]{3}-`
2. Specify feature explicitly: `/audit 001-feature-name`
3. Set environment: `export SPECIFY_FEATURE=001-feature-name`

### Issue: Missing Artifacts

**Symptoms**: "spec.md MISSING" or "tasks.md not found"

**Solutions**:
- Missing spec.md → Run `/feature` or specify-feature skill
- Missing plan.md → Run `/plan specs/[id]/spec.md`
- Missing tasks.md → Invoke generate-tasks skill
- Missing constitution → Check `.claude/shared-imports/constitution.md`

### Issue: False Positives

**Symptoms**: Audit flags something as issue but it's actually fine

**Solutions**:
1. Review finding details (file:line references)
2. Check if it's LOW severity (may be stylistic)
3. Provide feedback: "Audit finding A5 is incorrect because..."
4. Consider if it's truly a constitution violation

### Issue: Too Many Findings

**Symptoms**: Audit produces 50+ findings, overwhelming

**Solutions**:
1. Focus on CRITICAL first (only blockers)
2. Address HIGH severity next (significant risks)
3. Batch-fix MEDIUM/LOW issues later
4. Use remediation suggestions for guidance

---

## Technical Details

### File Paths

**Input Artifacts**:
- `specs/[feature-id]/spec.md`
- `specs/[feature-id]/plan.md`
- `specs/[feature-id]/tasks.md`
- `.claude/shared-imports/constitution.md`

**Output Report**:
- `specs/[feature-id]/YYYYMMDD-HHMM-audit-[feature-id].md`

### Allowed Tools

The `/audit` command is configured with:
```yaml
allowed-tools: Bash(fd:*), Bash(cat:*), Bash(jq:*), Read, Grep
```

This ensures it can:
- Find features with `fd`
- Read artifacts with `cat`/`Read`
- Search content with `Grep`
- Parse JSON with `jq`

But **cannot**:
- Write or Edit files (read-only enforcement)
- Execute arbitrary bash commands
- Modify git state

### Intelligence Integration

Uses `project-intel.mjs` to:
- Validate file references in tasks
- Check if symbols exist before flagging as undefined
- Provide evidence for CoD^Σ traces

```bash
project-intel.mjs --search "ComponentName" --json
```

---

## Related Documentation

- **Constitution**: `.claude/shared-imports/constitution.md`
- **SDD Skills**: `.claude/skills/specify-feature/`, etc.
- **Templates**: `.claude/templates/feature-spec.md`, `plan.md`
- **Planning**: `planning.md` (Master Plan V3)

---

## Future Enhancements

**Potential improvements** (not yet implemented):

1. **Auto-trigger**: Hook to run `/audit` automatically after task generation
2. **Incremental audit**: Only check changed artifacts since last audit
3. **Custom rules**: Project-specific audit rules beyond constitution
4. **Metrics tracking**: Audit history and trends over time
5. **Fix suggestions**: More specific remediation with exact diffs

---

**Remember**: `/audit` is your safety net. Use it liberally. Better to catch issues before implementation than during or after.
