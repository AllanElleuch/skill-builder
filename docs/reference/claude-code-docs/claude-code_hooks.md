# Claude Code: Hooks Reference Guide

**Complete guide to automating workflows with Claude Code hooks**

📖 **Official Documentation:** https://docs.anthropic.com/en/docs/claude-code/hooks

---

## Table of Contents

1. [Overview](#overview)
2. [Configuration](#configuration)
3. [Hook Events](#hook-events)
4. [Hook Input](#hook-input)
5. [Hook Output](#hook-output)
6. [Working with MCP Tools](#working-with-mcp-tools)
7. [Security Considerations](#security-considerations)
8. [Debugging Hooks](#debugging-hooks)
9. [Practical Examples](#practical-examples)

---

## Overview

Claude Code hooks are shell commands that execute automatically in response to events like tool calls. They enable workflow automation, validation, and enforcement of coding standards.

### What Hooks Can Do

- **Validate inputs** before tool execution
- **Provide feedback** after operations complete
- **Enforce standards** (linting, formatting)
- **Block operations** based on custom logic
- **Add context** to conversations
- **Trigger notifications** for important events

### Hook Types

| Hook Event | When It Runs | Common Use Cases |
|------------|-------------|------------------|
| `PreToolUse` | Before tool executes | Validation, permission control |
| `PostToolUse` | After tool completes | Formatting, verification |
| `UserPromptSubmit` | When user submits prompt | Add context, validate requests |
| `Notification` | When notifications sent | Custom alerts, logging |
| `Stop` | When agent finishes | Continuation logic, cleanup |
| `SubagentStop` | When subagent finishes | Subagent-specific logic |
| `PreCompact` | Before compacting context | Custom compaction logic |
| `SessionStart` | When session starts/resumes | Load development context |
| `SessionEnd` | When session ends | Cleanup, logging |

---

## Configuration

### Configuration Structure

Hooks are configured in settings files (`~/.claude/settings.json`, `.claude/settings.json`, etc.):

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "ToolPattern",
        "hooks": [
          {
            "type": "command",
            "command": "your-command-here",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

### Configuration Fields

| Field | Description | Example |
|-------|-------------|---------|
| `matcher` | Pattern to match tool names (case-sensitive) | `"Write"`, `"Edit\|Write"`, `"*"` |
| `hooks` | Array of commands to execute | Array of hook objects |
| `type` | Currently only `"command"` supported | `"command"` |
| `command` | Bash command to execute | `"npm run lint"` |
| `timeout` | Optional timeout in seconds | `60` |

### Matcher Patterns

- **Exact match**: `"Write"` matches only the Write tool
- **Regex**: `"Edit|Write"` or `"Notebook.*"`
- **Wildcard**: `"*"` matches all tools (or empty string `""`)

### Project-Specific Hook Scripts

Use `CLAUDE_PROJECT_DIR` environment variable for project-relative paths:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/check-style.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Hook Events

### PreToolUse

Runs after Claude creates tool parameters but before processing the tool call.

**Common Matchers:**
- `Task` - Subagent tasks
- `Bash` - Shell commands
- `Glob` - File pattern matching
- `Grep` - Content search
- `Read` - File reading
- `Edit`, `MultiEdit` - File editing
- `Write` - File writing
- `WebFetch`, `WebSearch` - Web operations

**Example:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/validate-bash.py"
          }
        ]
      }
    ]
  }
}
```

### PostToolUse

Runs immediately after a tool completes successfully.

**Example:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npm run lint --fix"
          }
        ]
      }
    ]
  }
}
```

### UserPromptSubmit

Runs when the user submits a prompt, before Claude processes it.

**Use Cases:**
- Add additional context based on prompt
- Validate prompts
- Block certain types of prompts

**Example:**
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/add-context.py"
          }
        ]
      }
    ]
  }
}
```

### Notification

Runs when Claude Code sends notifications.

**Notifications Occur When:**
1. Claude needs permission to use a tool
2. Prompt input idle for at least 60 seconds

**Example:**
```json
{
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/notify.sh"
          }
        ]
      }
    ]
  }
}
```

### Stop

Runs when the main Claude Code agent finishes responding (not on user interrupt).

**Example:**
```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/check-completion.py"
          }
        ]
      }
    ]
  }
}
```

### SubagentStop

Runs when a Claude Code subagent (Task tool call) finishes responding.

**Example:**
```json
{
  "hooks": {
    "SubagentStop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/subagent-cleanup.sh"
          }
        ]
      }
    ]
  }
}
```

### PreCompact

Runs before Claude Code compacts conversation context.

**Matchers:**
- `manual` - Invoked from `/compact`
- `auto` - Invoked from auto-compact (full context window)

**Example:**
```json
{
  "hooks": {
    "PreCompact": [
      {
        "matcher": "manual",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/pre-compact.sh"
          }
        ]
      }
    ]
  }
}
```

### SessionStart

Runs when Claude Code starts a new session or resumes an existing one.

**Matchers:**
- `startup` - Invoked from startup
- `resume` - Invoked from `--resume`, `--continue`, or `/resume`
- `clear` - Invoked from `/clear`
- `compact` - Invoked from auto or manual compact

**Example:**
```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/load-context.sh"
          }
        ]
      }
    ]
  }
}
```

### SessionEnd

Runs when a Claude Code session ends.

**Reasons:**
- `clear` - Session cleared with `/clear`
- `logout` - User logged out
- `prompt_input_exit` - User exited while prompt input visible
- `other` - Other exit reasons

**Example:**
```json
{
  "hooks": {
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/session-cleanup.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Hook Input

Hooks receive JSON data via stdin containing session information and event-specific data.

### Common Fields

All hooks receive:

```json
{
  "session_id": "string",
  "transcript_path": "/path/to/conversation.jsonl",
  "cwd": "/current/working/directory",
  "hook_event_name": "EventName"
}
```

### PreToolUse Input

```json
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../session.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "PreToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file.txt",
    "content": "file content"
  }
}
```

### PostToolUse Input

```json
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../session.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "PostToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file.txt",
    "content": "file content"
  },
  "tool_response": {
    "filePath": "/path/to/file.txt",
    "success": true
  }
}
```

### UserPromptSubmit Input

```json
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../session.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "UserPromptSubmit",
  "prompt": "Write a function to calculate factorial"
}
```

### Stop/SubagentStop Input

```json
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../session.jsonl",
  "hook_event_name": "Stop",
  "stop_hook_active": true
}
```

### PreCompact Input

```json
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../session.jsonl",
  "hook_event_name": "PreCompact",
  "trigger": "manual",
  "custom_instructions": ""
}
```

### SessionStart Input

```json
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../session.jsonl",
  "hook_event_name": "SessionStart",
  "source": "startup"
}
```

### SessionEnd Input

```json
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../session.jsonl",
  "cwd": "/Users/...",
  "hook_event_name": "SessionEnd",
  "reason": "exit"
}
```

---

## Hook Output

Hooks communicate status through **exit codes** or **JSON output**.

### Simple: Exit Code

| Exit Code | Behavior | stdout | stderr |
|-----------|----------|--------|--------|
| `0` | Success | Shown to user in transcript mode (except UserPromptSubmit/SessionStart where added to context) | N/A |
| `2` | Blocking error | N/A | Fed back to Claude automatically |
| Other | Non-blocking error | N/A | Shown to user, execution continues |

**Exit Code 2 Behavior by Event:**

| Hook Event | Behavior |
|------------|----------|
| `PreToolUse` | Blocks tool call, shows stderr to Claude |
| `PostToolUse` | Shows stderr to Claude (tool already ran) |
| `Notification` | N/A, shows stderr to user only |
| `UserPromptSubmit` | Blocks prompt processing, erases prompt, shows stderr to user |
| `Stop` | Blocks stoppage, shows stderr to Claude |
| `SubagentStop` | Blocks stoppage, shows stderr to Claude subagent |
| `PreCompact` | N/A, shows stderr to user only |
| `SessionStart` | N/A, shows stderr to user only |
| `SessionEnd` | N/A, shows stderr to user only |

### Advanced: JSON Output

For sophisticated control, return structured JSON in stdout:

#### Common JSON Fields

```json
{
  "continue": true,  // Whether Claude should continue (default: true)
  "stopReason": "string",  // Message shown when continue is false
  "suppressOutput": true,  // Hide stdout from transcript (default: false)
  "systemMessage": "string"  // Optional warning message shown to user
}
```

#### PreToolUse Decision Control

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow" | "deny" | "ask",
    "permissionDecisionReason": "Explanation here"
  }
}
```

**Permission Decisions:**
- `"allow"` - Bypasses permission system (reason shown to user, not Claude)
- `"deny"` - Prevents tool execution (reason shown to Claude)
- `"ask"` - Asks user to confirm (reason shown to user, not Claude)

#### PostToolUse Decision Control

```json
{
  "decision": "block" | undefined,
  "reason": "Explanation for decision",
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Additional info for Claude"
  }
}
```

#### UserPromptSubmit Decision Control

```json
{
  "decision": "block" | undefined,
  "reason": "Explanation for decision",
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "Context to add if not blocked"
  }
}
```

#### Stop/SubagentStop Decision Control

```json
{
  "decision": "block" | undefined,
  "reason": "Required when blocking - tells Claude how to proceed"
}
```

#### SessionStart Decision Control

```json
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Context to load at session start"
  }
}
```

---

## Working with MCP Tools

MCP tools follow the pattern `mcp__<server>__<tool>`:

- `mcp__memory__create_entities`
- `mcp__filesystem__read_file`
- `mcp__github__search_repositories`

### Configure Hooks for MCP Tools

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "mcp__memory__.*",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Memory operation initiated' >> ~/mcp-operations.log"
          }
        ]
      },
      {
        "matcher": "mcp__.*__write.*",
        "hooks": [
          {
            "type": "command",
            "command": "/home/user/scripts/validate-mcp-write.py"
          }
        ]
      }
    ]
  }
}
```

