# Data Model: Constitution File Format

**Feature**: 002-constitution-command
**Created**: 2025-10-20
**Purpose**: Define constitution.md structure without implementation details

---

## Overview

Constitution file (`.claude/shared-imports/constitution.md`) is a structured markdown document with consistent patterns for metadata, articles, and history. This document specifies the format without database schema or implementation code.

---

## File Structure

```
constitution.md
├── Metadata (lines 1-7)
├── Preamble (lines 9-18)
├── Articles (lines 20-380)
│   ├── Article I
│   ├── Article II
│   ├── ... (Article III-VII)
│   └── Article VIII
├── Governance (lines 382-427)
└── Amendment History (lines 430+)
```

---

## Entity 1: Constitution Metadata

**Purpose**: Version tracking and governance metadata

**Format**:
```markdown
# Intelligence Toolkit Constitution

**Version**: X.Y.Z
**Ratified**: YYYY-MM-DD
**Status**: ACTIVE | SUPERSEDED
```

**Attributes**:
- **Title**: Document name (always "Intelligence Toolkit Constitution")
- **Version**: Semantic version (MAJOR.MINOR.PATCH)
- **Ratified**: Original adoption date (ISO 8601: YYYY-MM-DD)
- **Status**: Lifecycle state (ACTIVE or SUPERSEDED)

**Validation**:
- Version must match regex: `\d+\.\d+\.\d+`
- Dates must be ISO 8601 format
- Status must be ACTIVE or SUPERSEDED
- Ratified date never changes (immutable)

**Location**: Lines 1-5

---

## Entity 2: Article

**Purpose**: Constitutional principle with requirements and rationale

**Format**:
```markdown
## Article [ROMAN]: Title

**Status**: NON-NEGOTIABLE | MANDATORY | RECOMMENDED

### Section [NUMBER]: Subtitle

[Content with requirements, prohibitions, rationale]

**Requirements**:
- Requirement 1
- Requirement 2

**Prohibited**:
- Prohibited action 1
- Prohibited action 2

**Rationale**: Explanation of why this article exists
```

**Attributes**:
- **Number**: Roman numeral (I, II, III, IV, V, VI, VII, VIII, IX, ...)
- **Title**: Descriptive name (e.g., "Intelligence-First Principle")
- **Status**: Binding level (NON-NEGOTIABLE > MANDATORY > RECOMMENDED)
- **Sections**: Numbered subsections (1.1, 1.2, 2.1, etc.)
- **Content**: Markdown text with requirements, prohibitions, rationale

**Relationships**:
- Constitution has many Articles
- Article has many Sections
- Section belongs to Article

**Validation**:
- Article number must be unique within constitution
- Article number must be valid Roman numeral (I-XX typically)
- Status must be one of three values
- Each article must have at least one section

**Location Pattern**: `^## Article [IVX]+:`

---

## Entity 3: Section

**Purpose**: Subsection within an article providing specific guidance

**Format**:
```markdown
### Section X.Y: Subtitle

[Content]

**Requirements**:
- Specific requirement 1
- Specific requirement 2
```

**Attributes**:
- **Number**: Decimal notation (1.1, 1.2, 2.1, 6.1, etc.)
- **Subtitle**: Descriptive name
- **Content**: Requirements, prohibitions, examples, evidence

**Relationships**:
- Section belongs to Article
- Section number first digit matches article number (Article VI → sections 6.1, 6.2, etc.)

**Validation**:
- Section number must match parent article
- Sections within article must be numbered sequentially
- Each section must have content (not empty)

**Location Pattern**: `^### Section \d+\.\d+:`

---

## Entity 4: Governance Section

**Purpose**: Meta-rules for constitutional amendments

**Format**:
```markdown
## Governance

### Version: X.Y.Z

**Ratified**: YYYY-MM-DD
**Last Amended**: YYYY-MM-DD

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
[Steps...]
```

**Attributes**:
- **Version**: Current semantic version (duplicated from metadata for governance section)
- **Ratified Date**: Original adoption (duplicated from metadata)
- **Last Amended**: Most recent amendment date
- **Amendment Rules**: Procedures for changing constitution
- **Versioning Rules**: Semantic versioning semantics (MAJOR/MINOR/PATCH)

**Validation**:
- Version must match metadata version
- Last Amended must be >= Ratified
- Last Amended updates with every amendment

**Location**: Lines 382-427

---

## Entity 5: Amendment Entry

**Purpose**: Historical record of constitutional changes

**Format**:
```markdown
**v1.1.0** (2025-10-20):
- Summary of changes (added/modified/removed)
- Additional context if needed
```

**Attributes**:
- **Version**: Version introduced by this amendment
- **Date**: Date amendment applied (ISO 8601)
- **Summary**: Brief description of changes (bullet list)

