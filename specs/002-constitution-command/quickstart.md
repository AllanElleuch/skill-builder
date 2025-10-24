# Quick Start: Constitution Command Testing

**Feature**: 002-constitution-command
**Created**: 2025-10-20
**Purpose**: Manual test scenarios for validating constitution command functionality

---

## Test Environment Setup

### Prerequisites
- Claude Code CLI installed
- Project with `.claude/shared-imports/constitution.md` present
- Constitution file version 1.0.0 (baseline)

### Test Data Location
- Constitution file: `.claude/shared-imports/constitution.md`
- Expected dependent skills: 8 files in `.claude/skills/*/SKILL.md`

---

## Test Scenario 1: View Constitution Summary

**Objective**: Verify REQ-001 (Constitution Viewing)

**Acceptance Criteria Tested**:
- AC-001.1: `/constitution` displays summary
- AC-001.2: Shows version, ratification, last amended
- AC-001.3: Lists all articles with status
- AC-001.4: Includes file path

**Test Steps**:
```bash
# 1. Run command without arguments
> /constitution
```

**Expected Output**:
```
Intelligence Toolkit Constitution v1.0.0
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

**Validation**:
- [ ] Command executes without errors
- [ ] Version number displayed correctly
- [ ] Ratified date matches file (2025-10-19)
- [ ] Last Amended date matches file
- [ ] All 8 articles listed
- [ ] Article statuses shown (NON-NEGOTIABLE, MANDATORY, RECOMMENDED)
- [ ] File path displayed
- [ ] Usage instructions included

---

## Test Scenario 2: Add New Article (With Arguments)

**Objective**: Verify REQ-002 (Amendment Proposal) and REQ-003 (Version Bump)

**Acceptance Criteria Tested**:
- AC-002.1: Parses $ARGUMENTS
- AC-002.3: Can add new article
- AC-003.2: MINOR bump for adding article
- AC-003.4: Shows rationale

**Test Steps**:
```bash
# 1. Propose new article via arguments
> /constitution "Add Article IX: Progressive Disclosure - All documentation must use lazy loading patterns. Skills should use SKILL.md as overview, with details in separate files loaded only when needed."
```

**Expected Output**:
```
Analyzing amendment proposal...

Proposed Change:
• Type: ADD
• Target: New Article IX
• Content: Progressive Disclosure principle

Version Bump Analysis:
Current: 1.0.0
Proposed: 1.1.0 (MINOR - new article addition)

Rationale: Adding new article constitutes material expansion of governance framework.

Dependent Components:
Checking files that import constitution...

Found 8 skills importing @.claude/shared-imports/constitution.md:
• .claude/skills/specify-feature/SKILL.md
• .claude/skills/clarify-specification/SKILL.md
• .claude/skills/create-implementation-plan/SKILL.md
• .claude/skills/generate-tasks/SKILL.md
• .claude/skills/implement-and-verify/SKILL.md
• .claude/skills/analyze-code/SKILL.md
• .claude/skills/debug-issues/SKILL.md
• .claude/skills/coordinator/SKILL.md

No article reference conflicts detected.

Proceed with amendment? (y/n/edit)
```

**User Input**: `y`

**Expected After Confirmation**:
```
✅ Amendment applied

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

**Validation**:
- [ ] Proposal parsed correctly from $ARGUMENTS
- [ ] Amendment type identified as ADD
- [ ] Version bump calculated as MINOR (1.0.0 → 1.1.0)
- [ ] Rationale shown to user
- [ ] 8 dependent skills discovered
- [ ] No conflicts detected
- [ ] Confirmation prompt shown
- [ ] After confirmation, file updated successfully
- [ ] Sync impact report generated
- [ ] Amendment history updated
- [ ] Last Amended date changed

