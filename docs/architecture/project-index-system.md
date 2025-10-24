# Project Index System

**Purpose**: Lightweight, token-efficient codebase intelligence through indexing and querying.

---

## Overview

The Project Index System consists of two components that work together to provide fast codebase exploration without reading full files:

1. **PROJECT_INDEX.json** - Auto-generated index of project structure
2. **project-intel.mjs** - CLI tool for querying the index

This system is the foundation of the "intelligence-first" architecture, achieving 80%+ token savings by querying indexes before reading files.

---

## PROJECT_INDEX.json

### What It Is

An automatically generated JSON file containing:
- Directory structure
- File metadata (type, size, modification time)
- Code symbols (functions, classes, interfaces, types)
- Import/export relationships
- Call graphs and dependencies

### When It's Updated

PROJECT_INDEX.json is automatically regenerated whenever:
- Files are added, removed, or renamed in the repository
- Code changes are committed
- The `/index` slash command is run manually

The file is **gitignored** and rebuilt locally as needed.

### Structure

```json
{
  "stats": {
    "total_files": 1,
    "total_directories": 23,
    "fully_parsed": {},
    "listed_only": { "json": 1 },
    "markdown_files": 28
  },
  "files": [...],
  "directories": [...]
}
```

### Usage

**Never read PROJECT_INDEX.json directly.** Always query it through `project-intel.mjs`.

---

## project-intel.mjs

### What It Is

A zero-dependency Node.js CLI tool that queries PROJECT_INDEX.json to provide fast codebase intelligence.

### Core Philosophy

**Query intel FIRST, read files SECOND**

```
❌ Bad:  Read full files → Search manually
✅ Good: Query index → Read targeted sections
```

### Common Commands

```bash
# Get project overview (always do this first in new session)
project-intel.mjs --overview --json

# Search for files by name/content
project-intel.mjs --search "auth" --type tsx --json

# Get symbols from a specific file
project-intel.mjs --symbols src/auth/login.tsx --json

# Trace dependencies
project-intel.mjs --dependencies src/auth/login.tsx --direction downstream --json

# Find callers of a function
project-intel.mjs --callers handleLogin --json

# Find what a function calls
project-intel.mjs --callees handleLogin --json

# Get project statistics
project-intel.mjs --stats --json
```

### Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `stats` | Show project statistics | `project-intel.mjs --stats` |
| `tree` | Display directory tree | `project-intel.mjs --tree` |
| `search` | Search for files/symbols | `project-intel.mjs --search "auth"` |
| `symbols` | List symbols in file | `project-intel.mjs --symbols file.ts` |
| `callers` | Find what calls a symbol | `project-intel.mjs --callers myFunc` |
| `callees` | Find what a symbol calls | `project-intel.mjs --callees myFunc` |
| `dependencies` | Show file dependencies | `project-intel.mjs --dependencies file.ts` |
| `trace` | Trace dependency chain | `project-intel.mjs --trace file.ts` |
| `dead` | Find unused code | `project-intel.mjs --dead` |
| `imports` | Show file imports | `project-intel.mjs --imports file.ts` |
| `importers` | Find what imports a file | `project-intel.mjs --importers file.ts` |
| `metrics` | Code metrics | `project-intel.mjs --metrics` |
| `summarize` | Codebase summary | `project-intel.mjs --summarize` |
| `investigate` | Deep analysis | `project-intel.mjs --investigate "issue"` |
| `debug` | Debug specific feature | `project-intel.mjs --debug "feature"` |

### Key Flags

| Flag | Purpose | Example |
|------|---------|---------|
| `--json` | JSON output (always use for parsing) | `--json` |
| `--type` | Filter by file type | `--type tsx` |
| `--direction` | Dependency direction (upstream/downstream) | `--direction downstream` |
| `--limit` | Limit results | `--limit 10` |

### Output Format

Always use `--json` flag for programmatic access:

```bash
# Capture JSON output
OUTPUT=$(project-intel.mjs --search "auth" --json)
echo "$OUTPUT" | jq '.results[] | .path'
```

