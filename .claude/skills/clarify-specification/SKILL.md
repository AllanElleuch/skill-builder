---
name: Specification Clarification
description: Identify and resolve ambiguities in specifications through structured questioning. Use when specification has [NEEDS CLARIFICATION] markers, when user mentions unclear or ambiguous requirements, before creating implementation plans, or when planning reveals specification gaps.
degree-of-freedom: low
allowed-tools: Read, Write, Edit
---

@.claude/shared-imports/constitution.md
@.claude/templates/clarification-checklist.md

# Specification Clarification

**Purpose**: Systematically eliminate ambiguity from specifications through structured questioning before implementation planning.

**Constitutional Authority**: Article IV (Specification-First Development), Article V (Template-Driven Quality)

---

## Phase 1: Load Specification and Detect Ambiguities

### Step 1.1: Read Current Specification

Identify current feature from SessionStart hook context or user input.

```bash
Read specs/<feature-number>-<name>/spec.md
```

### Step 1.2: Scan Against Ambiguity Categories

Use `@.claude/templates/clarification-checklist.md` categories:

**10+ Ambiguity Categories**:
1. **Functional Scope & Behavior**: What exactly does "process" mean? Which actions are in/out of scope?
2. **Domain & Data Model**: What entities exist? What are their relationships and cardinality?
3. **Interaction & UX Flow**: How do users navigate? What's the exact sequence of screens/actions?
4. **Non-Functional Requirements**: Performance targets? Scale expectations? Security requirements?
5. **Integration & Dependencies**: Which external systems? What data flows in/out?
6. **Edge Cases & Failure Scenarios**: What happens when X fails? How to handle boundary conditions?
7. **Constraints & Tradeoffs**: Budget limits? Technology restrictions? Compliance requirements?
8. **Terminology & Definitions**: What does "active user" mean? How is "completion" defined?
9. **Permissions & Access Control**: Who can do what? What are the authorization rules?
10. **State & Lifecycle**: What states can entities be in? What triggers transitions?

### Step 1.3: Identify Gaps and Mark Coverage

For each category, assess coverage:
- **Clear**: Well-defined, no ambiguity
- **Partial**: Some aspects defined, others unclear
- **Missing**: Not addressed in specification

**Output**: Coverage matrix showing which categories need clarification

---

## Phase 2: Prioritize Clarification Questions

### Step 2.1: Extract [NEEDS CLARIFICATION] Markers

Count existing markers in specification (Article IV limit: max 3).

### Step 2.2: Prioritize by Impact

**Priority Order** (Article IV, Section 4.2):
1. **Scope** (highest impact) - Affects what gets built
2. **Security** - Affects risk and compliance
3. **UX Flow** - Affects user experience
4. **Technical** (lowest impact) - Implementation details

**Maximum 5 Questions Per Iteration** (Article IV requirement)

### Step 2.3: Generate Questions with Recommendations

Each question MUST include:
- **Context**: Why this matters
- **Question**: Specific, focused inquiry
- **Options**: 2-3 recommendations based on common patterns
- **Impact**: What depends on this answer

**Example**:
```
**Question 1: Authentication Method** (Priority: Security)

Context: Specification mentions "user login" but doesn't specify authentication approach.

Question: How should users authenticate?

Options:
A) Email/password (simplest, industry standard)
B) Social login only (Google, GitHub - reduces friction)
C) Both email/password + social (maximum flexibility)

Recommendation: Option C provides flexibility while maintaining control.

Impact: Affects data model (user table schema), security requirements (password hashing, OAuth), and UX flow (login screens).

Intelligence Evidence:
- project-intel.mjs found: src/auth/login.tsx:12 (existing email/password flow)
- Recommendation aligns with existing pattern
```

---

## Phase 3: Interactive Clarification

### Step 3.1: Present Questions Sequentially

**ONE QUESTION AT A TIME** for complex topics (Article IV requirement).

Present question with:
- Numbered options
- Recommendation highlighted
- Impact analysis
- Evidence from intelligence queries (if available)

### Step 3.2: Capture User Response

Record answer with rationale:
```
**Answer to Q1**: Option C (both methods)

**Rationale**: Need to support existing email users while enabling social login for new users.

**Additional Context**: Google and GitHub OAuth only (not Facebook).
```

### Step 3.3: Update Specification Incrementally