**File Validation**:
```bash
# Check constitution.md was updated
grep "^\*\*Version\*\*:" .claude/shared-imports/constitution.md
# Expected: **Version**: 1.1.0

grep "^## Article IX:" .claude/shared-imports/constitution.md
# Expected: ## Article IX: Progressive Disclosure

grep "^\*\*Last Amended\*\*:" .claude/shared-imports/constitution.md
# Expected: **Last Amended**: 2025-10-20

# Check amendment history
grep "^\*\*v1.1.0\*\*" .claude/shared-imports/constitution.md
# Expected: **v1.1.0** (2025-10-20):
```

---

## Test Scenario 3: Interactive Amendment Mode

**Objective**: Verify REQ-002 (Amendment Proposal) interactive path

**Acceptance Criteria Tested**:
- AC-002.2: Interactive mode when no arguments provided

**Test Steps**:
```bash
# 1. Run without arguments (should show summary first)
> /constitution

# 2. Follow up with amendment request
> I want to amend the constitution
```

**Expected Output**:
```
[Constitution summary shown first]

What would you like to amend?
1. Add new article
2. Modify existing article
3. Add section to existing article
4. Cancel

Choose an option (1-4):
```

**User Input**: `2`

**Expected Next Prompt**:
```
Which article? (Enter number I-IX)
```

**User Input**: `VI`

**Expected Output**:
```
Article VI: Simplicity and Anti-Abstraction

Current content preview:
"Maximum 3 projects in initial implementation..."

What change do you want to make?
(Describe the modification)
```

**User Input**: `Change "Maximum 3 projects" to "Maximum 5 projects" to allow more flexibility`

**Expected Analysis**:
```
Analyzing amendment proposal...

Proposed Change:
• Type: MODIFY
• Target: Article VI, Section 6.1
• Content: Update project limit from 3 to 5

Version Bump Analysis:
Current: 1.1.0
Proposed: 2.0.0 (MAJOR - backward-incompatible change)

Rationale: This relaxes a constraint, potentially invalidating existing
plans that were designed with 3-project limit in mind. Existing plans
may need review to ensure they still comply.

Impact Assessment:
⚠️ Plans created under 3-project limit may now be under-utilizing available
complexity budget. Consider re-evaluating project decomposition strategies.

Proceed with MAJOR version bump? (y/n/edit)
```

**Validation**:
- [ ] Interactive menu shown with 4 options
- [ ] Article selection prompted
- [ ] Current content preview displayed
- [ ] Change description accepted
- [ ] Modification type identified (MODIFY)
- [ ] Version bump calculated as MAJOR (1.1.0 → 2.0.0)
- [ ] Backward compatibility impact explained
- [ ] Confirmation with version bump type shown

---

## Test Scenario 4: Version Override

**Objective**: Verify REQ-003 (Version Bump Automation) with override

**Acceptance Criteria Tested**:
- AC-003.5: User can override version bump decision

**Test Steps**:
```bash
# 1. Propose amendment that system classifies as MAJOR
> /constitution "Change Article VI project limit from 3 to 5"

# System shows MAJOR bump recommendation...
```

**Expected Prompt**:
```
Proceed with MAJOR version bump? (y/n/edit)
```

**User Input**: `edit`

**Expected Override Prompt**:
```
Current recommendation: MAJOR (2.0.0)

Override to:
1. MAJOR (2.0.0) - backward-incompatible changes
2. MINOR (1.2.0) - material expansion
3. PATCH (1.1.1) - clarifications only

Choose override option (1-3) or cancel (c):
```

**User Input**: `2`

**Expected Confirmation**:
```
Override accepted: MINOR (1.1.0 → 1.2.0)

You're overriding the recommendation. Please confirm:
Original: MAJOR (backward-incompatible)
Override: MINOR (material expansion)

Proceed with override? (y/n)
```

**User Input**: `y`

**Expected Result**:
```
✅ Amendment applied with MINOR version bump

Sync Impact Report:
• Version: 1.1.0 → 1.2.0 (OVERRIDDEN from MAJOR)
• Modified: Article VI, Section 6.1 (project limit 3→5)
...
```

