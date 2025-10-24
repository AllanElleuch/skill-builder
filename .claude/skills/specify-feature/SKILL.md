---
name: Specification Creation
description: Create technology-agnostic feature specifications using intelligence-first queries. Use when user describes what they want to build, mentions requirements, discusses user needs, or says "I want to create/build/implement" something. This skill enforces Article IV Specification-First Development.
degree-of-freedom: low
allowed-tools: Bash(fd:*), Bash(git:*), Bash(mkdir:*), Bash(project-intel.mjs:*), Read, Write, Edit, Grep
---

@.claude/shared-imports/constitution.md
@.claude/shared-imports/CoD_Σ.md
@.claude/templates/feature-spec.md
@.claude/templates/requirements-quality-checklist.md

# Specification Creation

**Purpose**: Generate technology-agnostic feature specifications (WHAT/WHY only, no HOW) with intelligence-backed evidence and structured user stories.

**Constitutional Authority**: Article IV (Specification-First Development), Article I (Intelligence-First Principle), Article II (Evidence-Based Reasoning), Article V (Template-Driven Quality)

---

## Phase 0: Pre-Specification Quality Gate

**CRITICAL**: Validate user input quality BEFORE creating specification.

**Purpose**: Ensure user has provided sufficient context to create a high-quality specification. Block early if description is too vague or technically prescriptive.

**Constitutional Authority**: Article V (Template-Driven Quality) - Quality gates enforce minimum standards

### Step 0.1: Evaluate User Input Quality

Assess user's feature description against 5 quality dimensions (0-10 scale each):

#### 1. Problem Clarity (0-10)
- **10 Points**: Clear problem statement, specific pain points, measurable impact
- **7-9 Points**: Problem stated but could be more specific
- **4-6 Points**: Vague problem description ("improve UX", "make it better")
- **0-3 Points**: No clear problem identified

**Questions**:
- What specific problem is being solved?
- Who experiences this problem?
- What is the measurable impact/cost of the problem?

#### 2. Value Proposition (0-10)
- **10 Points**: Clear business/user value, quantified benefits, success metrics
- **7-9 Points**: Value stated but not quantified
- **4-6 Points**: Implied value but not explicit
- **0-3 Points**: No value justification

**Questions**:
- Why is this feature needed now?
- What value does it deliver (time savings, revenue, user satisfaction)?
- How will success be measured?

#### 3. Requirements Completeness (0-10)
- **10 Points**: Key capabilities described, user scenarios mentioned, constraints stated
- **7-9 Points**: Main capabilities described, some details needed
- **4-6 Points**: Minimal capabilities, many details missing
- **0-3 Points**: Only feature name/title provided

**Questions**:
- What are the main capabilities needed?
- What scenarios should be supported?
- What are the constraints (time, budget, compliance)?

#### 4. Technology-Agnostic (0-10)
- **10 Points**: Zero technical details, pure WHAT/WHY focus
- **7-9 Points**: Minimal technical references, easily clarified
- **4-6 Points**: Some technical prescriptions ("use React", "REST API")
- **0-3 Points**: Heavily technical, implementation-focused

**Questions**:
- Is the description focused on capabilities (WHAT) not implementation (HOW)?
- Are any tech stack choices mentioned that should be removed?

#### 5. User-Centric (0-10)
- **10 Points**: User needs central, personas mentioned, user value clear
- **7-9 Points**: User needs mentioned but not detailed
- **4-6 Points**: System-focused, user needs implied
- **0-3 Points**: No user perspective, purely technical

**Questions**:
- Who are the users and what do they need?
- What user tasks/jobs does this enable?
- How does this improve user experience?

### Step 0.2: Calculate Quality Score

```
overall_score = (problem_clarity + value_proposition + requirements_completeness +
                technology_agnostic + user_centric) / 5
```

**Scoring Thresholds**:
- **≥ 7.0**: **PROCEED** to Phase 1 (intelligence gathering)
- **5.0-6.9**: **CLARIFY** - Request specific improvements, then re-evaluate
- **< 5.0**: **BLOCK** - User description too vague, request complete rework

### Step 0.3: Quality Gate Decision

**IF overall_score < 7.0:**

**BLOCK progression** and report deficiencies to user:

```markdown
# ❌ Pre-Specification Quality Gate: BLOCKED

**Overall Score**: X.X / 10.0 (Minimum required: 7.0)

## Quality Assessment

| Dimension | Score | Status |
|-----------|-------|--------|
| Problem Clarity | X/10 | [PASS/FAIL] |
| Value Proposition | X/10 | [PASS/FAIL] |
| Requirements Completeness | X/10 | [PASS/FAIL] |
| Technology-Agnostic | X/10 | [PASS/FAIL] |
| User-Centric | X/10 | [PASS/FAIL] |

## Deficiencies Identified

### [Dimension < 7.0]: [Score]
**Issue**: [What is missing or unclear]
**Example**: [Current vague statement]
**Needed**: [Specific improvement required]
**Question**: [Clarifying question to ask user]

### [Dimension < 7.0]: [Score]
**Issue**: [What is missing or unclear]
**Example**: [Current vague statement]
**Needed**: [Specific improvement required]
**Question**: [Clarifying question to ask user]

## Required Actions

To proceed with specification, please provide:

1. **[Dimension Name]**: [Specific information needed]
   - Example: "Describe the specific problem: 'Users spend 15+ minutes searching for products, causing 40% cart abandonment'"

2. **[Dimension Name]**: [Specific information needed]
   - Example: "Quantify the value: 'Reduce search time to < 2 seconds, increasing conversions by 20%'"

## How to Improve

**Option 1: Provide Additional Context**
Answer the questions above and re-submit your feature request with more detail.

**Option 2: Use define-product Skill**
If you're unsure of product direction, use the define-product skill to establish:
- User personas and pain points
- Value propositions
- Product principles

**Next**: Once you provide the missing information, I'll re-evaluate and create the specification.
```

**IF overall_score ≥ 7.0:**

**PROCEED to Phase 1** and note quality score:

```markdown
# ✅ Pre-Specification Quality Gate: PASSED

**Overall Score**: X.X / 10.0

Quality assessment complete. Proceeding to intelligence-first specification creation...
```

---

## Phase 1: Intelligence-First Context Gathering

**MANDATORY**: Execute intelligence queries BEFORE any file operations.

### Step 1.1: Auto-Number Next Feature

```bash
!`fd --type d --max-depth 1 '^[0-9]{3}-' specs/ 2>/dev/null | sort | tail -1`
```

Extract highest existing feature number, increment by 1 for next feature.

**Example**:
- Last feature: `specs/003-auth-system`
- Next number: `004`

### Step 1.2: Query Existing Patterns

```bash
!`project-intel.mjs --search "<user-keywords>" --type md --json > /tmp/spec_intel_patterns.json`
```

Search for related features, similar requirements, existing patterns.

**Save evidence** to `/tmp/spec_intel_patterns.json` for CoD^Σ tracing.

### Step 1.3: Understand Project Architecture

```bash
!`project-intel.mjs --overview --json > /tmp/spec_intel_overview.json`
```

Get project structure, tech stack, existing components to inform requirements.

---

## Phase 2: Extract User Requirements (WHAT/WHY Only)

**Article IV Mandate**: Specifications MUST be technology-agnostic.

### Step 2.1: Problem Statement

Extract from user description:
- What problem are they trying to solve?
- Why is this needed?
- Who will use this?
- What value does it provide?

**NO IMPLEMENTATION DETAILS**: No tech stack, no architecture, no "how to build it".

### Step 2.2: User Stories with Priorities

Organize requirements as user stories:

**Format**:
```
## User Story 1 - [Title] (Priority: P1)

**As a** [user type]
**I want to** [capability]
**So that** [value/benefit]

**Why P1**: [Rationale for priority]

**Independent Test**: [How to validate this story works standalone]

**Acceptance Scenarios**:
1. **Given** [state], **When** [action], **Then** [outcome]
2. **Given** [state], **When** [action], **Then** [outcome]
```

**Priority Levels**:
- **P1**: Must-have for MVP (core value)
- **P2**: Important but not blocking (enhances P1)
- **P3**: Nice-to-have (can be deferred)

**Requirement**: Each story MUST be independently testable (Article VII).

### Step 2.3: Functional Requirements (Technology-Agnostic)

Document as testable requirements:

```
- **FR-001**: System MUST [specific capability]
- **FR-002**: Users MUST be able to [interaction]
- **FR-003**: System MUST [behavior]
```

**Mark Unknowns**:
```
- **FR-004**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified]
```

**Maximum 3 [NEEDS CLARIFICATION] markers** - use sparingly, clarify rest through user dialogue.

---

## Phase 3: Generate Specification with CoD^Σ Evidence

### Step 3.1: Create Feature Directory Structure

```bash
NEXT_NUM=$(printf "%03d" $(($(fd --type d --max-depth 1 '^[0-9]{3}-' specs/ 2>/dev/null | wc -l) + 1)))
FEATURE_NAME="<derived-from-user-description>"  # Lowercase, hyphenated, 2-4 words
mkdir -p specs/$NEXT_NUM-$FEATURE_NAME
```

### Step 3.2: Create Git Branch (if git repo)

```bash
if git rev-parse --git-dir >/dev/null 2>&1; then
    git checkout -b "$NEXT_NUM-$FEATURE_NAME"
fi
```

### Step 3.3: Write Specification

Use `@.claude/templates/feature-spec.md` structure with:

1. **YAML Frontmatter**:
   ```yaml
   ---
   feature: <number>-<name>
   created: <YYYY-MM-DD>
   status: Draft
   priority: P1
   ---
   ```

2. **Problem Statement**: What problem are we solving and why?

3. **User Stories**: From Step 2.2 (prioritized, independently testable)

4. **Functional Requirements**: From Step 2.3 (technology-agnostic)

5. **Success Criteria**: Measurable outcomes (not technical metrics)

6. **CoD^Σ Evidence Trace**:
   ```
   Intelligence Queries:
   - project-intel.mjs --search "<keywords>" → /tmp/spec_intel_patterns.json
     Findings: [file:line references to similar features]
   - project-intel.mjs --overview → /tmp/spec_intel_overview.json
     Context: [existing architecture patterns]

   Assumptions:
   - [ASSUMPTION: rationale based on intelligence findings]

   Clarifications Needed:
   - [NEEDS CLARIFICATION: specific question]
   ```

7. **Edge Cases**: Boundary conditions, error scenarios

### Step 3.4: Save Specification

```bash
Write specs/$NEXT_NUM-$FEATURE_NAME/spec.md
```

---

## Phase 4: Report to User

**Output Format**:
```
✓ Feature specification created: specs/<number>-<name>/spec.md

Intelligence Evidence:
- Queries executed: project-intel.mjs --search, --overview
- Patterns found: <file:line references>
- Related features: <existing feature numbers>

User Stories:
- P1 stories: <count> (MVP scope)
- P2 stories: <count> (enhancements)
- P3 stories: <count> (future)

Clarifications Needed:
- [NEEDS CLARIFICATION markers if any, max 3]

**Automatic Next Steps**:
1. If clarifications needed: Use clarify-specification skill
2. Otherwise: **Automatically create implementation plan**

Invoking /plan command now...

[Plan creation, task generation, and audit will proceed automatically]
```

---

## Phase 5: Automatic Implementation Planning

**DO NOT ask user to trigger planning** - this is automatic workflow progression (unless clarifications needed).

### Step 5.1: Check for Clarifications

**If [NEEDS CLARIFICATION] markers exist**:
- Do NOT proceed to planning
- Report clarifications needed to user
- User must run clarify-specification skill or provide answers
- After clarifications, re-run specify-feature skill

**If NO clarifications** (or max 0-1 minor ones):
- Proceed automatically to implementation planning

### Step 5.2: Invoke /plan Command

**Instruct Claude**:

"Specification is complete. **Automatically create the implementation plan**:

Run: `/plan specs/$FEATURE/spec.md`

This will:
1. Create implementation plan with tech stack selection
2. Generate research.md, data-model.md, contracts/, quickstart.md
3. Define ≥2 acceptance criteria per user story
4. **Automatically invoke generate-tasks skill**
5. **Automatically invoke /audit quality gate**

The entire workflow from planning → tasks → audit happens automatically. No manual intervention needed."

### Step 5.3: Workflow Automation

After `/plan` is invoked, the automated workflow proceeds:

```
/plan specs/$FEATURE/spec.md
  ↓ (automatic)
create-implementation-plan skill
  ↓ (automatic)
generate-tasks skill
  ↓ (automatic)
/audit $FEATURE
  ↓
Quality Gate Result: PASS/FAIL
```

**User sees**:
- spec.md created ✓
- plan.md created ✓
- tasks.md created ✓
- audit report generated ✓
- Implementation readiness status

**User only needs to**:
- Review audit results
- Fix any CRITICAL issues (if audit fails)
- Or proceed with `/implement plan.md` (if audit passes)

---

**Note**: This completes specification creation. Next steps happen automatically unless clarifications are needed.
```

**Constitutional Compliance**:
- ✓ Article I: Intelligence queries executed before file operations
- ✓ Article II: CoD^Σ trace with evidence saved to /tmp/*.json
- ✓ Article IV: Specification is technology-agnostic (WHAT/WHY only)
- ✓ Article VII: User stories are independently testable

---

## Anti-Patterns to Avoid

**DO NOT**:
- Include tech stack choices in specification
- Design architecture or data models
- Specify implementation details ("use React hooks", "create API endpoint")
- Create more than 3 [NEEDS CLARIFICATION] markers (clarify through dialogue first)
- Write vague requirements ("system should be fast" → specify "p95 latency < 200ms")

**DO**:
- Focus on user value and business requirements
- Make requirements testable and measurable
- Prioritize user stories (P1, P2, P3)
- Document evidence from intelligence queries
- Limit unknowns (max 3 [NEEDS CLARIFICATION])

---

## Example Execution

**User Input**: "I want to build a user authentication system with social login options"

**Execution**:

1. **Intelligence Queries**:
   ```bash
   fd --type d --max-depth 1 '^[0-9]{3}-' specs/
   # Output: specs/001-dashboard, specs/002-api, specs/003-reporting
   # Next: 004

   project-intel.mjs --search "auth login" --type tsx --json
   # Findings: src/components/Login.tsx:12-45 (existing login form)
   #           src/utils/auth.ts:23 (auth helper functions)
   ```

2. **Extract Requirements**:
   ```
   Problem: Users need to securely access their accounts
   Why: Enable personalized experiences and data security
   Who: End users, administrators
   Value: Secure access, convenience

   User Stories:
   - P1: Basic email/password authentication
   - P2: Social login (Google, GitHub)
   - P3: Two-factor authentication
   ```

3. **Create Feature**:
   ```bash
   mkdir -p specs/004-user-authentication
   git checkout -b 004-user-authentication
   ```

4. **Write Spec** with CoD^Σ evidence, user stories, requirements

5. **Report**:
   ```
   ✓ Feature specification created: specs/004-user-authentication/spec.md

   Intelligence Evidence:
   - Found existing: src/components/Login.tsx:12-45, src/utils/auth.ts:23
   - Pattern: Email/password already partially implemented

   User Stories: 3 total (1 P1, 1 P2, 1 P3)

   Next: Run clarify-specification skill or create-implementation-plan skill
   ```

---

## Prerequisites

Before using this skill:
- ✅ Git repository initialized
- ✅ project-intel.mjs exists and is executable
- ✅ PROJECT_INDEX.json exists (auto-generated)
- ⚠️ Optional: product.md exists (for product-aligned features)

## Dependencies

**Depends On**:
- None (this skill is the entry point to SDD workflow)

**Integrates With**:
- **clarify-specification skill**: Use after this skill if ambiguities exist
- **create-implementation-plan skill**: Use after this skill (auto-invoked via /plan)

**Tool Dependencies**:
- fd (file discovery for feature numbering)
- git (branch creation, feature isolation)
- project-intel.mjs (pattern discovery)

## Next Steps

After specification completes, **automatic workflow progression**:

**Automatic Chain** (no manual intervention needed):
```
specify-feature (creates spec.md)
    ↓ (auto-invokes /plan)
create-implementation-plan (creates plan.md, research.md, data-model.md)
    ↓ (auto-invokes generate-tasks)
generate-tasks (creates tasks.md)
    ↓ (auto-invokes /audit)
/audit (validates consistency)
    ↓ (if PASS)
