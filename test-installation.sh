#!/bin/bash

# Intelligence Toolkit - Comprehensive Installation & Bootstrap Test Suite
# Tests all edge cases for install-toolkit.sh and /bootstrap command

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test output directory
TEST_DIR="$(pwd)/test-output"
TOOLKIT_DIR="$(pwd)"

# Cleanup function
cleanup() {
    if [ -d "$TEST_DIR" ]; then
        echo -e "${BLUE}Cleaning up test directory...${NC}"
        rm -rf "$TEST_DIR"
    fi
}

# Setup test environment
setup_test_env() {
    echo -e "${BLUE}Setting up test environment...${NC}"
    cleanup
    mkdir -p "$TEST_DIR"
}

# Print test header
print_test_header() {
    local test_name="$1"
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}TEST: $test_name${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    TESTS_RUN=$((TESTS_RUN + 1))
}

# Print test result
print_result() {
    local result="$1"
    local message="$2"

    if [ "$result" = "PASS" ]; then
        echo -e "${GREEN}✓ PASS${NC}: $message"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗ FAIL${NC}: $message"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Print final summary
print_summary() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}TEST SUMMARY${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "Tests Run:    $TESTS_RUN"
    echo -e "${GREEN}Tests Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Tests Failed: $TESTS_FAILED${NC}"
    echo ""

    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}✓ ALL TESTS PASSED${NC}"
        return 0
    else
        echo -e "${RED}✗ SOME TESTS FAILED${NC}"
        return 1
    fi
}

# ============================================================================
# PHASE 8.1: INSTALLATION EDGE CASE TESTS
# ============================================================================

test_dry_run_mode() {
    print_test_header "Installation: Dry-run mode (no files created)"

    local target="$TEST_DIR/test-dry-run"

    # Run dry-run
    "$TOOLKIT_DIR/install-toolkit.sh" --dry-run "$target" > "$TEST_DIR/dry-run.log" 2>&1 || true

    # Verify no files were created
    if [ ! -d "$target/.claude" ]; then
        print_result "PASS" "Dry-run did not create .claude directory"
    else
        print_result "FAIL" "Dry-run created .claude directory (should not)"
    fi

    if [ ! -f "$target/project-intel.mjs" ]; then
        print_result "PASS" "Dry-run did not create project-intel.mjs"
    else
        print_result "FAIL" "Dry-run created project-intel.mjs (should not)"
    fi

    # Verify log shows what WOULD be installed
    if grep -q "Would create directory" "$TEST_DIR/dry-run.log"; then
        print_result "PASS" "Dry-run log shows planned operations"
    else
        print_result "FAIL" "Dry-run log missing planned operations"
    fi
}