**Validation**:
- [ ] Override option shown when user enters "edit"
- [ ] 3 version bump options presented
- [ ] User selection accepted
- [ ] Confirmation prompt shown with original vs override
- [ ] File updated with overridden version
- [ ] Sync report indicates override

---

## Test Scenario 5: Dependency Conflict Detection

**Objective**: Verify REQ-004 (Consistency Validation)

**Acceptance Criteria Tested**:
- AC-004.1: Find importing skills
- AC-004.2: Check article references
- AC-004.3: Report with status
- AC-004.4: Warn on broken references

**Test Steps**:
```bash
# 1. Propose removing an article that is referenced
> /constitution "Remove Article IV"
```

**Expected Output**:
```
⚠️ Warning: Breaking change detected

The following components explicitly reference Article IV:
• .claude/skills/specify-feature/SKILL.md:8 - "@.claude/shared-imports/constitution.md"
• .claude/skills/create-implementation-plan/SKILL.md:8 - "Article IV Specification-First"
• .claude/templates/feature-spec.md:10 - "Article IV requirements"

Removing Article IV will break these references.

Recommended actions:
1. Update all 3 files to reference new article number (if renumbering)
2. Remove references if article is truly being deleted
3. Provide migration guide for skills

Proceed anyway? (y/n)
Type 'details' to see full file paths and line numbers.
```

**User Input**: `details`

**Expected Detail Output**:
```
Detailed Reference Analysis:

File: .claude/skills/specify-feature/SKILL.md
Line 8: @.claude/shared-imports/constitution.md
Context: [shows 3 lines before and after]

File: .claude/skills/create-implementation-plan/SKILL.md
Line 8: Follow Article IV Specification-First workflow
Context: [shows 3 lines before and after]

File: .claude/templates/feature-spec.md
Line 10: ## Article IV Requirements
Context: [shows 3 lines before and after]

Proceed anyway? (y/n)
```

**User Input**: `n`

**Expected Result**:
```
Amendment cancelled.

No changes made to constitution.
```

**Validation**:
- [ ] References discovered via rg/grep
- [ ] File paths with line numbers shown
- [ ] Context shown when "details" requested
- [ ] Warning issued before proceeding
- [ ] User can cancel amendment
- [ ] File unchanged after cancellation

---

## Test Scenario 6: Amendment History Tracking

**Objective**: Verify REQ-005 (Amendment History Tracking)

**Acceptance Criteria Tested**:
- AC-005.1: Entry added to history
- AC-005.2: Includes version, date, summary
- AC-005.3: Chronological order
- AC-005.4: Last Amended date updated

**Test Steps**:
```bash
# 1. Add Article IX (from Scenario 2)
> /constitution "Add Article IX: Progressive Disclosure..."

# 2. Check amendment history in file
> grep -A 5 "^## Amendment History" .claude/shared-imports/constitution.md
```

**Expected File Content**:
```markdown
## Amendment History

**v1.1.0** (2025-10-20):
- Added Article IX: Progressive Disclosure
- Clarification pass on progressive disclosure patterns

**v1.0.0** (2025-10-19):
- Initial ratification
- 8 core articles established
- Integration with Spec-Kit SDD methodology
```

**Validation**:
- [ ] New entry added to history section
- [ ] Version number included (v1.1.0)
- [ ] Date included in ISO 8601 format (2025-10-20)
- [ ] Summary describes changes (bullet list)
- [ ] Newest entry appears first (reverse chronological)
- [ ] Last Amended date in metadata matches history date

**Additional Check**:
```bash
# Check Last Amended date was updated
grep "^\*\*Last Amended\*\*:" .claude/shared-imports/constitution.md
# Expected: **Last Amended**: 2025-10-20

# Check Governance section version matches
grep -A 2 "^### Version:" .claude/shared-imports/constitution.md
# Expected: ### Version: 1.1.0
```

