#!/usr/bin/env bash
# PreToolUse Workflow Validation Hook
# Purpose: Block invalid workflow operations (e.g., plan without spec)
# Replaces: check-prerequisites.sh validation logic

set -e

# Read JSON input from stdin
INPUT=$(cat)

# Extract tool name and file path
TOOL=$(echo "$INPUT" | jq -r '.tool_name')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only validate Write operations on spec/plan/tasks files
if [[ "$TOOL" != "Write" ]]; then
    exit 0
fi

# Skip if not a spec-related file
if [[ ! "$FILE_PATH" =~ specs/[0-9]{3}- ]]; then
    exit 0
fi

# Extract feature directory
FEATURE_DIR=$(dirname "$FILE_PATH")

# Validation 1: Cannot create plan.md without spec.md
if [[ "$FILE_PATH" == *"/plan.md" ]]; then
    if [[ ! -f "$FEATURE_DIR/spec.md" ]]; then
        cat >&2 << EOF
{
  "feedback": "Cannot create plan without specification. Article IV: Specification-First Development requires spec.md to exist before plan.md.\n\nNext action: Create specification first using specify-feature skill or /feature command."
}
EOF
        exit 2
    fi
fi

# Validation 2: Cannot create tasks.md without plan.md
if [[ "$FILE_PATH" == *"/tasks.md" ]]; then
    if [[ ! -f "$FEATURE_DIR/plan.md" ]]; then
        cat >&2 << EOF
{
  "feedback": "Cannot create tasks without implementation plan. Article IV: Specification-First Development requires plan.md to exist before tasks.md.\n\nNext action: Create implementation plan first using create-implementation-plan skill or /plan command."
}
EOF
        exit 2
    fi
fi

# All validations passed
exit 0
