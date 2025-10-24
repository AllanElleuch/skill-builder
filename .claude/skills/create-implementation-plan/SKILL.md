---
name: Implementation Planning
description: Create technical implementation plans from specifications with intelligence-backed architectural decisions. Use when specification exists and user mentions tech stack, architecture, implementation approach, or asks "how to implement" or "how to build" the feature.
degree-of-freedom: medium
allowed-tools: Bash(project-intel.mjs:*), Read, Write, Edit
---

@.claude/shared-imports/constitution.md
@.claude/shared-imports/CoD_Σ.md
@.claude/templates/plan.md
@.claude/templates/research-template.md
@.claude/templates/data-model-template.md

# Implementation Planning

**Purpose**: Transform technology-agnostic specifications into technical implementation plans with architecture decisions, tech stack selection, and acceptance criteria mapping.

**Constitutional Authority**: Article IV (Specification-First Development), Article VI (Simplicity & Anti-Abstraction), Article I (Intelligence-First Principle)

---

## Phase 0: Pre-Design Constitutional Gates

**MANDATORY**: Check Article VI limits BEFORE design.

### Step 0.1: Validate Specification Exists

PreToolUse hook will block plan.md creation without spec.md, but verify explicitly:

```bash
FEATURE=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "${SPECIFY_FEATURE:-}")
if [[ ! -f "specs/$FEATURE/spec.md" ]]; then
    echo "ERROR: Cannot create plan without specification (Article IV violation)"
    echo "Next: Run specify-feature skill or use /feature command"
    exit 1
fi
```

### Step 0.2: Constitution Check (Article VI)

Read specification and assess complexity against Article VI gates.

**Gate 1: Project Count (MAX 3)**
- **Rule**: Maximum 3 projects for initial implementation
- **Check**: Count distinct deployable units implied by spec
- **If > 3**: Violation detected → require justification

**Gate 2: Abstraction Layers (MAX 2 per concept)**
- **Rule**: Maximum 2 abstraction layers per concept
- **Check**: No repository/service/facade patterns unless documented
- **If > 2**: Violation detected → require justification

**Gate 3: Framework Trust (Use directly)**
- **Rule**: Use framework features directly (no custom wrappers)
- **Check**: No reinvention of framework capabilities
- **If wrappers present**: Violation detected → require justification

#### Gate Decision Process

**For each gate**, assess and report:

```markdown
## Pre-Design Constitutional Gates

### Gate 1: Project Count
**Status**: [PASS ✓ | NEEDS JUSTIFICATION ⚠ | VIOLATION ✗]
**Count**: [X] projects
**Details**: [List projects identified from spec]
**Decision**: [PROCEED | NEEDS JUSTIFICATION]

### Gate 2: Abstraction Layers
**Status**: [PASS ✓ | NEEDS JUSTIFICATION ⚠ | VIOLATION ✗]
**Details**: [Abstraction analysis]
**Decision**: [PROCEED | NEEDS JUSTIFICATION]

### Gate 3: Framework Trust
**Status**: [PASS ✓ | NEEDS JUSTIFICATION ⚠ | VIOLATION ✗]
**Details**: [Framework usage analysis]
**Decision**: [PROCEED | NEEDS JUSTIFICATION]

---

**Overall Pre-Design Gate**: [PASS ✓ | CONDITIONAL ⚠ | BLOCKED ✗]
```

#### Violation Handling

**IF any gate = VIOLATION (no justification)**:

```markdown
# ❌ Constitutional Gate BLOCKED

**Violations Detected**: [X]

**Gate [N]**: [Gate Name] - VIOLATION
- **Issue**: [What violates the constitution]
- **Specification**: [Where in spec.md this comes from]
- **Article VI Limit**: [What the limit is]
- **Detected Count**: [What the actual count is]

**Required Action**:
1. Provide justification in Complexity Justification Table
2. Document why simpler alternative won't work
3. Get approval for complexity increase

**Complexity Justification Table**:

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [Gate violated] | [Specific reason] | [Why 3 projects insufficient, etc.] |

**Status**: ⚠ Conditional proceed with documented justification
```

**IF all gates = PASS**:

```markdown
# ✅ Pre-Design Constitutional Gates: PASSED

All Article VI gates cleared:
- ✓ Gate 1: Project Count ≤ 3
- ✓ Gate 2: Abstraction Layers ≤ 2 per concept
- ✓ Gate 3: Framework Trust maintained (no unnecessary wrappers)

Proceeding to intelligence-first context gathering...
```