---

## Test Scenario 7: Edge Case - Invalid Amendment

**Objective**: Verify error handling for invalid amendments

**Test Steps**:
```bash
# 1. Try to remove all articles
> /constitution "Remove all articles"
```

**Expected Output**:
```
❌ Amendment rejected

Reason: Removing all articles would leave constitution empty, violating
governance requirements.

Minimum requirements:
• At least one NON-NEGOTIABLE article must exist
• Governance section must be preserved
• Amendment history must be maintained

Please revise your proposal.
```

**Validation**:
- [ ] Invalid amendment detected
- [ ] Clear error message shown
- [ ] Minimum requirements explained
- [ ] No changes made to file

---

## Test Scenario 8: Edge Case - Version Conflict

**Objective**: Verify handling of external file modifications

**Test Steps**:
```bash
# 1. Manually edit constitution.md externally (change version to 1.2.0)

# 2. Try to apply amendment via command
> /constitution "Add Article X: Documentation Standards"
```

**Expected Output**:
```
⚠️ Version conflict detected

Expected current version: 1.1.0
Actual file version: 1.2.0

The constitution file may have been modified outside this command.

Options:
1. Reload and retry (recommended)
2. Force amendment (advanced - may create inconsistency)
3. Cancel and review changes manually

Choose: (1/2/3)
```

**User Input**: `1`

**Expected Result**:
```
Reloading constitution...

Current version: 1.2.0

Proceeding with amendment...
[Normal amendment flow continues]
```

**Validation**:
- [ ] Version mismatch detected
- [ ] Clear explanation provided
- [ ] 3 options offered
- [ ] Reload option works correctly
- [ ] Amendment proceeds after reload

---

## Test Scenario 9: Sync Impact Report Verification

**Objective**: Verify comprehensive impact reporting

**Acceptance Criteria Tested**:
- AC-004.3: Report lists files with status

**Test Steps**:
```bash
# 1. Apply amendment (reuse Scenario 2)
> /constitution "Add Article IX: Progressive Disclosure..."
> y
```

**Expected Sync Impact Report Section**:
```
Dependent Files Status:
⚠️ 8 skills import constitution - review recommended
    - .claude/skills/specify-feature/SKILL.md
    - .claude/skills/clarify-specification/SKILL.md
    - .claude/skills/create-implementation-plan/SKILL.md
    - .claude/skills/generate-tasks/SKILL.md
    - .claude/skills/implement-and-verify/SKILL.md
    - .claude/skills/analyze-code/SKILL.md
    - .claude/skills/debug-issues/SKILL.md
    - .claude/skills/coordinator/SKILL.md

✅ No templates reference Article IX yet (new article)

Next Actions:
1. Review skills to determine if Article IX applies
2. Update templates if progressive disclosure affects them
3. Update documentation referencing article count
4. Consider adding Article IX guidance to skill development docs

Amendment complete!
```

**Validation**:
- [ ] All 8 dependent files listed
- [ ] Status indicators shown (⚠️ for review needed, ✅ for no action)
- [ ] Specific next actions provided
- [ ] File paths included
- [ ] No false positives (templates correctly show no references)

---

## Test Scenario 10: Typo Fix (PATCH Version)

**Objective**: Verify PATCH version bump for non-semantic changes

**Acceptance Criteria Tested**:
- AC-003.3: PATCH bump for clarifications/typos

**Test Steps**:
```bash
> /constitution "Fix typo in Article II: 'evidance' should be 'evidence'"
```

**Expected Output**:
```
Analyzing amendment proposal...

Proposed Change:
• Type: MODIFY
• Target: Article II, Section 2.1
• Content: Typo correction (evidance → evidence)

Version Bump Analysis:
Current: 1.1.0
Proposed: 1.1.1 (PATCH - non-semantic clarification)

Rationale: Typo fix does not change meaning or requirements.
This is a clarification with no impact on implementations.

Dependent Components:
[Standard dependency check...]

Proceed with PATCH version bump? (y/n)
```