---

## Security Considerations

### Disclaimer

**USE AT YOUR OWN RISK**: Claude Code hooks execute arbitrary shell commands automatically. You are solely responsible for the commands you configure.

### Security Best Practices

1. **Validate and sanitize inputs** - Never trust input data blindly
2. **Always quote shell variables** - Use `"$VAR"` not `$VAR`
3. **Block path traversal** - Check for `..` in file paths
4. **Use absolute paths** - Specify full paths for scripts
5. **Skip sensitive files** - Avoid `.env`, `.git/`, keys, etc.

### Configuration Safety

- Direct edits to hooks don't take effect immediately
- Claude Code captures hook snapshot at startup
- Warns if hooks modified externally
- Requires review in `/hooks` menu for changes to apply

This prevents malicious hook modifications from affecting your current session.

---

## Debugging Hooks

### Basic Troubleshooting

1. **Check configuration**: Run `/hooks` to see registered hooks
2. **Verify syntax**: Ensure JSON settings are valid
3. **Test commands**: Run hook commands manually first
4. **Check permissions**: Ensure scripts are executable
5. **Review logs**: Use `claude --debug` to see hook execution details

### Common Issues

- **Quotes not escaped**: Use `\"` inside JSON strings
- **Wrong matcher**: Check tool names match exactly (case-sensitive)
- **Command not found**: Use full paths for scripts

