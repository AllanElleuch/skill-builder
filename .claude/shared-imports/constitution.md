# Intelligence Toolkit Constitution

**Version**: 1.0.0
**Ratified**: 2025-10-19
**Status**: ACTIVE

---

## Preamble

This Constitution establishes the immutable principles governing the Intelligence Toolkit. These articles are NON-NEGOTIABLE architectural foundations that all workflows, agents, skills, and implementations MUST uphold.

**Purpose**: Prevent over-engineering, enforce evidence-based reasoning, mandate test-driven development, separate specification from implementation, and ensure MVP-first delivery.

**Scope**: Applies to all code analysis, planning, implementation, and verification activities within this system.

**Amendment Process**: See Governance section below.

---

## Article I: Intelligence-First Principle

**Status**: NON-NEGOTIABLE

### Section 1.1: Query Before Read

All code analysis, debugging, and planning activities MUST query intelligence sources before reading full files.

**Requirements**:
1. Execute `project-intel.mjs` queries BEFORE any file read operations
2. Use MCP tools (Ref, Supabase, etc.) for external knowledge
3. Save intelligence query results to `/tmp/*.json` for evidence
4. Read only targeted file sections identified by intelligence queries

**Prohibited**:
- Reading full files without prior intelligence queries
- Guessing file locations instead of using `project-intel.mjs --search`
- Analyzing code without symbol or dependency queries

**Rationale**: Intelligence queries consume 1-2% of tokens vs reading full files. This achieves 80%+ token savings while providing better context.

### Section 1.2: Token Efficiency Target

**Target**: 80%+ token savings vs naive file reading approach

**Measurement**:
- Token count per analysis session
- Comparison baseline: reading all candidate files in full
- Violations require documented justification

**Evidence Required**:
- All analysis reports MUST include:
  - Intelligence queries executed (with results saved to /tmp/)
  - File sections read (with line ranges)
  - Token savings calculation vs full-file baseline

---

## Article II: Evidence-Based Reasoning

**Status**: NON-NEGOTIABLE

### Section 2.1: Chain of Density Sigma (CoD^Σ) Requirement

Every claim, conclusion, and recommendation MUST have traceable evidence documented in CoD^Σ format.

**CoD^Σ Composition Operators**:
- `⊕` Direct Sum - parallel composition
- `∘` Function Composition - sequential pipeline
- `→` Delegation - handover between components
- `≫` Transformation - data reshaping
- `⇄` Bidirectional - iterative exchange
- `∥` Parallel - simultaneous execution

**Requirements**:
1. Claims MUST reference specific evidence sources:
   - File locations with line numbers (e.g., `ComponentA.tsx:45-52`)
   - MCP query results with timestamps
   - Intelligence query outputs from `/tmp/*.json`
   - Test execution results with exit codes

2. Reasoning chains MUST use CoD^Σ operators to document flow:
   ```
   Example:
   intel-query ≫ targeted-read ∘ CoD^Σ-trace → evidence-backed-conclusion
   ```

3. NO unsupported claims:
   - "Probably", "should be", "likely", "might be" require evidence
   - Assumptions MUST be marked as [ASSUMPTION: rationale]
   - Unknowns MUST be marked as [NEEDS CLARIFICATION: specific question]

### Section 2.2: Valid Evidence Sources

**Approved**:
- `file:line` references from actual code
- MCP query results (Ref, Supabase, etc.)
- `project-intel.mjs` JSON outputs
- Test execution logs
- Compiler/linter error messages
- Git history and diffs

**Prohibited**:
- "I think", "probably", "should be" without evidence
- References to non-existent files
- Outdated documentation assumptions
- Guesses about implementation details

**Rationale**: Evidence-based reasoning prevents hallucination, ensures reproducibility, and provides audit trails for all decisions.

---

## Article III: Test-First Imperative

**Status**: NON-NEGOTIABLE

### Section 3.1: Test-Driven Development (TDD) Sequence

All implementation activities MUST follow TDD discipline:

**Required Sequence**:
1. **Write tests** for acceptance criteria FIRST (tests MUST fail initially)
2. **Run tests** to verify failure (proves tests are valid)
3. **Implement** minimal code to make tests pass
4. **Run tests** again to verify passing
5. **Refactor** if needed while keeping tests green

**Prohibited**:
- Writing implementation code before tests exist
- Skipping test execution to "save time"
- Assuming tests work without running them
- Marking tasks complete without passing tests

### Section 3.2: Acceptance Criteria (AC) Coverage

**Minimum Requirements**:
- Every task MUST have ≥ 2 testable acceptance criteria
- Every AC MUST have ≥ 1 automated test
- Tests MUST map 1:1 to ACs (traceable)

