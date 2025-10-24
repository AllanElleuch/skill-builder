---
feature: 002-constitution-command
specification: specs/002-constitution-command/spec.md
plan: specs/002-constitution-command/plan.md
status: Ready for Implementation
created: 2025-10-20
---

# Implementation Tasks: Constitution Management Command

## Overview

This task list breaks down the constitution-command implementation into user-story-centric tasks following Article VII principles. Tasks are organized by priority (P1 → P2 → P3) with independent test criteria per user story, enabling progressive delivery and early validation.

**Total Tasks**: 24
**Total Acceptance Criteria**: 22 (100% coverage)
**Parallelization**: 8 tasks marked [P] for parallel execution

---

## Phase 0: Setup (Foundational)

### Task 0.1: Create Command File Structure
**User Story**: Infrastructure setup for all subsequent development
**Priority**: P0 (Blocking prerequisite)
**Estimated Effort**: 5 minutes

**Description**: Create `.claude/commands/constitution.md` with proper frontmatter and bash shebang.

**Implementation Steps**:
1. Create file at `.claude/commands/constitution.md`
2. Add YAML frontmatter with:
   - `allowed-tools: Read, Write, Edit, Grep, Bash(rg:*), Bash(fd:*)`
   - `description: Manage Intelligence Toolkit Constitution - view, amend, and track constitutional changes`
   - `argument-hint: [amendment-description]`
3. Add bash shebang and initial structure

**Acceptance Criteria**:
- File exists at correct path
- Frontmatter valid YAML format
- allowed-tools includes all required tools
- SlashCommand tool can discover command (appears in `/help`)

**Test Criteria**:
```bash
# Test 1: File exists
ls -la .claude/commands/constitution.md

# Test 2: Valid structure
head -20 .claude/commands/constitution.md | grep "allowed-tools"

# Test 3: Command discoverable
claude --debug 2>&1 | grep "constitution"
```

**Dependencies**: None
**Parallelization**: N/A (blocking all other tasks)

---

## Phase 1: P1 Tasks - Core Viewing (REQ-001)

**User Story**: As a developer, I want to view the current constitution summary so I understand what principles govern the system.

### Task 1.1: Parse Constitution Metadata [P]
**Acceptance Criteria**: AC-001.2 (partial)
**Estimated Effort**: 15 minutes

**Description**: Extract version, ratified date, and last amended date from constitution file.

**Implementation Steps**:
1. Use `Read .claude/shared-imports/constitution.md`
2. Parse version line: `grep "^\*\*Version\*\*:" | sed 's/.*: //'`
3. Parse ratified date: `grep "^\*\*Ratified\*\*:" | sed 's/.*: //'`
4. Parse last amended date: `grep "^\*\*Last Amended\*\*:" | sed 's/.*: //'`
5. Store in shell variables (VERSION, RATIFIED, LAST_AMENDED)

**Test Criteria**:
```bash
# Given: constitution.md has version 1.0.0, ratified 2025-10-19
# When: Parse metadata
# Then: VERSION=1.0.0, RATIFIED=2025-10-19, LAST_AMENDED=[date]
```

**Dependencies**: Task 0.1
**Parallelization**: [P] Can run parallel with Task 1.2

---

### Task 1.2: Extract Article List [P]
**Acceptance Criteria**: AC-001.3 (partial)
**Estimated Effort**: 15 minutes

**Description**: Extract all article titles and statuses from constitution.

**Implementation Steps**:
1. Use grep to find all article headers: `grep "^## Article [IVX]" constitution.md`
2. Extract article titles (e.g., "Article I: Intelligence-First Principle")
3. For each article, find status line: `grep -A 5 "^## Article I" | grep "^\*\*Status\*\*:"`
4. Parse status value (NON-NEGOTIABLE/MANDATORY/RECOMMENDED)
5. Store in array or formatted string

**Test Criteria**:
```bash
# Given: Constitution has 8 articles (I-VIII)
# When: Extract articles
# Then: List contains 8 entries with titles and statuses
# Example: "Article I: Intelligence-First Principle (NON-NEGOTIABLE)"
```