### Debug Output Example

Use `claude --debug` to see detailed hook execution:

```
[DEBUG] Executing hooks for PostToolUse:Write
[DEBUG] Getting matching hook commands for PostToolUse with query: Write
[DEBUG] Found 1 hook matchers in settings
[DEBUG] Matched 1 hooks for query "Write"
[DEBUG] Found 1 hook commands to execute
[DEBUG] Executing hook command: <Your command> with timeout 60000ms
[DEBUG] Hook command completed with status 0: <Your stdout>
```

---

## Practical Examples

### Example 1: Bash Command Validation

Validate bash commands before execution:

```python
#!/usr/bin/env python3
import json
import re
import sys

# Validation rules
VALIDATION_RULES = [
    (
        r"\bgrep\b(?!.*\|)",
        "Use 'rg' (ripgrep) instead of 'grep'"
    ),
    (
        r"\bfind\s+\S+\s+-name\b",
        "Use 'rg --files | rg pattern' instead of 'find -name'"
    ),
]

def validate_command(command: str) -> list[str]:
    issues = []
    for pattern, message in VALIDATION_RULES:
        if re.search(pattern, command):
            issues.append(message)
    return issues

try:
    input_data = json.load(sys.stdin)
except json.JSONDecodeError as e:
    print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
    sys.exit(1)

tool_name = input_data.get("tool_name", "")
tool_input = input_data.get("tool_input", {})
command = tool_input.get("command", "")

if tool_name != "Bash" or not command:
    sys.exit(0)

# Validate the command
issues = validate_command(command)

if issues:
    for message in issues:
        print(f"• {message}", file=sys.stderr)
    # Exit code 2 blocks tool call and shows stderr to Claude
    sys.exit(2)
```

