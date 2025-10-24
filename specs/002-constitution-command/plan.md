---
feature: 002-constitution-command
created: 2025-10-20
specification: specs/002-constitution-command/spec.md
clarification: specs/002-constitution-command/clarification-checklist.md
status: Ready for Implementation
---

# Implementation Plan: Constitution Management Command

## Summary

Create `/constitution` slash command (.claude/commands/constitution.md) enabling interactive amendment of Intelligence Toolkit Constitution. Command will parse markdown structure, determine semantic version bumps, validate dependent file references, and generate sync impact reports. Implementation uses pure Claude Code tools (Read, Write, Edit, Grep, Bash) with no external dependencies, targeting < 300 lines for simplicity (Article VI compliance).

---

## Technical Context

### Tech Stack
- **Language**: Bash (slash command scripting)
- **Platform**: Claude Code CLI environment
- **Primary Dependencies**: None (pure Claude Code built-in tools)
- **Target File**: `.claude/shared-imports/constitution.md` (442 lines, Markdown)
- **Storage**: File system (no database)
- **Testing**: Manual validation via quickstart scenarios

### Existing Architecture (Intelligence Evidence)

**Slash Commands Pattern** (evidence: .claude/commands/*.md):
- 6 existing commands totaling 1,378 lines (avg ~230 lines/command)
- Commands use bash pre-execution (`!command` prefix)
- Markdown format with natural language instructions for Claude
- Example pattern from bug.md:1-10 shows bash shebang + pre-execution

**Constitution Structure** (evidence: .claude/shared-imports/constitution.md):
- Version metadata: `**Version**: X.Y.Z` (line 3)
- Ratified/Amended dates: ISO 8601 format (lines 4-5)
- 8 articles with Roman numerals (lines 21, 59, 113, 150, 208, 261, 302, 355)
- Governance section: lines 382-427 (with amendment procedures)
- Amendment History: lines 430+ (chronological log)

**Dependency Pattern** (evidence: rg "@.*constitution\.md"):
- 8 skills import constitution via `@.claude/shared-imports/constitution.md`
- Article references found in skills (e.g., "Article IV Specification-First")
- @ import architecture requires single source of truth (no token replacement)

---

## Constitution Check (Article VI)

### Pre-Design Gates

**Gate 1: Project Count** ✅ PASS
- This feature adds 1 slash command file
- No new projects introduced
- Total project complexity unchanged

**Gate 2: Abstraction Layers** ✅ PASS
- No repository/service/facade patterns
- Direct file I/O using Claude Code tools (Read, Write, Edit)
- No wrapper layers

**Gate 3: Framework Trust** ✅ PASS
- Using Claude Code tools directly (not wrapping them)
- Relying on bash for parsing (not custom parser)
- No reinvention of existing functionality

### Post-Design Validation

**Complexity Assessment:**
| Metric | Limit | Actual | Status |
|--------|-------|--------|--------|
| Projects | ≤ 3 | 0 new | ✅ Pass |
| Abstraction layers | ≤ 2 | 0 (direct I/O) | ✅ Pass |
| Custom frameworks | Justify | 0 | ✅ Pass |
| Line count | < 300 | ~250 (est) | ✅ Pass |

**Violations**: None

---

## Architecture

### Component Breakdown

**Single Component**: `.claude/commands/constitution.md`

**Responsibilities**:
1. **Parse Constitution** - Extract version, articles, amendment history
2. **Display Summary** - Format current state for user viewing
3. **Accept Amendment** - Parse $ARGUMENTS or interactive prompts
4. **Determine Version Bump** - Apply semver rules (MAJOR/MINOR/PATCH)
5. **Validate Dependencies** - Find skills/templates referencing constitution
6. **Update File** - Modify constitution.md with new content + history entry
7. **Report Impact** - Show version change, affected files, next actions

### Integration Points

**Input Sources**:
- User: `$ARGUMENTS` (amendment proposal text)
- File System: `.claude/shared-imports/constitution.md` (target file)

**Output Destinations**:
- File System: Updated `.claude/shared-imports/constitution.md`
- User: Formatted summary, impact report (stdout)

**External Queries**:
- `rg "@.*constitution\.md" .claude/` - Find importing skills
- `rg "Article [IVX]+" .claude/` - Find article references

### Data Flow

```
User → $ARGUMENTS → Parse Amendment Type (ADD/MODIFY/REMOVE)
  ↓
Read constitution.md → Extract Current State (version, articles)
  ↓
Determine Version Bump (MAJOR/MINOR/PATCH based on change type)
  ↓
Find Dependencies (rg for imports and references)
  ↓
User Confirmation → Apply Changes (Edit/Write constitution.md)
  ↓
Generate Impact Report → Output to User
```

---

## File Structure

```
.claude/commands/
└── constitution.md      # NEW - Constitution management command (~250 lines)

.claude/shared-imports/
└── constitution.md      # EXISTING - Target file for amendments (442 lines)

.claude/skills/
├── specify-feature/SKILL.md       # EXISTING - Imports constitution (no changes)
├── clarify-specification/SKILL.md # EXISTING - Imports constitution (no changes)
├── create-implementation-plan/SKILL.md # EXISTING - Imports constitution (no changes)
└── ...                            # 5 more skills importing constitution

specs/002-constitution-command/
├── spec.md              # EXISTING - Feature specification
├── clarification-checklist.md # EXISTING - Clarification analysis
├── plan.md              # THIS FILE - Implementation plan
├── research.md          # TO CREATE - Technical decisions
├── data-model.md        # TO CREATE - File format specification
└── quickstart.md        # TO CREATE - Test scenarios
```

---

## Acceptance Criteria

### REQ-001: Constitution Viewing (P1)

**AC-001.1**: `/constitution` with no arguments displays summary
- **Given** constitution exists with current version and articles
- **When** user runs `/constitution` with no arguments
- **Then** summary displays version, ratification date, last amended, article list
- **Test**: Run command, verify output contains all metadata fields

**AC-001.2**: Summary shows version number, ratification date, last amended date
- **Given** constitution has version 1.0.0, ratified 2025-10-19
- **When** user views summary
- **Then** all three fields visible in formatted output
- **Test**: Verify `**Version**: 1.0.0`, `**Ratified**: 2025-10-19`, `**Last Amended**: YYYY-MM-DD` present

**AC-001.3**: Summary lists all articles with status
- **Given** constitution has 8 articles (I-VIII)
- **When** user views summary
- **Then** each article shown with title and status (NON-NEGOTIABLE/MANDATORY/RECOMMENDED)
- **Test**: Count output lines, verify 8 articles with statuses

**AC-001.4**: Summary includes link to full file path
- **Given** constitution at `.claude/shared-imports/constitution.md`
- **When** user views summary
- **Then** output includes `File: .claude/shared-imports/constitution.md`
- **Test**: Verify file path string in output

### REQ-002: Amendment Proposal (P1)

**AC-002.1**: `/constitution "$ARGUMENTS"` parses amendment proposal
- **Given** user provides amendment text in $ARGUMENTS
- **When** command executes with arguments
- **Then** amendment text captured and analyzed
- **Test**: `/constitution "Add Article IX"` triggers amendment mode

**AC-002.2**: Interactive mode prompts if no arguments provided
- **Given** user runs `/constitution` alone
- **When** user responds to "What would you like to amend?" prompt
- **Then** interactive workflow guides through amendment options
- **Test**: Run without args, verify prompt appears

**AC-002.3**: Amendment can add new article
- **Given** constitution has 8 articles
- **When** user proposes "Add Article IX: New Principle"
- **Then** new article added with Roman numeral IX
- **Test**: Verify Article IX present in updated file

**AC-002.4**: Amendment can modify existing article
- **Given** Article VI exists with "Maximum 3 projects"
- **When** user proposes modification to change limit
- **Then** article content updated, version bumped correctly
- **Test**: Verify content change and MAJOR version bump

**AC-002.5**: Amendment can add/modify sections within articles
- **Given** Article I has sections 1.1 and 1.2
- **When** user proposes adding section 1.3
- **Then** new section inserted correctly
- **Test**: Verify section numbering preserved

### REQ-003: Version Bump Automation (P2)

**AC-003.1**: MAJOR bump when removing/redefining articles
- **Given** current version 1.0.0
- **When** user removes or redefines existing article
- **Then** version becomes 2.0.0
- **Test**: Propose removal, verify version incremented to 2.0.0

**AC-003.2**: MINOR bump when adding new articles
- **Given** current version 1.0.0
- **When** user adds Article IX
- **Then** version becomes 1.1.0
- **Test**: Propose addition, verify version incremented to 1.1.0

**AC-003.3**: PATCH bump for clarifications/wording fixes
- **Given** current version 1.0.0
- **When** user fixes typo or clarifies existing text
- **Then** version becomes 1.0.1
- **Test**: Propose typo fix, verify version incremented to 1.0.1

**AC-003.4**: User shown proposed version with rationale
- **Given** amendment proposal analyzed
- **When** version bump determined
- **Then** user sees "Current: 1.0.0 → Proposed: 1.1.0 (MINOR - new article addition)"
- **Test**: Verify version bump explanation in output

**AC-003.5**: User can override version bump decision
- **Given** system proposes MINOR bump
- **When** user disagrees and specifies different bump
- **Then** user's choice respected (with confirmation prompt)
- **Test**: Override version bump, verify user choice applied

### REQ-004: Consistency Validation (P2)

**AC-004.1**: Find all skills importing constitution
- **Given** 8 skills import `@.claude/shared-imports/constitution.md`
- **When** command validates dependencies
- **Then** all 8 skills listed in report
- **Test**: Verify `rg "@.*constitution\.md"` finds all 8 skills

**AC-004.2**: Check templates for article references
- **Given** templates may reference "Article IV" etc.
- **When** command searches for article mentions
- **Then** all references found and reported
- **Test**: Verify `rg "Article [IVX]+"` finds template references

**AC-004.3**: Report lists files with status (✅/⚠️)
- **Given** dependent files discovered
- **When** impact report generated
- **Then** each file marked as reviewed or needs review
- **Test**: Verify report contains ✅/⚠️ symbols with file paths

**AC-004.4**: Warning if skills reference removed/renumbered articles
- **Given** skill references "Article IV Specification-First"
- **When** user attempts to remove Article IV
- **Then** warning shown with affected file paths
- **Test**: Propose Article IV removal, verify warning with file:line references

### REQ-005: Amendment History Tracking (P3)

**AC-005.1**: Each amendment adds entry to Amendment History section
- **Given** amendment approved and applied
- **When** constitution file updated
- **Then** new entry appended to Amendment History
- **Test**: Verify new entry with version in Amendment History section

**AC-005.2**: Entry includes version, date, summary of changes
- **Given** amendment creates version 1.1.0 on 2025-10-20
- **When** history entry created
- **Then** entry format: `**v1.1.0** (2025-10-20): Added Article IX (description)`
- **Test**: Verify format matches pattern

**AC-005.3**: Amendment history maintains chronological order
- **Given** multiple amendments over time
- **When** new amendment added
- **Then** entries ordered newest first (or oldest first, consistently)
- **Test**: Verify order preserved across multiple amendments

**AC-005.4**: Last Amended date updates with each change
- **Given** constitution `**Last Amended**: 2025-10-19`
- **When** amendment applied on 2025-10-20
- **Then** `**Last Amended**: 2025-10-20`
- **Test**: Verify date field updated to today's date

---

## Implementation Phases

### Phase 1: Basic View Mode (P1 - Core)
**Scope**: Implement read-only constitution viewing

**Tasks**:
1. Create `.claude/commands/constitution.md` file with bash shebang
2. Implement `Read .claude/shared-imports/constitution.md`
3. Parse version line (`**Version**: X.Y.Z`)
4. Parse dates (`**Ratified**:`, `**Last Amended**:`)
5. Extract articles (grep for `## Article [IVX]+:`)
6. Format and display summary output
7. Include file path in output

**Acceptance Criteria**: AC-001.1, AC-001.2, AC-001.3, AC-001.4

**Verification**:
```bash
/constitution
# Expected: Summary with version, dates, 8 articles, file path
```

### Phase 2: Amendment Parsing (P1 - Core)
**Scope**: Accept and parse amendment proposals

**Tasks**:
1. Detect if `$ARGUMENTS` provided (amendment mode vs view mode)
2. Parse amendment type from text (ADD/MODIFY/REMOVE keywords)
3. Extract target (article number, section, or new)
4. Extract content (amendment text)
5. Implement interactive prompts if no arguments
6. Validate amendment structure (article numbers, formatting)

**Acceptance Criteria**: AC-002.1, AC-002.2

**Verification**:
```bash
/constitution "Add Article IX: Progressive Disclosure"
# Expected: Amendment parsed, type=ADD, target=IX

/constitution
# Expected: Interactive prompt: "What would you like to amend?"
```

### Phase 3: Version Bump Logic (P2 - Should-Have)
**Scope**: Implement semantic versioning rules

**Tasks**:
1. Parse current version from constitution
2. Determine bump type based on amendment:
   - MAJOR if REMOVE article or redefine existing
   - MINOR if ADD article or material expansion
   - PATCH if clarification/wording/typo
3. Calculate new version (X+1.0.0, X.Y+1.0, X.Y.Z+1)
4. Format version bump explanation
5. Prompt user for confirmation with rationale
6. Allow user override (ask for different bump type)

**Acceptance Criteria**: AC-003.1, AC-003.2, AC-003.3, AC-003.4, AC-003.5

**Verification**:
```bash
/constitution "Add Article IX"
# Expected: "Current: 1.0.0 → Proposed: 1.1.0 (MINOR - new article addition)"

/constitution "Remove Article VIII"
# Expected: "Current: 1.0.0 → Proposed: 2.0.0 (MAJOR - article removal)"
```

### Phase 4: Dependency Discovery (P2 - Should-Have)
**Scope**: Find and validate dependent files

**Tasks**:
1. Run `rg "@.*constitution\.md" .claude/` to find importing skills
2. Run `rg "Article [IVX]+" .claude/` to find article references
3. Parse results to extract file paths and line numbers
4. Check if removed/renumbered articles are referenced
5. Generate warnings for breaking changes
6. Format dependency list for report

**Acceptance Criteria**: AC-004.1, AC-004.2, AC-004.3, AC-004.4

**Verification**:
```bash
rg "@.*constitution\.md" .claude/ | wc -l
# Expected: 8 (matches known skill count)

/constitution "Remove Article IV"
# Expected: Warning listing 3 files referencing Article IV
```

### Phase 5: File Update (P1 - Core)
**Scope**: Apply amendment to constitution file

**Tasks**:
1. Read entire constitution file content
2. For ADD: Insert new article at appropriate position (before Governance)
3. For MODIFY: Replace targeted section/article content
4. For REMOVE: Delete article (with confirmation)
5. Update `**Version**:` line with new version
6. Update `**Last Amended**:` line with today's date
7. Write updated content back to file
8. Verify write succeeded (file exists, readable)

**Acceptance Criteria**: AC-002.3, AC-002.4, AC-002.5

**Verification**:
```bash
/constitution "Add Article IX"
# Then: Read .claude/shared-imports/constitution.md
# Expected: Article IX present, version updated, date updated
```

### Phase 6: Amendment History (P3 - Nice-to-Have)
**Scope**: Track changes in constitution

**Tasks**:
1. Locate Amendment History section (line 430+)
2. Generate entry: `**vX.Y.Z** (YYYY-MM-DD): <summary>`
3. Append entry to history (maintain chronological order)
4. Ensure history section exists (create if missing)

**Acceptance Criteria**: AC-005.1, AC-005.2, AC-005.3, AC-005.4

**Verification**:
```bash
/constitution "Add Article IX"
# Then: grep -A 5 "## Amendment History" .claude/shared-imports/constitution.md
# Expected: New entry with v1.1.0, today's date, summary
```

### Phase 7: Impact Report (P2 - Should-Have)
**Scope**: Generate sync impact summary

**Tasks**:
1. Format report header with emoji indicators (✅/⚠️)
2. Show version change (old → new)
3. List modified articles (added/removed/changed)
4. List dependent files with status
5. Suggest next actions based on changes
6. Output report after successful amendment

**Acceptance Criteria**: AC-004.3 (partial), AC-001.1 (report format)

**Verification**:
```bash
/constitution "Add Article IX"
# Expected: Sync Impact Report with:
#   - Version: 1.0.0 → 1.1.0
#   - Added: Article IX
#   - Dependent Files: 8 skills ⚠️ review recommended
#   - Next Actions: [list]
```

---

## CoD^Σ Evidence Traces

### Tech Stack Selection
```
Intel Query: ls -la .claude/commands/*.md | wc -l → 6 commands exist
Intel Query: wc -l .claude/commands/*.md → 1,378 total lines (avg ~230/cmd)
Decision: Use bash + markdown (same as existing commands)
Evidence: bug.md:1-10 shows bash shebang + pre-execution pattern
```

### Constitution Structure Analysis
```
Intel Query: rg "^## Article" constitution.md -n → 8 articles at known lines
Intel Query: grep "**Version**:" constitution.md → Line 3 format: **Version**: X.Y.Z
Decision: Parse version with grep + sed, articles with grep + Roman numeral regex
Evidence: constitution.md:3,21,59,113,150,208,261,302,355
```

### Dependency Discovery
```
Intel Query: rg "@.*constitution\.md" .claude/ -l → 8 skills importing
Intel Query: rg "Article [IVX]+" .claude/skills/ → References found in skill descriptions
Decision: Use rg for dependency discovery (already in codebase, fast, accurate)
Evidence: Skills explicitly reference "Article IV Specification-First"
```

### Version Bump Logic
```
Spec Analysis: constitution.md:394-397 defines semver rules
Logic: MAJOR = breaking, MINOR = additions, PATCH = clarifications
Decision: Implement via bash conditionals checking amendment type
Evidence: Governance section explicitly defines version bump semantics
```

---

## Technical Decisions (Research)

### Decision 1: Markdown Parsing Approach

**Decision**: Use bash text processing (grep, sed, awk) instead of custom parser

**Rationale**:
- Constitution is structured markdown with consistent patterns
- grep handles regex patterns for `## Article [IVX]+:`
- sed can extract specific line ranges
- No need for full markdown AST (Article VI: Framework Trust)

**Alternatives Considered**:
- Custom markdown parser: Rejected (complexity violation, reinvents wheel)
- Python/Node script: Rejected (external dependency violation)

**Evidence**:
- bug.md:1-10 shows bash commands used successfully in existing commands
- Constitution structure is regular (articles always start with `## Article`)

### Decision 2: Amendment Application Method

**Decision**: Use Write tool for full file replacement (not Edit tool)

**Rationale**:
- Edit tool requires exact string matching (fragile for large edits)
- Write tool guarantees atomic replacement (safer)
- Simpler logic: read → modify in memory → write back
- Article VI: Simplicity principle

**Alternatives Considered**:
- Edit tool for surgical changes: Rejected (requires exact string match, error-prone)
- Line-by-line sed editing: Rejected (complex, hard to verify)

**Evidence**:
- Write tool available in slash commands (allowed-tools: Write)
- Full file replacement ensures consistency

### Decision 3: Version Bump Determination

**Decision**: Rule-based logic with user override option

**Rationale**:
- ADD article → MINOR (material expansion)
- MODIFY article → Context-dependent (ask user or default MINOR)
- REMOVE article → MAJOR (breaking change)
- Constitution.md:394-397 defines explicit rules

**Alternatives Considered**:
- Always ask user: Rejected (tedious, defeats automation purpose)
- AI-based classification: Rejected (unnecessary complexity)

**Evidence**:
- Constitution governance explicitly defines semver rules
- User override preserves flexibility for edge cases

### Decision 4: Dependency Validation Depth

**Decision**: Find imports and article references, report but don't block

**Rationale**:
- Blocking amendments based on references is too restrictive (REQ-008: Open access)
- Reporting empowers user to make informed decision
- Skills resilient to constitutional changes (principles guide, don't dictate syntax)

**Alternatives Considered**:
- Block breaking changes: Rejected (conflicts with open access model)
- Auto-update references: Rejected (out of scope, future v2)

**Evidence**:
- REQ-008: Open access model (no approval workflow)
- Skills import constitution but aren't tightly coupled to article numbers

---

## Risk Mitigation

### Risk 1: Constitution File Corruption
**Impact**: High
**Likelihood**: Low
**Mitigation**:
- Validate version/date formats before writing
- Verify file still readable after write
- User can git revert if needed (version controlled)

### Risk 2: Broken @ Imports
**Impact**: High
**Likelihood**: Low
**Mitigation**:
- File path never changes (`.claude/shared-imports/constitution.md`)
- @ imports reference path, not content (resilient)
- Report shows affected files for manual review

### Risk 3: Version Number Confusion
**Impact**: Medium
**Likelihood**: Medium
**Mitigation**:
- Clear version bump rationale shown to user
- User can override if system gets it wrong
- Amendment history provides audit trail

---

## Testing Strategy

### Manual Testing (Quickstart Scenarios)
See `specs/002-constitution-command/quickstart.md` for detailed test scenarios.

**Smoke Test**:
```bash
# 1. View mode
/constitution
# Verify: Summary displays correctly

# 2. Add article
/constitution "Add Article IX: Test Principle"
# Verify: Article added, version 1.0.0 → 1.1.0

# 3. Verify file updated
Read .claude/shared-imports/constitution.md | grep "Article IX"
# Verify: Article IX present

# 4. Check history
Read .claude/shared-imports/constitution.md | grep -A 2 "Amendment History"
# Verify: New entry with v1.1.0
```

### Article VI Compliance Verification
- Line count: `wc -l .claude/commands/constitution.md` (expect < 300)
- No external deps: `grep -E "npm|pip|gem|cargo" constitution.md` (expect no matches)
- Framework trust: Manual review (no wrapper functions)

---

## Next Steps

After this plan approved:
1. Use `generate-tasks` skill to break down into implementable tasks
2. Use `implement-and-verify` skill to execute with TDD (Article III)
3. Verify all 22 acceptance criteria pass
4. Update this plan if implementation reveals gaps

---

**Status**: ✅ READY FOR TASK GENERATION (Phase 4)
**Next Action**: Run `/tasks specs/002-constitution-command/plan.md` or invoke `generate-tasks` skill
**Blocked By**: None
**Planning Completed**: 2025-10-20 - 7 phases, 22 ACs, full CoD^Σ evidence