**Dependencies**: Task 0.1
**Parallelization**: [P] Can run parallel with Task 1.1

---

### Task 1.3: Format and Display Summary
**Acceptance Criteria**: AC-001.1, AC-001.2, AC-001.3, AC-001.4
**Estimated Effort**: 20 minutes

**Description**: Generate formatted summary output combining metadata and article list.

**Implementation Steps**:
1. Check if `$ARGUMENTS` is empty (view mode vs amendment mode)
2. If empty, enter view mode
3. Format summary header:
   ```
   Intelligence Toolkit Constitution v{VERSION}
   Ratified: {RATIFIED}
   Last Amended: {LAST_AMENDED}
   ```
4. Format article list (• bullet points)
5. Add file path footer
6. Add usage hint

**Test Criteria**:
```bash
# Given: constitution.md exists with metadata and 8 articles
# When: /constitution (no arguments)
# Then: Summary displays with:
#   - Version number (AC-001.2) ✓
#   - Ratified date (AC-001.2) ✓
#   - Last amended date (AC-001.2) ✓
#   - All 8 articles with statuses (AC-001.3) ✓
#   - File path (AC-001.4) ✓
```

**Dependencies**: Task 1.1, Task 1.2
**Parallelization**: N/A (depends on 1.1 and 1.2)

---

## Phase 2: P1 Tasks - Amendment Parsing (REQ-002, partial)

**User Story**: As a system architect, I want to propose amendments to the constitution so I can evolve architectural principles.

### Task 2.1: Detect Amendment Mode
**Acceptance Criteria**: AC-002.1, AC-002.2 (partial)
**Estimated Effort**: 10 minutes

**Description**: Determine if command is in view mode or amendment mode based on arguments.

**Implementation Steps**:
1. Check if `$ARGUMENTS` is non-empty
2. If non-empty: Parse as amendment proposal
3. If empty: Check for interactive mode flag
4. Store mode in variable (VIEW / AMENDMENT / INTERACTIVE)

**Test Criteria**:
```bash
# Given: /constitution "Add Article IX"
# When: Detect mode
# Then: mode=AMENDMENT, amendment_text="Add Article IX"

# Given: /constitution
# When: Detect mode
# Then: mode=VIEW or INTERACTIVE
```

**Dependencies**: Task 1.3 (view mode must work first)
**Parallelization**: N/A

---

### Task 2.2: Parse Amendment Type and Target
**Acceptance Criteria**: AC-002.1 (partial)
**Estimated Effort**: 25 minutes

**Description**: Classify amendment as ADD/MODIFY/REMOVE and identify target article/section.

**Implementation Steps**:
1. Parse `$ARGUMENTS` for keywords:
   - "Add Article" → type=ADD, extract Roman numeral
   - "Modify Article" → type=MODIFY, extract Roman numeral
   - "Remove Article" → type=REMOVE, extract Roman numeral
   - "Change" / "Update" → type=MODIFY (heuristic)
2. Extract target article number (I, II, III, etc.)
3. Extract amendment content (the actual change text)
4. Validate article number format (must be valid Roman numeral)

**Test Criteria**:
```bash
# Given: /constitution "Add Article IX: Progressive Disclosure"
# When: Parse amendment
# Then: type=ADD, target=IX, content="Progressive Disclosure"

# Given: /constitution "Modify Article VI to change project limit"
# When: Parse amendment
# Then: type=MODIFY, target=VI, content="change project limit"
```

**Dependencies**: Task 2.1
**Parallelization**: N/A

---

### Task 2.3: Implement Interactive Mode Prompts
**Acceptance Criteria**: AC-002.2
**Estimated Effort**: 30 minutes

**Description**: Guide user through amendment proposal if no arguments provided.

**Implementation Steps**:
1. Display menu:
   ```
   What would you like to amend?
   1. Add new article
   2. Modify existing article
   3. Add section to existing article
   4. Cancel
   ```
2. Capture user selection
3. Based on selection, prompt for details:
   - If ADD: "Enter new article title and content"
   - If MODIFY: "Which article? (I-VIII)", then "What change?"
