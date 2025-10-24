---
feature_id: "constitution-command"
version: "1.0"
status: "draft"
priority: "high"
created: "2025-10-20"
---

# Feature Specification: Constitution Management Command

## Overview

### Problem Statement

Currently, our Intelligence Toolkit Constitution (`.claude/shared-imports/constitution.md`) can only be updated through direct file editing. There's no interactive workflow for:
- Viewing the current constitutional principles
- Proposing amendments with version tracking
- Validating impacts on dependent skills/templates
- Ensuring proper semantic versioning of changes

**Evidence**: Constitution exists at `.claude/shared-imports/constitution.md:1-442` (v1.0.0, ratified 2025-10-19) with governance procedures defined (lines 382-427) but no command interface for amendments.

**Comparison**: GitHub's spec-kit provides `/constitution` command with interactive amendment flow, template sync validation, and version management automation.

### Proposed Solution

Create a `/constitution` slash command that provides an interactive interface for:
1. **Viewing** current constitution (summary with version, articles)
2. **Amending** principles via `$ARGUMENTS` or interactive prompts
3. **Versioning** amendments automatically (MAJOR/MINOR/PATCH)
4. **Validating** consistency across dependent components
5. **Reporting** sync impact showing affected skills/templates

**Key Architectural Decision**: Work with our @ import model (shared single source of truth) rather than GitHub's token-based template approach (per-feature copies).

### Success Criteria

**Functional:**
- `/constitution` displays current version, articles, and amendment history
- `/constitution "Add Article IX..."` proposes and applies amendment
- Version bumps follow semantic versioning rules automatically
- Dependent components discovered via `rg "@.*constitution\.md"`
- Amendment history appended to constitution file

**Usability:**
- Amendment workflow completes in < 5 interactions
- Clear prompts guide user through proposal → validation → approval
- Sync impact report shows what changed and what needs review

**Quality:**
- No broken @ imports after amendments
- Version numbers follow semver strictly
- Amendment history maintains chronological order

---

## Requirements

### Functional Requirements

**REQ-001: Constitution Viewing**
- **Priority:** P1 (Must-have)
- **User Story:** As a developer, I want to view the current constitution summary so I understand what principles govern the system
- **Acceptance Criteria:**
  - AC-001.1: `/constitution` with no arguments displays summary
  - AC-001.2: Summary shows version number, ratification date, last amended date
  - AC-001.3: Summary lists all articles with status (NON-NEGOTIABLE/MANDATORY/RECOMMENDED)
  - AC-001.4: Summary includes link to full file path

**REQ-002: Amendment Proposal**
- **Priority:** P1 (Must-have)
- **User Story:** As a system architect, I want to propose amendments to the constitution so I can evolve architectural principles
- **Acceptance Criteria:**
  - AC-002.1: `/constitution "$ARGUMENTS"` parses amendment proposal
  - AC-002.2: Interactive mode prompts if no arguments provided
  - AC-002.3: Amendment can add new article
  - AC-002.4: Amendment can modify existing article
  - AC-002.5: Amendment can add/modify sections within articles

**REQ-003: Version Bump Automation**
- **Priority:** P2 (Should-have)
- **User Story:** As a maintainer, I want automatic version bumps so I don't have to manually calculate semantic versions
- **Acceptance Criteria:**
  - AC-003.1: MAJOR bump when removing/redefining articles (backward-incompatible)
  - AC-003.2: MINOR bump when adding new articles or material expansions
  - AC-003.3: PATCH bump for clarifications, wording fixes, typos
  - AC-003.4: User shown proposed version with rationale before applying
  - AC-003.5: User can override version bump decision

**REQ-004: Consistency Validation**
- **Priority:** P2 (Should-have)
- **User Story:** As a reviewer, I want to see which skills/templates are affected by constitutional changes so I can review impacts
- **Acceptance Criteria:**
  - AC-004.1: Find all skills importing constitution via `rg "@.*constitution\.md"`
  - AC-004.2: Check templates for article references (e.g., "Article IV")
  - AC-004.3: Report lists files with status: ✅ reviewed / ⚠️ needs review
  - AC-004.4: Warning if skills reference removed/renumbered articles

