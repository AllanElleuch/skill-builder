# Claude Code: Getting Started Guide

**Complete guide to installing, configuring, and using Claude Code**

📖 **Official Documentation:** https://docs.anthropic.com/en/docs/claude-code

---

## Table of Contents

1. [Overview](#overview)
2. [What is Claude Code?](#what-is-claude-code)
3. [Why Use Claude Code?](#why-use-claude-code)
4. [Prerequisites](#prerequisites)
5. [Installation](#installation)
   - [NPM Installation](#npm-installation)
   - [Native Installation (Beta)](#native-installation-beta)
6. [Authentication](#authentication)
7. [Your First Session](#your-first-session)
8. [Essential Commands](#essential-commands)
9. [Quick Start Examples](#quick-start-examples)
10. [Pro Tips for Beginners](#pro-tips-for-beginners)
11. [Next Steps](#next-steps)

---

## Overview

Claude Code is Anthropic's official CLI tool for AI-powered software development. It brings Claude's capabilities directly to your terminal, allowing you to build features, debug code, navigate codebases, and automate development tasks—all through natural language conversation.

---

## What is Claude Code?

Claude Code is an **agentic coding tool** that lives in your terminal and helps you turn ideas into code faster than ever before. Unlike chat interfaces or IDE extensions, Claude Code:

- **Works in your terminal** - integrates seamlessly with your existing workflow
- **Takes action** - directly edits files, runs commands, and creates commits
- **Maintains context** - understands your entire project structure
- **Is composable** - follows Unix philosophy and works with pipes and scripts
- **Enterprise-ready** - includes security, privacy, and compliance features

### What Claude Code Does for You

- **Build features from descriptions**: Tell Claude what you want in plain English
- **Debug and fix issues**: Describe a bug or paste an error message
- **Navigate any codebase**: Ask questions about unfamiliar code
- **Automate tedious tasks**: Fix linting, resolve merge conflicts, write release notes
- **Work with external services**: Connect to tools via MCP (Model Context Protocol)

---

## Why Use Claude Code?

### Key Benefits

1. **Terminal-Native**: Not another chat window or IDE plugin - works where you work
2. **Direct Action**: Edits files, runs commands, creates commits without manual copying
3. **Unix Philosophy**: Composable and scriptable (`tail -f app.log | claude -p "alert me if errors"`)
4. **Context-Aware**: Understands your project structure automatically
5. **Extensible**: Connect to any tool via MCP (Jira, GitHub, databases, etc.)
6. **Enterprise Security**: Built-in security, privacy controls, and compliance

---

## Prerequisites

Before installing Claude Code, ensure you have:

- A terminal or command prompt
- One of these accounts:
  - **[Claude.ai](https://claude.ai)** account (recommended for most users)
  - **[Claude Console](https://console.anthropic.com/)** account (for API billing)
- For NPM installation: **[Node.js 18 or newer](https://nodejs.org/en/download/)**

> **Note:** You can have both account types under the same email address. Use `/login` within Claude Code to switch accounts.

---

## Installation

### NPM Installation

If you have Node.js 18+ installed:

```bash
npm install -g @anthropic-ai/claude-code
```

**Verify installation:**

```bash
claude --version
```

### Native Installation (Beta)

The native installation doesn't require Node.js or npm:

**macOS, Linux, WSL:**

```bash
# Install stable version (default)
curl -fsSL https://claude.ai/install.sh | bash

# Install latest version
curl -fsSL https://claude.ai/install.sh | bash -s latest

# Install specific version
curl -fsSL https://claude.ai/install.sh | bash -s 1.0.58
```

**Windows PowerShell:**

```powershell
# Install stable version (default)
irm https://claude.ai/install.ps1 | iex

# Install latest version
& ([scriptblock]::Create((irm https://claude.ai/install.ps1))) latest

# Install specific version
& ([scriptblock]::Create((irm https://claude.ai/install.ps1))) 1.0.58
```

**Windows CMD:**

```batch
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

> **Important:** Ensure `~/.local/bin` (or equivalent) is in your PATH.

**Verify installation:**

```bash
which claude  # macOS/Linux/WSL
where claude  # Windows
```

---

## Authentication

### First-Time Login

When you first run `claude`, you'll be prompted to log in:

```bash
claude
# Follow the prompts to authenticate
```

### Login Options

You can authenticate with either account type:

1. **Claude.ai** (subscription plans - recommended)
   - Free, Pro, or Team plans
   - Simple authentication flow

2. **Claude Console** (API usage billing)
   - Pay-as-you-go with pre-paid credits
   - Creates "Claude Code" workspace automatically

### Manual Login

To switch accounts or log in again:

```bash
# Within Claude Code
> /login

# Or from command line
claude
> /login
```

### Logging Out

```bash
> /logout
```

Your credentials are stored securely and persist across sessions. See the **Security & Permissions** guide for details on credential management.

---

## Your First Session

### Start Claude Code

Navigate to your project and launch:

```bash
cd /path/to/your/project
claude
```

You'll see:
- Welcome screen
- Session information
- Recent conversations
- Latest updates

### Available Help

```bash
# Get help
> /help

# Resume previous conversation
> /resume

# Ask about Claude Code itself
> what can Claude Code do?
```

---

## Essential Commands

### Interactive Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `claude` | Start interactive mode | `claude` |
| `claude "task"` | Start with initial prompt | `claude "explain this project"` |
| `exit` or `Ctrl+C` | Exit Claude Code | `exit` |
| `/help` | Show available commands | `/help` |
| `/clear` | Clear conversation history | `/clear` |

### Command-Line Usage

| Command | Purpose | Example |
|---------|---------|---------|
| `claude -p "query"` | Run query and exit | `claude -p "explain main.py"` |
| `claude -c` | Continue most recent conversation | `claude -c` |
| `claude -r` | Resume specific conversation | `claude -r` |
| `cat file \| claude -p "query"` | Process piped input | `cat error.log \| claude -p "explain"` |
| `claude update` | Update to latest version | `claude update` |

### Common Slash Commands

| Command | Purpose |
|---------|---------|
| `/agents` | Manage AI subagents |
| `/bug` | Report bugs to Anthropic |
| `/compact` | Compress conversation history |
| `/config` | Open settings interface |
| `/cost` | Show token usage statistics |
| `/init` | Initialize project CLAUDE.md |
| `/mcp` | Manage MCP server connections |
| `/memory` | Edit memory files |
| `/model` | Change AI model |
| `/permissions` | View/update permissions |
| `/review` | Request code review |

---

## Quick Start Examples

### Example 1: Understand Your Codebase

```bash
> what does this project do?
# Claude analyzes files and provides summary

> what technologies does this project use?

> where is the main entry point?

> explain the folder structure
```

### Example 2: Make Code Changes

```bash
> add a hello world function to the main file
# Claude finds the file, shows changes, asks for approval

> fix the bug where users can submit empty forms

> refactor the auth module to use async/await
```

### Example 3: Work with Git

```bash
> what files have I changed?

> commit my changes with a descriptive message

> create a new branch called feature/user-auth

> show me the last 5 commits
```

### Example 4: Add Features

```bash
> add input validation to the user registration form

> write unit tests for the calculator functions

> update the README with installation instructions
```

### Example 5: Debug Issues

```bash
> there's a bug where users can't log in after password reset
# Claude analyzes code, identifies issue, proposes fix

> the build is failing with a type error
# Claude reads error, locates problem, fixes it

> help me resolve merge conflicts
```

### Example 6: Ask About Claude Code

```bash
> can Claude Code create pull requests?

> how does Claude Code handle permissions?

> what slash commands are available?

> how do I use MCP with Claude Code?
```

---

## Pro Tips for Beginners

### 1. Be Specific with Requests

**Instead of:**
```
> fix the bug
```

**Try:**
```
> fix the login bug where users see a blank screen after entering wrong credentials
```

### 2. Use Step-by-Step Instructions

Break complex tasks into steps:

```bash
> 1. create a new database table for user profiles
> 2. create an API endpoint to get and update user profiles
> 3. build a webpage that allows users to see and edit their information
```

### 3. Let Claude Explore First

Before making changes:

```bash
> analyze the database schema
# Let Claude understand the structure first

> build a dashboard showing products that are most frequently returned by UK customers
# Claude will explore data before building
```

### 4. Use Shortcuts

- Press **Tab** for command completion
- Press **↑** for command history
- Type **`/`** to see all slash commands
- Press **Shift+Tab** to cycle through permission modes
- Press **ESC** to interrupt Claude

### 5. Reference Files Directly

Use `@` to reference files and directories:

```bash
> Explain the logic in @src/utils/auth.js

> What's the structure of @src/components?

> Compare @old-version.js with @new-version.js
```

### 6. Work with Images

Drag and drop images into Claude Code or paste them (Ctrl+V):

```bash
# After pasting an image
> What does this error screenshot show?

> Generate CSS to match this design mockup

> Describe the UI elements in this screenshot
```

---

## Next Steps

### Explore More Guides

- **[Workflows Guide](claude-code_workflows.md)** - Step-by-step guides for common tasks
- **[Configuration Guide](claude-code_configuration.md)** - Customize Claude Code
- **[CLI & SDK Reference](claude-code_cli-sdk.md)** - Master command-line usage
- **[Hooks Guide](claude-code_hooks.md)** - Automate workflows with hooks
- **[Subagents Guide](claude-code_subagents.md)** - Create specialized AI assistants
- **[MCP Integration](claude-code_mcp-integration.md)** - Connect to external tools
- **[Security & Permissions](claude-code_security-permissions.md)** - Configure access controls
- **[Troubleshooting](claude-code_troubleshooting.md)** - Solutions to common issues

### Join the Community

- **Discord**: [Join our Discord](https://www.anthropic.com/discord) for tips and support
- **GitHub**: [Report issues and contribute](https://github.com/anthropics/claude-code)
- **Documentation**: [Official docs](https://docs.anthropic.com/en/docs/claude-code)

---

## Getting Help

### Within Claude Code

```bash
> /help              # Show available commands
> how do I...        # Ask Claude directly
> /doctor            # Check installation health
> /bug               # Report issues to Anthropic
```

### Common Questions

**Q: Does Claude Code modify my code without permission?**
A: No. Claude Code always asks for permission before making changes.

**Q: Can I undo changes?**
A: Yes, use Git to revert changes. Claude works with your version control.

**Q: Is my code sent to Anthropic?**
A: See the **Security & Permissions** guide for details on data handling.

**Q: Can I use Claude Code offline?**
A: No, Claude Code requires an internet connection to communicate with Claude.

**Q: What models does Claude Code use?**
A: By default, Claude Code uses Claude Sonnet 4.5. You can change models with `/model`.

---

## Quick Reference Card

### Starting Claude Code
```bash
claude                    # Start interactive session
claude "prompt"           # Start with initial query
claude -p "query"         # Run once and exit
claude -c                 # Continue last conversation
claude -r                 # Resume specific conversation
```

### Essential Shortcuts
```
Tab           # Auto-complete commands
↑/↓          # Command history
Shift+Tab     # Cycle permission modes
Ctrl+R        # View transcript
ESC           # Interrupt Claude
Ctrl+C        # Exit
```

### Must-Know Commands
```
/help         # Show all commands
/permissions  # Configure permissions
/model        # Change AI model
/compact      # Compress conversation
/memory       # Edit project memory
/agents       # Manage subagents
/mcp          # Configure MCP servers
/clear        # Start fresh conversation
```

---

**Ready to start coding with Claude? Run `claude` to begin!**

---

*Part of the Claude Code Documentation Series. See [claude-code_manifest.md](claude-code_manifest.md) for all available guides.*