---

## Phase 1: Intelligence-First Context Gathering

**Article I Mandate**: Query before reading files.

### Step 1.1: Search for Existing Patterns

```bash
!`project-intel.mjs --search "<tech-stack-keywords>" --type "tsx,ts,py,go" --json > /tmp/plan_intel_patterns.json`
```

**Example**:
- If spec mentions "authentication" → search for "auth login session"
- If spec mentions "real-time" → search for "websocket socket io"

**Save evidence** to `/tmp/plan_intel_patterns.json`

### Step 1.2: Analyze Project Architecture

```bash
!`project-intel.mjs --overview --json > /tmp/plan_intel_overview.json`
```

Understand:
- Existing tech stack and frameworks
- Directory structure patterns
- Naming conventions
- Test frameworks in use

### Step 1.3: Query Dependencies and Integration Points

```bash
!`project-intel.mjs --dependencies "<key-files>" --direction both --json > /tmp/plan_intel_deps.json`
```

Identify integration points where new feature connects to existing code.

---

## Phase 2: Technical Design

### Step 2.1: Select Tech Stack

**Based on intelligence findings and spec requirements**:

**Language/Version**: [from project-intel overview or specify new]
**Primary Dependencies**: [frameworks, libraries with versions]
**Storage**: [database, caching, file system if applicable]
**Testing**: [test frameworks, assertion libraries]
**Target Platform**: [web, mobile, desktop, server]

**CoD^Σ Evidence**:
```
Tech Stack Selection:
project-intel.mjs --overview → existing stack is TypeScript + React + Supabase
Decision: Continue with existing stack for consistency
Evidence: src/*/package.json:12 shows react@18, typescript@5
```

### Step 2.2: Design Architecture

**Component Breakdown** (from spec user stories):

For each P1 user story:
1. Identify required components (models, services, UI, API)
2. Map to existing architecture (from intelligence queries)
3. Document new components needed
4. Define interfaces/contracts

**Example**:
```
User Story P1: Email/Password Authentication

Components:
- Model: User (extends existing User model at models/user.ts:8)
- Service: AuthService (new, will integrate with existing auth.ts:23)
- API: POST /auth/login, POST /auth/register (new endpoints)
- UI: LoginForm, RegisterForm (enhance existing at components/auth/)

Integration Points:
- Existing: src/utils/auth.ts:23 (session management)
- New: src/services/auth-service.ts (authentication logic)
```

### Step 2.3: Create Research Document

**Generate `research.md`** with:

**Technical Decisions**:
1. Decision: [what was decided]
   - Rationale: [why]
   - Alternatives considered: [what else was considered]
   - Evidence: [file:line from intelligence or MCP query]

**Example**:
```markdown
## Decision 1: OAuth Provider Libraries

Decision: Use @supabase/auth-helpers for OAuth integration

Rationale:
- Already using Supabase for backend (src/lib/supabase.ts:5)
- Native support for Google/GitHub OAuth
- Handles token refresh automatically

Alternatives Considered:
- NextAuth.js: Rejected (adds complexity, not needed with Supabase)
- Custom OAuth: Rejected (reinventing wheel, Article VI violation)

Evidence:
- Intelligence: project-intel found Supabase client at src/lib/supabase.ts:5
- MCP Ref: @supabase/auth-helpers supports Google/GitHub OAuth
```

### Step 2.4: Design Data Model

**Generate `data-model.md`** (entities WITHOUT implementation):

**For each entity**:
- Name and purpose
- Attributes (without database types)
- Relationships to other entities
- Validation rules

**Example**:
```markdown
## Entity: User

Purpose: Represents authenticated system user

Attributes:
- id: Unique identifier
- email: Email address (unique, validated)
- password_hash: Hashed password (never plaintext)
- oauth_provider: Optional (google|github)
- oauth_id: Optional provider-specific ID
- created_at: Registration timestamp
- last_login: Last successful login

Relationships:
- Has many: Sessions
- Has many: UserRoles

Validation:
- email: Must be valid email format
- password: Minimum 8 characters, must include number + special char
- oauth_provider + oauth_id: Required together or both null
```

### Step 2.5: Define API Contracts

**Generate `contracts/` directory** with API specifications:

**For each endpoint**:
- HTTP method and path
- Request schema
- Response schema
- Error cases
- Authentication required?

**Example**: `contracts/auth-endpoints.md`
```markdown
## POST /api/auth/register

Purpose: Create new user account

Request:
- email: string (required, valid email)
- password: string (required, min 8 chars)

Response (201 Created):
- user: { id, email, created_at }
- session: { access_token, refresh_token, expires_at }

Errors:
- 400: Invalid email format
- 409: Email already exists
- 500: Server error

Authentication: None (public endpoint)
```

### Step 2.6: Create Quickstart Validation Scenarios

**Generate `quickstart.md`** with test scenarios:

**For each user story**, document:
- Setup steps
- Exact actions to test
- Expected outcomes
- How to verify success

**Example**:
```markdown
## Scenario 1: User Registration (P1 Story)

Setup:
1. Navigate to /register
2. Have valid email ready

Test Steps:
1. Enter email: test@example.com
2. Enter password: SecurePass123!
3. Click "Register"

Expected Outcome:
- HTTP 201 response
- User created in database
- Session token returned
- Redirected to /dashboard

Verification:
- Check database: SELECT * FROM users WHERE email='test@example.com'
- Check session storage: localStorage.getItem('session')
- Verify redirect: window.location.pathname === '/dashboard'
```

---

## Phase 3: Acceptance Criteria Mapping

**Article III Requirement**: Minimum 2 testable ACs per user story.

### Step 3.1: Extract User Stories from Specification

```bash
Read specs/$FEATURE/spec.md
```

Identify all user stories with priorities (P1, P2, P3).

### Step 3.2: Generate Acceptance Criteria

**For EACH user story**, create ≥2 ACs:

**AC Format**:
- **AC-ID**: [Story]-[Number] (e.g., P1-001, P1-002)
- **Given** [precondition], **When** [action], **Then** [outcome]
- **Test**: How to automate verification

**Example**:
```markdown
### User Story P1: Email/Password Registration

**AC-P1-001**: User can register with valid email and password
- **Given** user has valid email and strong password
- **When** user submits registration form
- **Then** account is created and user is logged in
- **Test**: POST /api/auth/register with valid data returns 201 + session token

**AC-P1-002**: System rejects weak passwords
- **Given** user has valid email but weak password ("12345")
- **When** user submits registration form
- **Then** registration fails with error "Password must be at least 8 characters with number and special character"
- **Test**: POST /api/auth/register with weak password returns 400 with specific error
```

---

## Phase 4: Post-Design Constitutional Re-Check

**Article VI Mandate**: Verify gates still pass AFTER design decisions.

**Purpose**: Ensure technical design didn't introduce constitutional violations.

### Step 4.1: Re-validate All Three Gates

Re-check each Article VI gate against the completed design:

**Gate 1: Project Count Re-Check**
- **Question**: Did component breakdown create a 4th project?
- **Check**: Count deployable units in architecture (from Phase 2.2)
- **Status**: [PASS ✓ | NEW VIOLATION ⚠]

**Gate 2: Abstraction Layers Re-Check**
- **Question**: Did architecture add unnecessary abstraction layers?
- **Check**: Count layers per concept (Model → Service → API → Controller?)
- **Examples to Check**:
  - Data access: Database → [Repository?] → Service → Controller
  - State management: State → [Store?] → [Actions?] → Component
- **Status**: [PASS ✓ | NEW VIOLATION ⚠]

**Gate 3: Framework Trust Re-Check**
- **Question**: Did design create wrappers around framework features?
- **Examples to Check**:
  - Authentication: Using Supabase Auth directly OR custom AuthWrapper?
  - Database: Using Supabase client directly OR custom DB abstraction?
  - State management: Using React state/hooks OR custom state abstraction?
- **Status**: [PASS ✓ | NEW VIOLATION ⚠]

### Step 4.2: Post-Design Gate Report

Generate comprehensive post-design gate assessment:

```markdown
## Post-Design Constitutional Gates

### Gate 1: Project Count (Re-Check)
**Pre-Design Status**: [PASS/CONDITIONAL]
**Post-Design Status**: [PASS ✓ | NEW VIOLATION ⚠]
**Project Count**: [X] deployable units
**Details**: [List all projects identified in architecture]
**Decision**: [GATES HOLD | NEEDS JUSTIFICATION | VIOLATION]

### Gate 2: Abstraction Layers (Re-Check)
**Pre-Design Status**: [PASS/CONDITIONAL]
**Post-Design Status**: [PASS ✓ | NEW VIOLATION ⚠]
**Analysis**:
- [Concept 1]: [X] layers ([list layers])
- [Concept 2]: [X] layers ([list layers])
**Decision**: [GATES HOLD | NEEDS JUSTIFICATION | VIOLATION]

### Gate 3: Framework Trust (Re-Check)
**Pre-Design Status**: [PASS/CONDITIONAL]
**Post-Design Status**: [PASS ✓ | NEW VIOLATION ⚠]
**Framework Usage**:
- Authentication: [Using Supabase Auth directly ✓ | Custom wrapper ⚠]
- Database: [Using Supabase client ✓ | Custom ORM/wrapper ⚠]
- State: [Using framework state ✓ | Custom abstraction ⚠]
**Decision**: [GATES HOLD | NEEDS JUSTIFICATION | VIOLATION]

---

**Overall Post-Design Assessment**: [PASS ✓ | CONDITIONAL ⚠ | BLOCKED ✗]
```

### Step 4.3: Handle New Violations

**IF new violations detected in Post-Design**:

```markdown
# ⚠ Post-Design Violations Detected

**New Violations**: [X]

**What Changed**:
Pre-Design: [Gate status before design]
Post-Design: [Gate status after design]

**Violations**:

**1. [Gate Name] - NEW VIOLATION**
- **Pre-Design**: [PASS]
- **Post-Design**: [VIOLATION - X projects/layers/wrappers]
- **Cause**: [What design decision introduced this]
- **Location**: [Where in plan.md/architecture]

**Required Actions**:
1. Update Complexity Justification Table with new violations
2. Document why design requires this complexity
3. Consider simpler alternatives:
   - [Alternative 1]: [Why rejected]
   - [Alternative 2]: [Why rejected]

**Updated Complexity Justification Table**:

| Violation | Why Needed | Simpler Alternative Rejected Because | Added In Phase |
|-----------|------------|-------------------------------------|----------------|
| [Gate] | [Design rationale] | [Why simpler won't work] | Post-Design |

**Status**: ⚠ Conditional proceed with documented justification
```

**IF all gates still PASS**:

```markdown
# ✅ Post-Design Constitutional Gates: PASSED

All Article VI gates maintained through design:
- ✓ Gate 1: Project Count ≤ 3 (Pre: X, Post: X)
- ✓ Gate 2: Abstraction Layers ≤ 2 per concept (maintained)
- ✓ Gate 3: Framework Trust maintained (no wrappers added)

Design respects constitutional limits. Proceeding to plan generation...
```

---

## Phase 5: Generate Implementation Plan

### Step 5.1: Write plan.md

Use `@.claude/templates/plan.md` structure:

```yaml
---
feature: <number>-<name>
created: <YYYY-MM-DD>
specification: specs/<number>-<name>/spec.md
status: Ready for Implementation
---
```

**Sections**:
1. **Summary**: One paragraph overview
2. **Technical Context**: Tech stack, platform, dependencies
3. **Constitution Check**: Gates passed/violated with justifications
4. **Architecture**: Component breakdown with integration points
5. **Acceptance Criteria**: All ACs from Step 3.2
6. **File Structure**: Exact paths where code will live
7. **CoD^Σ Evidence**: Intelligence query results, MCP sources

**Save**:
- `specs/$FEATURE/plan.md`
- `specs/$FEATURE/research.md`
- `specs/$FEATURE/data-model.md`
- `specs/$FEATURE/contracts/*.md`
- `specs/$FEATURE/quickstart.md`

### Step 5.2: Report Completion

**Output**:
```
✓ Implementation plan created: specs/<number>-<name>/plan.md

Intelligence Evidence:
- project-intel.mjs queries: 3 executed, results in /tmp/plan_intel_*.json
- Existing patterns found: auth.ts:23, Login.tsx:12
- Integration points: 2 identified

Technical Decisions:
- Tech stack: TypeScript + React + Supabase (existing)
- New components: AuthService, LoginForm, RegisterForm
- Architecture: Extends existing auth pattern

Artifacts Generated:
- plan.md (implementation plan)
- research.md (technical decisions)
- data-model.md (User entity)
- contracts/auth-endpoints.md (API specs)
- quickstart.md (test scenarios)

Acceptance Criteria: 6 total (2 per P1 story)

Constitutional Compliance:
- ✓ Article I: Intelligence queries executed before design
- ✓ Article IV: Plan references existing spec.md
- ✓ Article VI: No complexity violations (3 projects, framework trust maintained)
- ✓ Article III: All user stories have ≥2 ACs

**Automatic Task Generation**:
Now invoking generate-tasks skill to create task breakdown...

[Task generation and audit will proceed automatically]
```