**Validation**:
- [ ] Change classified as PATCH
- [ ] Version increments correctly (1.1.0 → 1.1.1)
- [ ] Rationale explains non-semantic nature
- [ ] File updated with PATCH version

---

## Manual Verification Checklist

After running all scenarios:

### File Integrity
- [ ] Constitution.md has valid version format (X.Y.Z)
- [ ] Ratified date unchanged (immutable)
- [ ] Last Amended date reflects latest change
- [ ] Amendment History entries in reverse chronological order
- [ ] No duplicate version numbers in history
- [ ] All articles have unique Roman numerals
- [ ] Governance section version matches metadata version

### Dependency Integrity
- [ ] All 8 skills still import constitution correctly
- [ ] No broken @ import references
- [ ] Article references in skills remain valid
- [ ] Templates referencing articles not broken

### Command Behavior
- [ ] View mode works without arguments
- [ ] Argument mode parses correctly
- [ ] Interactive mode provides clear prompts
- [ ] Confirmation step always shown
- [ ] User can cancel at any point
- [ ] Version override works as expected
- [ ] Error messages are clear and actionable

### Output Quality
- [ ] Sync impact reports complete
- [ ] Next actions specific and helpful
- [ ] File paths absolute and correct
- [ ] Status indicators (✅/⚠️) appropriate
- [ ] Line numbers shown in conflict warnings

---

## Performance Checks

### Token Efficiency
- [ ] View mode output < 500 tokens
- [ ] Amendment flow < 1,500 tokens
- [ ] Sync report < 1,000 tokens

### Execution Time
- [ ] View mode: < 2 seconds
- [ ] Amendment proposal: < 5 seconds
- [ ] Dependency discovery: < 10 seconds
- [ ] File update: < 3 seconds

### Line Count Validation
- [ ] Command file: < 300 lines (Article VI compliance)
- [ ] No external dependencies
- [ ] Pure bash/Claude Code tools

---

## Rollback Test

**Objective**: Verify constitution can be reverted if needed

**Test Steps**:
```bash
# 1. Create backup
cp .claude/shared-imports/constitution.md /tmp/constitution-backup.md

# 2. Apply amendment
> /constitution "Add Article IX..."

# 3. Manual rollback (git revert or file restore)
cp /tmp/constitution-backup.md .claude/shared-imports/constitution.md

# 4. Verify restoration
grep "^\*\*Version\*\*:" .claude/shared-imports/constitution.md
# Expected: original version restored
```

**Validation**:
- [ ] File restores correctly
- [ ] Skills continue importing without errors
- [ ] No broken references after rollback
- [ ] Amendment history reflects rollback if documented

---

## Success Criteria Summary

**All 22 Acceptance Criteria Covered:**
- REQ-001: AC-001.1 through AC-001.4 (View mode)
- REQ-002: AC-002.1 through AC-002.5 (Amendment proposals)
- REQ-003: AC-003.1 through AC-003.5 (Version bumps)
- REQ-004: AC-004.1 through AC-004.4 (Dependency validation)
- REQ-005: AC-005.1 through AC-005.4 (Amendment history)
- REQ-008: Open access model (governance)

**Edge Cases Covered:**
- Invalid amendments (remove all)
- Version conflicts (external edits)
- Dependency conflicts (referenced articles)
- Typo fixes (PATCH version)
- Version overrides

**Integration Validated:**
- 8 skills importing constitution
- Templates referencing articles
- Git workflow compatibility
- Claude Code tool usage

---

**Test Status**: ✅ READY FOR MANUAL TESTING
**Next Action**: Proceed to Phase 4 (Task Generation) to break implementation into specific tasks
**Validation**: All 22 ACs mapped to test scenarios with clear pass/fail criteria
