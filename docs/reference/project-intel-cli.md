# project-intel.mjs - CLI Reference

**Purpose**: Query PROJECT_INDEX.json for fast codebase intelligence
**Type**: Zero-dependency Node.js CLI tool
**Location**: Project root

---

## Quick Start

```bash
# Get project overview (always first)
./project-intel.mjs --overview --json

# Search for files
./project-intel.mjs --search "auth" --json

# Get symbols from a file
./project-intel.mjs --symbols src/file.ts --json

# Trace dependencies
./project-intel.mjs --dependencies src/file.ts --json
```

---

## Installation

No installation required. The tool is a standalone Node.js script with zero external dependencies.

**Requirements**: Node.js 14+

**Make executable**:
```bash
chmod +x project-intel.mjs
```

---

## Command Reference

### Basic Commands

#### `stats` - Project Statistics

Show project-wide statistics.

```bash
./project-intel.mjs --stats [--json]
```

**Output**:
- Total files
- Total directories
- Fully parsed files (by language)
- Listed only files (by type)
- Markdown file count

**Example**:
```bash
./project-intel.mjs --stats --json
```

---

#### `tree` - Directory Tree

Display project directory structure.

```bash
./project-intel.mjs --tree [--max-depth <n>] [--json]
```

**Flags**:
- `--max-depth <n>`: Limit tree depth (default: unlimited)
- `--json`: Output as JSON

**Example**:
```bash
# Show full tree
./project-intel.mjs --tree

# Limit to 2 levels
./project-intel.mjs --tree --max-depth 2 --json
```

---

#### `search` - Search Files/Symbols

Search for files by name or content pattern.

```bash
./project-intel.mjs --search <term> [--type <ext>] [-l <limit>] [--json]
```

**Flags**:
- `--search <term>`: Search term (required)
- `--type <ext>`: Filter by file extension (ts, tsx, js, jsx, etc.)
- `-l <limit>`: Limit number of results
- `--json`: Output as JSON

**Examples**:
```bash
# Search for "auth" in all files
./project-intel.mjs --search "auth" --json

# Search in TypeScript files only
./project-intel.mjs --search "Button" --type tsx --json

# Limit to 10 results
./project-intel.mjs --search "util" -l 10 --json
```

---

### Symbol Commands

#### `symbols` - List Symbols in File

Show all symbols (functions, classes, interfaces) in a specific file.

```bash
./project-intel.mjs --symbols <file-path> [--json]
```

**Examples**:
```bash
./project-intel.mjs --symbols src/auth/login.tsx --json
./project-intel.mjs --symbols lib/utils.ts --json
```

**Output includes**:
- Symbol name
- Symbol type (function, class, interface, type, const, etc.)
- Line number (if available)

---

#### `callers` - Find What Calls a Symbol

Find all locations that call/reference a specific symbol.

```bash
./project-intel.mjs --callers <symbol-name> [-l <limit>] [--json]
```

**Flags**:
- `--callers <symbol>`: Symbol name to find callers for
- `-l <limit>`: Limit number of results
- `--json`: Output as JSON

**Examples**:
```bash
./project-intel.mjs --callers handleLogin --json
./project-intel.mjs --callers UserClass -l 20 --json
```

---

#### `callees` - Find What a Symbol Calls

Find all symbols that a specific symbol calls/references.

```bash
./project-intel.mjs --callees <symbol-name> [-l <limit>] [--json]
```

**Examples**:
```bash
./project-intel.mjs --callees processPayment --json
./project-intel.mjs --callees validateUser -l 10 --json
```

---

### Dependency Commands

#### `dependencies` - Show File Dependencies

Show what files depend on a specific file (upstream) or what a file depends on (downstream).

```bash
./project-intel.mjs --dependencies <file-path> [--direction <up|down>] [--json]
```

**Flags**:
- `--dependencies <file>`: File to analyze
- `--direction <up|down>`:
  - `upstream`: What depends on this file
  - `downstream`: What this file depends on
- `--json`: Output as JSON

**Examples**:
```bash
# What does this file import?
./project-intel.mjs --dependencies src/utils/format.ts --direction downstream --json

# What imports this file?
./project-intel.mjs --dependencies src/utils/format.ts --direction upstream --json
```

---

#### `trace` - Trace Dependency Chain