---

## Phase 6: Automatic Task Generation

**DO NOT ask user to trigger task generation** - this is automatic workflow progression.

### Step 6.1: Invoke generate-tasks Skill

After all plan artifacts are complete (plan.md, research.md, data-model.md, contracts/, quickstart.md), **automatically** proceed to task generation.

**Instruct Claude**:

"Now that the implementation plan is complete, **automatically generate the task breakdown**:

Use the **generate-tasks skill** to create tasks.md.

This will:
1. Load user stories from specs/$FEATURE/spec.md
2. Load technical details from specs/$FEATURE/plan.md
3. Organize tasks by user story (Article VII)
4. Mark parallelizable tasks with [P]
5. Ensure ≥2 ACs per story (Article III)
6. **Automatically invoke /audit for quality gate validation**

The generate-tasks skill will handle this entire workflow automatically, including the quality gate check."

### Step 6.2: Quality Gate Enforcement

The generate-tasks skill will automatically invoke `/audit` after creating tasks.md.

**This enforces**:
- Article IV: Specification-First Development (spec → plan → tasks validated)
- Article V: Template-Driven Quality (automatic validation)
- Article VII: User-Story-Centric Organization (verified)

**User will see**:
- tasks.md created
- /audit runs automatically
- Quality gate PASS/FAIL result
- Next steps based on audit outcome

**No manual intervention required** - workflow proceeds automatically through task generation and validation.

---

**Note**: This completes the planning phase. The next steps (task generation + audit) happen automatically.
```

---

## Anti-Patterns to Avoid

**DO NOT**:
- Plan before specification exists (Article IV violation)
- Skip intelligence queries (Article I violation)
- Design without checking constitution gates (Article VI violation)
- Create ACs with < 2 per story (Article III violation)
- Mix specification and implementation concerns
- Copy existing code without intelligence analysis
- Create wrapper layers around framework features

**DO**:
- Query intelligence sources before designing
- Check constitution gates pre AND post design
- Create ≥2 testable ACs per user story
- Use CoD^Σ traces with file:line evidence
- Trust framework features (avoid custom implementations)
- Document decisions with rationale in research.md
- Map components to existing architecture patterns

---

## Prerequisites

Before using this skill:
- ✅ spec.md exists (Article IV: cannot create plan without specification)
- ✅ PreToolUse hook validates spec.md presence (automatic enforcement)
- ✅ project-intel.mjs is executable
- ✅ PROJECT_INDEX.json exists
- ⚠️ Optional: constitution.md exists (for Article VI complexity gates)
- ⚠️ Optional: product.md exists (for user-need alignment)

## Dependencies

**Depends On**:
- **specify-feature skill** - MUST run before this skill (Article IV)
- **clarify-specification skill** - Should run if [NEEDS CLARIFICATION] markers exist

**Integrates With**:
- **generate-tasks skill** - Automatically invoked after this skill completes
- **implement-and-verify skill** - Uses plan.md output as input

**Tool Dependencies**:
- project-intel.mjs (intelligence queries for patterns, dependencies)
- MCP Ref tool (library documentation)
- MCP Context7 tool (external framework docs)

## Next Steps

After plan completes, **automatic workflow progression**:

**Automatic Chain** (no manual intervention):
```
create-implementation-plan (creates plan.md, research.md, data-model.md, contracts/)
    ↓ (auto-invokes generate-tasks)
generate-tasks (creates tasks.md)
    ↓ (auto-invokes /audit)
/audit (validates consistency)
    ↓ (if PASS)