**After EACH answer**:
1. Edit specification to incorporate answer
2. Remove or resolve [NEEDS CLARIFICATION] marker
3. Add functional requirement with answer
4. Verify no contradictions introduced

**Example Update**:
```markdown
## Functional Requirements

- **FR-001**: System MUST support email/password authentication
- **FR-002**: System MUST support OAuth2 social login (Google, GitHub)
- **FR-003**: Users MUST be able to link multiple auth methods to one account
```

**Remove**:
```markdown
- **FR-XXX**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified]
```

---

## Phase 4: Validation and Completion

### Step 4.1: Verify Consistency

**Check for contradictions**:
- Do new requirements conflict with existing ones?
- Are priorities consistent?
- Do user stories align with clarifications?

### Step 4.2: Update Clarification Checklist

Mark categories as **Clear** after resolution:

```markdown
## Clarification Status

| Category | Status | Notes |
|----------|--------|-------|
| Functional Scope | Clear | All features defined |
| Domain Model | Clear | User/Auth entities specified |
| UX Flow | Clear | Login/register flows documented |
| Non-Functional | Partial | Need performance targets |
| Integration | Clear | Google/GitHub OAuth |
...
```

### Step 4.3: Report Completion

**Output**:
```
✓ Clarification complete: <N> questions resolved

Resolved:
- Q1: Authentication method → Email/password + Social (Google, GitHub)
- Q2: User roles → Admin, User, Guest with specified permissions
- Q3: Data retention → 90 days for inactive accounts

Updated Specification:
- Added FR-001 through FR-008 (authentication requirements)
- Updated User Stories with auth flow details
- Removed all [NEEDS CLARIFICATION] markers

Remaining Ambiguities: 0 (ready for planning)

Next Step: Use create-implementation-plan skill to define HOW
```

---

## Phase 5: Re-Clarification (If Needed)

### When to Re-Run

Trigger clarification again if:
- Implementation planning reveals new ambiguities
- User requests changes to requirements
- New [NEEDS CLARIFICATION] markers added during planning

### Iterative Approach

Each iteration:
- Maximum 5 new questions
- Focus on highest-priority gaps
- Update specification incrementally
- Validate consistency

---

## Anti-Patterns to Avoid

**DO NOT**:
- Ask more than 5 questions per iteration (Article IV limit)
- Ask open-ended questions without recommendations
- Present all questions at once (use sequential for complex topics)
- Make assumptions instead of asking
- Skip updating specification after each answer
- Accept ambiguous answers (press for specifics)

**DO**:
- Prioritize by impact (scope > security > UX > technical)
- Provide 2-3 options with recommendations
- Use intelligence queries for context
- Update spec incrementally (after each answer)
- Verify consistency after updates
- Limit [NEEDS CLARIFICATION] markers to max 3

---

## Example Execution

**Input**: Specification with markers:
```markdown
- **FR-004**: System MUST handle [NEEDS CLARIFICATION: concurrent user limit?]
- **FR-005**: Data MUST be stored [NEEDS CLARIFICATION: how long?]
- **FR-006**: Errors MUST be [NEEDS CLARIFICATION: logged where?]
```

**Phase 1**: Scan shows Missing coverage for:
- Non-functional requirements (no performance targets)
- Integration (no error logging system specified)

**Phase 2**: Generate 3 questions (all markers + 1 gap):

```
Q1: Concurrent User Limit (Priority: Technical/NFR)
Options:
A) 100 concurrent users (small team)
B) 1,000 concurrent users (department)
C) 10,000+ concurrent users (enterprise)
Recommendation: B (1,000) based on "department-scale" in problem statement

Q2: Data Retention Policy (Priority: Security/Compliance)
Options:
A) 30 days (minimal retention)
B) 90 days (standard)
C) Indefinite (until user deletes)
Recommendation: B (90 days) balances compliance and user needs

Q3: Error Logging Destination (Priority: Technical)
Options:
A) File-based logging (local files)
B) Centralized logging service (Sentry, DataDog)
C) Both (files + service)
Recommendation: C (both) for redundancy

Additional Gap:
Q4: Response Time Target (Priority: NFR)
Options:
A) < 200ms p95 (fast)
B) < 500ms p95 (standard)
C) < 1000ms p95 (acceptable)
Recommendation: B (500ms) standard for web apps
```

**Phase 3**: Present Q1, get answer (Option B), update spec:
```markdown
- **FR-004**: System MUST support 1,000 concurrent users with < 500ms p95 latency
```

