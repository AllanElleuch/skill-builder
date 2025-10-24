# Claude Code: Configuration Guide

**Complete reference for settings, memory management, and environment configuration**

📖 **Official Documentation:** https://docs.anthropic.com/en/docs/claude-code/settings

---

## Table of Contents

1. [Overview](#overview)
2. [Settings Files](#settings-files)
3. [Available Settings](#available-settings)
4. [Permission Settings](#permission-settings)
5. [Memory Management (CLAUDE.md)](#memory-management-claudemd)
6. [Environment Variables](#environment-variables)
7. [Subagent Configuration](#subagent-configuration)
8. [Settings Precedence](#settings-precedence)
9. [Configuration Examples](#configuration-examples)

---

## Overview

Claude Code offers hierarchical configuration through settings files, memory files, and environment variables. This guide explains how to customize Claude Code for your workflow and team.

### Configuration System Components

| Component | Purpose | Location |
|-----------|---------|----------|
| **Settings files** | Configure permissions, tools, environment | `settings.json` |
| **Memory files** | Instructions and context for Claude | `CLAUDE.md` |
| **Slash commands** | Reusable prompts | `.claude/commands/` |
| **Subagents** | Specialized AI assistants | `.claude/agents/` |
| **MCP servers** | External tool integrations | `.mcp.json` |

---

## Settings Files

Settings are configured through `settings.json` files in a hierarchical structure:

### Settings File Locations

| Type | Location | Purpose | Shared With |
|------|----------|---------|-------------|
| **Enterprise Policy** | macOS: `/Library/Application Support/ClaudeCode/managed-settings.json`<br>Linux/WSL: `/etc/claude-code/managed-settings.json`<br>Windows: `C:\ProgramData\ClaudeCode\managed-settings.json` | Organization-wide policies (highest priority) | All users in organization |
| **Project Settings** | `.claude/settings.json` | Team-shared project configuration | Team (via source control) |
| **Project Local** | `.claude/settings.local.json` | Personal project preferences (git-ignored) | Just you (current project) |
| **User Settings** | `~/.claude/settings.json` | Personal global configuration | Just you (all projects) |

### Example Settings File

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run test:*)",
      "Read(~/.zshrc)"
    ],
    "deny": [
      "Bash(curl:*)",
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)"
    ]
  },
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp"
  }
}
```

---

## Available Settings

### Core Settings

| Key | Description | Example |
|-----|-------------|---------|
| `apiKeyHelper` | Custom script to generate auth value | `/bin/generate_temp_api_key.sh` |
| `cleanupPeriodDays` | Transcript retention period (default: 30 days) | `20` |
| `env` | Environment variables for every session | `{"FOO": "bar"}` |
| `includeCoAuthoredBy` | Include Claude co-author byline in commits (default: true) | `false` |
| `permissions` | Permission rules for tools and files | See [Permission Settings](#permission-settings) |
| `hooks` | Custom commands for tool executions | See [Hooks Guide](claude-code_hooks.md) |
| `disableAllHooks` | Disable all hooks | `true` |
| `model` | Override default model | `"claude-sonnet-4-5-20250929"` |
| `statusLine` | Custom status line configuration | `{"type": "command", "command": "~/.claude/statusline.sh"}` |
| `outputStyle` | System prompt adjustment | `"Explanatory"` |
| `forceLoginMethod` | Restrict login method (`claudeai` or `console`) | `"claudeai"` |
| `forceLoginOrgUUID` | Auto-select organization during login | `"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"` |

### MCP Configuration Settings

| Key | Description | Example |
|-----|-------------|---------|
| `enableAllProjectMcpServers` | Auto-approve all project MCP servers | `true` |
| `enabledMcpjsonServers` | Specific MCP servers to approve | `["memory", "github"]` |
| `disabledMcpjsonServers` | Specific MCP servers to reject | `["filesystem"]` |
| `useEnterpriseMcpConfigOnly` | Restrict to enterprise MCP only | `true` |

### AWS/Cloud Configuration

| Key | Description | Example |
|-----|-------------|---------|
| `awsAuthRefresh` | AWS credential refresh script | `"aws sso login --profile myprofile"` |
| `awsCredentialExport` | AWS credential export script | `"/bin/generate_aws_grant.sh"` |

---

## Permission Settings

Control what Claude Code can access and modify.

### Permission Configuration Keys

| Key | Description | Example |
|-----|-------------|---------|
| `allow` | Tools/files to allow without prompting | `["Bash(git diff:*)"]` |
| `ask` | Tools/files requiring confirmation | `["Bash(git push:*)"]` |
| `deny` | Tools/files to completely block | `["WebFetch", "Read(./.env)"]` |
| `additionalDirectories` | Extra working directories | `["../docs/"]` |
| `defaultMode` | Default permission mode | `"acceptEdits"` |
| `disableBypassPermissionsMode` | Prevent bypass mode | `"disable"` |

### Permission Modes

| Mode | Description | Access Level |
|------|-------------|-------------|
| **Normal** | Ask before each operation | Standard approval flow |
| **Accept Edits** | Auto-approve file edits, ask for commands | Edits approved, commands require approval |
| **Plan** | Read-only, no modifications | Research and planning only |
| **Bypass Permissions** | Auto-approve all operations | ⚠️ Use with caution |

### Permission Examples

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run test:*)",
      "Bash(git status)",
      "Bash(git diff:*)",
      "Read"
    ],
    "ask": [
      "Bash(git push:*)",
      "Bash(git commit:*)"
    ],
    "deny": [
      "Bash(curl:*)",
      "Bash(rm:*)",
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(./build/**)",
      "Write(./.env*)"
    ],
    "additionalDirectories": [
      "../shared-lib",
      "../documentation"
    ],
    "defaultMode": "acceptEdits"
  }
}
```

### Excluding Sensitive Files

To prevent Claude Code from accessing sensitive files:

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(./config/credentials.json)",
      "Write(./.env*)",
      "Write(./secrets/**)"
    ]
  }
}
```

---

## Memory Management (CLAUDE.md)

CLAUDE.md files provide instructions and context to Claude across sessions.

### Memory File Locations

| Type | Location | Purpose | Shared With |
|------|----------|---------|-------------|
| **Enterprise Policy** | macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`<br>Linux: `/etc/claude-code/CLAUDE.md`<br>Windows: `C:\ProgramData\ClaudeCode\CLAUDE.md` | Organization-wide instructions | All users |
| **Project Memory** | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team-shared instructions | Team (via git) |
| **User Memory** | `~/.claude/CLAUDE.md` | Personal preferences across projects | Just you |
| **Project Local** | `./CLAUDE.local.md` | *(Deprecated)* Use imports instead | Just you (current project) |