**REQ-005: Amendment History Tracking**
- **Priority:** P3 (Nice-to-have)
- **User Story:** As an auditor, I want amendment history tracked in the constitution so I can understand principle evolution
- **Acceptance Criteria:**
  - AC-005.1: Each amendment adds entry to Amendment History section
  - AC-005.2: Entry includes version, date, summary of changes
  - AC-005.3: Amendment history maintains chronological order
  - AC-005.4: Last Amended date updates with each change

### Non-Functional Requirements

**REQ-006: Simplicity**
- Command file should be < 300 lines
- No external dependencies beyond Claude Code tools
- Clear, linear workflow (no complex branching logic)

**REQ-007: Integration**
- Uses existing Claude Code tools for file operations and search
- Respects Article IV governance procedures (constitution.md:388-405)
- Works with @ import architecture (no token replacement)

**REQ-008: Access Control**
- **Authorization Model**: Open access - any developer with command access can propose and apply amendments
- **Rationale**: Suitable for single-developer and small-team contexts where constitution changes are visible via git history
- **Governance**: Relies on version control (git) for change tracking and optional peer review
- **Future Enhancement**: Multi-user approval workflow documented for v2

### Out of Scope (for v1)

- ❌ Multi-user approval workflow (future v2: governance voting, role-based access)
  - **Rationale**: Open access model sufficient for single-dev/small-team usage
  - **v2 Consideration**: Add approval gates when system scales to larger teams
- ❌ Diff visualization of changes (future: show before/after)
- ❌ Rollback to previous version (future: version history with revert command)
- ❌ Template auto-fixing (future: AI-assisted sync of dependent files)
- ❌ Branch/merge workflow for amendments (future: Git integration with PR workflow)

---

## Domain Model

### Core Entities

**Constitution File** (`.claude/shared-imports/constitution.md`):
- **Version**: Semantic version (MAJOR.MINOR.PATCH)
- **Ratified Date**: Original adoption (ISO 8601: YYYY-MM-DD)
- **Last Amended Date**: Most recent change (ISO 8601)
- **Status**: ACTIVE | SUPERSEDED
- **Articles**: List of principle sections (Article I, II, III...)
- **Amendment History**: Chronological log of changes

**Article**:
- **Number**: Roman numeral (I, II, III...)
- **Title**: Descriptive name (e.g., "Intelligence-First Principle")
- **Status**: NON-NEGOTIABLE | MANDATORY | RECOMMENDED
- **Sections**: Subsections within article (e.g., 1.1, 1.2)
- **Content**: Markdown text with requirements, rationale

**Amendment**:
- **Type**: ADD | MODIFY | REMOVE
- **Target**: Article number or section
- **Content**: New/modified text
- **Rationale**: Why the change is needed
- **Version Bump**: MAJOR | MINOR | PATCH

**Dependency**:
- **File Path**: Relative path to dependent file
- **Type**: SKILL | TEMPLATE | AGENT | COMMAND
- **Import Pattern**: `@.claude/shared-imports/constitution.md`
- **Article References**: List of article numbers mentioned

### Data Flow

```
User Input → Parse Amendment → Determine Version Bump → Validate Dependencies
    ↓
Update Constitution File ← Generate Amendment Entry ← Collect User Approval
    ↓
Report Sync Impact (affected files, version change, next actions)
```

---

## User Interaction Flows

### Flow 1: View Constitution (No Arguments)

```
User: /constitution

System: Intelligence Toolkit Constitution v1.0.0
        Ratified: 2025-10-19
        Last Amended: 2025-10-19

        Articles:
        • Article I: Intelligence-First Principle (NON-NEGOTIABLE)
        • Article II: Evidence-Based Reasoning (NON-NEGOTIABLE)
        • Article III: Test-First Imperative (NON-NEGOTIABLE)
        • Article IV: Specification-First Development (MANDATORY)
        • Article V: Template-Driven Quality (MANDATORY)
        • Article VI: Simplicity and Anti-Abstraction (NON-NEGOTIABLE)
        • Article VII: User-Story-Centric Organization (MANDATORY)
        • Article VIII: Parallelization Markers (RECOMMENDED)

        File: .claude/shared-imports/constitution.md

        To propose amendment: /constitution "description of change"
        To view full text: Read .claude/shared-imports/constitution.md
```

