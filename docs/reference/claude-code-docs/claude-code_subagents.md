# Claude Code: Subagents Guide

**Create and use specialized AI subagents for task-specific workflows**

📖 **Official Documentation:** https://docs.anthropic.com/en/docs/claude-code/sub-agents

---

## Table of Contents

1. [What Are Subagents?](#what-are-subagents)
2. [Key Benefits](#key-benefits)
3. [Quick Start](#quick-start)
4. [Subagent Configuration](#subagent-configuration)
5. [Managing Subagents](#managing-subagents)
6. [Using Subagents Effectively](#using-subagents-effectively)
7. [Example Subagents](#example-subagents)
8. [Best Practices](#best-practices)
9. [Advanced Usage](#advanced-usage)

---

## What Are Subagents?

Subagents are pre-configured AI personalities that Claude Code can delegate tasks to. Each subagent:

- Has a **specific purpose** and expertise area
- Uses its **own context window** separate from the main conversation
- Can be configured with **specific tools** it's allowed to use
- Includes a **custom system prompt** that guides its behavior

When Claude Code encounters a task matching a subagent's expertise, it can delegate that task to the specialized subagent, which works independently and returns results.

---

## Key Benefits

### 1. Context Preservation
Each subagent operates in its own context, preventing pollution of the main conversation and keeping it focused on high-level objectives.

### 2. Specialized Expertise
Subagents can be fine-tuned with detailed instructions for specific domains, leading to higher success rates on designated tasks.

### 3. Reusability
Once created, subagents can be used across different projects and shared with your team for consistent workflows.

### 4. Flexible Permissions
Each subagent can have different tool access levels, allowing you to limit powerful tools to specific subagent types.

---

## Quick Start

### Step 1: Open the Subagents Interface

```bash
> /agents
```

### Step 2: Select 'Create New Agent'

Choose whether to create:
- **Project-level subagent** (shared with team via git)
- **User-level subagent** (personal, across all projects)

### Step 3: Define the Subagent

**Recommended**: Generate with Claude first, then customize:

1. Describe your subagent in detail and when it should be used
2. Select tools you want to grant access to (or leave blank to inherit all)
3. The interface shows all available tools, making selection easy
4. If generating with Claude, you can edit the system prompt in your editor by pressing `e`

### Step 4: Save and Use

Your subagent is now available! Claude will use it automatically when appropriate, or you can invoke it explicitly:

```bash
> Use the code-reviewer subagent to check my recent changes
```

---

## Subagent Configuration

### File Locations

| Type | Location | Scope | Priority |
|------|----------|-------|----------|
| **Project subagents** | `.claude/agents/` | Current project only | Highest |
| **User subagents** | `~/.claude/agents/` | All your projects | Lower |

**Note**: When names conflict, project-level subagents take precedence.

### CLI-Based Configuration

Define subagents dynamically using the `--agents` CLI flag:

```bash
claude --agents '{
  "code-reviewer": {
    "description": "Expert code reviewer. Use proactively after code changes.",
    "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  }
}'
```

**Priority**: CLI-defined subagents have lower priority than project-level but higher than user-level.

**Use Cases**:
- Quick testing of subagent configurations
- Session-specific subagents that don't need to be saved
- Automation scripts that need custom subagents
- Sharing subagent definitions in documentation or scripts

### File Format

Each subagent is defined in a Markdown file with YAML frontmatter:

```markdown
---
name: your-sub-agent-name
description: Description of when this subagent should be invoked
tools: tool1, tool2, tool3  # Optional - inherits all tools if omitted
model: sonnet  # Optional - specify model alias or 'inherit'
---

Your subagent's system prompt goes here. This can be multiple paragraphs
and should clearly define the subagent's role, capabilities, and approach
to solving problems.

Include specific instructions, best practices, and any constraints
the subagent should follow.
```

### Configuration Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier using lowercase letters and hyphens |
| `description` | Yes | Natural language description of the subagent's purpose |
| `tools` | No | Comma-separated list of specific tools. If omitted, inherits all tools from main thread |
| `model` | No | Model to use: `sonnet`, `opus`, `haiku`, or `'inherit'`. If omitted, defaults to configured subagent model |

### Model Selection

The `model` field controls which AI model the subagent uses:

- **Model alias**: `sonnet`, `opus`, or `haiku` for latest of each tier
- **`'inherit'`**: Use the same model as the main conversation
- **Omitted**: Uses default model configured for subagents (typically `sonnet`)

**Tip**: Using `'inherit'` ensures consistent capabilities and response style throughout your session.

### Available Tools

Subagents can access any of Claude Code's internal tools. See the [Configuration Guide](claude-code_configuration.md) for the complete list.

**Recommended**: Use the `/agents` command to modify tool access - it provides an interactive interface listing all available tools, including MCP tools.

**Tool Configuration Options**:
1. **Omit `tools` field**: Inherit all tools from main thread (default), including MCP tools
2. **Specify individual tools**: Comma-separated list for granular control

**MCP Tools**: Subagents can access MCP tools from configured MCP servers. When the `tools` field is omitted, subagents inherit all MCP tools available to the main thread.

---

## Managing Subagents

### Using the /agents Command (Recommended)

The `/agents` command provides a comprehensive interface:

```bash
> /agents
```

**Features**:
- View all available subagents (built-in, user, and project)
- Create new subagents with guided setup
- Edit existing custom subagents, including their tool access
- Delete custom subagents
- See which subagents are active when duplicates exist
- **Easily manage tool permissions** with complete list of available tools

### Direct File Management

You can also manage subagents by working directly with their files:

```bash
# Create a project subagent
mkdir -p .claude/agents
cat > .claude/agents/test-runner.md << 'EOL'
---
name: test-runner
description: Use proactively to run tests and fix failures
---

You are a test automation expert. When you see code changes, proactively 
run the appropriate tests. If tests fail, analyze the failures and fix them 
while preserving the original test intent.
EOL

# Create a user subagent
mkdir -p ~/.claude/agents
# ... create subagent file
```

---

## Using Subagents Effectively

### Automatic Delegation

Claude Code proactively delegates tasks based on:
- The task description in your request
- The `description` field in subagent configurations
- Current context and available tools

**Tip**: To encourage more proactive subagent use, include phrases like "use PROACTIVELY" or "MUST BE USED" in your `description` field.

### Explicit Invocation

Request a specific subagent by mentioning it in your command:

```bash
> Use the test-runner subagent to fix failing tests
> Have the code-reviewer subagent look at my recent changes
> Ask the debugger subagent to investigate this error
```

---

## Example Subagents

### Code Reviewer

```markdown
---
name: code-reviewer
description: Expert code review specialist. Proactively reviews code for quality, security, and maintainability. Use immediately after writing or modifying code.
tools: Read, Grep, Glob, Bash
model: inherit
---

You are a senior code reviewer ensuring high standards of code quality and security.

When invoked:
1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately

Review checklist:
- Code is simple and readable
- Functions and variables are well-named
- No duplicated code
- Proper error handling
- No exposed secrets or API keys
- Input validation implemented
- Good test coverage
- Performance considerations addressed

Provide feedback organized by priority:
- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (consider improving)

Include specific examples of how to fix issues.
```

### Debugger

```markdown
---
name: debugger
description: Debugging specialist for errors, test failures, and unexpected behavior. Use proactively when encountering any issues.
tools: Read, Edit, Bash, Grep, Glob
---

You are an expert debugger specializing in root cause analysis.

When invoked:
1. Capture error message and stack trace
2. Identify reproduction steps
3. Isolate the failure location
4. Implement minimal fix
5. Verify solution works

Debugging process:
- Analyze error messages and logs
- Check recent code changes
- Form and test hypotheses
- Add strategic debug logging
- Inspect variable states

For each issue, provide:
- Root cause explanation
- Evidence supporting the diagnosis
- Specific code fix
- Testing approach
- Prevention recommendations

Focus on fixing the underlying issue, not just symptoms.
```

### Data Scientist

```markdown
---
name: data-scientist
description: Data analysis expert for SQL queries, BigQuery operations, and data insights. Use proactively for data analysis tasks and queries.
tools: Bash, Read, Write
model: sonnet
---

You are a data scientist specializing in SQL and BigQuery analysis.

When invoked:
1. Understand the data analysis requirement
2. Write efficient SQL queries
3. Use BigQuery command line tools (bq) when appropriate
4. Analyze and summarize results
5. Present findings clearly

Key practices:
- Write optimized SQL queries with proper filters
- Use appropriate aggregations and joins
- Include comments explaining complex logic
- Format results for readability
- Provide data-driven recommendations

For each analysis:
- Explain the query approach
- Document any assumptions
- Highlight key findings
- Suggest next steps based on data

Always ensure queries are efficient and cost-effective.
```

### Test Runner

```markdown
---
name: test-runner
description: Test automation expert. Use proactively to run tests after code changes and fix failures.
tools: Bash, Read, Edit, Write
---

You are a test automation expert focused on maintaining test quality.

When invoked:
1. Identify relevant tests for recent changes
2. Run appropriate test suites
3. Analyze any failures
4. Fix broken tests or code as needed

Testing approach:
- Run unit tests first, then integration tests
- Analyze failure patterns
- Fix tests without changing their intent
- Add new tests for uncovered cases
- Ensure all tests pass before finishing

For test failures:
- Determine if test or code is wrong
- Fix the actual problem, not the test
- Preserve test intent
- Add comments explaining fixes
```

### API Designer

```markdown
---
name: api-designer
description: REST API design specialist. Use when designing or modifying API endpoints.
tools: Read, Write, Edit, Bash
---

You are an API design expert specializing in RESTful APIs.

When invoked:
1. Understand the business requirement
2. Design appropriate endpoints
3. Define request/response schemas
4. Consider error cases
5. Document the API

Design principles:
- Follow REST conventions
- Use appropriate HTTP methods and status codes
- Design consistent URL structures
- Provide clear error messages
- Include pagination for collections
- Version APIs appropriately

For each API:
- Define clear contracts
- Consider authentication/authorization
- Plan for backwards compatibility
- Document all endpoints
- Provide example requests/responses
```

---

## Best Practices

### 1. Start with Claude-Generated Agents

**Highly Recommended**: Generate your initial subagent with Claude and then iterate on it. This gives you a solid foundation that you can customize to your specific needs.

### 2. Design Focused Subagents

Create subagents with single, clear responsibilities rather than trying to make one subagent do everything. This improves performance and makes subagents more predictable.

**Good**:
- code-reviewer (reviews code only)
- test-runner (runs and fixes tests)
- api-designer (designs APIs)

**Bad**:
- super-agent (does everything)
- dev-helper (too broad)

### 3. Write Detailed Prompts

Include specific instructions, examples, and constraints in your system prompts. The more guidance you provide, the better the subagent will perform.

**Example**:
```markdown
When reviewing code:
1. Check for security vulnerabilities
2. Verify error handling
3. Ensure proper logging
4. Validate input sanitization
5. Review test coverage

Do NOT:
- Suggest cosmetic changes
- Refactor working code without reason
- Change variable names without justification
```

### 4. Limit Tool Access

Only grant tools that are necessary for the subagent's purpose. This improves security and helps the subagent focus on relevant actions.

**Example**:
```markdown
---
tools: Read, Grep, Glob  # Read-only for code reviewer
---
```

### 5. Version Control

Check project subagents into version control so your team can benefit from and improve them collaboratively.

```bash
git add .claude/agents/
git commit -m "Add code-reviewer subagent"
```

### 6. Use Descriptive Names

Use clear, descriptive names that indicate the subagent's purpose:

**Good**:
- code-reviewer
- test-runner
- api-designer
- debugger
- performance-optimizer

**Bad**:
- agent1
- helper
- temp

---

## Advanced Usage

### Chaining Subagents

For complex workflows, you can chain multiple subagents:

```bash
> First use the code-analyzer subagent to find performance issues, 
  then use the optimizer subagent to fix them
```

### Dynamic Subagent Selection

Claude Code intelligently selects subagents based on context. Make your `description` fields specific and action-oriented for best results.

**Examples**:
```markdown
# Good descriptions
description: Use proactively to review code after any changes for security, quality, and best practices
description: MUST BE USED when tests fail. Analyzes failures and fixes broken tests
description: Use when designing or modifying REST API endpoints

# Less effective descriptions
description: Reviews code
description: Helps with tests
description: API stuff
```

### Subagents with MCP Tools

Subagents can use MCP tools when they inherit all tools or when specific MCP tools are listed:

```markdown
---
name: github-helper
description: Manages GitHub operations including PRs, issues, and code reviews
tools: mcp__github__*, Read, Write
---
```

---

## Performance Considerations

### Context Efficiency
- **Benefit**: Subagents help preserve main context, enabling longer overall sessions
- **Trade-off**: Subagents start with a clean slate and may add latency as they gather required context

### When to Use Subagents

**Use subagents when**:
- Task requires specialized expertise
- Task needs isolated context
- You want consistent behavior for specific operations
- Multiple similar tasks will benefit from reusable logic

**Don't use subagents when**:
- Simple one-off tasks
- Main context already has all needed information
- Task requires maintaining conversation history

---

## Related Documentation

- **[Slash Commands](claude-code_slash-commands.md)** - Custom commands
- **[Configuration](claude-code_configuration.md)** - Settings and configuration
- **[Hooks](claude-code_hooks.md)** - Workflow automation
- **[Workflows](claude-code_workflows.md)** - Common development workflows

---

*Part of the Claude Code Documentation Series. See [claude-code_manifest.md](claude-code_manifest.md) for all available guides.*
