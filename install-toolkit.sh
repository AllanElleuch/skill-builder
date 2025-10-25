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
TEMP_CLONE=""

#==============================================================================
# Self-Cloning Logic (for curl | bash usage)
#==============================================================================

# Check if source files exist in current location
if [ ! -d "$SCRIPT_DIR/.claude" ]; then
    # Source files not found - we're likely being run via curl | bash
    # Clone the repo to a temp location and re-execute from there

    # Generate unique temp directory
    TEMP_CLONE="/tmp/skill-builder-install-$$"

    # Cleanup function
    cleanup_temp_clone() {
        if [ -n "$TEMP_CLONE" ] && [ -d "$TEMP_CLONE" ]; then
            rm -rf "$TEMP_CLONE"
        fi
    }

    # Register cleanup on exit
    trap cleanup_temp_clone EXIT

    echo -e "${BLUE}ℹ${NC} Source files not found locally, cloning repository..."

    if ! git clone --quiet https://github.com/yangsi7/skill-builder.git "$TEMP_CLONE" 2>/dev/null; then
        echo -e "${RED}✗${NC} Failed to clone repository"
        exit 1
    fi

    echo -e "${GREEN}✓${NC} Repository cloned to temporary location"

    # Re-execute the installer from the cloned location with all original arguments
    exec "$TEMP_CLONE/install-toolkit.sh" "$@"
fi

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
            if [ "$FORCE" = true ]; then
                # Force mode: create automatically
                mkdir -p "$TARGET_DIR"
                print_success "Created directory: $TARGET_DIR"
            else
                # Interactive mode: ask user
                read -p "Create it? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    mkdir -p "$TARGET_DIR"
                    print_success "Created directory: $TARGET_DIR"
                else
                    print_error "Installation cancelled"
                    exit 1
                fi
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
        if [ "$FORCE" = true ]; then
            # Force mode: auto-backup existing files
            BACKUP_DIR="$TARGET_DIR/.toolkit-backup-$(date +%Y%m%d-%H%M%S)"
            mkdir -p "$BACKUP_DIR"
            print_success "Auto-backup enabled at: $BACKUP_DIR"
        elif [ "$DRY_RUN" = false ]; then
            # Interactive mode: ask user
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

## Intelligence Toolkit Usage (CoD^Σ)

### Core Principle
**Intel → [Query] ⇒ Read**: Query project-intel.mjs BEFORE files → 80-95% token savings

**Workflow Formula**:
```
Analysis := intelligence_query ∘ targeted_read ∘ CoD^Σ_reasoning → evidence_based_output
```

### Intelligence-First Pattern
```bash
# ALWAYS start sessions with:
project-intel.mjs --overview --json          # Get structure
project-intel.mjs --search "target" --json   # Find files
project-intel.mjs --symbols file.ts --json   # Get symbols
# THEN read specific files
```

**If PROJECT_INDEX.json missing** → Run `/index` first

---

## Component Usage (When to Use What)

### Skills (10 total - Auto-invoked)
**Trigger** → **Skill** ⇒ **Outcome**

- [need debugging ∨ bug analysis] → **analyze-code** ⇒ intelligence-first diagnosis
- [bugs ∨ test failures] → **debug-issues** ⇒ root cause analysis with fix
- [new feature] → **specify-feature** ⇒ tech-agnostic spec.md
- [ambiguity in spec] → **clarify-specification** ⇒ structured Q&A
- [spec exists, need plan] → **create-implementation-plan** ⇒ plan.md + research + contracts
- [plan exists, need tasks] → **generate-tasks** ⇒ user-story-organized tasks.md
- [tasks exist, ready to code] → **implement-and-verify** ⇒ TDD implementation with AC verification
- [define product] → **define-product** ⇒ product definition with CoD^Σ
- [need constitution] → **generate-constitution** ⇒ constitutional framework
- [legacy planning] → **create-plan** ⇒ basic plan (deprecated, use create-implementation-plan)

### Commands (14 total - User-invoked)
**Command** → **Action** ⇒ **Result**

- `/feature` → specify-feature skill ⇒ spec+plan+tasks auto-generated (85% automation)
- `/plan` → create-implementation-plan ⇒ tech plan from spec
- `/tasks` → generate-tasks ⇒ user-story tasks from plan
- `/audit` → cross-artifact validation ⇒ PASS/FAIL (required before /implement)
- `/implement` → implement-and-verify ⇒ TDD per story with /verify loops
- `/verify` → acceptance criteria check ⇒ story-level validation
- `/analyze` → code-analyzer agent ⇒ intel-first analysis report
- `/bug` → debug-issues skill ⇒ symptom→root_cause→fix
- `/index` → regenerate PROJECT_INDEX.json ⇒ update intelligence
- `/bootstrap` → system health check ⇒ verify installation

### Agents (4 total - Delegated via Task tool)
**Condition** → **Agent** ⇒ **Capability**