### Memory File Lookup

Claude Code reads memories recursively:
1. Starts in current working directory
2. Recurses up to (but not including) root directory `/`
3. Reads any `CLAUDE.md` or `CLAUDE.local.md` files found
4. Also discovers `CLAUDE.md` in subdirectories (loaded when files in those directories are read)

### CLAUDE.md Imports

Import additional files using `@path/to/import` syntax:

```markdown
See @README for project overview and @package.json for available npm commands.

# Additional Instructions
- Git workflow @docs/git-instructions.md

# Individual Preferences
- @~/.claude/my-project-instructions.md
```

**Features:**
- Relative and absolute paths supported
- Imports not evaluated in code blocks/spans
- Recursive imports up to 5 hops
- View loaded memories with `/memory` command

### Quick Memory Management

**Add memories quickly with `#` shortcut:**

```bash
# Always use descriptive variable names
# You'll be prompted to select which memory file
```

**Edit memories with `/memory` command:**

```bash
> /memory
# Opens memory file in system editor
```

**Initialize project memory:**

```bash
> /init
# Creates CLAUDE.md with project context
```

### Memory Best Practices

1. **Be Specific**: "Use 2-space indentation" > "Format code properly"
2. **Use Structure**: Format as bullet points, group under headings
3. **Review Periodically**: Update as project evolves

### Example CLAUDE.md

```markdown
# Project Overview
This is a Next.js e-commerce application using TypeScript and Tailwind CSS.

# Coding Standards
- Use TypeScript for all new code
- Follow Airbnb style guide
- Use functional components with hooks
- Write tests for all business logic

# Common Commands
- `npm run dev` - Start development server
- `npm test` - Run test suite
- `npm run build` - Production build
- `npm run lint` - Run ESLint

# Architecture Notes
- API routes in `pages/api/`
- Components in `components/`, organized by feature
- Database queries use Prisma ORM
- Authentication via NextAuth.js

# Preferences
- Prefer async/await over promises
- Use named exports over default exports
- Keep components under 200 lines
```

---

## Environment Variables

### Common Environment Variables

| Variable | Purpose |
|----------|---------|
| `ANTHROPIC_API_KEY` | API key for authentication |
| `ANTHROPIC_AUTH_TOKEN` | Custom Authorization header value |
| `ANTHROPIC_CUSTOM_HEADERS` | Custom headers in `Name: Value` format |
| `ANTHROPIC_MODEL` | Model to use |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | Max output tokens for requests |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Model for subagents |
| `CLAUDE_CODE_USE_BEDROCK` | Use AWS Bedrock |
| `CLAUDE_CODE_USE_VERTEX` | Use Google Vertex AI |
| `MAX_THINKING_TOKENS` | Enable extended thinking |
| `BASH_DEFAULT_TIMEOUT_MS` | Default bash timeout |
| `BASH_MAX_TIMEOUT_MS` | Maximum bash timeout |
| `DISABLE_TELEMETRY` | Opt out of telemetry |
| `DISABLE_ERROR_REPORTING` | Opt out of error reporting |
| `DISABLE_AUTOUPDATER` | Disable auto-updates |
| `HTTP_PROXY` | HTTP proxy server |
| `HTTPS_PROXY` | HTTPS proxy server |