4. Construct amendment proposal from interactive inputs
5. Feed into same parsing logic as argument mode

**Test Criteria**:
```bash
# Given: /constitution (no arguments)
# When: User selects option 1 (Add new article)
# Then: Prompt for article details
# When: User provides "Article IX: Test"
# Then: Amendment proposal constructed: type=ADD, target=IX, content="Test"
```

**Dependencies**: Task 2.2
**Parallelization**: N/A

---

## Phase 3: P2 Tasks - Version Bump Automation (REQ-003)

**User Story**: As a maintainer, I want automatic version bumps so I don't have to manually calculate semantic versions.

### Task 3.1: Implement Version Bump Rules [P]
**Acceptance Criteria**: AC-003.1, AC-003.2, AC-003.3
**Estimated Effort**: 30 minutes

**Description**: Determine semantic version bump based on amendment type.

**Implementation Steps**:
1. Read current version from constitution
2. Apply versioning rules:
   ```bash
   if [[ "$TYPE" == "REMOVE" ]] || [[ "$TYPE" == "REDEFINE" ]]; then
       BUMP_TYPE="MAJOR"  # Breaking change
   elif [[ "$TYPE" == "ADD" ]]; then
       BUMP_TYPE="MINOR"  # New feature
   elif [[ "$CONTENT" =~ "typo|fix|clarif" ]]; then
       BUMP_TYPE="PATCH"  # Clarification
   else
       BUMP_TYPE="MINOR"  # Default for modifications
   fi
   ```
3. Calculate new version:
   - MAJOR: X+1.0.0
   - MINOR: X.Y+1.0
   - PATCH: X.Y.Z+1
4. Generate rationale text explaining the bump

**Test Criteria**:
```bash
# Given: Current version 1.0.0
# When: type=ADD (add article)
# Then: new_version=1.1.0, bump_type=MINOR (AC-003.2) ✓

# Given: Current version 1.0.0
# When: type=REMOVE (remove article)
# Then: new_version=2.0.0, bump_type=MAJOR (AC-003.1) ✓

# Given: Current version 1.0.0
# When: type=MODIFY, content="fix typo"
# Then: new_version=1.0.1, bump_type=PATCH (AC-003.3) ✓
```

**Dependencies**: Task 2.2
**Parallelization**: [P] Can develop in parallel with Task 3.2

---

### Task 3.2: Display Version Bump Proposal [P]
**Acceptance Criteria**: AC-003.4
**Estimated Effort**: 15 minutes

**Description**: Show user the proposed version change with clear rationale.

**Implementation Steps**:
1. Format version bump display:
   ```
   Version Bump Analysis:
   Current: {OLD_VERSION}
   Proposed: {NEW_VERSION} ({BUMP_TYPE} - {RATIONALE})

   Rationale: {DETAILED_EXPLANATION}
   ```
2. Include rationale based on bump type:
   - MAJOR: "Backward-incompatible change (article removal/redefinition)"
   - MINOR: "Material expansion (new article or section addition)"
   - PATCH: "Non-semantic change (typo fix, clarification)"
3. Display before asking for confirmation

**Test Criteria**:
```bash
# Given: Proposed version bump from 1.0.0 to 1.1.0
# When: Display proposal
# Then: Output shows "Current: 1.0.0 → Proposed: 1.1.0 (MINOR - new article addition)"
# And: Rationale explains why MINOR was chosen (AC-003.4) ✓
```

**Dependencies**: Task 3.1
**Parallelization**: [P] Can develop in parallel with Task 3.1

---

### Task 3.3: Implement Version Override
**Acceptance Criteria**: AC-003.5
**Estimated Effort**: 20 minutes

**Description**: Allow user to override automatic version bump decision.

**Implementation Steps**:
1. After displaying proposal, prompt:
   ```
   Accept this version bump? (y/n/override)
   ```
2. If user selects 'override':
   - Display options:
     ```
     Choose version bump type:
     1. MAJOR (X+1.0.0) - Breaking change
     2. MINOR (X.Y+1.0) - New feature/addition
     3. PATCH (X.Y.Z+1) - Clarification/fix
     ```
   - Capture user choice
   - Recalculate version with chosen bump type
   - Confirm override with user