**Relationships**:
- Amendment History section has many Amendment Entries
- Amendment Entry references Articles (implicitly via summary text)

**Validation**:
- Version must follow semver rules
- Date must be ISO 8601 format
- Date must be >= previous amendment date (chronological order)
- Summary must be non-empty

**Ordering**: Newest first (most recent amendments at top of history)

**Location**: Lines 430+ (Amendment History section)

---

## Parsing Patterns

### Extract Version
```bash
grep "^\*\*Version\*\*:" constitution.md | sed 's/.*: //'
# Output: 1.0.0
```

### Extract Articles
```bash
grep "^## Article" constitution.md
# Output:
# ## Article I: Intelligence-First Principle
# ## Article II: Evidence-Based Reasoning
# ...
```

### Extract Article Status
```bash
grep -A 2 "^## Article I:" constitution.md | grep "^\*\*Status\*\*:"
# Output: **Status**: NON-NEGOTIABLE
```

### Find Last Amended Date
```bash
grep "^\*\*Last Amended\*\*:" constitution.md | sed 's/.*: //'
# Output: 2025-10-19
```

### Count Articles
```bash
grep -c "^## Article [IVX]" constitution.md
# Output: 8
```

---

## Amendment Operations

### ADD Article
**Target**: New article number (IX, X, etc.)
**Action**:
1. Determine insertion point (before Governance section)
2. Insert new article with proper formatting
3. Ensure no article number collision

### MODIFY Article/Section
**Target**: Existing article number or section number
**Action**:
1. Locate article/section by header pattern
2. Replace content while preserving header
3. Maintain section numbering

### REMOVE Article
**Target**: Existing article number
**Action**:
1. Locate article by header pattern
2. Remove entire article (header + all sections)
3. Warning: May require renumbering subsequent articles

---

## Validation Rules

### File-Level Validation
1. Version appears exactly twice (metadata + governance)
2. Both version instances match
3. Ratified date never changes (compare to history)
4. Last Amended >= Ratified
5. Amendment History entries are chronological

### Article-Level Validation
1. Article numbers are unique
2. Article numbers use valid Roman numerals
3. Each article has >= 1 section
4. Section numbers match parent article

### Amendment-Level Validation
1. New version follows semver rules
2. Amendment entry added to history
3. Last Amended date updated
4. No duplicate version numbers in history

---

## Integration Points

### Importing Files (@ Syntax)
Skills import constitution via: `@.claude/shared-imports/constitution.md`

**Import Resolution**:
- Relative path from importing file
- Max 5 hops of recursive imports
- No circular references allowed

**Impact of Amendments**:
- File path never changes (imports don't break)
- Content changes propagate automatically (@ imports read file)
- Article references in skills may need manual updates if articles renumbered

### Article References
Skills may reference articles by number (e.g., "Article IV Specification-First")

**Reference Format**: `"Article [IVX]+ [text]"`

**Detection**: `rg "Article [IVX]+" .claude/`

**Impact of Amendments**:
- Adding articles: No impact (new articles don't conflict)
- Modifying articles: Low impact (content change, not number)
- Removing articles: High impact (references become invalid)

---

## Edge Cases

### Article Number Gaps
**Scenario**: User adds Article XI when Article IX and X don't exist

**Handling**: Allow (constitution doesn't require sequential numbers) but warn user about gap

### Duplicate Article Numbers
**Scenario**: User tries to add Article V when Article V already exists

**Handling**: Reject with error, prompt for different number or modification intent

### Invalid Roman Numerals
**Scenario**: User tries to add "Article ABC"

**Handling**: Reject with error, show valid Roman numerals (I-XX)

### Amendment Date in Past
**Scenario**: User manually sets Last Amended to 2025-01-01 when current date is 2025-10-20

**Handling**: Warn but allow (user may be backdating for record-keeping)

---

## Example Constitution Structure

```markdown
# Intelligence Toolkit Constitution

**Version**: 1.0.0
**Ratified**: 2025-10-19
**Status**: ACTIVE

---

## Preamble

[Preamble text...]

---

## Article I: Intelligence-First Principle

**Status**: NON-NEGOTIABLE

### Section 1.1: Query Before Read

[Content...]

**Requirements**:
- Requirement 1
- Requirement 2

**Rationale**: [Why this matters]

---

[Articles II-VIII...]

---

## Governance

### Version: 1.0.0

**Ratified**: 2025-10-19
**Last Amended**: 2025-10-19

### Amendment Procedure

[Amendment rules...]

---

## Amendment History

**v1.0.0** (2025-10-19):
- Initial ratification
- 7 core articles established
```

---

**Data Model Version**: 1.0
**Last Updated**: 2025-10-20
