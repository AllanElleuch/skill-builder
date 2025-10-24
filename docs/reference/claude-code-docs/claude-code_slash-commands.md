# Claude Code: Slash Commands Reference

**Complete guide to built-in, custom, and MCP slash commands**

📖 **Official Documentation:** https://docs.anthropic.com/en/docs/claude-code/slash-commands

---

## Table of Contents

1. [Built-in Slash Commands](#built-in-slash-commands)
2. [Custom Slash Commands](#custom-slash-commands)
3. [MCP Slash Commands](#mcp-slash-commands)
4. [SlashCommand Tool](#slashcommand-tool)

---

## Built-in Slash Commands

| Command | Purpose |
|---------|---------|
| `/add-dir` | Add additional working directories |
| `/agents` | Manage custom AI subagents for specialized tasks |
| `/bug` | Report bugs (sends conversation to Anthropic) |
| `/clear` | Clear conversation history |
| `/compact [instructions]` | Compact conversation with optional focus instructions |
| `/config` | Open the Settings interface (Config tab) |
| `/cost` | Show token usage statistics |
| `/doctor` | Check health of Claude Code installation |
| `/help` | Get usage help |
| `/init` | Initialize project with CLAUDE.md guide |
| `/login` | Switch Anthropic accounts |
| `/logout` | Sign out from your Anthropic account |
| `/mcp` | Manage MCP server connections and OAuth authentication |
| `/memory` | Edit CLAUDE.md memory files |
| `/model` | Select or change the AI model |
| `/permissions` | View or update permissions |
| `/pr_comments` | View pull request comments |
| `/review` | Request code review |
| `/rewind` | Rewind the conversation and/or code |
| `/status` | Open Settings interface (Status tab) showing version, model, account, connectivity |
| `/terminal-setup` | Install Shift+Enter key binding for newlines (iTerm2 and VSCode only) |
| `/usage` | Show plan usage limits and rate limit status (subscription plans only) |
| `/vim` | Enter vim mode for alternating insert and command modes |

---

## Custom Slash Commands

Custom slash commands allow you to define frequently-used prompts as Markdown files that Claude Code can execute.

### Syntax

```
/<command-name> [arguments]
```

### Command Types

#### Project Commands

Commands stored in your repository and shared with your team. Show "(project)" in `/help`.

**Location**: `.claude/commands/`

**Example**:
```bash
# Create a project command
mkdir -p .claude/commands
echo "Analyze this code for performance issues and suggest optimizations:" > .claude/commands/optimize.md
```

**Usage**:
```bash
> /optimize
```

#### Personal Commands

Commands available across all your projects. Show "(user)" in `/help`.

**Location**: `~/.claude/commands/`

**Example**:
```bash
# Create a personal command
mkdir -p ~/.claude/commands
echo "Review this code for security vulnerabilities:" > ~/.claude/commands/security-review.md
```

**Usage**:
```bash
> /security-review
```

### Features

#### Namespacing

Organize commands in subdirectories. Subdirectories appear in the command description but don't affect the command name.

**Example**:
- `.claude/commands/frontend/component.md` creates `/component` with description showing "(project:frontend)"
- `~/.claude/commands/component.md` creates `/component` with description showing "(user)"

**Note**: Conflicts between user and project level commands are not supported. Multiple commands with the same base file name can coexist at different levels.

#### Arguments

Pass dynamic values to commands using argument placeholders:

##### All Arguments with `$ARGUMENTS`

Captures all arguments passed to the command:

```bash
# Command definition
echo 'Fix issue #$ARGUMENTS following our coding standards' > .claude/commands/fix-issue.md

# Usage
> /fix-issue 123 high-priority
# $ARGUMENTS becomes: "123 high-priority"
```

##### Individual Arguments with `$1`, `$2`, etc.

Access specific arguments individually (like shell scripts):

```bash
# Command definition  
echo 'Review PR #$1 with priority $2 and assign to $3' > .claude/commands/review-pr.md

# Usage
> /review-pr 456 high alice
# $1 = "456", $2 = "high", $3 = "alice"
```

**Use positional arguments when you need to**:
- Access arguments individually in different parts of your command
- Provide defaults for missing arguments
- Build more structured commands with specific parameter roles

#### Bash Command Execution

Execute bash commands before the slash command runs using the `!` prefix. Output is included in the command context.

**Requirements**: Must include `allowed-tools` with the `Bash` tool.

**Example**:
```markdown
---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes, create a single git commit.
```

#### File References

Include file contents using the `@` prefix:

```markdown
# Reference a specific file
Review the implementation in @src/utils/helpers.js

# Reference multiple files
Compare @src/old-version.js with @src/new-version.js
```

#### Thinking Mode

Slash commands can trigger extended thinking by including extended thinking keywords:

```bash
> /analyze  # If the command includes "think deeply" or similar
```

### Frontmatter

Command files support frontmatter for metadata:

| Frontmatter | Purpose | Default |
|-------------|---------|---------|
| `allowed-tools` | List of tools the command can use | Inherits from conversation |
| `argument-hint` | Arguments expected for the slash command | None |
| `description` | Brief description of the command | First line from prompt |
| `model` | Specific model string | Inherits from conversation |
| `disable-model-invocation` | Prevent `SlashCommand` tool from calling this command | false |

**Example**:
```markdown
---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
argument-hint: [message]
description: Create a git commit
model: claude-3-5-haiku-20241022
---

Create a git commit with message: $ARGUMENTS
```

**Example with positional arguments**:
```markdown
---
argument-hint: [pr-number] [priority] [assignee]
description: Review pull request
---

Review PR #$1 with priority $2 and assign to $3.
Focus on security, performance, and code style.
```

---

## MCP Slash Commands

MCP servers can expose prompts as slash commands that become available in Claude Code.

### Command Format

MCP commands follow the pattern:

```
/mcp__<server-name>__<prompt-name> [arguments]
```

### Features

#### Dynamic Discovery

MCP commands are automatically available when:
- An MCP server is connected and active
- The server exposes prompts through the MCP protocol
- The prompts are successfully retrieved during connection

#### Arguments

MCP prompts can accept arguments defined by the server:

```bash
# Without arguments
> /mcp__github__list_prs

# With arguments
> /mcp__github__pr_review 456
> /mcp__jira__create_issue "Bug title" high
```

#### Naming Conventions

- Server and prompt names are normalized
- Spaces and special characters become underscores
- Names are lowercased for consistency

### Managing MCP Connections

Use the `/mcp` command to:
- View all configured MCP servers
- Check connection status
- Authenticate with OAuth-enabled servers
- Clear authentication tokens
- View available tools and prompts from each server

### MCP Permissions and Wildcards

When configuring permissions for MCP tools, note that **wildcards are not supported**:

- ✅ **Correct**: `mcp__github` (approves ALL tools from the github server)
- ✅ **Correct**: `mcp__github__get_issue` (approves specific tool)
- ❌ **Incorrect**: `mcp__github__*` (wildcards not supported)

To approve all tools from an MCP server, use just the server name: `mcp__servername`. To approve specific tools only, list each tool individually.

---

## SlashCommand Tool

The `SlashCommand` tool allows Claude to execute custom slash commands programmatically during a conversation.

### Encouraging Claude to Use SlashCommand

Your instructions (prompts, CLAUDE.md, etc.) generally need to reference the command by name with its slash:

**Example**:
```bash
> Run /write-unit-test when you are about to start writing tests.
```

### SlashCommand Tool Supported Commands

`SlashCommand` tool only supports custom slash commands that:
- Are user-defined (built-in commands like `/compact` are NOT supported)
- Have the `description` frontmatter field populated
- Don't have `disable-model-invocation: true` in frontmatter

For Claude Code versions >= 1.0.124, you can see which custom slash commands `SlashCommand` tool can invoke by running `claude --debug`.

### Disable SlashCommand Tool

To prevent Claude from executing any slash commands via the tool:

```bash
/permissions
# Add to deny rules: SlashCommand
```

This removes SlashCommand tool and slash command descriptions from context.

### Disable Specific Commands

To prevent a specific slash command from being available, add to frontmatter:

```markdown
---
disable-model-invocation: true
---
```

This removes the command's metadata from context.

### SlashCommand Permission Rules

Permission rules support:
- **Exact match**: `SlashCommand:/commit` (allows only `/commit` with no arguments)
- **Prefix match**: `SlashCommand:/review-pr:*` (allows `/review-pr` with any arguments)

### Character Budget Limit

The `SlashCommand` tool includes a character budget to limit the size of command descriptions shown to Claude.

- **Default limit**: 15,000 characters
- **Custom limit**: Set via `SLASH_COMMAND_TOOL_CHAR_BUDGET` environment variable

When the budget is exceeded, Claude sees only a subset of available commands. In `/context`, a warning shows "M of N commands".

---

## Command Examples

### Example 1: Fix Issue Command

```markdown
---
argument-hint: [issue-number]
description: Fix a GitHub issue following our coding standards
---

Fix issue #$ARGUMENTS:

1. Read the issue description from GitHub
2. Understand the requirements
3. Implement the fix following our code standards
4. Write or update tests
5. Create a commit with descriptive message
```

**Usage**:
```bash
> /fix-issue 123
```

### Example 2: Review PR Command

```markdown
---
argument-hint: [pr-number] [priority] [assignee]
description: Review pull request with specific priority and assignment
---

Review PR #$1:

- Priority level: $2
- Assign to: $3

Focus areas:
1. Security vulnerabilities
2. Code quality and maintainability
3. Test coverage
4. Performance implications
5. Documentation updates
```

**Usage**:
```bash
> /review-pr 456 high alice
```

### Example 3: Git Commit Command with Context

```markdown
---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a well-formatted git commit
---

## Current State

- Status: !`git status`
- Diff: !`git diff HEAD`
- Branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -5`

## Task

Create a commit with a clear, descriptive message following conventional commit format.
```

**Usage**:
```bash
> /commit
```

### Example 4: API Documentation Command

```markdown
---
argument-hint: [endpoint-path]
description: Generate OpenAPI documentation for an API endpoint
---

Generate OpenAPI 3.0 documentation for endpoint: $ARGUMENTS

Include:
- Path and HTTP methods
- Request/response schemas
- Example requests/responses
- Error responses
- Authentication requirements
```

**Usage**:
```bash
> /api-docs /api/users/{id}
```

### Example 5: Multi-file Analysis

```markdown
---
description: Compare implementations between two files
argument-hint: [file1] [file2]
---

Compare the implementations in:
- File 1: @$1
- File 2: @$2

Analyze:
1. Differences in approach
2. Which is more maintainable
3. Performance considerations
4. Recommendations for consolidation
```

**Usage**:
```bash
> /compare-files src/old-auth.ts src/new-auth.ts
```

---

## Best Practices

### 1. Descriptive Names

Use clear, descriptive command names:

**Good**:
- `/fix-issue`
- `/review-pr`
- `/api-docs`

**Bad**:
- `/fix`
- `/do`
- `/cmd1`

### 2. Include Argument Hints

Always include `argument-hint` in frontmatter:

```markdown
---
argument-hint: [issue-number] [priority]
---
```

### 3. Document Commands

Use the `description` field to clearly explain what the command does:

```markdown
---
description: Fix a GitHub issue following coding standards and create a PR
---
```

### 4. Use File References

Include relevant files using `@` to provide context:

```markdown
Review the authentication logic in @src/auth/index.ts and @src/auth/middleware.ts
```

### 5. Version Control Project Commands

Check project commands into git for team sharing:

```bash
git add .claude/commands/
git commit -m "Add custom slash commands"
```

---

## Related Documentation

- **[Subagents Guide](claude-code_subagents.md)** - Specialized AI assistants
- **[Hooks Guide](claude-code_hooks.md)** - Workflow automation
- **[Configuration Guide](claude-code_configuration.md)** - Settings and configuration
- **[MCP Integration](claude-code_mcp-integration.md)** - Model Context Protocol

---

*Part of the Claude Code Documentation Series. See [claude-code_manifest.md](claude-code_manifest.md) for all available guides.*