Trace the full dependency chain from a file.

```bash
./project-intel.mjs --trace <file-path> [--json]
```

**Examples**:
```bash
./project-intel.mjs --trace src/app/page.tsx --json
```

---

#### `imports` - Show File Imports

Show all modules/files imported by a specific file.

```bash
./project-intel.mjs --imports <file-path> [--json]
```

**Examples**:
```bash
./project-intel.mjs --imports src/components/Button.tsx --json
```

---

#### `importers` - Find What Imports a File

Find all files that import a specific file or module.

```bash
./project-intel.mjs --importers <file-path> [-l <limit>] [--json]
```

**Examples**:
```bash
./project-intel.mjs --importers src/lib/utils.ts --json
./project-intel.mjs --importers react -l 20 --json
```

---

### Analysis Commands

#### `dead` - Find Unused Code

Identify functions and symbols that appear to be unused (not called anywhere).

```bash
./project-intel.mjs --dead [-l <limit>] [--json]
```

**Examples**:
```bash
./project-intel.mjs --dead --json
./project-intel.mjs --dead -l 50 --json
```

**Note**: This is heuristic-based and may have false positives.

---

#### `metrics` - Code Metrics

Calculate and display code metrics.

```bash
./project-intel.mjs --metrics [--json]
```

**Metrics include**:
- File count by type
- Symbol count by type
- Average symbols per file
- Call graph statistics

---

#### `summarize` - Codebase Summary

Generate a comprehensive codebase summary.

```bash
./project-intel.mjs --summarize [--json]
```

**Output includes**:
- Project statistics
- File type breakdown
- Symbol distribution
- Dependency overview

---

#### `investigate` - Deep Analysis

Perform deep analysis on specific features or issues.

```bash
./project-intel.mjs --investigate <term> [-l <limit>] [--json]
```

**Examples**:
```bash
./project-intel.mjs --investigate "authentication" --json
./project-intel.mjs --investigate "error handling" -l 30 --json
```

---

#### `debug` - Debug Features

Debug analysis for specific features.

```bash
./project-intel.mjs --debug <feature> [--json]
```

**Examples**:
```bash
./project-intel.mjs --debug "payment flow" --json
```

---

#### `docs` - Search Documentation

Search markdown documentation files.

```bash
./project-intel.mjs --docs <search-term> [-l <limit>] [--json]
```

**Examples**:
```bash
./project-intel.mjs --docs "authentication" --json
./project-intel.mjs --docs "setup" -l 10 --json
```

---

#### `report` - Comprehensive Report

Generate a comprehensive analysis report.

```bash
./project-intel.mjs --report [--focus <path>] [--json]
```

**Flags**:
- `--focus <path>`: Focus report on specific directory

**Examples**:
```bash
./project-intel.mjs --report --json
./project-intel.mjs --report --focus src/auth --json
```

---

## Global Flags

These flags work with all commands:

| Flag | Description | Example |
|------|-------------|---------|
| `--json` | Output as JSON (always use for programmatic access) | `--json` |
| `--force` | Skip line limit warnings | `--force` |
| `-l <n>` | Limit number of results | `-l 20` |
| `-i <path>` | Specify custom PROJECT_INDEX.json location | `-i /path/to/index.json` |

---

## Output Format

### Text Output (Human-Readable)

Default output format with formatting and colors (if terminal supports it).

```bash
./project-intel.mjs --search "auth"
```

### JSON Output (Programmatic)

Always use `--json` for programmatic access.

```bash
./project-intel.mjs --search "auth" --json
```

**Example parsing with jq**:
```bash
./project-intel.mjs --search "auth" --json | jq -r '.results[].path'
```

---

## Line Limit Warnings

By default, the tool warns when output exceeds 200 lines.

**Interactive Mode** (terminal):
- Shows warning with suggestions
- Prompts: `[y]` show all, `[n]` cancel, `[h]` show first 50 lines

**Non-Interactive Mode** (pipe/redirect):
- Shows warning to stderr
- Outputs all data to stdout
- Suggest using `--force` flag

**Skip warnings**:
```bash
./project-intel.mjs --search "common" --force --json
```

---

## Exclusion Patterns

The tool respects `.gitignore` patterns plus default exclusions:

**Default Exclusions**:
- `node_modules/`, `.next/`, `.git/`
- `coverage/`, `.vercel/`
- `**/archive/**`, `**/.archived/**`
- `*.backup`, `*.bak`, `*.old`
- `.DS_Store`, `*.tsbuildinfo`

**Custom exclusions**: Add to your `.gitignore` file.

---

## Examples by Use Case

### Finding a Component

```bash
# 1. Search for component
./project-intel.mjs --search "Button" --type tsx --json

# 2. View symbols in component
./project-intel.mjs --symbols src/components/Button.tsx --json

# 3. Find what uses the component
./project-intel.mjs --importers src/components/Button.tsx --json
```

### Tracing a Bug

```bash
# 1. Find the buggy function
./project-intel.mjs --search "handlePayment" --json

# 2. See what calls it
./project-intel.mjs --callers handlePayment --json

# 3. See what it calls
./project-intel.mjs --callees handlePayment --json

# 4. Trace full dependency chain
./project-intel.mjs --dependencies src/payment/handler.ts --direction upstream --json
```

### Understanding Project Structure

```bash
# 1. Get overview
./project-intel.mjs --overview --json

# 2. View directory tree (2 levels)
./project-intel.mjs --tree --max-depth 2 --json

# 3. Get statistics
./project-intel.mjs --stats --json

# 4. View comprehensive summary
./project-intel.mjs --summarize --json
```

### Refactoring Support

```bash
# 1. Find all uses of function
./project-intel.mjs --callers oldFunctionName --json

# 2. Check dependencies
./project-intel.mjs --dependencies src/old-module.ts --direction upstream --json

# 3. Find unused code to remove
./project-intel.mjs --dead --json
```

---

## Integration with Claude Code

### In Agent Instructions

```markdown
## Step 1: Intel Queries (REQUIRED)

Before reading any files:

1. Get overview:
   `Bash: project-intel.mjs --overview --json`

2. Search for relevant files:
   `Bash: project-intel.mjs --search "target" --json`

3. Get symbols:
   `Bash: project-intel.mjs --symbols path/to/file.ts --json`

4. Check dependencies:
   `Bash: project-intel.mjs --dependencies path/to/file.ts --json`

## Step 2: Read Files (ONLY AFTER INTEL)

Now read specific files with context.
```

### In Slash Commands

Use bash pre-execution (! prefix):

```markdown
---
allowed-tools: Bash(project-intel.mjs:*)
---

!project-intel.mjs --search "auth" --json

Analyze the authentication flow based on the intel above.
```

### In Skills

```markdown
When user mentions finding code, instruct Claude:

1. Run intel queries using Bash tool
2. Parse JSON output
3. Read targeted files
4. Provide analysis
```

---

## Troubleshooting

### Error: PROJECT_INDEX.json not found

**Cause**: Index file doesn't exist or isn't in expected location

**Solution**:
1. Run `/index` command in Claude Code, OR
2. Run your index generation script, OR
3. Specify custom location: `-i /path/to/PROJECT_INDEX.json`

---

### Error: Invalid JSON

**Cause**: PROJECT_INDEX.json is corrupted

**Solution**: Regenerate the index using `/index` command

---

### Warning: Output too large

**Cause**: Command would produce more than 200 lines

**Solutions**:
- Use `-l` flag to limit results
- Make search term more specific
- Use `--force` to skip warning
- Use `--max-depth` for tree command

---

### No results found

**Possible causes**:
- File excluded by .gitignore
- Search term too specific
- Symbol not in index (may not be parsed)

**Solutions**:
- Check .gitignore patterns
- Broaden search term
- Verify file exists: `ls <file-path>`

---

## Performance Tips

1. **Use --json for parsing**: Text output is for humans, JSON for scripts
2. **Limit results**: Use `-l` flag when you don't need everything
3. **Focus searches**: More specific terms = faster results
4. **Cache results**: Save JSON output to file if reusing

---

## Related Documentation

- **System Architecture**: @docs/architecture/project-index-system.md
- **Intelligence Workflow**: @docs/architecture/system-overview.md (Intelligence-First section)
- **CoD^Σ Framework**: @docs/architecture/cod-sigma-framework.md

---

**Key Takeaway**: Always query project-intel.mjs BEFORE reading files. This is the foundation of intelligence-first architecture.
