# Technical Research: Constitution Command

**Feature**: 002-constitution-command
**Created**: 2025-10-20
**Purpose**: Document technical decisions with evidence and alternatives

---

## Decision 1: Markdown Parsing Approach

**Context**: Constitution is 442-line markdown file with structured articles

**Decision**: Use bash text processing (grep, sed, awk) for parsing

**Rationale**:
- Constitution has consistent patterns (`## Article [IVX]+:` for articles)
- grep/sed/awk are built-in, no external dependencies
- Sufficient for our needs (extract version, articles, sections)
- Article VI: Trust framework features (bash is the "framework" here)

**Alternatives Considered**:
1. **Custom markdown parser in Python/Node**
   - ❌ Rejected: Requires external dependency (REQ-006: No external deps)
   - ❌ Rejected: Violates Article VI (reinventing wheel)
   - Evidence: Adds 50+ lines for parser, increases complexity

2. **Full markdown AST library**
   - ❌ Rejected: Overkill for structured document
   - ❌ Rejected: External dependency
   - Evidence: Constitution structure is simpler than general markdown

**Evidence**:
- bug.md:1-10 shows bash commands working in existing slash commands
- Constitution articles always start with `## Article` (verified via grep)
- Existing commands average ~230 lines (bash-only, no parsing libraries)

---

## Decision 2: File Modification Strategy

**Context**: Need to update constitution content, version, dates, history

**Decision**: Use Write tool for full file replacement

**Rationale**:
- Write guarantees atomic replacement (safer than incremental edits)
- Simpler logic: read → modify in memory → write back
- No string matching fragility (Edit tool requires exact matches)
- Article VI: Simplicity principle

**Alternatives Considered**:
1. **Edit tool for surgical changes**
   - ❌ Rejected: Requires exact string matching (fragile for large amendments)
   - ❌ Rejected: Multiple edits increase failure risk
   - Evidence: Adding Article IX requires inserting before Governance section (Edit tool would need exact surrounding text)

2. **Line-by-line sed editing**
   - ❌ Rejected: Complex logic, hard to test
   - ❌ Rejected: Error-prone for multi-line amendments
   - Evidence: Amendment might span 20+ lines (too complex for sed)

**Evidence**:
- Write tool available in Claude Code (allowed-tools list)
- Full replacement is idempotent (deterministic outcome)
- Constitution file is < 500 lines (small enough to rewrite entirely)

---

## Decision 3: Version Bump Logic

**Context**: Constitution.md:394-397 defines semantic versioning rules

**Decision**: Rule-based classification with user override

**Classification Rules**:
- **MAJOR** (X+1.0.0): REMOVE article, redefine existing article (breaking)
- **MINOR** (X.Y+1.0): ADD article, material expansion of section (additive)
- **PATCH** (X.Y.Z+1): Typo fixes, wording clarifications, formatting (non-semantic)

**Rationale**:
- Constitution explicitly defines semver rules (lines 394-397)
- Automated classification reduces user burden
- User override preserves flexibility for edge cases
- Clear rationale helps user validate decision

**Alternatives Considered**:
1. **Always ask user for bump type**
   - ❌ Rejected: Tedious, defeats automation purpose
   - ❌ Rejected: Users may not understand semver rules
   - Evidence: Spec requires "automatic version bumps" (REQ-003)

2. **AI-based semantic analysis**
   - ❌ Rejected: Unnecessary complexity (Article VI violation)
   - ❌ Rejected: Rules are explicit enough for deterministic logic
   - Evidence: Amendment types (ADD/MODIFY/REMOVE) map cleanly to semver

**Implementation Approach**:
```bash
if [[ "$AMENDMENT_TYPE" == "REMOVE" ]] || [[ "$AMENDMENT_TYPE" == "REDEFINE" ]]; then
    BUMP_TYPE="MAJOR"
    RATIONALE="Article removal/redefinition is backward-incompatible"
elif [[ "$AMENDMENT_TYPE" == "ADD" ]]; then
    BUMP_TYPE="MINOR"
    RATIONALE="New article constitutes material expansion"
else  # MODIFY (section changes, not full article)
    BUMP_TYPE="MINOR"  # Default for expansions
    RATIONALE="Section expansion (verify: is this just clarification?)"
fi
```

**User Override**:
- Show proposed bump with rationale
- Ask: "Proceed with [TYPE] bump? (y/n/override)"
- If override: ask for desired bump type + confirm

**Evidence**:
- Constitution.md:394-397 provides explicit semver mapping
- AC-003.5 requires user override capability
- Spec shows example: "Change 'Maximum 3 projects' to 5" → MAJOR (breaking change)

---

## Decision 4: Dependency Discovery Depth

**Context**: 8 skills import constitution, templates may reference articles

**Decision**: Report dependencies but don't block amendments

**Discovery Approach**:
```bash
# Find @ imports
rg "@.*constitution\.md" .claude/ -l

# Find article references (e.g., "Article IV Specification-First")
rg "Article [IVX]+" .claude/ -n
```

