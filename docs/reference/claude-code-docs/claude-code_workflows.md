# Claude Code: Common Workflows Guide

**Step-by-step guides for mastering Claude Code workflows**

📖 **Official Documentation:** https://docs.anthropic.com/en/docs/claude-code/common-workflows

---

## Table of Contents

1. [Overview](#overview)
2. [Understanding New Codebases](#understanding-new-codebases)
3. [Fixing Bugs Efficiently](#fixing-bugs-efficiently)
4. [Refactoring Code](#refactoring-code)
5. [Working with Tests](#working-with-tests)
6. [Creating Pull Requests](#creating-pull-requests)
7. [Handling Documentation](#handling-documentation)
8. [Using Plan Mode](#using-plan-mode)
9. [Working with Images](#working-with-images)
10. [Referencing Files and Directories](#referencing-files-and-directories)
11. [Using Extended Thinking](#using-extended-thinking)
12. [Resuming Previous Conversations](#resuming-previous-conversations)
13. [Running Parallel Sessions with Git Worktrees](#running-parallel-sessions-with-git-worktrees)
14. [Using Claude as a Unix-Style Utility](#using-claude-as-a-unix-style-utility)
15. [Using Specialized Subagents](#using-specialized-subagents)
16. [Best Practices](#best-practices)

---

## Overview

This guide provides step-by-step instructions for common development workflows with Claude Code. Each task includes clear instructions, example commands, and best practices to help you get the most from Claude Code.

---

## Understanding New Codebases

### Get a Quick Codebase Overview

When joining a new project, quickly understand its structure:

**Steps:**

1. Navigate to the project root:
   ```bash
   cd /path/to/project
   ```

2. Start Claude Code:
   ```bash
   claude
   ```

3. Ask for a high-level overview:
   ```
   > give me an overview of this codebase
   ```

4. Dive deeper into specific components:
   ```
   > explain the main architecture patterns used here
   > what are the key data models?
   > how is authentication handled?
   ```

**Tips:**
- Start with broad questions, then narrow down to specific areas
- Ask about coding conventions and patterns used in the project
- Request a glossary of project-specific terms

### Find Relevant Code

Locate code related to specific features or functionality:

**Steps:**

1. Ask Claude to find relevant files:
   ```
   > find the files that handle user authentication
   ```

2. Get context on how components interact:
   ```
   > how do these authentication files work together?
   ```

3. Understand the execution flow:
   ```
   > trace the login process from front-end to database
   ```

**Tips:**
- Be specific about what you're looking for
- Use domain language from the project
- Ask Claude to explain relationships between files

---

## Fixing Bugs Efficiently

### Debug and Fix Issues

When encountering errors, use Claude to diagnose and fix:

**Steps:**

1. Share the error with Claude:
   ```
   > I'm seeing an error when I run npm test
   ```

2. Ask for fix recommendations:
   ```
   > suggest a few ways to fix the @ts-ignore in user.ts
   ```

3. Apply the fix:
   ```
   > update user.ts to add the null check you suggested
   ```

**Tips:**
- Tell Claude the command to reproduce the issue
- Mention any steps to reproduce the error
- Let Claude know if the error is intermittent or consistent
- Share stack traces and error messages

**Example with Error Details:**

```bash
# Share context
> When I run npm test, I get this error:
> TypeError: Cannot read property 'id' of undefined at UserService.findUser (user.ts:42)

# Claude analyzes and suggests fixes
> The error occurs because user.findUser can return undefined...

# Apply the fix
> add the null check you suggested
```

---

## Refactoring Code

### Modernize and Improve Code

Update old code to use modern patterns and practices:

**Steps:**

1. Identify legacy code for refactoring:
   ```
   > find deprecated API usage in our codebase
   ```

2. Get refactoring recommendations:
   ```
   > suggest how to refactor utils.js to use modern JavaScript features
   ```

3. Apply the changes safely:
   ```
   > refactor utils.js to use ES2024 features while maintaining the same behavior
   ```

4. Verify the refactoring:
   ```
   > run tests for the refactored code
   ```

**Tips:**
- Ask Claude to explain the benefits of the modern approach
- Request that changes maintain backward compatibility when needed
- Do refactoring in small, testable increments

**Example Refactoring Flow:**

```bash
# Find opportunities
> analyze src/utils/ for outdated patterns

# Get recommendations
> show me how to refactor the callback-based code to use promises

# Apply incrementally
> refactor getUserData in user.ts first

# Verify
> run the user tests to verify the refactoring works
```

---

## Working with Tests

### Add Tests for Uncovered Code

Create comprehensive test coverage:

**Steps:**

1. Identify untested code:
   ```
   > find functions in NotificationsService.swift that are not covered by tests
   ```

2. Generate test scaffolding:
   ```
   > add tests for the notification service
   ```

3. Add meaningful test cases:
   ```
   > add test cases for edge conditions in the notification service
   ```

4. Run and verify tests:
   ```
   > run the new tests and fix any failures
   ```

**Tips:**
- Ask for tests that cover edge cases and error conditions
- Request both unit and integration tests when appropriate
- Have Claude explain the testing strategy

**Example Test Workflow:**

```bash
# Identify gaps
> check test coverage for the payment module

# Generate tests
> create unit tests for PaymentProcessor.processRefund

# Add edge cases
> add tests for: invalid amounts, expired cards, network failures

# Run and fix
> run the payment tests and fix any issues
```

---

## Creating Pull Requests

### Generate Well-Documented PRs

Create comprehensive pull requests with Claude's help:

**Steps:**

1. Summarize your changes:
   ```
   > summarize the changes I've made to the authentication module
   ```

2. Generate a PR with Claude:
   ```
   > create a pr
   ```

3. Review and refine:
   ```
   > enhance the PR description with more context about the security improvements
   ```

4. Add testing details:
   ```
   > add information about how these changes were tested
   ```

**Important: What Happens Behind the Scenes**

When you ask Claude to create a PR, Claude will:
1. Run `git status` to see untracked files
2. Run `git diff` to see staged and unstaged changes
3. Check if the current branch tracks a remote and is up to date
4. Run `git log` and `git diff [base-branch]...HEAD` to understand full commit history
5. Analyze **ALL commits** that will be included (not just the latest)
6. Create new branch if needed
7. Push to remote with `-u` flag if needed
8. Create PR using `gh pr create` with proper formatting

**Tips:**
- Ask Claude directly to make a PR for you
- Review Claude's generated PR before submitting
- Ask Claude to highlight potential risks or considerations

**Example PR Creation:**

```bash
# Start PR process
> create a pull request for my authentication changes

# Claude will run git commands and create PR
# You can then refine it
> add a section about backwards compatibility
```

---

## Handling Documentation

### Add or Update Documentation

Document your code properly:

**Steps:**

1. Identify undocumented code:
   ```
   > find functions without proper JSDoc comments in the auth module
   ```

2. Generate documentation:
   ```
   > add JSDoc comments to the undocumented functions in auth.js
   ```

3. Review and enhance:
   ```
   > improve the generated documentation with more context and examples
   ```

4. Verify documentation:
   ```
   > check if the documentation follows our project standards
   ```

**Tips:**
- Specify the documentation style you want (JSDoc, docstrings, etc.)
- Ask for examples in the documentation
- Request documentation for public APIs, interfaces, and complex logic

**Example Documentation Flow:**

```bash
# Audit documentation
> check which API endpoints lack documentation

# Generate docs
> add OpenAPI documentation for the user endpoints

# Add examples
> include request/response examples for each endpoint

# Verify
> check if the API docs follow our standard format
```

---

## Using Plan Mode

Plan Mode is perfect for safe code analysis and planning complex changes.

### When to Use Plan Mode

- **Multi-step implementation**: Feature requires editing many files
- **Code exploration**: Research codebase before making changes
- **Interactive development**: Iterate on direction with Claude

### How to Use Plan Mode

**Turn on Plan Mode During a Session:**

Press **Shift+Tab** to cycle through permission modes:
- Normal Mode → Auto-Accept Mode (`⏵⏵ accept edits on`)
- Auto-Accept Mode → Plan Mode (`⏸ plan mode on`)

**Start a New Session in Plan Mode:**

```bash
claude --permission-mode plan
```

**Run Headless Queries in Plan Mode:**

```bash
claude --permission-mode plan -p "Analyze the authentication system and suggest improvements"
```

### Example: Planning a Complex Refactor

```bash
# Start in plan mode
claude --permission-mode plan

# Plan a refactor
> I need to refactor our authentication system to use OAuth2. Create a detailed migration plan.

# Refine with follow-ups
> What about backward compatibility?
> How should we handle database migration?
```

### Configure Plan Mode as Default

```json
// .claude/settings.json
{
  "permissions": {
    "defaultMode": "plan"
  }
}
```

See **[Configuration Guide](claude-code_configuration.md)** for more settings.

---

## Working with Images

### Analyze and Work with Visual Content

Use images for better context:

**Steps:**

1. **Add an image to the conversation** using any method:
   - Drag and drop into Claude Code window
   - Copy and paste with Ctrl+V (not Cmd+V)
   - Provide image path: `"Analyze this image: /path/to/image.png"`

2. **Ask Claude to analyze:**
   ```
   > What does this image show?
   > Describe the UI elements in this screenshot
   > Are there any problematic elements in this diagram?
   ```

3. **Use images for context:**
   ```
   > Here's a screenshot of the error. What's causing it?
   > This is our current database schema. How should we modify it for the new feature?
   ```

4. **Get code suggestions from visual content:**
   ```
   > Generate CSS to match this design mockup
   > What HTML structure would recreate this component?
   ```

**Tips:**
- Use images when text descriptions would be unclear or cumbersome
- Include screenshots of errors, UI designs, or diagrams
- You can work with multiple images in a conversation
- Works with diagrams, screenshots, mockups, and more

---

## Referencing Files and Directories

### Use @ to Include Files Directly

Speed up your workflow by referencing files without waiting for Claude to read them:

**Steps:**

1. **Reference a single file:**
   ```
   > Explain the logic in @src/utils/auth.js
   ```
   This includes the full content in the conversation.

2. **Reference a directory:**
   ```
   > What's the structure of @src/components?
   ```
   This provides a directory listing with file information.

3. **Reference MCP resources:**
   ```
   > Show me the data from @github:repos/owner/repo/issues
   ```
   Format: `@server:resource`

**Tips:**
- File paths can be relative or absolute
- `@` file references add CLAUDE.md from the file's directory and parent directories
- Directory references show listings, not contents
- You can reference multiple files: `@file1.js and @file2.js`

---

## Using Extended Thinking

### Deep Reasoning for Complex Tasks

Extended thinking improves performance on complex reasoning and coding tasks.

> **Note:** Extended thinking is disabled by default. Enable it on-demand with `Tab` to toggle Thinking on, or use prompts like "think" or "think hard". You can also set the `MAX_THINKING_TOKENS` environment variable.

**When to Use Extended Thinking:**

- Planning complex architectural changes
- Debugging intricate issues
- Creating implementation plans for new features
- Understanding complex codebases
- Evaluating tradeoffs between different approaches

**Steps:**

1. **Provide context and ask Claude to think:**
   ```
   > I need to implement a new authentication system using OAuth2 for our API. Think deeply about the best approach for implementing this in our codebase.
   ```
   Claude will use extended thinking (visible in the interface).

2. **Refine with follow-up prompts:**
   ```
   > think about potential security vulnerabilities in this approach
   > think hard about edge cases we should handle
   ```

**Thinking Depth Levels:**

- `"think"` - Basic extended thinking
- `"think hard"`, `"think more"`, `"think longer"` - Deeper thinking

**Tips:**
- Use Tab to toggle Thinking on/off during a session
- Extended thinking is most valuable for complex tasks
- Claude displays thinking process as italic gray text above responses

**Example:**

```bash
# Enable thinking and analyze
> think deeply about the best way to migrate our authentication system from JWT to OAuth2

# Follow up with specific concerns
> think about database migration strategy
> think hard about edge cases during the transition
```

---

## Resuming Previous Conversations

### Continue Where You Left Off

Claude Code provides two options:

- `--continue` to automatically continue the most recent conversation
- `--resume` to display a conversation picker

**Steps:**

1. **Continue the most recent conversation:**
   ```bash
   claude --continue
   ```
   Immediately resumes your most recent conversation.

2. **Continue in non-interactive mode:**
   ```bash
   claude --continue --print "Continue with my task"
   ```
   Use `--print` with `--continue` for scripts or automation.

3. **Show conversation picker:**
   ```bash
   claude --resume
   ```
   Displays interactive selector with:
   - Session summary (or initial prompt)
   - Metadata: time elapsed, message count, git branch
   - Use arrow keys to navigate, Enter to select, Esc to exit

**How It Works:**

1. **Conversation Storage**: All conversations saved locally with full message history
2. **Message Deserialization**: Entire message history restored
3. **Tool State**: Tool usage and results preserved
4. **Context Restoration**: All previous context intact

**Examples:**

```bash
# Continue most recent conversation
claude --continue

# Continue with a specific prompt
claude --continue --print "Show me our progress"

# Show conversation picker
claude --resume

# Continue in non-interactive mode
claude --continue --print "Run the tests again"
```

**Tips:**
- Conversation history stored locally on your machine
- Use `--continue` for quick access to recent conversation
- Use `--resume` when you need a specific past conversation
- Resumed conversation starts with same model and configuration

---

## Running Parallel Sessions with Git Worktrees

### Work on Multiple Tasks Simultaneously

Git worktrees allow complete code isolation between Claude Code instances:

**Steps:**

1. **Understand Git worktrees:**
   - Check out multiple branches into separate directories
   - Each worktree has its own working directory
   - Share the same Git history
   - [Official Git worktree docs](https://git-scm.com/docs/git-worktree)

2. **Create a new worktree:**
   ```bash
   # Create with new branch
   git worktree add ../project-feature-a -b feature-a

   # Or use existing branch
   git worktree add ../project-bugfix bugfix-123
   ```

3. **Run Claude Code in each worktree:**
   ```bash
   # Navigate to worktree
   cd ../project-feature-a

   # Run Claude Code
   claude
   ```

4. **Run Claude in another worktree:**
   ```bash
   cd ../project-bugfix
   claude
   ```

5. **Manage your worktrees:**
   ```bash
   # List all worktrees
   git worktree list

   # Remove a worktree when done
   git worktree remove ../project-feature-a
   ```

**Tips:**
- Each worktree has independent file state - perfect for parallel sessions
- Changes in one worktree won't affect others
- All worktrees share the same Git history and remote connections
- Long-running tasks in one worktree while you continue in another
- Use descriptive directory names to identify worktree purposes
- Initialize development environment in each new worktree (npm install, etc.)

---

## Using Claude as a Unix-Style Utility

### Add Claude to Your Verification Process

Use Claude as a linter or code reviewer:

**Add Claude to build script:**

```json
// package.json
{
    "scripts": {
        "lint:claude": "claude -p 'you are a linter. please look at the changes vs. main and report any issues related to typos. report the filename and line number on one line, and a description of the issue on the second line. do not return any other text.'"
    }
}
```

**Tips:**
- Use Claude for automated code review in CI/CD pipeline
- Customize the prompt to check for specific issues
- Create multiple scripts for different types of verification

### Pipe In, Pipe Out

Pipe data through Claude:

```bash
cat build-error.txt | claude -p 'concisely explain the root cause of this build error' > output.txt
```

**Tips:**
- Use pipes to integrate Claude into existing shell scripts
- Combine with other Unix tools for powerful workflows
- Consider using `--output-format` for structured output

### Control Output Format

Specify output format for scripts and tools:

**Steps:**

1. **Use text format (default):**
   ```bash
   cat data.txt | claude -p 'summarize this data' --output-format text > summary.txt
   ```
   Outputs just Claude's plain text response.

2. **Use JSON format:**
   ```bash
   cat code.py | claude -p 'analyze this code for bugs' --output-format json > analysis.json
   ```
   Outputs JSON array of messages with metadata (cost, duration).

3. **Use streaming JSON format:**
   ```bash
   cat log.txt | claude -p 'parse this log file for errors' --output-format stream-json
   ```
   Outputs JSON objects in real-time as Claude processes.

**Tips:**
- Use `--output-format text` for simple integrations
- Use `--output-format json` when you need full conversation log
- Use `--output-format stream-json` for real-time output

---

## Using Specialized Subagents

### Delegate Tasks to Specialized AI Assistants

Subagents are pre-configured AI personalities for specific tasks.

**Steps:**

1. **View available subagents:**
   ```
   > /agents
   ```
   Shows all available subagents and lets you create new ones.

2. **Use subagents automatically:**
   Claude Code delegates tasks automatically:
   ```
   > review my recent code changes for security issues
   > run all tests and fix any failures
   ```

3. **Explicitly request specific subagents:**
   ```
   > use the code-reviewer subagent to check the auth module
   > have the debugger subagent investigate why users can't log in
   ```

4. **Create custom subagents:**
   ```
   > /agents
   ```
   Select "Create New subagent" and define:
   - Subagent type (e.g., `api-designer`, `performance-optimizer`)
   - When to use it
   - Which tools it can access
   - Its specialized system prompt

**Tips:**
- Create project-specific subagents in `.claude/agents/` for team sharing
- Use descriptive `description` fields to enable automatic delegation
- Limit tool access to what each subagent actually needs
- Check the **[Subagents Guide](claude-code_subagents.md)** for detailed examples

---

## Best Practices

### General Workflow Tips

1. **Start with Exploration**
   - Let Claude understand your codebase before making changes
   - Ask broad questions, then narrow down

2. **Be Specific**
   - Provide detailed context and requirements
   - Include error messages, stack traces, and reproduction steps

3. **Work Incrementally**
   - Break complex tasks into smaller steps
   - Verify each step before proceeding

4. **Use the Right Tools**
   - Plan Mode for exploration and planning
   - Subagents for specialized tasks
   - Extended Thinking for complex decisions

5. **Leverage Context**
   - Use `@` to reference files directly
   - Include images for visual context
   - Share error screenshots and design mockups

6. **Maintain Safety**
   - Review changes before approving
   - Use version control (Git) for safety
   - Configure permissions appropriately

7. **Optimize Performance**
   - Use `/compact` to reduce context size
   - Resume conversations instead of starting fresh
   - Use parallel worktrees for concurrent work

### Prompt Engineering Tips

**Good Prompts:**
```
> Find the authentication bug where users see a 401 error after password reset,
  check the user.ts and auth.ts files, and fix the token refresh logic

> Refactor the payment processing module to use async/await instead of callbacks,
  maintain all existing functionality, and add error handling for network failures
```

**Avoid Vague Prompts:**
```
> Fix the bug
> Make it better
> Update the code
```

### Workflow Optimization

1. **Create Reusable Patterns**
   - Set up custom slash commands for common tasks
   - Configure subagents for project-specific workflows
   - Add project conventions to CLAUDE.md

2. **Automate Repetitive Tasks**
   - Use hooks to enforce code standards
   - Set up Claude as a linter in CI/CD
   - Create scripts with Claude in pipelines

3. **Collaborate Effectively**
   - Share configuration in version control
   - Document team conventions in CLAUDE.md
   - Use project-level subagents for consistency

---

## Related Guides

- **[Getting Started](claude-code_getting-started.md)** - Installation and basics
- **[Configuration Guide](claude-code_configuration.md)** - Settings and customization
- **[CLI & SDK Reference](claude-code_cli-sdk.md)** - Command-line usage
- **[Hooks Guide](claude-code_hooks.md)** - Automate workflows
- **[Subagents Guide](claude-code_subagents.md)** - Create specialized assistants
- **[Security & Permissions](claude-code_security-permissions.md)** - Access controls

---

*Part of the Claude Code Documentation Series. See [claude-code_manifest.md](claude-code_manifest.md) for all available guides.*
