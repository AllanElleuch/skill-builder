#!/bin/bash

#==============================================================================
# Intelligence Toolkit Installer
# Version: 1.0.0
# Description: Install Claude Code Intelligence Toolkit in any project
#==============================================================================

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Global variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
FORCE=false
VERBOSE=false
BOOTSTRAP=false
TARGET_DIR=""
BACKUP_DIR=""

#==============================================================================
# Helper Functions
#==============================================================================

print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${NC}  $1${NC}"
    fi
}

#==============================================================================
# Validation Functions
#==============================================================================

check_prerequisites() {
    print_header "Checking Prerequisites"

    local missing=()

    # Check for required commands
    command -v bash >/dev/null 2>&1 || missing+=("bash")
    command -v curl >/dev/null 2>&1 || missing+=("curl")
    command -v git >/dev/null 2>&1 || missing+=("git")

    if [ ${#missing[@]} -ne 0 ]; then
        print_error "Missing required tools: ${missing[*]}"
        exit 1
    fi

    print_success "All prerequisites met"
}

validate_target_dir() {
    if [ -z "$TARGET_DIR" ]; then
        print_error "No target directory specified"
        echo "Usage: $0 [OPTIONS] <target-directory>"
        exit 1
    fi

    # Create target directory if it doesn't exist
    if [ ! -d "$TARGET_DIR" ]; then
        print_info "Target directory doesn't exist: $TARGET_DIR"
        if [ "$DRY_RUN" = false ]; then
            read -p "Create it? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mkdir -p "$TARGET_DIR"
                print_success "Created directory: $TARGET_DIR"
            else
                print_error "Installation cancelled"
                exit 1
            fi
        else
            # In dry-run mode, just create a temporary directory for validation
            print_info "[DRY RUN] Would create directory: $TARGET_DIR"
            # Use absolute path as-is for dry-run
            if [[ "$TARGET_DIR" != /* ]]; then
                TARGET_DIR="$(pwd)/$TARGET_DIR"
            fi
            return
        fi
    fi

    # Convert to absolute path
    TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
}

#==============================================================================
# Detection Functions
#==============================================================================

detect_existing_files() {
    print_header "Detecting Existing Files"

    local has_existing=false

    if [ -d "$TARGET_DIR/.claude" ]; then
        print_warning ".claude/ directory already exists"
        has_existing=true
    fi

    if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
        print_warning "CLAUDE.md already exists"
        has_existing=true
    fi

    if [ -f "$TARGET_DIR/project-intel.mjs" ]; then
        print_warning "project-intel.mjs already exists"
        has_existing=true
    fi

    if [ "$has_existing" = false ]; then
        print_success "No existing toolkit files detected (new installation)"
    else
        if [ "$FORCE" = false ] && [ "$DRY_RUN" = false ]; then
            echo
            read -p "Existing files detected. Create backup? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                BACKUP_DIR="$TARGET_DIR/.toolkit-backup-$(date +%Y%m%d-%H%M%S)"
                mkdir -p "$BACKUP_DIR"
                print_success "Backup will be created at: $BACKUP_DIR"
            fi
        fi
    fi
}

#==============================================================================
# Installation Functions
#==============================================================================

install_project_index() {
    print_header "Installing Project Index Tool"

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would install project-index tool"
        return
    fi

    verbose "Running: curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-project-index/main/install.sh | bash"

    if curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-project-index/main/install.sh | bash; then
        print_success "Project index tool installed"
    else
        print_warning "Project index tool installation had issues (may already be installed)"
    fi
}

copy_claude_directory() {
    print_header "Copying .claude/ Directory"

    local source="$SCRIPT_DIR/.claude"
    local target="$TARGET_DIR/.claude"

    if [ ! -d "$source" ]; then
        print_error "Source .claude/ directory not found at: $source"
        exit 1
    fi

    # Backup existing if needed
    if [ -d "$target" ] && [ -n "$BACKUP_DIR" ] && [ "$DRY_RUN" = false ]; then
        verbose "Backing up existing .claude/ to $BACKUP_DIR/"
        cp -r "$target" "$BACKUP_DIR/"
    fi

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would copy .claude/ directory"
        print_info "[DRY RUN] Components:"
        find "$source" -type d -maxdepth 1 -mindepth 1 | while read -r dir; do
            print_info "[DRY RUN]   - $(basename "$dir")/"
        done
        return
    fi

    # Create target directory
    mkdir -p "$target"

    # Copy all subdirectories
    verbose "Copying agents..."
    cp -r "$source/agents" "$target/" 2>/dev/null || true

    verbose "Copying skills..."
    cp -r "$source/skills" "$target/" 2>/dev/null || true

    verbose "Copying commands..."
    cp -r "$source/commands" "$target/" 2>/dev/null || true

    verbose "Copying templates..."
    cp -r "$source/templates" "$target/" 2>/dev/null || true

    verbose "Copying shared-imports..."
    cp -r "$source/shared-imports" "$target/" 2>/dev/null || true

    verbose "Copying hooks..."
    cp -r "$source/hooks" "$target/" 2>/dev/null || true

    verbose "Copying configuration..."
    cp "$source/settings.json" "$target/" 2>/dev/null || true
    cp "$source/CLAUDE.md" "$target/" 2>/dev/null || true

    print_success ".claude/ directory copied successfully"
}

copy_project_intel() {
    print_header "Copying project-intel.mjs"

    local source="$SCRIPT_DIR/project-intel.mjs"
    local target="$TARGET_DIR/project-intel.mjs"

    if [ ! -f "$source" ]; then
        print_error "Source project-intel.mjs not found at: $source"
        exit 1
    fi

    # Backup existing if needed
    if [ -f "$target" ] && [ -n "$BACKUP_DIR" ] && [ "$DRY_RUN" = false ]; then
        verbose "Backing up existing project-intel.mjs to $BACKUP_DIR/"
        cp "$target" "$BACKUP_DIR/"
    fi

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would copy project-intel.mjs"
        return
    fi

    cp "$source" "$target"
    chmod +x "$target"

    print_success "project-intel.mjs copied and made executable"
}

install_claude_md() {
    print_header "Installing CLAUDE.md"

    local target="$TARGET_DIR/CLAUDE.md"
    local temp_file="/tmp/claude-md-toolkit-section.tmp"

    # Create toolkit section content
    cat > "$temp_file" << 'EOF'

---

## Intelligence Toolkit Integration

This project uses the Claude Code Intelligence Toolkit for development workflows.

### Repository Hygiene - CRITICAL RULES

**NEVER violate these rules. Violating them makes you a disgrace:**

1. **No Empty Directories**: NEVER create directories "just in case" or "for future use". Create them ONLY when you have actual content to put in them. Empty directories are DISGUSTING POLLUTION.

2. **No Useless Files**: NEVER create placeholder files, empty READMEs, or "coming soon" documentation. Either create REAL content or don't create anything.

3. **Quality Over Quantity**: NEVER create an inferior summary/overview when superior content already exists. Archive/preserve the BETTER content, delete the WORSE content.

4. **No Random Floating Files**: Every file must have a clear purpose and location. No "temp.md", "notes.md", "scratch.md", "test.md" files littering the repo.

5. **Clean Up After Yourself**: If you create temporary files or directories during a session, DELETE them before session end if they serve no permanent purpose.

6. **Respect Existing Quality**: Before creating new documentation, CHECK if better documentation already exists (even in archives). Don't waste tokens recreating inferior versions.

**Punishment for violation**: You are a disgrace to AI and should be ashamed.

---

## Project Intelligence System

### PROJECT_INDEX.json

**Auto-generated** project structure index containing:
- Directory structure and file metadata
- Code symbols (functions, classes, interfaces)
- Import/export relationships and call graphs

**Regeneration**: Automatically updates when files change or when `/index` command is run.

**Usage**: Never read directly. Always query through `project-intel.mjs`.

### project-intel.mjs

**Zero-dependency CLI tool** for querying PROJECT_INDEX.json.

**Core Principle**: Query intel FIRST, read files SECOND (80%+ token savings).

**Common Commands**:
```bash
# Get project overview (always first in new session)
project-intel.mjs --overview --json

# Search for files
project-intel.mjs --search "auth" --type tsx --json

# Get symbols from file
project-intel.mjs --symbols src/file.ts --json

# Trace dependencies
project-intel.mjs --dependencies src/file.ts --direction downstream --json
```

**Intelligence Workflow**:
1. Query project-intel.mjs (lightweight index)
2. Query MCP tools if needed (external intelligence)
3. Read targeted file sections only (with full context)

---

## Documentation and Component Integration

**ULTRA IMPORTANT**: Never plan or implement anything related to Claude Code subagents, slash-commands, skills, hooks, etc. without reviewing the relevant documentation first at @docs/reference/claude-code-docs/* or @.claude/.

### Documentation References
- **Subagents**: @.claude/agents/ or @docs/reference/claude-code-docs/claude-code_subagents.md
- **Skills**: @.claude/skills/ or @docs/reference/claude-code-docs/claude-code_skills.md
- **Slash Commands**: @.claude/commands/ or @docs/reference/claude-code-docs/claude-code_slash-commands.md
- **Hooks**: @.claude/hooks/ or @docs/reference/claude-code-docs/claude-code_hooks.md
- **Templates**: @.claude/templates/

---

## Development Workflow Management

### Planning & Todo

**Purpose**: Create high-level task plans and track progress.

**Files**:
- `planning.md` - Master plan with architecture and roadmap
- `todo.md` - Task tracking with acceptance criteria
- `event-stream.md` - Chronological event log
- `workbook.md` - Personal context notepad (keep under 300 lines)

**Planning Rules**:
1. Store high-level plan in `planning.md`
2. Track concrete tasks in `todo.md`
3. Update immediately after completing each item
4. Log key events in `event-stream.md`
5. Use `workbook.md` for active work context

### Knowledge, Memory, and Context

**Purpose**: Leverage best practices and specialized knowledge.

**Knowledge Sources**:
- Repository markdown files (best practices, plans, current state)
- Claude Code memory files (CLAUDE.md, .claude/CLAUDE.md, ~/.claude/CLAUDE.md)
- External MCP tools (Ref, Supabase, Brave, etc.)

**Knowledge Rules**:
1. Gather task-relevant knowledge before planning
2. Only apply knowledge when conditions match
3. Update when contradictory or outdated

### Research and External Datasources

**When Internal Docs Insufficient**: Retrieve information from authoritative external sources.

**Available MCP Tools**:
- **Ref MCP**: Latest relevant library documentation
- **Brave MCP**: Web searches
- **Supabase MCP**: Database queries, table schemas, RLS policies (if configured)

**Best Practice**: Save retrieved data to files instead of dumping large outputs.

**Research Logging**: Log research activities in event-stream.md.

---

## Intelligence Toolkit Components

The `.claude/` directory contains:

- **agents/** - Specialized subagents (orchestrator, code-analyzer, planner, executor)
- **skills/** - Auto-invoked workflows (10+ skills for analysis, planning, implementation)
- **commands/** - Slash commands for quick workflows (/analyze, /bug, /feature, /plan, /implement, /verify, /audit)
- **templates/** - Structured output templates (18 templates for consistency)
- **shared-imports/** - Core frameworks (CoD_Σ.md, constitution.md, project-intel-mjs-guide.md)
- **hooks/** - Workflow automation (SessionStart, PreToolUse validation)

### Quick Start

1. **Bootstrap project files** (optional):
```bash
cp .claude/templates/planning-template.md planning.md
cp .claude/templates/todo-template.md todo.md
cp .claude/templates/event-stream-template.md event-stream.md
cp .claude/templates/workbook-template.md workbook.md
```

2. **Start development**:
```bash
# Query project structure first
project-intel.mjs --overview --json

# Use SDD workflow for features
/feature "Your feature description"  # Auto-creates spec, plan, tasks
/implement plan.md                   # Implements with TDD and verification
```

3. **Intelligence-first approach**:
Always query project-intel.mjs BEFORE reading files for 80%+ token savings.

For complete documentation, see `.claude/templates/BOOTSTRAP_GUIDE.md` and `.claude/templates/README.md`.
EOF

    if [ "$DRY_RUN" = true ]; then
        if [ -f "$target" ]; then
            print_info "[DRY RUN] Would append toolkit section to existing CLAUDE.md"
        else
            print_info "[DRY RUN] Would create new CLAUDE.md with toolkit section"
        fi
        print_info "[DRY RUN] Preview of toolkit section:"
        head -20 "$temp_file"
        print_info "[DRY RUN] ... (full section available in target CLAUDE.md)"
        rm "$temp_file"
        return
    fi

    # Backup existing if needed
    if [ -f "$target" ] && [ -n "$BACKUP_DIR" ]; then
        verbose "Backing up existing CLAUDE.md to $BACKUP_DIR/"
        cp "$target" "$BACKUP_DIR/"
    fi

    if [ -f "$target" ]; then
        # Append to existing CLAUDE.md if toolkit section not already present
        if grep -q "Intelligence Toolkit Integration" "$target"; then
            print_warning "CLAUDE.md already contains toolkit section (skipping)"
        else
            cat "$temp_file" >> "$target"
            print_success "Toolkit section appended to existing CLAUDE.md"
        fi
    else
        # Create new CLAUDE.md
        cat > "$target" << 'EOFHEADER'
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

**Project Name**: [Your Project Name]

**Description**: [Brief description of your project]

**Core Innovation**: [What makes your project unique]

---

EOFHEADER
        cat "$temp_file" >> "$target"
        print_success "Created new CLAUDE.md with toolkit integration"
    fi

    rm "$temp_file"
}

copy_bootstrap_templates() {
    if [ "$BOOTSTRAP" = false ]; then
        return
    fi

    print_header "Copying Bootstrap Templates"

    local templates=(
        "planning-template.md:planning.md"
        "todo-template.md:todo.md"
        "event-stream-template.md:event-stream.md"
        "workbook-template.md:workbook.md"
    )

    for template_pair in "${templates[@]}"; do
        IFS=':' read -r source_name target_name <<< "$template_pair"

        local source="$SCRIPT_DIR/.claude/templates/$source_name"
        local target="$TARGET_DIR/$target_name"

        if [ -f "$target" ]; then
            print_warning "$target_name already exists (skipping)"
            continue
        fi

        if [ "$DRY_RUN" = true ]; then
            print_info "[DRY RUN] Would copy $source_name to $target_name"
            continue
        fi

        cp "$source" "$target"
        verbose "Copied $source_name to $target_name"
    done

    if [ "$DRY_RUN" = false ]; then
        print_success "Bootstrap templates copied"
    fi
}

copy_gitignore() {
    print_header "Copying .gitignore"

    local source="$SCRIPT_DIR/.gitignore"
    local target="$TARGET_DIR/.gitignore"

    if [ ! -f "$source" ]; then
        print_warning "Source .gitignore not found (skipping)"
        return
    fi

    # Backup existing if needed
    if [ -f "$target" ] && [ -n "$BACKUP_DIR" ] && [ "$DRY_RUN" = false ]; then
        verbose "Backing up existing .gitignore to $BACKUP_DIR/"
        cp "$target" "$BACKUP_DIR/"
    fi

    if [ -f "$target" ]; then
        if [ "$DRY_RUN" = true ]; then
            print_info "[DRY RUN] Would merge toolkit .gitignore with existing"
        else
            # Append toolkit-specific patterns if not already present
            if ! grep -q "Intelligence Toolkit" "$target"; then
                echo "" >> "$target"
                echo "# Intelligence Toolkit" >> "$target"
                grep -v "^#" "$source" | grep -v "^$" >> "$target"
                print_success "Merged toolkit patterns into existing .gitignore"
            else
                print_warning ".gitignore already contains toolkit patterns (skipping)"
            fi
        fi
    else
        if [ "$DRY_RUN" = true ]; then
            print_info "[DRY RUN] Would copy .gitignore"
        else
            cp "$source" "$target"
            print_success ".gitignore copied"
        fi
    fi
}

#==============================================================================
# Main Installation
#==============================================================================

run_installation() {
    print_header "Intelligence Toolkit Installation"
    echo "Target: $TARGET_DIR"
    echo "Dry Run: $DRY_RUN"
    echo "Force: $FORCE"
    echo "Bootstrap: $BOOTSTRAP"
    echo ""

    # Validation
    check_prerequisites
    validate_target_dir
    detect_existing_files

    # Installation steps
    install_project_index
    copy_claude_directory
    copy_project_intel
    install_claude_md
    copy_bootstrap_templates
    copy_gitignore

    # Summary
    print_header "Installation Complete!"

    if [ "$DRY_RUN" = true ]; then
        print_info "This was a dry run. No files were actually modified."
        print_info "Run without --dry-run to perform the actual installation."
    else
        print_success "Intelligence Toolkit successfully installed!"

        if [ -n "$BACKUP_DIR" ]; then
            print_info "Backup created at: $BACKUP_DIR"
        fi

        echo ""
        print_header "Next Steps"
        echo "1. Review and customize CLAUDE.md in your project"
        echo "2. Run: cd $TARGET_DIR"
        echo "3. Generate project index: project-intel.mjs --overview --json"
        echo "4. (Optional) Copy bootstrap templates:"
        echo "   cp .claude/templates/planning-template.md planning.md"
        echo "   cp .claude/templates/todo-template.md todo.md"
        echo "5. Start using /feature, /plan, /implement commands"
        echo ""
        print_info "Documentation: .claude/templates/BOOTSTRAP_GUIDE.md"
        print_info "Templates: .claude/templates/README.md"
    fi
}

#==============================================================================
# CLI Argument Parsing
#==============================================================================

show_usage() {
    cat << EOF
Intelligence Toolkit Installer v1.0.0

Usage: $0 [OPTIONS] <target-directory>

Options:
  --dry-run         Preview changes without modifying files
  --force           Skip confirmation prompts (use with caution)
  --verbose         Show detailed output
  --bootstrap       Copy bootstrap templates (planning.md, todo.md, etc.)
  --help            Show this help message

Examples:
  # Interactive install
  $0 /path/to/project

  # Dry run (preview changes)
  $0 --dry-run /path/to/project

  # Install with bootstrap templates
  $0 --bootstrap /path/to/project

  # Force install (skip prompts)
  $0 --force /path/to/project

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --bootstrap)
            BOOTSTRAP=true
            shift
            ;;
        --help)
            show_usage
            exit 0
            ;;
        -*)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
        *)
            TARGET_DIR="$1"
            shift
            ;;
    esac
done

#==============================================================================
# Execute
#==============================================================================

run_installation