- [routing decision] → **orchestrator** ⇒ delegates to specialized agents
- [bugs ∨ performance ∨ analysis] → **code-analyzer** ⇒ debugging + intelligence queries
- [architecture ∨ planning] → **planner** ⇒ implementation planning + research
- [TDD ∨ implementation] → **executor** ⇒ test-first coding + AC verification

**All agents use** `model: inherit` (same tier as main conversation)

### Templates (24 total - Referenced via @)
**Import Pattern**: `@.claude/templates/[template].md`

**Categories**:
- **Bootstrap**: planning-template, todo-template, event-stream-template, workbook-template
- **SDD**: feature-spec, clarification-checklist, plan, tasks, quality-checklist
- **Execution**: verification-report, bug-report, handover, report
- **Research**: research-notes, data-model
- **Analysis**: analysis-spec, audit, session-state

---

## Workflows (CoD^Σ Notation)

### 1. SDD (Specification-Driven Development) - 85% Automated
```
User: /feature → specify-feature ∘ /plan ∘ generate-tasks ∘ /audit → Ready ⇒ /implement
AutoChain := spec.md → plan.md → tasks.md → audit_gate → implementation
UserActions := 2 (manual: /feature, /implement)
Automation := 85% (6 automated steps per user action)
```

### 2. Implementation with Progressive Delivery - 66% Automated
```
User: /implement plan.md
→ implement-and-verify[P1] ∘ /verify --story P1 → ✓
→ implement-and-verify[P2] ∘ /verify --story P2 → ✓
→ implement-and-verify[P3] ∘ /verify --story P3 → ✓
AutoVerification := per_story (blocks next story until current passes)
```

### 3. Debugging Workflow
```
User: /bug "description"
→ debug-issues ∘ project-intel.mjs ∘ targeted_read → diagnosis
→ symptom ⇒ root_cause → fix_implementation ∥ test_verification
```

### 4. Analysis Workflow
```
User: /analyze [target]
→ analyze-code ∘ intelligence_queries[overview, symbols, dependencies]
→ targeted_reads ∘ CoD^Σ_reasoning → evidence_report
TokenSavings := 80-95% vs full file reading
```

---

## Best Practices (Ranked by Impact)

**CRITICAL** (Violate = Failure):
1. Query project-intel.mjs BEFORE reading any files
2. Use CoD^Σ notation in all reasoning (file:line evidence required)
3. Follow constitution (7 articles) - enforce via /audit
4. TDD: write_tests → red → implement → green
5. Run /index if PROJECT_INDEX.json missing

**IMPORTANT** (Violate = Inefficiency):
1. Use skills for workflows (don't reinvent)
2. Reference templates via @ imports
3. Let /audit validate before implementing (saves rework)
4. Progressive delivery: verify each story independently
5. Track work in planning.md + todo.md + event-stream.md

**RECOMMENDED** (Violate = Suboptimal):
1. Run /bootstrap after installation to verify
2. Keep workbook.md < 300 lines (active context only)
3. Use MCP tools for external knowledge (Ref, Brave, Supabase)
4. Follow SDD workflow order: spec → plan → tasks → audit → implement
5. Review @.claude/shared-imports/constitution.md for principles

---

## Quick Reference

**Start new feature**: `/feature "description"` → auto-generates spec+plan+tasks → `/audit` → `/implement`
**Debug issue**: `/bug "description"` → intelligence-first diagnosis → fix
**Analyze code**: `/analyze` → routes to code-analyzer agent
**Verify setup**: `/bootstrap` → checks installation health
**Update index**: `/index` → regenerates PROJECT_INDEX.json

**Documentation**: See `.claude/templates/BOOTSTRAP_GUIDE.md` for complete guide

**System Health**: This toolkit achieved 100/100 score in validation (see VALIDATION_REPORT.md)
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
        # Update existing CLAUDE.md (replace old toolkit section or append if not present)
        if grep -q "Intelligence Toolkit" "$target"; then
            # Remove old toolkit section (match both old and new headers)
            # Pattern matches: "## Intelligence Toolkit Integration" OR "## Intelligence Toolkit Usage"
            sed -i.tmp '/^## Intelligence Toolkit/,$d' "$target"
            rm -f "$target.tmp"
            # Append new toolkit section
            cat "$temp_file" >> "$target"
            print_success "Toolkit section updated in existing CLAUDE.md"
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
  --force           Fully automated mode (creates directories, auto-backups)
  --verbose         Show detailed output
  --bootstrap       Copy bootstrap templates (planning.md, todo.md, etc.)
  --help            Show this help message

Examples:
  # Interactive install (asks for confirmation)
  $0 /path/to/project

  # Fully automated install (creates dirs, backups automatically)
  $0 --force /path/to/project

  # Dry run (preview changes)
  $0 --dry-run /path/to/project

  # Install with bootstrap templates
  $0 --bootstrap /path/to/project

  # Automated with bootstrap
  $0 --force --bootstrap /path/to/project

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