3. If 'n': Cancel amendment
4. If 'y': Proceed with proposed version

**Test Criteria**:
```bash
# Given: System proposes MINOR bump (1.0.0 → 1.1.0)
# When: User selects 'override' and chooses MAJOR
# Then: Version becomes 2.0.0 (AC-003.5) ✓
# And: Confirmation prompt shown with new version
```

**Dependencies**: Task 3.2
**Parallelization**: N/A

---

## Phase 4: P2 Tasks - Dependency Discovery (REQ-004)

**User Story**: As a reviewer, I want to see which skills/templates are affected by constitutional changes so I can review impacts.

### Task 4.1: Find Constitution Imports [P]
**Acceptance Criteria**: AC-004.1
**Estimated Effort**: 15 minutes

**Description**: Discover all files that import constitution via @ syntax.

**Implementation Steps**:
1. Run ripgrep query:
   ```bash
   rg "@.*constitution\.md" .claude/ --type md -l
   ```
2. Capture output (list of file paths)
3. Count results
4. Store in array for reporting

**Test Criteria**:
```bash
# Given: 8 skills import @.claude/shared-imports/constitution.md
# When: Run discovery
# Then: Found 8 skill files (AC-004.1) ✓
# Verify: All 8 known skills in results
```

**Dependencies**: Task 2.3 (amendment proposal ready)
**Parallelization**: [P] Can run parallel with Task 4.2

---

### Task 4.2: Find Article References [P]
**Acceptance Criteria**: AC-004.2
**Estimated Effort**: 15 minutes

**Description**: Discover files that explicitly reference article numbers.

**Implementation Steps**:
1. Run ripgrep query:
   ```bash
   rg "Article [IVX]+" .claude/ --type md -n
   ```
2. Parse results to extract:
   - File path
   - Line number
   - Matched article reference (e.g., "Article IV")
3. Store in structured format for reporting

**Test Criteria**:
```bash
# Given: Templates and skills reference articles
# When: Run discovery
# Then: All article references found with file:line (AC-004.2) ✓
# Example: ".claude/skills/specify-feature/SKILL.md:20: Article IV"
```

**Dependencies**: Task 2.3
**Parallelization**: [P] Can run parallel with Task 4.1

---

### Task 4.3: Generate Dependency Report
**Acceptance Criteria**: AC-004.3
**Estimated Effort**: 20 minutes

**Description**: Format dependency findings into user-friendly report with status indicators.

**Implementation Steps**:
1. Combine results from Tasks 4.1 and 4.2
2. Format report with sections:
   ```
   Dependent Components:

   Skills importing constitution:
   • .claude/skills/specify-feature/SKILL.md
   • .claude/skills/clarify-specification/SKILL.md
   (8 total)

   Article references:
   • Article IV: 3 references (needs review)
   • Article VI: 1 reference
   ```
3. Add status symbols:
   - ✅ No action needed
   - ⚠️ Review recommended
4. Count and summarize impact

**Test Criteria**:
```bash
# Given: Dependency discovery complete
# When: Generate report
# Then: Report lists all files with ✅/⚠️ status (AC-004.3) ✓
# And: Summary shows total counts
```

**Dependencies**: Task 4.1, Task 4.2
**Parallelization**: N/A

---

### Task 4.4: Detect Breaking Article Changes
**Acceptance Criteria**: AC-004.4
**Estimated Effort**: 25 minutes

**Description**: Warn if amendment removes or renumbers articles that are explicitly referenced.

**Implementation Steps**:
1. If amendment type is REMOVE:
   - Check if target article appears in reference list
   - If found, generate warning with file:line details
2. If amendment type is MODIFY (renumbering):
   - Detect if article number changes
   - Check for references to old number
   - Generate migration warning
3. Format warning prominently:
   ```
   ⚠️ Warning: Breaking change detected

   The following components reference Article {TARGET}:
   • file1.md:20 - "Article IV Specification-First"
   • file2.md:15 - "per Article IV"

   Recommended actions:
   1. Update references if renumbering
   2. Remove references if deleting
   ```

