#!/usr/bin/env bash
# Session Start Hook
# Purpose: Auto-detect feature, validate artifacts, report workflow state
# Replaces: common.sh + check-prerequisites.sh + setup-plan.sh

set -e

# Detect current feature (git branch or SPECIFY_FEATURE env var)
FEATURE=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "${SPECIFY_FEATURE:-}")

# Only process if on a feature branch (starts with ###- pattern)
if [[ ! "$FEATURE" =~ ^[0-9]{3}- ]]; then
    # Not on a feature branch, exit silently
    exit 0
fi

# Define feature directory
FEATURE_DIR="specs/$FEATURE"

# Check artifact existence
SPEC_EXISTS=$([ -f "$FEATURE_DIR/spec.md" ] && echo "true" || echo "false")
PLAN_EXISTS=$([ -f "$FEATURE_DIR/plan.md" ] && echo "true" || echo "false")
TASKS_EXISTS=$([ -f "$FEATURE_DIR/tasks.md" ] && echo "true" || echo "false")

# Determine workflow state
if [ "$SPEC_EXISTS" = "false" ]; then
    STATE="needs_spec"
elif [ "$PLAN_EXISTS" = "false" ]; then
    STATE="needs_plan"
elif [ "$TASKS_EXISTS" = "false" ]; then
    STATE="needs_tasks"
else
    STATE="ready"
fi

# Output JSON for Claude to consume
cat << EOF
{
  "feature": "$FEATURE",
  "directory": "$FEATURE_DIR",
  "artifacts": {
    "spec": {
      "exists": $SPEC_EXISTS,
      "path": "$FEATURE_DIR/spec.md"
    },
    "plan": {
      "exists": $PLAN_EXISTS,
      "path": "$FEATURE_DIR/plan.md"
    },
    "tasks": {
      "exists": $TASKS_EXISTS,
      "path": "$FEATURE_DIR/tasks.md"
    }
  },
  "workflow_state": "$STATE",
  "next_action": "$(
    case "$STATE" in
      needs_spec) echo "Create specification with specify-feature skill" ;;
      needs_plan) echo "Create implementation plan with create-implementation-plan skill" ;;
      needs_tasks) echo "Generate tasks with generate-tasks skill" ;;
      ready) echo "Begin implementation with implement-and-verify skill" ;;
    esac
  )"
}
EOF

exit 0