**Phase 4**: After all questions resolved:
```
✓ 4 questions resolved
✓ 0 [NEEDS CLARIFICATION] markers remaining
✓ Specification ready for implementation planning
```

---

## Prerequisites

Before using this skill:
- ✅ spec.md exists (created by specify-feature skill)
- ✅ [NEEDS CLARIFICATION] markers present in spec OR user mentions ambiguity
- ✅ Feature directory structure exists: specs/<feature>/
- ⚠️ Optional: clarification-checklist.md exists (for category coverage tracking)
- ⚠️ Optional: project-intel.mjs available (for evidence-based recommendations)

## Dependencies

**Depends On**:
- **specify-feature skill** - MUST run before this skill (creates initial spec.md)

**Integrates With**:
- **create-implementation-plan skill** - Use after this skill resolves ambiguities
- **specify-feature skill** - May trigger this skill if ambiguities detected

**Tool Dependencies**:
- Read tool (to load spec.md and templates)
- Write, Edit tools (to update spec.md incrementally)
- project-intel.mjs (optional, for evidence-based recommendations)

## Next Steps

After clarification completes, typical progression:

**If all ambiguities resolved**:
```
clarify-specification (resolves ambiguities)
    ↓
create-implementation-plan (user invokes /plan or auto-triggered)
    ↓
generate-tasks (auto-invoked)
    ↓
/audit (auto-invoked)
```

**If new ambiguities discovered during planning**:
```
create-implementation-plan (finds gaps)
    ↓
clarify-specification (invoked again)
    ↓
create-implementation-plan (continues after resolution)
```

**User Action Required**:
- Answer clarification questions (max 5 per iteration)
- Provide specific answers, not vague responses
- Confirm specification updates after each answer

**Outputs Modified**:
- `specs/$FEATURE/spec.md` - Updated incrementally with clarifications
- Removed [NEEDS CLARIFICATION] markers
- Added functional requirements with clarified details

**Commands**:
- **/plan spec.md** - After clarification complete, create implementation plan
- **/clarify** - User-facing command that invokes this skill

## Agent Integration

This skill operates in the main conversation context but may be invoked by other agents when they encounter ambiguities.

### Invocation Patterns

**User-Initiated** (most common):
```
User notices ambiguity → runs /clarify → clarify-specification skill executes
```

**Agent-Initiated** (during planning):
```
implementation-planner agent (finds ambiguity during plan creation)
    ↓ can invoke
clarify-specification skill via Skill tool or instruction
    ↓ returns
Updated spec.md with resolved ambiguity
```

### Code Analyzer Support (Optional)

**When**: If clarification requires understanding existing codebase patterns

**Agent**: code-analyzer

**Example Task Tool Invocation**:
```python
# If clarification needs code analysis for evidence-based recommendations
Task(
    subagent_type="code-analyzer",
    description="Analyze existing authentication patterns",
    prompt="""
    @.claude/agents/code-analyzer.md

    Analyze existing authentication in codebase to inform
    clarification question about auth strategy.

    Use project-intel.mjs to find auth patterns.
    Output: What auth patterns exist (OAuth, JWT, sessions, etc.)
    """
)
```

**Use Case**: When user asks "What auth should we use?", analyzer can provide evidence-based recommendation from existing patterns.

### Integration with Planner

**Typical Flow**:
```
clarify-specification (resolves all ambiguities)
    ↓ updates
spec.md (all [NEEDS CLARIFICATION] removed)
    ↓ ready for
create-implementation-plan skill
    ↓ executed by
implementation-planner agent
```

**Iterative Flow** (if planner discovers new ambiguities):
```
implementation-planner (finds gap while planning)
    ↓ pauses planning
    ↓ invokes
clarify-specification (targeted question on gap)
    ↓ user answers
    ↓ updates spec.md
    ↓ returns to
implementation-planner (continues planning)
```

### Task Tool Usage