**Completion Requirements**:
- 100% AC pass rate required before marking task complete
- Partial implementations are NOT complete
- Failed tests = incomplete task (no exceptions)

**Rationale**: Tests are the specification. Code that passes tests meets requirements. Tests that don't run are worthless. Minimum 2 ACs prevents trivial "it compiles" testing.

---

## Article IV: Specification-First Development

**Status**: MANDATORY

### Section 4.1: Separation of Concerns (WHAT/WHY vs HOW)

Development MUST proceed in strict order:

**Phase 1: Specification (WHAT/WHY)**
- Create `spec.md` containing:
  - Problem statement and objectives
  - User stories with priorities (P1, P2, P3...)
  - Functional requirements (technology-agnostic)
  - Success criteria (measurable outcomes)
  - NO implementation details, tech stack, or architecture

**Phase 2: Clarification**
- Scan specification for ambiguities
- Generate max 5 high-impact clarification questions
- Update spec incrementally (no contradictions)
- Mark remaining unknowns as [NEEDS CLARIFICATION]

**Phase 3: Planning (HOW with Tech)**
- Create `plan.md` containing:
  - Tech stack and architecture decisions
  - Implementation approach with rationale
  - File structure and component organization
  - Dependencies and integration points
  - Acceptance criteria mapping to code

**Prohibited**:
- Mixing WHAT/WHY with HOW in specification
- Planning implementation before specification complete
- Creating tasks before plan exists
- Implementing before tasks defined

### Section 4.2: Clarification Workflow

**Requirements**:
1. Run clarification process BEFORE creating implementation plan
2. Maximum 5 clarification questions per iteration (prioritize impact)
3. Present questions with recommendations (not open-ended)
4. Sequential questioning (one at a time for complex topics)
5. Update specification incrementally after each answer

**Ambiguity Categories** (minimum coverage):
- Functional scope and behavior
- Domain and data model
- User interaction and UX flow
- Non-functional requirements (performance, security, scale)
- Integration and dependencies
- Edge cases and failure scenarios
- Constraints and tradeoffs

**Rationale**: Specification-first separates problem definition from solution design. Clarification eliminates ambiguity early (cheaper than fixing wrong implementations). Technology-agnostic specs survive implementation changes.

---

## Article V: Template-Driven Quality

**Status**: MANDATORY

### Section 5.1: Mandatory Template Usage

All outputs MUST use appropriate templates from `.claude/templates/`:

**Analysis Outputs**:
- `report.md` - Code analysis results with CoD^Σ traces
- `bug-report.md` - Bug diagnosis from symptom to fix
- `analysis-spec.md` - Analysis objectives and scope

**Planning Outputs**:
- `feature-spec.md` - Technology-agnostic requirements
- `plan.md` - Implementation plan with tech stack
- `tasks.md` - User-story-organized task breakdown

**Execution Outputs**:
- `verification-report.md` - AC verification results
- `handover.md` - Agent delegation with context (600 token limit)

**MCP Outputs**:
- `mcp-query.md` - External knowledge query results

### Section 5.2: Quality Gate Validation

**Checklists MUST validate** before proceeding:

1. **Pre-Planning Checklist** (quality-checklist.md):
   - Content quality (no implementation details in spec)
   - Requirement completeness (testable, measurable, bounded)
   - Feature readiness (ACs defined, scenarios covered)

2. **Pre-Implementation Checklist** (clarification-checklist.md):
   - Ambiguity scan complete (10+ categories covered)
   - [NEEDS CLARIFICATION] markers resolved (max 3 remaining)
   - Specification-plan consistency verified

3. **Pre-Completion Checklist** (verification-report.md):
   - All tests passing (100% AC coverage)
   - Code quality gates passed (lint, type-check, build)
   - Documentation updated (if required)

**Blocking Behavior**:
- Checklists with failures MUST block proceeding to next phase
- User override possible (requires explicit confirmation)
- Violations logged for audit

**Rationale**: Templates ensure consistency and completeness. Checklists prevent "ready except for..." syndrome. Quality gates catch issues early (cheaper fixes).

---

## Article VI: Simplicity and Anti-Abstraction

**Status**: NON-NEGOTIABLE

### Section 6.1: Project Complexity Limits

**Default Limits**:
- Maximum 3 projects in initial implementation
- Maximum 2 abstraction layers per concept
- Maximum 1 representation per domain model

**Justification Required For**:
- 4th project (document why 3 insufficient)
- Repository/service/facade patterns (document problem solved)
- Multiple parallel abstractions (document necessity)
- Custom frameworks (document why existing insufficient)