### Respects .gitignore

The tool automatically excludes:
- Patterns from `.gitignore`
- node_modules/, .next/, .git/
- Archive and backup files
- Test coverage directories

### Example Workflow

```bash
# 1. Get project overview (always first)
project-intel.mjs --overview --json

# 2. Search for relevant files
project-intel.mjs --search "auth" --type tsx --json

# 3. Get symbols from candidate files
project-intel.mjs --symbols src/auth/login.tsx --json

# 4. Trace dependencies if needed
project-intel.mjs --dependencies src/auth/login.tsx --direction downstream --json

# 5. NOW read specific files with context
Read src/auth/login.tsx  # Only after intel queries
```

### Integration with Agents

All agents and skills should follow this pattern:

```markdown
# In agent or skill instructions

## Step 1: Intel Queries (REQUIRED)
Before reading any files, query project-intel.mjs:

1. Run --overview to understand project structure
2. Run --search to find relevant files
3. Run --symbols to see what's in candidates
4. Run --dependencies to understand relationships

## Step 2: Targeted File Reading
Only after intel queries, read specific files or sections.
```

### Performance

- **Line Limits**: Tool warns when output exceeds limits, offers interactive filtering
- **Bounded Searches**: Use `--limit` to control result size
- **Targeted Queries**: Specific queries are faster than broad searches

### Troubleshooting

**Issue**: "PROJECT_INDEX.json not found"
**Solution**: Run `/index` command to generate the index

**Issue**: "Output too large"
**Solution**: Use `--limit` flag or more specific search terms

**Issue**: "Symbol not found"
**Solution**: Run `project-intel.mjs --symbols file.ts` to see available symbols first

---

## Best Practices

### 1. Always Query Before Reading
```bash
# ❌ Bad: Read files immediately
Read src/components/**/*.tsx

# ✅ Good: Query first, read targeted
project-intel.mjs --search "Button" --type tsx --json
Read src/components/Button.tsx  # Only the relevant file
```

### 2. Use JSON Output for Parsing
```bash
# ❌ Bad: Parse text output
project-intel.mjs --search "auth"

# ✅ Good: Use JSON and jq
project-intel.mjs --search "auth" --json | jq -r '.results[].path'
```

### 3. Understand Dependencies Before Editing
```bash
# Before modifying a file, check what depends on it
project-intel.mjs --importers src/utils/format.ts --json

# Check what it depends on
project-intel.mjs --imports src/utils/format.ts --json
```

### 4. Leverage Call Graph for Bug Tracing
```bash
# Find what calls the buggy function
project-intel.mjs --callers handlePayment --json

# Find what the buggy function calls
project-intel.mjs --callees handlePayment --json
```

---

## Token Efficiency

### Traditional Approach
```
Read 50 files (500 KB) → 125,000 tokens → Find 1 relevant file
```

### Intelligence-First Approach
```
Query index (5 KB) → 1,250 tokens → Read 1 relevant file (10 KB) → 2,500 tokens
Total: 3,750 tokens (97% savings)
```

---

## Integration Points

### With Agents
- Agents import intelligence SOPs that require intel queries first
- Handovers include intel query results, not full file contents

### With Skills
- Skills instruct to run specific intel queries based on task
- Example: code-intelligence skill uses intel for symbol lookup

### With Slash Commands
- Commands can run intel queries as bash pre-execution
- Results included in command context

### With CoD^Σ Reasoning
- Intel queries provide evidence for reasoning traces
- Example: "Function exists at file.ts:42 per intel query"

---

## Related Documentation

- **CLI Reference**: @docs/reference/project-intel-cli.md (comprehensive command reference)
- **CoD^Σ Framework**: @docs/architecture/cod-sigma-framework.md (reasoning with intel evidence)
- **Intelligence SOPs**: @.claude/sops/sop-analysis.md (analysis workflow using intel)

---

**Key Takeaway**: Query lightweight indexes before reading heavy files. This is the core innovation of the Intelligence Toolkit.