**Test Criteria**:
```bash
# Given: /constitution "Remove Article IV"
# When: Check dependencies
# Then: Warning shows 3 files referencing Article IV (AC-004.4) ✓
# And: Warning includes file paths and line numbers
# And: Recommended actions provided
```

**Dependencies**: Task 4.3
**Parallelization**: N/A

---

## Phase 5: P1 Tasks - File Update (REQ-002, core execution)

**User Story Continuation**: As a system architect, I want to propose amendments to the constitution so I can evolve architectural principles.

### Task 5.1: Read and Prepare Constitution Content
**Acceptance Criteria**: AC-002.3, AC-002.4, AC-002.5 (setup)
**Estimated Effort**: 15 minutes

**Description**: Load constitution file content into memory for modification.

**Implementation Steps**:
1. Read entire constitution file:
   ```bash
   CONTENT=$(cat .claude/shared-imports/constitution.md)
   ```
2. Validate file loaded correctly (non-empty)
3. Identify key sections:
   - Metadata section (lines 1-10)
   - Articles section (lines 11-380)
   - Governance section (lines 382-427)
   - Amendment History section (lines 430+)
4. Store line numbers or markers for each section

**Test Criteria**:
```bash
# Given: Constitution file exists
# When: Read content
# Then: CONTENT variable populated
# And: All sections identified
# And: File integrity validated
```

**Dependencies**: Task 3.3 (version determined), Task 4.4 (warnings shown)
**Parallelization**: N/A

---

### Task 5.2: Apply ADD Amendment
**Acceptance Criteria**: AC-002.3
**Estimated Effort**: 30 minutes

**Description**: Insert new article into constitution at appropriate location.

**Implementation Steps**:
1. If type=ADD:
   - Determine insertion point (before Governance section)
   - Format new article:
     ```markdown
     ## Article {NUMBER}: {TITLE}

     **Status**: {STATUS}

     {CONTENT}
     ```
   - Insert into content string
2. Preserve existing article ordering
3. Ensure proper spacing (2 blank lines between articles)

**Test Criteria**:
```bash
# Given: type=ADD, target=IX, content="Progressive Disclosure"
# When: Apply amendment
# Then: New article inserted before Governance section (AC-002.3) ✓
# And: Article formatted correctly
# And: Existing articles unchanged
```

**Dependencies**: Task 5.1
**Parallelization**: [P] Can implement parallel with Tasks 5.3, 5.4

---

### Task 5.3: Apply MODIFY Amendment [P]
**Acceptance Criteria**: AC-002.4, AC-002.5
**Estimated Effort**: 35 minutes

**Description**: Update existing article or section content.

**Implementation Steps**:
1. If type=MODIFY:
   - Locate target article (grep for `## Article {TARGET}:`)
   - If modifying entire article:
     - Extract article boundaries (from `## Article` to next `## Article` or `---`)
     - Replace article content
   - If modifying section:
     - Locate section within article
     - Replace section content only
2. Preserve article structure and formatting
3. Validate modification doesn't corrupt markdown

**Test Criteria**:
```bash
# Given: type=MODIFY, target=VI, content="change Maximum 3 to Maximum 5"
# When: Apply amendment
# Then: Article VI content updated (AC-002.4) ✓
# And: Other articles unchanged
# And: Markdown structure valid

# Given: type=MODIFY, target=I, section=1.3, content="new requirement"
# When: Apply amendment
# Then: Section 1.3 added to Article I (AC-002.5) ✓
# And: Other sections preserved
```

**Dependencies**: Task 5.1
**Parallelization**: [P] Can implement parallel with Tasks 5.2, 5.4

---

### Task 5.4: Apply REMOVE Amendment [P]
**Acceptance Criteria**: AC-002.4 (implicit - removal is modification type)
**Estimated Effort**: 20 minutes

**Description**: Delete article from constitution (with safety checks).

**Implementation Steps**:
1. If type=REMOVE:
   - Locate article to remove
   - Validate not removing NON-NEGOTIABLE article (safety check)
   - Confirm user intent (extra confirmation for destructive action)
   - Delete article section (from `## Article` to next `## Article` or `---`)
   - Clean up extra blank lines