Ready for /implement
```

**User Action Required**:
- **If audit PASS**: Run `/implement plan.md` to begin implementation
- **If audit FAIL**: Fix CRITICAL issues, then re-run (audit re-validates automatically)
- **If ambiguities found**: clarify-specification skill may be invoked during workflow

**Commands**:
- **/plan spec.md** - Automatically invoked after spec creation
- **/implement plan.md** - User runs after audit passes

## Agent Integration

This skill orchestrates agent delegation through the automatic workflow chain.

### Implementation Planning Agent

**When**: Automatically after spec.md is created (via `/plan` invocation)

**Agent**: implementation-planner

**Delegation Method**: The `/plan` slash command invokes the `create-implementation-plan` skill, which the implementation-planner agent executes.

**What the Planner Receives**:
- spec.md (technology-agnostic specification)
- Constitution requirements (Article IV compliance)
- Project intelligence context (existing patterns via project-intel.mjs)

**What the Planner Returns**:
- plan.md (implementation plan with tasks and ACs)
- research.md (technical research and decisions)
- data-model.md (database/state schema)

### Task Tool Usage (Indirect)

This skill does NOT directly use the Task tool. Instead:

```
specify-feature skill
    ↓ invokes
/plan command (SlashCommand tool)
    ↓ expands to
create-implementation-plan skill
    ↓ executed by
implementation-planner agent (isolated context)
```

**Why This Design**:
- Slash commands provide consistent user interface
- Skills provide reusable workflows
- Agents provide isolated context execution
- Separation of concerns: specify-feature focuses on WHAT/WHY, planner handles HOW

### Expected Workflow

1. **This skill completes**: spec.md created with all requirements
2. **Automatic /plan invocation**: SlashCommand tool runs `/plan spec.md`
3. **Planner agent engaged**: Receives spec, constitution, intelligence context
4. **Planning artifacts created**: plan.md, research.md, data-model.md generated
5. **Automatic task generation**: generate-tasks skill creates tasks.md
6. **Automatic audit**: /audit validates consistency
7. **Ready for implementation**: User runs `/implement plan.md` if audit passes

## Failure Modes

### Common Failures & Solutions

**1. Feature auto-numbering fails**
- **Symptom**: Cannot determine next feature number
- **Solution**: Create specs/ directory: `mkdir -p specs/`
- **Workaround**: Manually specify feature number (e.g., 001-feature-name)

**2. Intelligence queries return no results**
- **Symptom**: No existing patterns found
- **Solution**: This is normal for first features; continue without pattern evidence
- **Note**: Intelligence is opportunistic, not required

**3. Specification too technical**
- **Symptom**: Spec includes implementation details (React, PostgreSQL, etc.)
- **Solution**: Re-run skill with explicit "WHAT/WHY only, no HOW" instruction
- **Prevention**: Review @constitution.md Article IV (Specification-First)

**4. Requirements unclear or incomplete**
- **Symptom**: [NEEDS CLARIFICATION] markers in spec
- **Solution**: clarify-specification skill will be invoked automatically
- **Action**: Answer max 5 structured questions to resolve ambiguities

**5. Git branch creation fails**
- **Symptom**: Cannot create feature branch
- **Solution**: Commit current changes or stash them first
- **Command**: `git stash && git checkout -b <feature-branch>`

**6. Duplicate feature numbers**
- **Symptom**: Feature directory already exists
- **Solution**: Intelligence detected wrong next number; manually increment
- **Prevention**: Ensure consistent ###-name branch naming

## Related Skills & Commands

**Direct Integration**:
- **clarify-specification skill** - Invoked when ambiguities detected
- **create-implementation-plan skill** - Automatically invoked via /plan after spec
- **/feature command** - User-facing command that invokes this skill

**Workflow Context**:
- Position: **Entry point** to SDD workflow (Phase 1)
- Triggers: User describes feature idea, mentions "I want to build", "implement", "create"
- Output: spec.md in specs/###-feature-name/ directory
- Next: Automatic progression to /plan → /tasks → /audit → ready for /implement

---

**Skill Version**: 1.1.0
**Last Updated**: 2025-10-23
**Change Log**:
- v1.1.0 (2025-10-23): Added Phase 0 Pre-Specification Quality Gate
- v1.0.0 (2025-10-22): Initial version with cross-skill references