Ready for /implement
```

**User Action Required**:
- **If audit PASS**: Run `/implement plan.md` to begin implementation
- **If audit FAIL**: Fix CRITICAL issues (usually in spec or plan), re-run workflow
- **If complexity gates fail**: Justify violations or simplify design

**Outputs Created**:
- `specs/$FEATURE/plan.md` - Main implementation plan
- `specs/$FEATURE/research.md` - Technical decisions and rationale
- `specs/$FEATURE/data-model.md` - Entity schemas (if applicable)
- `specs/$FEATURE/contracts/` - API/interface contracts (if applicable)
- `specs/$FEATURE/quickstart.md` - Test scenarios (if applicable)

**Commands**:
- **/tasks** - Automatically invoked to generate task breakdown
- **/implement plan.md** - User runs after audit passes

## Failure Modes

### Common Failures & Solutions

**1. spec.md does not exist (Article IV violation)**
- **Symptom**: PreToolUse hook blocks with "Cannot create plan without specification"
- **Solution**: Run specify-feature skill or /feature command first
- **Prevention**: Follow SDD workflow order: /feature → /plan → /tasks → /implement

**2. Constitution complexity gates fail (Article VI)**
- **Symptom**: Plan requires >3 projects or >2 abstraction layers
- **Solution**: Simplify design OR document justification in plan.md
- **Justification Format**: Table showing violation → why needed → simpler alternative rejected
- **Prevention**: Check constitution.md Article VI limits before designing

**3. Intelligence queries return no patterns**
- **Symptom**: No existing code patterns found for reference
- **Solution**: This is normal for new projects; design from first principles
- **Note**: Intelligence is opportunistic, not required

**4. Tech stack selection conflicts with existing code**
- **Symptom**: Plan proposes different framework than codebase uses
- **Solution**: project-intel.mjs --overview reveals existing stack; align with it
- **Rationale**: Consistency beats novelty (unless justified in research.md)

**5. Missing acceptance criteria (Article III violation)**
- **Symptom**: User story has <2 ACs
- **Solution**: Add testable ACs (Given/When/Then format)
- **Requirement**: Minimum 2 ACs per user story for MVP

**6. Specification contains [NEEDS CLARIFICATION] markers**
- **Symptom**: Spec has unresolved ambiguities
- **Solution**: Invoke clarify-specification skill before continuing with plan
- **Action**: Answer structured questions to resolve ambiguities

**7. generate-tasks auto-invocation fails**
- **Symptom**: plan.md created but tasks.md not generated
- **Solution**: Manually run `/tasks plan.md` command
- **Root Cause**: Skill did not complete auto-invocation step (check Phase 6)

**8. Research document missing critical decisions**
- **Symptom**: /audit reports missing justification for tech choices
- **Solution**: Enhance research.md with decision rationale using CoD^Σ evidence
- **Format**: Decision → Rationale → Evidence (file:line or MCP query)

## Related Skills & Commands

**Direct Integration**:
- **specify-feature skill** - Required predecessor (creates spec.md input)
- **clarify-specification skill** - Optional predecessor (resolves ambiguities)
- **generate-tasks skill** - Automatically invoked successor (creates tasks.md)
- **implement-and-verify skill** - Uses plan.md as input
- **/plan command** - User-facing command that invokes this skill
- **planner subagent** - Subagent that routes to this skill

**Workflow Context**:
- Position: **Phase 2** of SDD workflow (after specification, before tasks)
- Triggers: Automatically invoked after specify-feature via /plan command
- Inputs: spec.md (required), product.md (optional), constitution.md (optional)
- Outputs: plan.md, research.md, data-model.md, contracts/, quickstart.md
- Next: Automatic progression to generate-tasks → /audit → ready for /implement

**Quality Gates**:
- **Pre-Design**: Article VI complexity gates (≤3 projects, ≤2 abstraction layers)
- **Post-Design**: Article VI re-check (no wrappers, trust framework features)
- **Pre-Implementation**: /audit validates cross-artifact consistency

---

**Skill Version**: 1.1.0
**Last Updated**: 2025-10-23

## Change Log

**v1.1.0 (2025-10-23)**:
- Enhanced Phase 0 Step 0.2 with explicit gate decision process and reporting
- Enhanced Phase 4 with comprehensive post-design constitutional re-validation
- Added detailed violation handling with Complexity Justification Table requirements
- Added side-by-side comparison (Pre-Design vs Post-Design status for each gate)

**v1.0.0 (2025-10-22)**:
- Initial skill creation with SDD integration
- Constitutional gates (Article VI) enforcement
- Intelligence-first architecture integration
- Template-driven outputs