2. Preserve article numbering (don't renumber remaining articles)

**Test Criteria**:
```bash
# Given: type=REMOVE, target=VIII (RECOMMENDED status)
# When: Apply amendment with confirmation
# Then: Article VIII removed
# And: Articles I-VII unchanged
# And: No orphaned blank lines

# Given: type=REMOVE, target=I (NON-NEGOTIABLE)
# When: Attempt removal
# Then: Warning shown: "Cannot remove NON-NEGOTIABLE article"
# And: Removal blocked
```

**Dependencies**: Task 5.1
**Parallelization**: [P] Can implement parallel with Tasks 5.2, 5.3

---

### Task 5.5: Update Metadata Fields
**Acceptance Criteria**: AC-005.4 (Last Amended date)
**Estimated Effort**: 15 minutes

**Description**: Update version and last amended date in modified constitution.

**Implementation Steps**:
1. Replace `**Version**: {OLD}` with `**Version**: {NEW}`
2. Update `**Last Amended**: {OLD_DATE}` with today's date (ISO 8601)
3. Preserve `**Ratified**:` date (immutable)
4. Validate metadata format after changes

**Test Criteria**:
```bash
# Given: Amendment applied, new version calculated
# When: Update metadata
# Then: **Version**: line shows new version
# And: **Last Amended**: shows today's date (AC-005.4) ✓
# And: **Ratified**: unchanged (immutable)
```

**Dependencies**: Tasks 5.2 OR 5.3 OR 5.4 (at least one amendment type)
**Parallelization**: N/A

---

### Task 5.6: Write Updated Constitution
**Acceptance Criteria**: All REQ-002 ACs (final write)
**Estimated Effort**: 15 minutes

**Description**: Save modified constitution back to file atomically.

**Implementation Steps**:
1. Use Write tool for atomic file replacement:
   ```bash
   Write(.claude/shared-imports/constitution.md, $MODIFIED_CONTENT)
   ```
2. Verify write succeeded (check file exists and readable)
3. Validate file size reasonable (not empty, not corrupted)
4. On failure: Report error, don't lose original

**Test Criteria**:
```bash
# Given: Modified constitution content ready
# When: Write file
# Then: File saved successfully
# And: File readable
# And: Content matches expected (spot check version, article)
# And: File size > 0 bytes
```

**Dependencies**: Task 5.5
**Parallelization**: N/A

---

## Phase 6: P3 Tasks - Amendment History (REQ-005)

**User Story**: As an auditor, I want amendment history tracked in the constitution so I can understand principle evolution.

### Task 6.1: Generate Amendment History Entry [P]
**Acceptance Criteria**: AC-005.1, AC-005.2
**Estimated Effort**: 20 minutes

**Description**: Create formatted history entry for the amendment.

**Implementation Steps**:
1. Format entry:
   ```
   **v{VERSION}** ({DATE}):
   - {AMENDMENT_SUMMARY}
   ```
2. Generate summary based on amendment type:
   - ADD: "Added Article {NUMBER} ({TITLE})"
   - MODIFY: "Modified Article {NUMBER} ({CHANGE_DESCRIPTION})"
   - REMOVE: "Removed Article {NUMBER}"
3. Use today's date (ISO 8601)
4. Include version from Task 3.1

**Test Criteria**:
```bash
# Given: Amendment applied (ADD Article IX)
# When: Generate history entry
# Then: Entry format: "**v1.1.0** (2025-10-20):" (AC-005.2) ✓
# And: Summary: "- Added Article IX (Progressive Disclosure)"
```

**Dependencies**: Task 5.6 (amendment applied)
**Parallelization**: [P] Can develop in parallel with Task 6.2

---

### Task 6.2: Locate Amendment History Section [P]
**Acceptance Criteria**: AC-005.1 (prerequisite)
**Estimated Effort**: 15 minutes

**Description**: Find or create Amendment History section in constitution.

**Implementation Steps**:
1. Search for `## Amendment History` marker
2. If exists: Note line number for insertion
3. If doesn't exist:
   - Create section after Governance section
   - Add header: `## Amendment History`
   - Add initial entry for v1.0.0 (constitution creation)
4. Determine insertion point (append to section)

**Test Criteria**:
```bash
# Given: Constitution may or may not have Amendment History section
# When: Locate section
# Then: Section found or created
# And: Insertion point identified
```

**Dependencies**: Task 5.6
**Parallelization**: [P] Can develop in parallel with Task 6.1

---

### Task 6.3: Insert History Entry
**Acceptance Criteria**: AC-005.1, AC-005.3
**Estimated Effort**: 20 minutes

**Description**: Add new entry to Amendment History maintaining chronological order.

**Implementation Steps**:
1. Read Amendment History section content
2. Determine ordering (newest first or oldest first)
3. Insert new entry:
   - If newest-first: Insert at top of history entries
   - If oldest-first: Append to bottom of history entries
4. Preserve existing entries
5. Ensure proper spacing

**Test Criteria**:
```bash
# Given: Amendment History exists with 1 entry (v1.0.0)
# When: Insert new entry (v1.1.0)
# Then: New entry added to history (AC-005.1) ✓
# And: Chronological order maintained (AC-005.3) ✓
# And: Existing entry preserved
# And: Proper markdown formatting
```

**Dependencies**: Task 6.1, Task 6.2
**Parallelization**: N/A

---

## Phase 7: P2 Tasks - Sync Impact Report (REQ-004 completion)

**User Story Continuation**: As a reviewer, I want to see which skills/templates are affected by constitutional changes so I can review impacts.

### Task 7.1: Format Sync Impact Report
**Acceptance Criteria**: AC-004.3 (final report), partial AC-001.1
**Estimated Effort**: 25 minutes

**Description**: Generate comprehensive impact report after successful amendment.

**Implementation Steps**:
1. Create report structure:
   ```
   ✅ Amendment applied

   Sync Impact Report:
   • Version: {OLD} → {NEW}
   • {ACTION}: Article {NUMBER} ({DESCRIPTION})
   • Modified: {SECTIONS_CHANGED}

   Dependent Files Status:
   {DEPENDENCY_REPORT from Task 4.3}

   Next Actions:
   {RECOMMENDED_ACTIONS}
   ```
2. Populate fields with data from previous phases
3. Use emoji indicators (✅/⚠️/❌) for visual clarity
4. Include dependency count and file list
5. Generate next action recommendations based on changes

**Test Criteria**:
```bash
# Given: Amendment applied successfully (Article IX added)
# When: Generate report
# Then: Report shows:
#   - Version change: 1.0.0 → 1.1.0 ✓
#   - Added: Article IX ✓
#   - Dependent files: 8 skills ⚠️ (AC-004.3) ✓
#   - Next actions: [recommendations]
```

**Dependencies**: Task 6.3 (all changes applied)
**Parallelization**: N/A

---

### Task 7.2: Display Final Report
**Acceptance Criteria**: Complete workflow (all ACs satisfied)
**Estimated Effort**: 10 minutes

**Description**: Output final report to user and confirm completion.

**Implementation Steps**:
1. Display sync impact report from Task 7.1
2. Add completion message:
   ```
   Amendment complete!

   Updated file: .claude/shared-imports/constitution.md
   ```
3. Suggest next steps:
   - Review affected skills
   - Update documentation
   - Commit changes to git
4. Exit successfully

**Test Criteria**:
```bash
# Given: All tasks complete, report generated
# When: Display report
# Then: User sees complete impact summary
# And: Clear next actions provided
# And: Confirmation of success
```

**Dependencies**: Task 7.1
**Parallelization**: N/A

---

## Task Summary by Priority

### P1 (Must-Have) - 11 tasks
Covers core viewing and amendment execution:
- Task 0.1: Setup
- Tasks 1.1-1.3: View mode (REQ-001)
- Tasks 2.1-2.3: Amendment parsing (REQ-002 partial)
- Tasks 5.1-5.6: File updates (REQ-002 core execution)

**Early Validation Point**: After P1 tasks, constitution viewing and basic amendments work.

### P2 (Should-Have) - 10 tasks
Covers version automation, dependency validation, reporting:
- Tasks 3.1-3.3: Version bumps (REQ-003)
- Tasks 4.1-4.4: Dependency discovery (REQ-004)
- Tasks 7.1-7.2: Impact reporting (REQ-004 completion)

**Second Validation Point**: After P2 tasks, complete workflow with versioning and validation works.

### P3 (Nice-to-Have) - 3 tasks
Covers amendment history tracking:
- Tasks 6.1-6.3: History tracking (REQ-005)

**Final Validation Point**: After P3 tasks, full audit trail maintained.

---

## Testing Strategy

### Unit Testing (Per Task)
Each task includes specific test criteria with Given-When-Then format.

### Integration Testing (Per Priority)
- **After P1**: Run quickstart Scenarios 1-3 (view + basic amendment)
- **After P2**: Run quickstart Scenarios 4-5 (version override + dependency warnings)
- **After P3**: Run quickstart Scenario 6 (history tracking)

### Full Workflow Testing
After all tasks: Run complete quickstart.md test suite (10 scenarios).

---

## Parallelization Map

**Parallel Groups** (can execute simultaneously):
- **Group A**: Tasks 1.1, 1.2 (metadata + articles)
- **Group B**: Tasks 3.1, 3.2 (version logic + display)
- **Group C**: Tasks 4.1, 4.2 (imports + references)
- **Group D**: Tasks 5.2, 5.3, 5.4 (ADD/MODIFY/REMOVE implementations)
- **Group E**: Tasks 6.1, 6.2 (history entry + section location)

**Total Parallelization Potential**: 8 tasks can run in parallel (33% of tasks)

---

## Acceptance Criteria Coverage Matrix

| AC | Description | Covered By |
|----|-------------|------------|
| AC-001.1 | View mode displays summary | Task 1.3 |
| AC-001.2 | Shows version, dates | Tasks 1.1, 1.3 |
| AC-001.3 | Lists articles with status | Tasks 1.2, 1.3 |
| AC-001.4 | Includes file path | Task 1.3 |
| AC-002.1 | Parses $ARGUMENTS | Tasks 2.1, 2.2 |
| AC-002.2 | Interactive mode prompts | Task 2.3 |
| AC-002.3 | Can add new article | Task 5.2 |
| AC-002.4 | Can modify article | Task 5.3 |
| AC-002.5 | Can add/modify sections | Task 5.3 |
| AC-003.1 | MAJOR bump for removal | Task 3.1 |
| AC-003.2 | MINOR bump for addition | Task 3.1 |
| AC-003.3 | PATCH bump for clarifications | Task 3.1 |
| AC-003.4 | Shows version proposal | Task 3.2 |
| AC-003.5 | User can override | Task 3.3 |
| AC-004.1 | Finds importing skills | Task 4.1 |
| AC-004.2 | Checks article references | Task 4.2 |
| AC-004.3 | Report with status | Tasks 4.3, 7.1 |
| AC-004.4 | Warns on breaking changes | Task 4.4 |
| AC-005.1 | Adds history entry | Tasks 6.1, 6.3 |
| AC-005.2 | Entry format (version, date, summary) | Task 6.1 |
| AC-005.3 | Chronological order | Task 6.3 |
| AC-005.4 | Updates Last Amended date | Task 5.5 |

**Coverage**: 22/22 ACs (100%)

---

## Article VII Compliance

✅ **User-Story-Centric Organization**: Tasks grouped by user story (REQ-001 → REQ-005)
✅ **Independent Test Criteria**: Each user story has standalone test scenarios
✅ **Progressive Delivery**: P1 → P2 → P3 enables incremental validation
✅ **Parallelization Markers**: 8 tasks marked [P] for parallel execution

---

**Status**: ✅ READY FOR IMPLEMENTATION (Phase 5)
**Next Action**: Run `/implement specs/002-constitution-command/plan.md` or invoke `implement-and-verify` skill
**Total Estimated Effort**: ~6.5 hours (24 tasks × 5-35 minutes avg)
**Recommended Approach**: Implement P1 → validate → P2 → validate → P3 → final validation