**Complexity Tracking**:
All plans MUST include "Complexity Justification" section if limits exceeded:

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| 4th project | [reason] | [why 3 projects insufficient] |
| Repository pattern | [problem] | [why direct DB access insufficient] |

### Section 6.2: Framework Trust Principle

**Requirements**:
- Use framework features directly (no unnecessary wrappers)
- Trust framework conventions (don't reinvent routing, ORM, etc.)
- Justify all abstractions over framework built-ins

**Prohibited**:
- Wrapper layers that add no value
- Custom implementations of framework features
- Reinventing standard patterns without justification

**Rationale**: Complexity is expensive (cognitive load, maintenance, bugs). Frameworks already solved common problems. Simple code is reviewable code.

---

## Article VII: User-Story-Centric Organization

**Status**: MANDATORY

### Section 7.1: Task Organization by User Story

Tasks MUST be grouped by user story priority (P1, P2, P3...), NOT by technical layer:

**Required Structure**:
```
Phase 1: Setup (infrastructure only)
Phase 2: Foundational (blocking prerequisites for ALL stories)
Phase 3: User Story P1 (highest priority, independently testable)
Phase 4: User Story P2 (independently testable)
Phase 5: User Story P3 (independently testable)
...
Final Phase: Polish & Cross-Cutting Concerns
```

**Within Each Story Phase**:
1. Tests for this story's ACs
2. Models needed for this story
3. Services needed for this story
4. Endpoints/UI needed for this story
5. Integration for this story
6. Verification of this story (independent test)

**Prohibited**:
- "Implement all models" phase (layer-first organization)
- "Complete backend before frontend" (big-bang integration)
- Tasks that span multiple stories (violates independence)

### Section 7.2: Independent Test Criteria

**Every user story MUST**:
- Have independent test criteria (can validate without other stories)
- Be demonstrable in isolation (MVP-capable)
- Have clear "done" definition (all ACs pass)

**Story Dependencies**:
- Mark explicitly in task breakdown
- Minimize cross-story dependencies (prefer independence)
- Document why dependencies exist if unavoidable

**Progressive Delivery**:
- Implement P1 → validate independently → ship/demo
- Implement P2 → validate independently → ship/demo
- Continue until all stories complete

**Rationale**: User-story organization delivers value incrementally. Independent stories enable parallel development and early user feedback. Avoids "all layers done but nothing works" syndrome.

---

## Article VIII: Parallelization Markers

**Status**: RECOMMENDED

### Section 8.1: Task Parallelization

Tasks that can execute in parallel MUST be marked with `[P]`:

**Criteria for Parallel Execution**:
- Operate on different files (no conflicts)
- No dependencies on incomplete tasks
- Can run simultaneously without coordination

**Example Task Breakdown**:
```
- [ ] T001 Create project structure
- [ ] T002 [P] Create User model in models/user.py
- [ ] T003 [P] Create Order model in models/order.py
- [ ] T004 Create UserService (depends on T002)
- [ ] T005 [P] Create OrderService (depends on T003)
```

**Rationale**: Explicit parallelization markers enable faster development and clear dependency visualization.

---

## Governance

### Version: 1.0.0

**Ratified**: 2025-10-19
**Last Amended**: 2025-10-19

### Amendment Procedure

**Requirements for Amendment**:
1. Documented rationale for change
2. Backwards compatibility assessment
3. Impact analysis on existing workflows
4. Version bump per semantic versioning:
   - **MAJOR**: Backward-incompatible principle changes
   - **MINOR**: New principle additions or expansions
   - **PATCH**: Clarifications, wording fixes, typos

**Approval Process**:
1. Propose amendment with rationale
2. Review impact on all skills, agents, workflows
3. Update all affected components
4. Increment version number
5. Document change in amendment history

### Compliance

**Enforcement**:
- All workflows, agents, and skills MUST comply
- Violations MUST be logged and reported
- Systematic violations trigger workflow halt

**Audit Trail**:
- All CoD^Σ traces logged
- Intelligence queries saved to `/tmp/*.json`
- Test execution results preserved
- Checklist validations documented

### Review Cycle

**Annual Review**: 2025-10-19 (one year from ratification)

**Triggers for Early Review**:
- Systematic compliance failures
- New capabilities rendering principles obsolete
- Discovered contradictions or ambiguities

---

## Amendment History

**v1.0.0** (2025-10-19):
- Initial ratification
- 7 core articles established
- Integration with GitHub Spec-Kit SDD methodology

---

**All workflows, agents, skills, and implementations MUST comply with this Constitution.**

Violations are not suggestions. These are architectural invariants.