**Configuration:**

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/validate-bash.py"
          }
        ]
      }
    ]
  }
}
```

### Example 2: Auto-Formatting After Edits

Automatically format code after file modifications:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npm run lint --fix"
          }
        ]
      }
    ]
  }
}
```

### Example 3: Add Context on Prompt Submit

Add current time and project status to context:

```python
#!/usr/bin/env python3
import json
import sys
import datetime

try:
    input_data = json.load(sys.stdin)
except json.JSONDecodeError as e:
    print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
    sys.exit(1)

prompt = input_data.get("prompt", "")

# Check for sensitive patterns
sensitive_patterns = [
    (r"(?i)\b(password|secret|key|token)\s*[:=]", "Potential secrets"),
]

for pattern, message in sensitive_patterns:
    if re.search(pattern, prompt):
        output = {
            "decision": "block",
            "reason": f"Security violation: {message}"
        }
        print(json.dumps(output))
        sys.exit(0)

# Add current time to context
context = f"Current time: {datetime.datetime.now()}"
print(context)
sys.exit(0)
```

**Configuration:**

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/add-context.py"
          }
        ]
      }
    ]
  }
}
```

### Example 4: Auto-Approve Documentation Files

Automatically approve reads of documentation files:

```python
#!/usr/bin/env python3
import json
import sys

try:
    input_data = json.load(sys.stdin)
except json.JSONDecodeError as e:
    print(f"Error: Invalid JSON: {e}", file=sys.stderr)
    sys.exit(1)

tool_name = input_data.get("tool_name", "")
tool_input = input_data.get("tool_input", {})

# Auto-approve documentation files
if tool_name == "Read":
    file_path = tool_input.get("file_path", "")
    if file_path.endswith((".md", ".mdx", ".txt", ".json")):
        output = {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "allow",
                "permissionDecisionReason": "Documentation file auto-approved"
            },
            "suppressOutput": True
        }
        print(json.dumps(output))
        sys.exit(0)

# Let normal permission flow proceed
sys.exit(0)
```

### Example 5: Load Development Context on Session Start

Load relevant issues and recent changes when starting a session:

```bash
#!/bin/bash

# Load GitHub issues
echo "## Recent GitHub Issues"
gh issue list --limit 5

# Show recent commits
echo ""
echo "## Recent Commits"
git log --oneline -10

# Show current branch and status
echo ""
echo "## Current Branch"
git branch --show-current
git status --short
```

**Configuration:**

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/load-dev-context.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Hook Execution Details

- **Timeout**: 60-second default, configurable per command
- **Parallelization**: All matching hooks run in parallel
- **Deduplication**: Identical commands deduplicated automatically
- **Environment**: Runs in current directory with Claude Code's environment
- **`CLAUDE_PROJECT_DIR`**: Available, contains absolute path to project root
- **Input**: JSON via stdin
- **Output**:
  - PreToolUse/PostToolUse/Stop/SubagentStop: Progress shown in transcript (Ctrl-R)
  - Notification/SessionEnd: Logged to debug only (`--debug`)
  - UserPromptSubmit/SessionStart: stdout added as context for Claude

---

## Related Guides

- **[Configuration Guide](claude-code_configuration.md)** - Settings and configuration
- **[Security & Permissions](claude-code_security-permissions.md)** - Security best practices
- **[Workflows Guide](claude-code_workflows.md)** - Common workflows
- **[Subagents Guide](claude-code_subagents.md)** - Specialized AI assistants

---

*Part of the Claude Code Documentation Series. See [claude-code_manifest.md](claude-code_manifest.md) for all available guides.*