**Rationale**:
- Reporting empowers user to assess impact
- Blocking conflicts with open access model (REQ-008)
- Skills are resilient to constitutional changes (principles guide, not rigid contracts)
- User can decide if breaking change is justified

**Alternatives Considered**:
1. **Block breaking changes (require approval)**
   - ❌ Rejected: Conflicts with REQ-008 open access model
   - ❌ Rejected: Out of scope for v1 (multi-user approval deferred to v2)
   - Evidence: Clarification decision chose Option A (open access)

2. **Auto-update references in dependent files**
   - ❌ Rejected: Out of scope for v1 (complexity)
   - ❌ Rejected: Risky (might change semantics unintentionally)
   - Evidence: Spec defers auto-fixing to v2 (line 125)

3. **Ignore dependencies entirely**
   - ❌ Rejected: User needs impact awareness (REQ-004)
   - ❌ Rejected: Fails AC-004.1 through AC-004.4
   - Evidence: Spec explicitly requires dependency checking

**Impact Reporting Format**:
```
Dependent Files:
⚠️  8 skills import constitution - review recommended
    - .claude/skills/specify-feature/SKILL.md
    - .claude/skills/clarify-specification/SKILL.md
    - ... (6 more)

✅  No templates reference Article IX yet (new article)

⚠️  3 files reference Article IV (if removing):
    - .claude/skills/specify-feature/SKILL.md:20
    - .claude/skills/create-implementation-plan/SKILL.md:15
    - .claude/templates/feature-spec.md:10
```

**Evidence**:
- rg query confirms 8 skills import constitution
- @ import architecture means file path never breaks (resilient)
- Skills reference principles conceptually, not syntactically (loose coupling)

---

## Decision 5: Amendment History Format

**Context**: Track constitutional evolution for audit purposes

**Decision**: Chronological log with version, date, summary

**Format**:
```markdown
## Amendment History

**v1.1.0** (2025-10-20):
- Added Article IX: Progressive Disclosure
- Clarification pass on Article VI limits

**v1.0.0** (2025-10-19):
- Initial ratification
- 7 core articles established
- Integration with GitHub Spec-Kit SDD methodology
```

**Rationale**:
- Newest first for easy reference to recent changes
- Version + date provides temporal anchoring
- Summary gives quick context without reading full diff
- Article V: Template-driven quality (consistent format)

**Alternatives Considered**:
1. **Git-only history (no amendment log in file)**
   - ❌ Rejected: Requires git knowledge to trace changes
   - ❌ Rejected: Fails AC-005.1 (history tracking requirement)
   - Evidence: Spec explicitly requires in-file history

2. **Detailed diff in history**
   - ❌ Rejected: Makes history section too large
   - ❌ Rejected: git already provides full diff
   - Evidence: Summary provides sufficient context

**Evidence**:
- Constitution.md:430-436 already has amendment history section
- Git history provides detailed diff, summary provides overview
- AC-005.2 specifies format: version + date + summary

---

## Decision 6: Interactive vs Argument-Based Amendments

**Context**: Spec requires both `$ARGUMENTS` and interactive modes

**Decision**: Hybrid approach with smart fallback

**Behavior**:
- If `$ARGUMENTS` provided → parse directly, confirm before applying
- If no arguments → interactive prompts with menu
- Both paths converge at confirmation step

**Rationale**:
- Power users get efficiency (argument-based)
- New users get guidance (interactive)
- Reduces user error (confirmation step for both)

**Interactive Flow**:
```
1. What would you like to amend?
   A) Add new article
   B) Modify existing article
   C) Add section to existing article
   D) Cancel

2. [Based on choice, show relevant prompts]

3. Preview and confirm
```

**Argument Parsing**:
```bash
if [[ "$ARGUMENTS" =~ [Aa]dd.*[Aa]rticle ]]; then
    TYPE="ADD"
    # Extract article number and content
elif [[ "$ARGUMENTS" =~ [Mm]odify|[Cc]hange|[Uu]pdate ]]; then
    TYPE="MODIFY"
    # Extract target and new content
elif [[ "$ARGUMENTS" =~ [Rr]emove|[Dd]elete ]]; then
    TYPE="REMOVE"
    # Extract article to remove
fi
```

**Evidence**:
- AC-002.1 requires argument parsing
- AC-002.2 requires interactive mode
- Spec Flow 2 shows argument-based, Flow 3 shows interactive

---

## Summary

**Decisions Made**: 6 major technical choices
**Alternatives Evaluated**: 11 rejected with rationale
**Evidence Sources**: Constitution structure, existing commands, Constitutional articles
**Constitutional Compliance**: All decisions respect Article VI (Simplicity, Framework Trust)

**Next**: Proceed to task generation with confidence in technical approach

---

**Research Version**: 1.0
**Last Updated**: 2025-10-20
