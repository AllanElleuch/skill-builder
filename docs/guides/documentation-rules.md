# Documentation Rules & Lifecycle Management

**Purpose**: Clear rules for creating, updating, and maintaining project documentation
**Version**: 1.0
**Status**: Active

---

## Overview

This document defines the structure, lifecycle, and maintenance rules for all project documentation. Following these rules prevents context pollution from outdated, duplicated, or irrelevant documentation.

**Core Principle**: Separate curated knowledge from session artifacts to maintain clean, useful context.

---

## Anti-Patterns - NEVER Do These

These patterns are UNACCEPTABLE and must be avoided at all costs:

### ❌ Empty Directory Creation
**BAD**: Creating `reports/`, `analysis/`, `decisions/` directories before any content exists
**GOOD**: Create directory ONLY when first file goes into it
**Why**: Empty directories are useless pollution that clutter the repo

**Example of violation**:
```bash
mkdir docs/sessions/session-id/{reports,analysis,decisions,artifacts}
# Creates 4 empty directories that serve ZERO purpose
```

**Correct approach**:
```bash
# Create directory ONLY when placing first file
echo "# Report" > docs/sessions/session-id/reports/20251019-report.md
# Directory created automatically with content
```

---

### ❌ Inferior Summaries Over Superior Content
**BAD**: Creating generic overview when detailed architecture doc already exists
**GOOD**: Use/promote superior content, delete inferior attempts
**Why**: Wastes tokens, creates confusion, degrades documentation quality

**Example of violation**:
- Superior doc exists: `SYSTEM_ARCHITECTURE_MAP.md` (510 lines, complete dependency graphs, detailed workflows)
- Created inferior doc: `system-overview.md` (200 lines, generic tables, missing detail)
- Result: Worse documentation replaces better documentation

**Correct approach**:
1. Check if documentation already exists (including in archives)
2. Compare quality: detail, completeness, accuracy
3. Keep SUPERIOR content, delete INFERIOR content
4. Update/enhance superior content if needed

---

### ❌ Placeholder Pollution
**BAD**: Empty READMEs, "Coming Soon" docs, TODO placeholders without content
**GOOD**: Only create files with real, complete, useful content
**Why**: Placeholders are noise that pollute context and search results

**Examples of violations**:
```markdown
# Coming Soon
This documentation will be added later.

# TODO
- Write documentation
- Add examples

# README.md (empty or just title)
```

**Correct approach**: Don't create file until you have REAL content to put in it.

---

### ❌ Temporary File Survivors
**BAD**: temp.md, scratch.md, notes.md, test.md surviving past session end
**GOOD**: Delete ALL temporary files before session completes
**Why**: Temporary files become permanent pollution if not cleaned up

**Common violations**:
- `temp-analysis.md`
- `scratch-notes.md`
- `test-output.md`
- `debug-log.md`
- `quick-notes.md`

**Session cleanup checklist**:
```bash
# Before session end, delete:
rm temp*.md scratch*.md notes*.md test*.md debug*.md quick*.md

# Or better: use /tmp for truly temporary files
echo "analysis" > /tmp/analysis.txt  # Auto-cleaned by OS
```

---