### Flow 2: Propose Amendment (With Arguments)

```
User: /constitution "Add Article IX: Progressive Disclosure - All documentation must use lazy loading patterns"

System: Analyzing amendment proposal...

        Proposed Change:
        • Type: ADD
        • Target: New Article IX
        • Content: Progressive Disclosure principle

        Version Bump Analysis:
        Current: 1.0.0
        Proposed: 1.1.0 (MINOR - new article addition)

        Rationale: Adding new article constitutes material expansion of governance.

        Dependent Components:
        Checking files that import constitution...

        Found 8 skills importing @.claude/shared-imports/constitution.md:
        • .claude/skills/specify-feature/SKILL.md
        • .claude/skills/clarify-specification/SKILL.md
        • .claude/skills/create-implementation-plan/SKILL.md
        • .claude/skills/generate-tasks/SKILL.md
        • .claude/skills/implement-and-verify/SKILL.md
        (3 more...)

        No article reference conflicts detected.

        Proceed with amendment? (y/n/edit)

User: y

System: ✅ Amendment applied

        Sync Impact Report:
        • Version: 1.0.0 → 1.1.0
        • Added: Article IX (Progressive Disclosure)
        • Modified: Governance section (version, last amended date)
        • Amendment History: Entry added

        Dependent Files Status:
        ⚠️ 8 skills import constitution - review recommended
        ✅ No templates reference Article IX yet

        Next Actions:
        1. Review skills to determine if Article IX applies
        2. Update templates if progressive disclosure affects them
        3. Update documentation referencing article count

        Amendment complete!
```

### Flow 3: Modify Existing Article

```
User: /constitution

System: [Shows current summary]

        What would you like to amend?
        1. Add new article
        2. Modify existing article
        3. Add section to existing article
        4. Cancel

User: 2

System: Which article? (Enter number I-VIII)

User: VI

System: Article VI: Simplicity and Anti-Abstraction

        Current content preview:
        "Maximum 3 projects in initial implementation..."

        What change do you want to make?
        (Describe the modification)

User: Change "Maximum 3 projects" to "Maximum 5 projects" to allow more flexibility

System: Analyzing amendment proposal...

        Proposed Change:
        • Type: MODIFY
        • Target: Article VI, Section 6.1
        • Content: Update project limit from 3 to 5

        Version Bump Analysis:
        Current: 1.0.0
        Proposed: 2.0.0 (MAJOR - backward-incompatible change)

        Rationale: This relaxes a constraint, potentially invalidating existing
        plans that were designed with 3-project limit in mind. Existing plans
        may need review to ensure they still comply.

        Impact Assessment:
        ⚠️ Plans created under 3-project limit may now be under-utilizing available
        complexity budget. Consider re-evaluating project decomposition strategies.

        Proceed with MAJOR version bump? (y/n/edit)
```

---

## Edge Cases & Error Handling

### Edge Case 1: Invalid Amendment Proposal

```
User: /constitution "Remove all articles"

System: ❌ Amendment rejected

        Reason: Removing all articles would leave constitution empty, violating
        governance requirements.

        Minimum requirements:
        • At least one NON-NEGOTIABLE article must exist
        • Governance section must be preserved
        • Amendment history must be maintained

        Please revise your proposal.
```

### Edge Case 2: Conflicting Article References

```
User: /constitution "Remove Article IV"

System: ⚠️ Warning: Breaking change detected

        The following components explicitly reference Article IV:
        • .claude/skills/specify-feature/SKILL.md:20 - "Article IV Specification-First"
        • .claude/skills/create-implementation-plan/SKILL.md:15 - "per Article IV"
        • .claude/templates/feature-spec.md:10 - "Article IV requirements"

        Removing Article IV will break these references.

        Recommended actions:
        1. Update all 3 files to reference new article number (if renumbering)
        2. Remove references if article is truly being deleted
        3. Provide migration guide for skills

        Proceed anyway? (y/n)
        Type 'details' to see full file paths and line numbers.
```