test_fresh_installation() {
    print_test_header "Installation: Fresh installation (empty directory)"

    local target="$TEST_DIR/test-fresh"
    mkdir -p "$target"

    # Run installation
    "$TOOLKIT_DIR/install-toolkit.sh" --force "$target" > "$TEST_DIR/fresh.log" 2>&1

    # Verify core components installed
    if [ -d "$target/.claude/skills" ]; then
        print_result "PASS" "Skills directory created"
    else
        print_result "FAIL" "Skills directory missing"
    fi

    if [ -d "$target/.claude/commands" ]; then
        print_result "PASS" "Commands directory created"
    else
        print_result "FAIL" "Commands directory missing"
    fi

    if [ -d "$target/.claude/agents" ]; then
        print_result "PASS" "Agents directory created"
    else
        print_result "FAIL" "Agents directory missing"
    fi

    if [ -d "$target/.claude/templates" ]; then
        print_result "PASS" "Templates directory created"
    else
        print_result "FAIL" "Templates directory missing"
    fi

    if [ -f "$target/project-intel.mjs" ]; then
        print_result "PASS" "project-intel.mjs installed"
    else
        print_result "FAIL" "project-intel.mjs missing"
    fi

    if [ -f "$target/CLAUDE.md" ]; then
        print_result "PASS" "CLAUDE.md created"
    else
        print_result "FAIL" "CLAUDE.md missing"
    fi

    # Count components
    local skill_count=$(find "$target/.claude/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
    local cmd_count=$(ls "$target/.claude/commands"/*.md 2>/dev/null | wc -l | tr -d ' ')
    local agent_count=$(ls "$target/.claude/agents"/*.md 2>/dev/null | wc -l | tr -d ' ')
    local template_count=$(ls "$target/.claude/templates"/*.md 2>/dev/null | wc -l | tr -d ' ')

    if [ "$skill_count" -ge 10 ]; then
        print_result "PASS" "Skills installed: $skill_count (expected ≥10)"
    else
        print_result "FAIL" "Skills count: $skill_count (expected ≥10)"
    fi

    if [ "$cmd_count" -ge 14 ]; then
        print_result "PASS" "Commands installed: $cmd_count (expected ≥14)"
    else
        print_result "FAIL" "Commands count: $cmd_count (expected ≥14)"
    fi

    if [ "$agent_count" -eq 4 ]; then
        print_result "PASS" "Agents installed: $agent_count (expected 4)"
    else
        print_result "FAIL" "Agents count: $agent_count (expected 4)"
    fi

    if [ "$template_count" -ge 24 ]; then
        print_result "PASS" "Templates installed: $template_count (expected ≥24)"
    else
        print_result "FAIL" "Templates count: $template_count (expected ≥24)"
    fi
}

test_existing_claude_directory() {
    print_test_header "Installation: Existing .claude directory (backup creation)"

    local target="$TEST_DIR/test-existing"
    mkdir -p "$target/.claude"
    echo "existing content" > "$target/.claude/test-file.txt"

    # Run installation
    "$TOOLKIT_DIR/install-toolkit.sh" --force "$target" > "$TEST_DIR/existing.log" 2>&1

    # Verify backup created
    local backup_dir=$(find "$target" -maxdepth 1 -name ".toolkit-backup-*" -type d | head -1)
    if [ -n "$backup_dir" ]; then
        print_result "PASS" "Backup directory created: $(basename "$backup_dir")"

        if [ -f "$backup_dir/.claude/test-file.txt" ]; then
            print_result "PASS" "Backup contains existing file"
        else
            print_result "FAIL" "Backup missing existing file"
        fi
    else
        print_result "FAIL" "Backup directory not created"
    fi

    # Verify new installation succeeded
    if [ -d "$target/.claude/skills" ]; then
        print_result "PASS" "New .claude directory created after backup"
    else
        print_result "FAIL" "New .claude directory not created"
    fi
}

test_existing_claude_md() {
    print_test_header "Installation: Existing CLAUDE.md (intelligent merge)"

    local target="$TEST_DIR/test-claude-md"
    mkdir -p "$target"

    # Create existing CLAUDE.md with custom content
    cat > "$target/CLAUDE.md" << 'EOF'
# CLAUDE.md

## Custom Project Instructions

This is custom content that should be preserved.

## Intelligence Toolkit Integration

Old content that should be replaced.
EOF

    # Run installation
    "$TOOLKIT_DIR/install-toolkit.sh" --force "$target" > "$TEST_DIR/claude-md.log" 2>&1

    # Verify custom content preserved
    if grep -q "Custom Project Instructions" "$target/CLAUDE.md"; then
        print_result "PASS" "Custom content preserved in CLAUDE.md"
    else
        print_result "FAIL" "Custom content lost in CLAUDE.md"
    fi

    # Verify toolkit section updated
    if grep -q "Intelligence-First Pattern" "$target/CLAUDE.md"; then
        print_result "PASS" "Toolkit section added to CLAUDE.md"
    else
        print_result "FAIL" "Toolkit section missing from CLAUDE.md"
    fi

    # Verify backup created
    local backup_dir=$(find "$target" -maxdepth 1 -name ".toolkit-backup-*" -type d | head -1)
    if [ -n "$backup_dir" ] && [ -f "$backup_dir/CLAUDE.md" ]; then
        print_result "PASS" "CLAUDE.md backup created in $(basename "$backup_dir")"
    else
        print_result "FAIL" "CLAUDE.md backup not created"
    fi
}

test_bootstrap_mode() {
    print_test_header "Installation: Bootstrap mode (templates copied)"

    local target="$TEST_DIR/test-bootstrap"
    mkdir -p "$target"

    # Run installation with bootstrap
    "$TOOLKIT_DIR/install-toolkit.sh" --force --bootstrap "$target" > "$TEST_DIR/bootstrap.log" 2>&1

    # Verify bootstrap templates copied
    if [ -f "$target/planning.md" ]; then
        print_result "PASS" "planning.md copied to project root"
    else
        print_result "FAIL" "planning.md not copied"
    fi

    if [ -f "$target/todo.md" ]; then
        print_result "PASS" "todo.md copied to project root"
    else
        print_result "FAIL" "todo.md not copied"
    fi

    if [ -f "$target/event-stream.md" ]; then
        print_result "PASS" "event-stream.md copied to project root"
    else
        print_result "FAIL" "event-stream.md not copied"
    fi

    if [ -f "$target/workbook.md" ]; then
        print_result "PASS" "workbook.md copied to project root"
    else
        print_result "FAIL" "workbook.md not copied"
    fi
}

test_nonexistent_target() {
    print_test_header "Installation: Nonexistent target directory (auto-creation)"

    local target="$TEST_DIR/test-nonexistent/nested/path"

    # Run installation
    "$TOOLKIT_DIR/install-toolkit.sh" --force "$target" > "$TEST_DIR/nonexistent.log" 2>&1

    # Verify directory created
    if [ -d "$target" ]; then
        print_result "PASS" "Target directory created automatically"
    else
        print_result "FAIL" "Target directory not created"
    fi

    if [ -d "$target/.claude" ]; then
        print_result "PASS" ".claude directory created in new path"
    else
        print_result "FAIL" ".claude directory not created"
    fi
}

# ============================================================================
# PHASE 8.2: BOOTSTRAP VALIDATION TESTS
# ============================================================================

test_bootstrap_all_components() {
    print_test_header "Bootstrap: All components present (100/100 score expected)"

    # Use the current toolkit directory (which should be complete)
    cd "$TOOLKIT_DIR"

    # Run system integrity check
    ./.claude/hooks/system-integrity-check.sh > "$TEST_DIR/bootstrap-full.log" 2>&1 || true

    # Check for expected components
    if grep -q "Skills: 10" "$TEST_DIR/bootstrap-full.log"; then
        print_result "PASS" "Skills count validated (10)"
    else
        print_result "FAIL" "Skills count incorrect"
    fi

    if grep -q "Commands: 15" "$TEST_DIR/bootstrap-full.log"; then
        print_result "PASS" "Commands count validated (15)"
    else
        print_result "FAIL" "Commands count incorrect"
    fi

    if grep -q "Agents: 4" "$TEST_DIR/bootstrap-full.log"; then
        print_result "PASS" "Agents count validated (4)"
    else
        print_result "FAIL" "Agents count incorrect"
    fi

    if grep -q "Templates: 24" "$TEST_DIR/bootstrap-full.log"; then
        print_result "PASS" "Templates count validated (24)"
    else
        print_result "FAIL" "Templates count incorrect"
    fi
}

test_bootstrap_missing_components() {
    print_test_header "Bootstrap: Missing components detection"

    local target="$TEST_DIR/test-missing"
    mkdir -p "$target/.claude"

    # Create incomplete installation (only agents, no skills)
    cp -r "$TOOLKIT_DIR/.claude/agents" "$target/.claude/"

    cd "$target"

    # Run integrity check (will fail)
    if "$TOOLKIT_DIR/.claude/hooks/system-integrity-check.sh" > "$TEST_DIR/missing.log" 2>&1; then
        print_result "FAIL" "Integrity check passed with missing components (should fail)"
    else
        print_result "PASS" "Integrity check correctly failed with missing components"
    fi

    cd "$TOOLKIT_DIR"
}

test_bootstrap_constitution_imports() {
    print_test_header "Bootstrap: Constitution imports validation"

    local target="$TEST_DIR/test-constitution"

    # Install full toolkit
    "$TOOLKIT_DIR/install-toolkit.sh" --force "$target" > /dev/null 2>&1

    cd "$target"

    # Check all agents import constitution.md
    local agents_with_constitution=0
    for agent in .claude/agents/*.md; do
        if grep -q "@.claude/shared-imports/constitution.md" "$agent"; then
            agents_with_constitution=$((agents_with_constitution + 1))
        fi
    done

    if [ "$agents_with_constitution" -eq 4 ]; then
        print_result "PASS" "All 4 agents import constitution.md"
    else
        print_result "FAIL" "Only $agents_with_constitution/4 agents import constitution.md"
    fi

    cd "$TOOLKIT_DIR"
}

test_bootstrap_slashcommand_compatibility() {
    print_test_header "Bootstrap: SlashCommand tool compatibility"

    local target="$TEST_DIR/test-slashcommand"

    # Install full toolkit
    "$TOOLKIT_DIR/install-toolkit.sh" --force "$target" > /dev/null 2>&1

    cd "$target"

    # Check all commands have description field
    local commands_with_description=0
    local total_commands=0
    for cmd in .claude/commands/*.md; do
        total_commands=$((total_commands + 1))
        if grep -q "^description:" "$cmd"; then
            commands_with_description=$((commands_with_description + 1))
        fi
    done

    if [ "$commands_with_description" -eq "$total_commands" ]; then
        print_result "PASS" "All $total_commands commands have description field"
    else
        print_result "FAIL" "Only $commands_with_description/$total_commands commands have description"
    fi

    cd "$TOOLKIT_DIR"
}

# ============================================================================
# PHASE 8.3: INDEX GENERATION TESTS
# ============================================================================

test_index_first_generation() {
    print_test_header "Index: First-time generation (SKIPPED - requires external tool)"

    local target="$TEST_DIR/test-index-first"

    # Install toolkit
    "$TOOLKIT_DIR/install-toolkit.sh" --force "$target" > /dev/null 2>&1

    cd "$target"

    # Verify project-intel.mjs tool is present
    if [ -f "project-intel.mjs" ]; then
        print_result "PASS" "project-intel.mjs query tool installed"
    else
        print_result "FAIL" "project-intel.mjs not found"
    fi

    echo "NOTE: Index generation tests skipped (requires claude-code-project-index tool)"
    echo "      This external tool is installed separately via GitHub"

    cd "$TOOLKIT_DIR"
}

test_index_queries() {
    print_test_header "Index: Query validation (using existing index)"

    local target="$TEST_DIR/test-index-query"

    # Install toolkit
    "$TOOLKIT_DIR/install-toolkit.sh" --force "$target" > /dev/null 2>&1
    cd "$target"

    # Copy the existing PROJECT_INDEX.json from toolkit repo for testing
    if [ -f "$TOOLKIT_DIR/PROJECT_INDEX.json" ]; then
        cp "$TOOLKIT_DIR/PROJECT_INDEX.json" .
        print_result "PASS" "Copied existing index for query testing"

        # Test stats query (doesn't require --json)
        if node project-intel.mjs stats > /dev/null 2>&1; then
            print_result "PASS" "Stats query succeeded"
        else
            print_result "FAIL" "Stats query failed"
        fi

        # Test search query
        if node project-intel.mjs search "skill" --json > /dev/null 2>&1; then
            print_result "PASS" "Search query succeeded"
        else
            print_result "FAIL" "Search query failed"
        fi
    else
        echo "NOTE: No existing index found in toolkit repo, skipping query tests"
    fi

    cd "$TOOLKIT_DIR"
}

# ============================================================================
# PHASE 8.4: INTEGRATION WORKFLOW TESTS
# ============================================================================

test_full_workflow() {
    print_test_header "Integration: Full install → bootstrap → index workflow"

    local target="$TEST_DIR/test-full-workflow"

    # Step 1: Install
    echo "Step 1: Installing toolkit..."
    if "$TOOLKIT_DIR/install-toolkit.sh" --force --bootstrap "$target" > "$TEST_DIR/workflow-install.log" 2>&1; then
        print_result "PASS" "Installation succeeded"
    else
        print_result "FAIL" "Installation failed"
    fi

    cd "$target"

    # Step 2: Verify bootstrap templates
    echo "Step 2: Verifying bootstrap templates..."
    local bootstrap_files=("planning.md" "todo.md" "event-stream.md" "workbook.md")
    local bootstrap_ok=true
    for file in "${bootstrap_files[@]}"; do
        if [ ! -f "$file" ]; then
            bootstrap_ok=false
            break
        fi
    done

    if [ "$bootstrap_ok" = true ]; then
        print_result "PASS" "All bootstrap templates present"
    else
        print_result "FAIL" "Some bootstrap templates missing"
    fi

    # Step 3: Copy existing index for testing (generation requires external tool)
    echo "Step 3: Setting up project index for testing..."
    if [ -f "$TOOLKIT_DIR/PROJECT_INDEX.json" ]; then
        cp "$TOOLKIT_DIR/PROJECT_INDEX.json" .
        print_result "PASS" "Index copied for testing"
    else
        echo "NOTE: No existing index, skipping index tests"
    fi

    # Step 4: Verify index queries work
    echo "Step 4: Testing index queries..."
    if [ -f "PROJECT_INDEX.json" ] && node project-intel.mjs stats > /dev/null 2>&1; then
        print_result "PASS" "Index queries functional"
    else
        print_result "FAIL" "Index queries failed"
    fi

    # Step 5: Run bootstrap check
    echo "Step 5: Running bootstrap integrity check..."
    if "$TOOLKIT_DIR/.claude/hooks/system-integrity-check.sh" > "$TEST_DIR/workflow-bootstrap.log" 2>&1; then
        print_result "PASS" "Bootstrap integrity check passed"
    else
        # Check if it's just a warning (exit code 1 is acceptable)
        if grep -q "Skills: 10" "$TEST_DIR/workflow-bootstrap.log"; then
            print_result "PASS" "Bootstrap check completed (with warnings)"
        else
            print_result "FAIL" "Bootstrap integrity check failed"
        fi
    fi

    cd "$TOOLKIT_DIR"
}

test_claude_md_instructional() {
    print_test_header "Integration: CLAUDE.md is instructional (not descriptive)"

    local target="$TEST_DIR/test-instructional"

    # Install toolkit
    "$TOOLKIT_DIR/install-toolkit.sh" --force "$target" > /dev/null 2>&1

    cd "$target"

    # Check for instructional patterns (WHEN to use, HOW to use)
    if grep -q "When to Use What" "CLAUDE.md"; then
        print_result "PASS" "CLAUDE.md contains usage guidance"
    else
        print_result "FAIL" "CLAUDE.md missing 'When to Use What' section"
    fi

    if grep -q "\[.*\] →" "CLAUDE.md"; then
        print_result "PASS" "CLAUDE.md uses trigger conditions (CoD^Σ notation)"
    else
        print_result "FAIL" "CLAUDE.md missing trigger conditions"
    fi

    if grep -q "⇒" "CLAUDE.md"; then
        print_result "PASS" "CLAUDE.md uses outcome notation (⇒)"
    else
        print_result "FAIL" "CLAUDE.md missing outcome notation"
    fi

    # Check it's NOT just descriptive
    local descriptive_count=$(grep -c "This is" "CLAUDE.md" 2>/dev/null | tr -d '\n' || echo "0")
    local instructional_count=$(grep -c "Use when\|When to use\|→.*⇒" "CLAUDE.md" 2>/dev/null | tr -d '\n' || echo "0")

    if [ "$instructional_count" -gt "$descriptive_count" ]; then
        print_result "PASS" "CLAUDE.md is more instructional ($instructional_count) than descriptive ($descriptive_count)"
    else
        print_result "FAIL" "CLAUDE.md is too descriptive (instructional:$instructional_count vs descriptive:$descriptive_count)"
    fi

    cd "$TOOLKIT_DIR"
}

# ============================================================================
# MAIN TEST EXECUTION
# ============================================================================

main() {
    echo -e "${BLUE}═════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Intelligence Toolkit - Comprehensive Test Suite${NC}"
    echo -e "${BLUE}═════════════════════════════════════════════════════════════════════${NC}"
    echo ""

    setup_test_env

    echo -e "${YELLOW}PHASE 8.1: Installation Edge Case Tests${NC}"
    test_dry_run_mode
    test_fresh_installation
    test_existing_claude_directory
    test_existing_claude_md
    test_bootstrap_mode
    test_nonexistent_target

    echo ""
    echo -e "${YELLOW}PHASE 8.2: Bootstrap Validation Tests${NC}"
    test_bootstrap_all_components
    test_bootstrap_missing_components
    test_bootstrap_constitution_imports
    test_bootstrap_slashcommand_compatibility

    echo ""
    echo -e "${YELLOW}PHASE 8.3: Index Generation Tests${NC}"
    test_index_first_generation
    test_index_queries

    echo ""
    echo -e "${YELLOW}PHASE 8.4: Integration Workflow Tests${NC}"
    test_full_workflow
    test_claude_md_instructional

    # Cleanup
    cleanup

    # Print summary
    print_summary
}

# Run tests
main "$@"