### ❌ Session Artifact Mixing
**BAD**: Session artifacts in curated docs directories, or curated content in session dirs
**GOOD**: Strict separation - curated in docs/*, session artifacts in docs/sessions/[id]/
**Why**: Mixing prevents proper gitignore, creates confusion about what's permanent vs ephemeral

**Examples of violations**:
- `docs/architecture/20251019-analysis.md` (timestamped file in curated location)
- `docs/guides/temp-workflow.md` (temporary file in permanent location)
- `planning.md` in docs/sessions/[id]/ (active work file in wrong location)

**Correct approach**:
- **Curated docs**: docs/architecture/, docs/guides/, docs/reference/ (committed, kebab-case.md)
- **Session artifacts**: docs/sessions/[session-id]/ (gitignored, YYYYMMDD-HHMM-type-description.md)
- **Active work**: Root level only (planning.md, todo.md)

---

### ❌ Stale References
**BAD**: Broken @ imports, dead cross-references, outdated file paths
**GOOD**: Valid references that resolve correctly, updated when files move
**Why**: Broken references waste context window loading attempts, confuse Claude

**Examples of violations**:
```markdown
See @docs/guides/deleted-file.md for details
Reference the workflow in [old-location.md](docs/old-location.md)
Import @.claude/nonexistent-template.md
```

**Detection**:
```bash
# Find @ references
rg "@[a-zA-Z0-9/._-]+" *.md

# Check if referenced files exist
# (Manual verification or scripted check)
```

**Correct approach**:
1. Update references when moving/renaming files
2. Delete references to deleted files
3. Use relative paths for stability
4. Verify @ imports resolve correctly (max 5 hops)

---

### ✅ Proper Approach Summary

1. **Check existing content** (including archives) before creating new files
2. **Create directories only** when placing first real file
3. **Use superior existing content** instead of recreating inferior versions
4. **Clean up all temporary files** at session end
5. **Delete empty directories** immediately
6. **No placeholders** - only create files with complete content
7. **Maintain strict separation** between curated docs and session artifacts
8. **Update references** when moving/renaming files
9. **Verify @ imports** resolve correctly

---

## Documentation Quality Rubric

Use this rubric to evaluate documentation quality before committing:

### Completeness (0-10)
- **10**: All required sections present, examples complete, edge cases covered
- **7-9**: Most content present, minor gaps acceptable
- **4-6**: Significant gaps, missing examples or key sections
- **1-3**: Barely started, placeholder-level content
- **0**: Empty or "Coming Soon"

**Threshold**: Minimum score 7 for commit

### Accuracy (0-10)
- **10**: All claims verifiable, code examples tested, no errors
- **7-9**: Minor inaccuracies that don't affect core message
- **4-6**: Some incorrect information, needs fact-checking
- **1-3**: Significant errors, misleading content
- **0**: Completely wrong or fictional

**Threshold**: Minimum score 8 for commit

### Clarity (0-10)
- **10**: Crystal clear, easy to follow, well-structured
- **7-9**: Generally clear, minor ambiguity acceptable
- **4-6**: Confusing in places, needs reorganization
- **1-3**: Hard to understand, poor structure
- **0**: Incomprehensible

**Threshold**: Minimum score 7 for commit

### Token Efficiency (0-10)
- **10**: Maximally concise without losing information
- **7-9**: Good balance of detail and brevity
- **4-6**: Some verbosity, could be condensed
- **1-3**: Excessive verbosity, significant waste
- **0**: Extreme waste (e.g., 10x necessary tokens)

**Threshold**: Minimum score 6 for commit

### Usefulness (0-10)
- **10**: High-value content, frequently referenced, enables new capabilities
- **7-9**: Useful reference, solves real problems
- **4-6**: Some value, occasionally useful
- **1-3**: Low value, rarely needed
- **0**: No practical value

**Threshold**: Minimum score 7 for commit

### Overall Quality Gate

**Commit if**:
- Completeness ≥ 7
- Accuracy ≥ 8
- Clarity ≥ 7
- Token Efficiency ≥ 6
- Usefulness ≥ 7

**Archive if** (not commit):
- Any critical dimension < threshold
- Overall average < 7.0

**Delete if**:
- Usefulness < 4
- Accuracy < 4
- Or duplicate of superior existing content

---

## Documentation Structure

### Root Level

**Location**: `/` (project root)

**Allowed Files**:
- `CLAUDE.md` - Main guidance for Claude Code (imports this file)
- `README.md` - Human-readable project overview
- `planning.md` - Current implementation plan (session artifact, committed)
- `todo.md` - Current task list (session artifact, committed)
- `event-stream.md` - Session event log (gitignored)
- `PROJECT_INDEX.json` - Auto-generated index (gitignored)
- `project-intel.mjs` - CLI tool for querying index

**Rules**:
- ✅ Keep root clean and minimal
- ✅ Only active work files at root (planning.md, todo.md)
- ✅ Archive completed plans to `docs/sessions/[session-id]/archive/`
- ❌ No random markdown files
- ❌ No "draft", "notes", "scratch" files
- ❌ No numbered files (00_, 01_, 02_, etc.) except during active development

---

### docs/ Directory Structure

**Location**: `/docs/`

#### docs/documentation-rules.md
- This file
- Imported by root CLAUDE.md
- Update when documentation structure changes

#### docs/architecture/
**Purpose**: System design and architectural documentation

**Allowed Files**:
- system-overview.md
- cod-sigma-framework.md
- project-index-system.md
- [architecture topic].md

**When to Create**:
- New architectural pattern added
- System design decision documented
- Core framework explained

**When to Update**:
- Architecture changes
- New components added
- Design decisions revised

#### docs/guides/
**Purpose**: How-to guides and tutorials

**Allowed Files**:
- developing-agent-skills.md
- code-intel-guide.md
- skills-guide/ (multi-part guide)
- [topic]-guide.md

**When to Create**:
- New development workflow established
- Tutorial needed for complex task
- Best practices documented

**When to Update**:
- Process changes
- New tools/techniques added
- Examples need refreshing

#### docs/reference/
**Purpose**: Reference material and external documentation

**Allowed Files**:
- project-intel-cli.md
- mcp-tools.md
- claude-code-docs/ (official Claude Code docs)
- [tool]-reference.md

**When to Create**:
- New tool added to project
- External docs need local copy
- API reference needed

**When to Update**:
- Tool version upgraded
- API changes
- New features added

---

### docs/sessions/ Directory

**Location**: `/docs/sessions/[session-id]/`

**Purpose**: Session-generated artifacts isolated by session ID

**Structure**:
```
docs/sessions/
└── [session-id]/           # e.g., "20251019-session"
    ├── reports/            # Analysis reports
    ├── analysis/           # Deep analysis documents
    ├── decisions/          # Decision logs
    ├── artifacts/          # Generated code, configs, etc.
    └── archive/            # Obsolete planning docs
```

**Rules**:
- ✅ All session artifacts go here
- ✅ Use descriptive filenames: `YYYYMMDD-HHMM-type-description.md`
- ✅ Entire docs/sessions/ directory is gitignored
- ❌ Never commit session artifacts
- ❌ Don't reference session docs in curated docs (extract insights instead)

**Session ID Access**:
Read current session ID from `.session-id` file (created by SessionStart hook):
```bash
SESSION_ID=$(cat .session-id)
```

---

### .claude/ Directory

**Location**: `/.claude/`

**Purpose**: Intelligence Toolkit components (agents, skills, commands, etc.)

**Has its own CLAUDE.md**: `.claude/CLAUDE.md` documents the toolkit folder structure

**See**: `.claude/CLAUDE.md` for detailed component documentation

---

## File Naming Conventions

### Curated Documentation
**Pattern**: `kebab-case.md`

**Examples**:
- system-overview.md
- developing-agent-skills.md
- project-intel-cli.md

**Rules**:
- Descriptive, permanent names
- No dates, no version numbers in filename
- Use markdown headings for versions

---

### Session Artifacts
**Pattern**: `YYYYMMDD-HHMM-type-description.md`

**Examples**:
- 20251019-1430-report-auth-analysis.md
- 20251019-1445-decision-database-choice.md
- 20251019-1500-analysis-performance-bottleneck.md

**Rules**:
- Timestamp for chronological sorting
- Type indicates content category
- Description for quick identification

---

## Lifecycle Management

### Creating New Documentation

**1. Determine Type**:
- **Architecture**: System design, framework, core concepts
- **Guide**: How-to, tutorial, workflow
- **Reference**: Tool docs, API reference, external docs
- **Session Artifact**: Analysis, report, decision for current session

**2. Choose Location**:
- Architecture → `docs/architecture/`
- Guide → `docs/guides/`
- Reference → `docs/reference/`
- Session Artifact → `docs/sessions/[session-id]/[category]/`

**3. Use Appropriate Template**:
- Architecture: Concept overview + design + integration
- Guide: Step-by-step + examples + troubleshooting
- Reference: Commands + parameters + examples
- Session Artifact: Use .claude/templates/ if available

**4. Add to Index** (if curated):
Update relevant README.md or add cross-references

---

### Updating Existing Documentation

**When to Update**:
- Feature added/changed
- Process improved
- Examples outdated
- Errors discovered

**Update Process**:
1. Read existing doc fully
2. Identify specific sections to update
3. Preserve structure and style
4. Update examples if needed
5. Update "Last Modified" date (if present)

**Don't**:
- Replace entire file unnecessarily
- Change structure without reason
- Remove working examples
- Update just to update

---

### Archiving Documentation

**When to Archive**:
- Planning doc completed (move to sessions/[id]/archive/)
- Feature removed (move to sessions/[id]/archive/ with note)
- Documentation superseded (move old to archive, keep new)

**Archive Location**:
- Session artifacts: Already in sessions/, no action needed
- Curated docs: Move to `docs/sessions/[session-id]/archive/[original-filename]`

**Never Delete**:
Archive instead of deleting. Disk space is cheap, lost context is expensive.

---

### Promoting Session Artifacts to Curated Docs

**Process**:
1. Review session artifact for valuable insights
2. Identify which curated doc should receive the insights
3. Extract key information (not copy-paste entire artifact)
4. Update curated doc with synthesized insights
5. Leave session artifact in place (don't delete)

**Example**:
```markdown
# Session artifact: docs/sessions/20251019/analysis/performance-analysis.md
Found: "Database queries can be batched using Promise.all"

# Update curated guide: docs/guides/optimization-guide.md
Add section: "Database Query Batching"
Include: Distilled insight + example code + reference to analysis
```

---

## Session ID Management

### Accessing Current Session ID

**Location**: `.session-id` file (root directory)

**Created By**: `.claude/hooks/log-session-start.sh`

**Usage**:
```bash
# Read session ID
SESSION_ID=$(cat .session-id)

# Create session directory
mkdir -p "docs/sessions/$SESSION_ID/reports"

# Name session artifact
echo "# Analysis" > "docs/sessions/$SESSION_ID/analysis/analysis-$TIMESTAMP.md"
```

---

## Git Integration

### Committed Files

**Root**:
- CLAUDE.md ✅
- README.md ✅
- planning.md ✅ (current plan)
- todo.md ✅ (current todo)
- event-stream.md ❌ (gitignored)

**docs/**:
- docs/documentation-rules.md ✅
- docs/architecture/* ✅
- docs/guides/* ✅
- docs/reference/* ✅
- docs/sessions/* ❌ (gitignored)

**.claude/**:
- All .claude/ contents ✅ (toolkit components)

**Generated**:
- PROJECT_INDEX.json ❌ (gitignored)
- .session-id ❌ (gitignored)

---

### .gitignore Rules

```gitignore
# Session artifacts
event-stream.md
docs/sessions/

# Generated files
PROJECT_INDEX.json
.session-id

# Local settings
.claude/settings.local.json
*.local.json

# Session-specific
planning.md  # Only if treating as session artifact
todo.md      # Only if treating as session artifact
```

**Note**: In this project, `planning.md` and `todo.md` are committed as current work. Adjust per team preferences.

---

## Import Rules (@ Syntax)

### How @ Imports Work

Claude Code loads files referenced with `@` prefix:

```markdown
# In CLAUDE.md
See @docs/documentation-rules.md for documentation lifecycle.
```

**Features**:
- Relative and absolute paths supported
- Max 5 hops of recursive imports
- Not evaluated in code blocks/spans
- View loaded files with `/memory` command

---

### When to Use @ Imports

**In root CLAUDE.md**:
- Import key documentation: `@docs/documentation-rules.md`
- Import process guides: `@docs/guides/workflow-guide.md`
- Import reference: `@docs/reference/project-intel-cli.md`

**In .claude/ components**:
- Import shared frameworks: `@.claude/shared-imports/CoD_Σ.md`
- Import templates: `@.claude/templates/report.md`
- Import SOPs: `@.claude/sops/sop-analysis.md`

**Don't Import**:
- Session artifacts (ephemeral)
- Large reference files (point to specific sections instead)
- Files that change frequently

---

### Import Best Practices

1. **Keep imports shallow**: Max 1 level deep from main file
2. **Use relative paths**: `@docs/` not `@/Users/name/project/docs/`
3. **Import stable files**: Curated docs, not session artifacts
4. **Document imports**: Comment why file is imported

---

## Common Patterns

### Pattern 1: New Feature Development

**Start of Session**:
1. Create `planning.md` with feature plan
2. Create `todo.md` with task breakdown
3. Log to `event-stream.md` as you work

**During Development**:
1. Generate session artifacts in `docs/sessions/[session-id]/`
2. Update `todo.md` as tasks complete
3. Update `planning.md` if plan changes

**End of Session**:
1. Review session artifacts
2. Extract insights to curated docs
3. Archive `planning.md` to `docs/sessions/[session-id]/archive/`
4. Create new `planning.md` for next feature

---

### Pattern 2: Documentation Sprint

**Goal**: Create new guide

1. Create in appropriate `docs/` subdirectory
2. Follow guide template (intro + steps + examples + troubleshooting)
3. Add cross-references to related docs
4. Update relevant README or index
5. Test all examples work
6. Review for clarity and completeness

---

### Pattern 3: Architectural Change

**When system architecture changes**:

1. Update `docs/architecture/system-overview.md`
2. Create new architecture doc if new pattern added
3. Update affected guides in `docs/guides/`
4. Update root CLAUDE.md if workflow changes
5. Update `.claude/CLAUDE.md` if toolkit components affected
6. Document decision in `docs/sessions/[session-id]/decisions/`

---

## Maintenance Schedule

### After Every Session
- Review event-stream.md for insights
- Update relevant curated docs
- Archive session planning.md if complete

### Weekly (or After Major Work)
- Review docs/architecture/ for accuracy
- Update outdated examples
- Archive obsolete session directories

### Monthly (or Major Release)
- Comprehensive doc review
- Consolidate duplicated content
- Update cross-references
- Check all @ imports work

---

## Troubleshooting

### Issue: Too many session artifacts

**Solution**: They're gitignored, so no pollution. Archive old session dirs if desired.

---

### Issue: Can't find session ID

**Solution**: Read from `.session-id` file. If missing, hooks not configured correctly.

---

### Issue: Documentation out of sync

**Solution**: Review recent session artifacts, extract insights, update curated docs.

---

### Issue: Circular imports

**Solution**: Max 5 hops prevents infinite loops. Simplify import chain.

---

### Issue: Context pollution from old docs

**Solution**: Move outdated docs to archive, update cross-references.

---

## Related Documentation

- **System Overview**: @docs/architecture/system-overview.md
- **Claude Code Memory**: @docs/reference/claude-code-docs/claude-code-memory.md
- **.claude/ Toolkit**: @.claude/CLAUDE.md

---

## Key Takeaways

1. **Separate curated from session**: Curated docs in `docs/`, session artifacts in `docs/sessions/[id]/`
2. **Use session IDs**: Read from `.session-id` file for isolation
3. **Archive, don't delete**: Move to `docs/sessions/[id]/archive/`
4. **Promote insights**: Extract from session artifacts to curated docs
5. **Keep root clean**: Only active work files at root
6. **Use @ imports**: For stable, curated documentation
7. **Follow naming conventions**: Kebab-case for curated, timestamp for session artifacts
8. **Maintain regularly**: Review and update after sessions and major changes

---

**Remember**: Clean, organized documentation = Better context for Claude = Higher quality outputs