### Edge Case 3: Version Conflict

```
System: Analyzing amendment proposal...

        ⚠️ Version conflict detected

        Expected current version: 1.0.0
        Actual file version: 1.1.0

        The constitution file may have been modified outside this command.

        Options:
        1. Reload and retry (recommended)
        2. Force amendment (advanced - may create inconsistency)
        3. Cancel and review changes manually

        Choose: (1/2/3)
```

---

## Technical Constraints

**File Format:**
- Constitution is standard Markdown with metadata lines
- Version format: `**Version**: X.Y.Z`
- Dates format: ISO 8601 (YYYY-MM-DD)
- Article numbering: Roman numerals (I, II, III, IV...)

**Tool Limitations:**
- Edit tool requires exact string matching (must load full file)
- Bash commands limited to 300-line output (may need chunking)
- No external dependencies (pure Claude Code tools)

**Constitutional Constraints** (self-referential):
- Must follow Article governance procedures (lines 388-405)
- Must maintain amendment history (line 430+)
- Must use semantic versioning (lines 394-397)

---

## Success Metrics

**Adoption:**
- Command used for 100% of constitutional amendments (no direct file edits)
- < 5 minutes average time to propose and apply amendment

**Correctness:**
- 100% of version bumps follow semantic versioning rules
- 0% broken @ imports after amendments
- 100% of amendments recorded in history

**Usability:**
- Users can propose amendment without reading governance section
- Sync impact report catches all affected files
- Clear guidance on next actions after amendment

---

## Dependencies & Integration

**Imports Required:**
- `@.claude/shared-imports/constitution.md` - Target file
- `@.claude/shared-imports/CoD_Σ.md` - Reasoning traces (evidence-based decisions)

**Skills Relationship:**
- This command follows same SDD workflow this specification demonstrates
- Created via `specify-feature` skill (dogfooding our system)
- Next: `/plan` will create implementation plan
- Then: `/implement` will build the command
- Finally: `/verify` will validate against these ACs

---

## Risks & Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Breaking @ imports | High | Medium | Validate imports after each amendment, provide rollback guidance |
| Version number confusion | Medium | Low | Clear version bump rationale, allow user override |
| Amendment history conflicts | Low | Low | Append-only history, timestamp each entry |
| Lost amendments (file not saved) | High | Low | Confirm write success, show file path after save |
| Concurrent edits | Medium | Very Low | Detect version mismatch, prompt user to reload |

---

## Rollback Plan

If critical issues arise:
1. Constitution file is version controlled (can `git revert`)
2. Amendment history shows what was changed (manual rollback guide)
3. Users can directly edit `.claude/shared-imports/constitution.md`
4. Skills continue working with any valid constitution content (resilient)

---

## Amendment History (for this Spec)

**Spec v1.0** (2025-10-20):
- Initial specification created using `specify-feature` skill
- Testing our SDD workflow end-to-end
- Evidence-based requirements from existing constitution analysis

---

## CoD^Σ Evidence Traces

**Constitution File Analysis**:
```
Read(.claude/shared-imports/constitution.md:1-50) ∘ Extract(version=1.0.0, articles=8)
  → Evidence: Constitution exists with governance procedures
```

**Slash Command Pattern Analysis**:
```
Read(.claude/commands/feature.md:1-50) ∘ Identify(frontmatter format, argument handling)
  → Evidence: Commands use YAML-like metadata, support $ARGUMENTS
```

**Dependency Discovery**:
```
Bash(rg "@.*constitution\.md" .claude/) ≫ Filter(SKILL.md files)
  → Evidence: 8 skills import constitution, creating sync requirements
```

**Version Bump Rules**:
```
Read(.claude/shared-imports/constitution.md:394-397) ∘ Parse(semver rules)
  → Evidence: MAJOR=breaking, MINOR=additions, PATCH=clarifications
```

---

**Status**: ✅ CLARIFIED - Ready for Planning (Phase 3)
**Next Action**: Run `/plan specs/002-constitution-command/spec.md` or invoke `create-implementation-plan` skill
**Blocked By**: None
**Clarification Completed**: 2025-10-20 - 1 question resolved (access control)