### Setting Environment Variables

**Via settings.json:**

```json
{
  "env": {
    "CLAUDE_CODE_MAX_OUTPUT_TOKENS": "8192",
    "MAX_THINKING_TOKENS": "10000",
    "DISABLE_TELEMETRY": "1"
  }
}
```

**Via shell:**

```bash
export MAX_THINKING_TOKENS=10000
claude
```

**For single session:**

```bash
MAX_THINKING_TOKENS=10000 claude
```

---

## Subagent Configuration

Subagents are configured as Markdown files with YAML frontmatter.

### Subagent Locations

| Type | Location | Scope |
|------|----------|-------|
| **Project Subagents** | `.claude/agents/` | Project-specific, shared via git |
| **User Subagents** | `~/.claude/agents/` | Personal, across all projects |

### Subagent File Format

```markdown
---
name: code-reviewer
description: Expert code reviewer. Use proactively after code changes.
tools: Read, Grep, Glob, Bash
model: sonnet
---

You are a senior code reviewer focusing on code quality, security, and best practices.

When invoked:
1. Run git diff to see recent changes
2. Review modified files
3. Provide feedback

Review checklist:
- Code is readable and maintainable
- No security vulnerabilities
- Proper error handling
- Good test coverage
```

See **[Subagents Guide](claude-code_subagents.md)** for detailed information.

---

## Settings Precedence

Settings are applied in order (highest to lowest priority):

1. **Enterprise Managed Policies** (highest)
   - Deployed by IT/DevOps
   - Cannot be overridden
   - Example: `/etc/claude-code/managed-settings.json`

2. **Command Line Arguments**
   - Temporary overrides for specific session
   - Example: `claude --model opus`

3. **Local Project Settings**
   - Personal project-specific settings
   - Example: `.claude/settings.local.json`

4. **Shared Project Settings**
   - Team-shared project settings
   - Example: `.claude/settings.json`

5. **User Settings** (lowest)
   - Personal global settings
   - Example: `~/.claude/settings.json`

### Configuration Merging

- Settings are **merged**, not replaced
- More specific settings add to or override broader ones
- Arrays are typically **replaced** (not merged)
- Enterprise policies always take precedence

---

## Configuration Examples

### Example 1: Secure Project Configuration

```json
// .claude/settings.json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(./config/prod-*)",
      "Bash(curl:*)",
      "Bash(wget:*)",
      "WebFetch"
    ],
    "allow": [
      "Bash(npm run test:*)",
      "Bash(git status)",
      "Bash(git diff:*)",
      "Read"
    ],
    "defaultMode": "acceptEdits"
  }
}
```

### Example 2: Development Environment Setup

```json
// ~/.claude/settings.json
{
  "env": {
    "CLAUDE_CODE_MAX_OUTPUT_TOKENS": "8192",
    "MAX_THINKING_TOKENS": "10000",
    "BASH_DEFAULT_TIMEOUT_MS": "300000"
  },
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(yarn:*)",
      "Bash(git status)",
      "Bash(git diff:*)",
      "Bash(git log:*)"
    ]
  }
}
```

### Example 3: Team Configuration

```json
// .claude/settings.json (checked into git)
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run test:*)",
      "Bash(git status)",
      "Read"
    ],
    "deny": [
      "Read(./.env*)",
      "Read(./secrets/**)"
    ]
  },
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
  },
  "includeCoAuthoredBy": true
}
```

### Example 4: Enterprise Policy

```json
// /etc/claude-code/managed-settings.json
{
  "permissions": {
    "deny": [
      "WebFetch",
      "Bash(curl:*)",
      "Bash(wget:*)",
      "Read(/etc/**)",
      "Read(~/.ssh/**)"
    ],
    "disableBypassPermissionsMode": "disable"
  },
  "forceLoginMethod": "console",
  "forceLoginOrgUUID": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "useEnterpriseMcpConfigOnly": true
}
```

---

## Related Guides

- **[Getting Started](claude-code_getting-started.md)** - Installation and basics
- **[Workflows Guide](claude-code_workflows.md)** - Common development workflows
- **[Hooks Guide](claude-code_hooks.md)** - Automate with hooks
- **[Subagents Guide](claude-code_subagents.md)** - Specialized AI assistants
- **[Security & Permissions](claude-code_security-permissions.md)** - Security details
- **[Slash Commands](claude-code_slash-commands.md)** - Command reference

---

*Part of the Claude Code Documentation Series. See [claude-code_manifest.md](claude-code_manifest.md) for all available guides.*