This skill typically does NOT use Task tool directly. It:
1. Runs in main conversation context (needs user interaction)
2. Updates spec.md incrementally based on user answers
3. May suggest analyzer agent if code evidence needed (but doesn't invoke directly)

**Design Rationale**:
- Clarification requires user dialog (can't run in isolated agent)
- Incremental updates more efficient than agent round-trips
- User must approve spec changes (can't delegate to agent)

### Expected Workflow

**Phase 1: Initial Clarification** (after /feature):
1. specify-feature creates spec.md
2. If ambiguities exist, user may run /clarify
3. clarify-specification asks ≤5 high-impact questions
4. User answers, spec updated incrementally
5. Repeat until ≤3 [NEEDS CLARIFICATION] markers remain

**Phase 2: Planning Clarification** (during /plan if needed):
1. create-implementation-plan finds technical ambiguity
2. Planner may pause and invoke clarify-specification
3. Targeted clarification on specific gap
4. Planning resumes after resolution

## Failure Modes

### Common Failures & Solutions

**1. Too many [NEEDS CLARIFICATION] markers (> 3)**
- **Symptom**: Specification has > 3 ambiguity markers (Article IV violation)
- **Solution**: Clarify most during initial specification, use markers sparingly
- **Prevention**: specify-feature skill should clarify through dialogue, not markers

**2. Open-ended questions without options**
- **Symptom**: Questions like "What do you want for auth?" (too vague)
- **Solution**: Always provide 2-3 specific options with recommendations
- **Pattern**: "Option A (simple), Option B (standard), Option C (comprehensive)"

**3. Asking more than 5 questions at once**
- **Symptom**: Overwhelming user with many questions simultaneously
- **Solution**: Article IV mandates max 5 questions per iteration
- **Approach**: Prioritize by impact (scope > security > UX > technical)

**4. Not updating spec after each answer**
- **Symptom**: Spec unchanged, [NEEDS CLARIFICATION] markers remain
- **Solution**: Edit spec.md immediately after each answer
- **Benefit**: Incremental updates prevent contradictions and lost context

**5. Accepting ambiguous answers**
- **Symptom**: User says "something secure" (not specific)
- **Solution**: Press for specifics: "Do you mean OAuth2, JWT, or session cookies?"
- **Requirement**: Every answer must be concrete and actionable

**6. No prioritization of questions**
- **Symptom**: Asking technical questions before scope questions
- **Solution**: Always prioritize: Scope > Security > UX > Technical
- **Reason**: High-priority ambiguities block more decisions

**7. Contradictions introduced by clarifications**
- **Symptom**: New requirement conflicts with existing user story
- **Solution**: Validate consistency after each update (Step 4.1)
- **Check**: Do new FRs align with user stories and priorities?

**8. No intelligence evidence for recommendations**
- **Symptom**: Recommendations don't consider existing codebase patterns
- **Solution**: Run project-intel.mjs queries to find similar features
- **Benefit**: Recommendations align with existing architecture

**9. Iterating forever on minor details**
- **Symptom**: Clarifying technical minutiae that can be decided during implementation
- **Solution**: Focus on high-impact ambiguities only (scope, security, UX flow)
- **Principle**: Perfect is the enemy of good - allow some flexibility for implementation

**10. Not tracking clarification coverage**
- **Symptom**: Don't know which categories are clear vs. missing
- **Solution**: Use clarification-checklist.md to track coverage status
- **Benefit**: Visual coverage matrix shows gaps at a glance

## Related Skills & Commands

**Direct Integration**:
- **specify-feature skill** - Creates spec.md that this skill refines (required predecessor)
- **create-implementation-plan skill** - Uses clarified spec.md as input (typical successor)
- **/clarify command** - User-facing command that invokes this skill (NOT /feature)

**Workflow Context**:
- Position: **Phase 1.5** of SDD workflow (between specification and planning)
- Triggers: [NEEDS CLARIFICATION] markers OR user mentions "unclear requirements"
- Output: Updated spec.md with resolved ambiguities

**Quality Gates**:
- **Pre-Planning**: Ensures spec is unambiguous before creating plan (Article IV)
- **Max 3 Markers**: Article IV limits [NEEDS CLARIFICATION] markers to 3 max
- **Max 5 Questions**: Article IV limits clarification questions to 5 per iteration

**Workflow Diagram**:
```
specify-feature (creates spec.md with 0-3 [NEEDS CLARIFICATION] markers)
    ↓ (if markers exist OR ambiguities detected)
clarify-specification (resolves ambiguities, max 5 questions/iteration)
    ↓ (when all resolved)
create-implementation-plan (can proceed without specification gaps)
```

**Re-Clarification Trigger**:
- If create-implementation-plan discovers new gaps, it can trigger clarify-specification again
- Iterative refinement until specification is complete and unambiguous

---

**Skill Version**: 1.0.0
**Last Updated**: 2025-10-22
