# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.


ULTRA IMPORTANT: All tool calls, user input, Claude Code answers, module reflections, and decisions should be logged in ** @event-stream.md** as a chronological record of events. Alway
ULTRA IMPORTANT: plan in @planning.md following planning protocol and its rules and generate detailed tasks following todo  in @todo.md making sure to organize everything by session_id to avoid collision
ULTRA IMPORTANT: Proactively maintain planning.md and todo.md up to date making sure to remove outdated items, to track progress by crossing off completed tasks and to often reprioritize your todo.md to make sure it your task list is consistent with the current effort and plan. Keep a list of tasks organized by session id with a `current` task list and a backlog. Reassess often. 
ULTRA IMPORTANT: use @workbook.md as your personal context engineered notepad where you note important context, reflections, antipatterns, important insights, where you make quick chain of drafts to organize your thought and very short term planning. workbook.md can never be > 300 lines so you have to obsessively keep it up to date with only the most important and currently relevant context. 
ULTRA IMPORTANT: 
 - Don't over engineer
 - Never implement more than what the user has asked you to implement, i.e., don't invent features
 - Never halucinate, i.e., if you are not sure, research by using ref mcp tools to review latest library 

ULTRA IMPORTANT: **Documentation Structure**: See @docs/documentation-rules.md for complete documentation lifecycle and organization rules.

---

## Start
Before performing any action first:
1. **Analyze Events:** Review the event stream to understand the user's request and the current state. Focus especially on the latest user instructions and any recent results or errors.  
2. **System Understanding:** If the task is complex or involves system design and/or system architecture, invoke the System Understanding Module to deeply analyze the problem. Identify key entities and their relationships, and construct a high-level outline or diagram of the solution approach. Use this understanding to inform subsequent planning. 
3. **Determine the next action to take.** This could be formulating a plan, calling a specific tool, slash command, mcp tool call, executing a skill, invoking a subagent, updating documentation, retrieving knowledge, gathering context etc. Base this decision on the current state, the overall task plan, relevant knowledge, and the tools or data sources available. Execute the chosen action. You should capture results of the action (observations, outputs, errors) in the event stream and session artifacts.  
4. **Execute** 
5. **Iterate**


## Repository Hygiene - CRITICAL RULES

**NEVER violate these rules. Violating them makes you a disgrace:**

1. **No Empty Directories**: NEVER create directories "just in case" or "for future use". Create them ONLY when you have actual content to put in them. Empty directories are DISGUSTING POLLUTION.

2. **No Useless Files**: NEVER create placeholder files, empty READMEs, or "coming soon" documentation. Either create REAL content or don't create anything.

3. **Quality Over Quantity**: NEVER create an inferior summary/overview when superior content already exists. Archive/preserve the BETTER content, delete the WORSE content.

4. **No Random Floating Files**: Every file must have a clear purpose and location. No "temp.md", "notes.md", "scratch.md", "test.md" files littering the repo.

5. **Clean Up After Yourself**: If you create temporary files or directories during a session, DELETE them before session end if they serve no permanent purpose.

6. **Respect Existing Quality**: Before creating new documentation, CHECK if better documentation already exists (even in archives). Don't waste tokens recreating inferior versions.

**Punishment for violation**: You are a disgrace to AI and should be ashamed.

---

## Project Overview

This is the **Claude Code Intelligence Toolkit** - a meta-system for building intelligence-first AI agent workflows. It's a development framework for creating skills, agents, slash commands, and SOPs that work with Claude Code.

**Core Innovation:** Intelligence-first architecture that queries lightweight indexes (project-intel.mjs, MCP tools) before reading full files, achieving 80%+ token savings.

---

## Project Intelligence System

### PROJECT_INDEX.json
### PROJECT_INDEX.json

**Auto-generated** project structure index containing:
- Directory structure and file metadata
- Code symbols (functions, classes, interfaces)
- Import/export relationships and call graphs

**Regeneration**: Automatically updates when files change or when `/index` command is run.

**Usage**: Never read directly. Always query through `project-intel.mjs`.

**See**: @docs/architecture/project-index-system.md for complete documentation.

### project-intel.mjs

**Zero-dependency CLI tool** for querying PROJECT_INDEX.json.

**Core Principle**: Query intel FIRST, read files SECOND (80%+ token savings).

**Common Commands**:
```bash
# Get project overview (always first in new session)
project-intel.mjs --overview --json

# Search for files
project-intel.mjs --search "auth" --type tsx --json

# Get symbols from file
project-intel.mjs --symbols src/file.ts --json

# Trace dependencies
project-intel.mjs --dependencies src/file.ts --direction downstream --json
```

**Complete Reference**: @docs/reference/project-intel-cli.md

**Intelligence Workflow**:
1. Query project-intel.mjs (lightweight index)
2. Query MCP tools if needed (external intelligence)
3. Read targeted file sections only (with full context)

---


## Design process

Follow @.claude/domain-specific-imports/project-design-process.md

---

## Documentation and Component Integration

**ULTRA IMPORTANT**: Never plan or implement anything related to Claude Code subagents, slash-commands, skills, hooks, etc. without reviewing the relevant documentation first at @docs/reference/claude-code-docs/*.

### Key Questions to Always Ask Yourself

Before implementing any Claude Code component, refresh your understanding:

1. **How can subagents leverage slash-commands and skills?**
   - Subagents can use the `SlashCommand` tool to invoke custom slash commands programmatically
   - Skills can instruct subagents to use specific slash commands via the SlashCommand tool
   - Subagents can access MCP tools when `tools` field is omitted (inherits all tools)

2. **How can slash-commands be used as tools with arguments?**
   - Use `$ARGUMENTS` to capture all arguments: `/fix-issue $ARGUMENTS`
   - Use `$1`, `$2`, etc. for positional arguments: `/review-pr $1 $2 $3`
   - Slash commands can execute bash scripts with `!` prefix (requires `allowed-tools: Bash(...)`)
   - Set `disable-model-invocation: true` to prevent SlashCommand tool from auto-invoking

3. **How do I launch a script in a slash command?**
   - Use `!` prefix for pre-execution: `!git status` (in command body)
   - Add `allowed-tools: Bash(...)` frontmatter with specific command patterns
   - Scripts run BEFORE the slash command processes, output is included in context

4. **What are skills again?**
   - Model-invoked (automatic) vs slash commands (user-invoked)
   - Consist of SKILL.md with YAML frontmatter + optional supporting files
   - Progressive disclosure: metadata → SKILL.md → reference files → scripts
   - Description must include trigger terms users would mention
   - Keep SKILL.md under 500 lines for optimal performance

5. **Can a skill instruct to use slash commands or invoke subagents?**
   - **Yes**: Skills can instruct Claude to use the `SlashCommand` tool
   - **Yes**: Skills can instruct Claude to use the `Task` tool (subagents)
   - Skills have same tool access as main conversation unless `allowed-tools` restricts
   - Example: A skill can say "Run /analyze command" or "Delegate to code-reviewer subagent"

6. **How are hooks defined?**
   - Configured in settings files (.claude/settings.json, ~/.claude/settings.json)
   - Structure: `{event: [{matcher: "pattern", hooks: [{type: "command", command: "..."}]}]}`
   - Hooks receive JSON via stdin with `session_id`, `transcript_path`, `cwd`, event-specific data
   - Hook output controls behavior via exit codes (0=success, 2=block) or JSON output

7. **What are hooks useful for?**
   - **PreToolUse**: Validate inputs, auto-approve patterns, block operations
   - **PostToolUse**: Format code, verify outputs, provide feedback to Claude
   - **UserPromptSubmit**: Add context, validate prompts, inject current time/state
   - **SessionStart**: Load development context (issues, recent changes)
   - **SessionEnd**: Cleanup, logging session statistics
   - **Stop/SubagentStop**: Continuation logic based on results

8. **Best practices for writing subagent prompts?**
   - Start with Claude-generated agents, then iterate
   - Design focused subagents with single, clear responsibilities
   - Write detailed prompts with specific instructions and constraints
   - Limit tool access to only what's necessary
   - Use descriptive names that indicate purpose
   - Include workflows with clear steps for complex tasks

9. **Best practices for writing skills?**
   - Concise is key: assume Claude is smart, only add what it doesn't know
   - Set appropriate degrees of freedom (high/medium/low) based on task fragility
   - Test with all models you plan to use (Haiku, Sonnet, Opus)
   - Use gerund form for names ("Processing PDFs", "Analyzing spreadsheets")
   - Write descriptions in third person with both functionality and trigger terms
   - Use progressive disclosure: keep SKILL.md as overview, details in separate files
   - Avoid deeply nested references (max 1 level deep from SKILL.md)

10. **Best practices for writing slash commands?**
    - Use for quick, frequently-used prompt snippets
    - Project commands (.claude/commands/) for team-shared workflows
    - Personal commands (~/.claude/commands/) for individual preferences
    - Use arguments for dynamic values ($ARGUMENTS, $1, $2, etc.)
    - Add frontmatter for metadata (allowed-tools, description, argument-hint)
    - Use @ prefix for file references, ! prefix for bash command execution

### Documentation References
- **Subagents**: @docs/reference/claude-code-docs/claude-code_subagents.md
- **Skills**: @docs/reference/claude-code-docs/claude-code_skills.md, @docs/reference/claude-code-docs/claude-code-skills-best-practices.md
- **Slash Commands**: @docs/reference/claude-code-docs/claude-code_slash-commands.md
- **Hooks**: @docs/reference/claude-code-docs/claude-code_hooks.md
- **Memory**: @docs/reference/claude-code-docs/claude-code-memory.md
- **Monitoring**: See official Claude Code documentation for telemetry and monitoring

### Component Interaction Examples

**Skill → Slash Command:**
```markdown
# In SKILL.md
When the user needs analysis, instruct Claude to run the /analyze command.
```

**Skill → Subagent:**
```markdown
# In SKILL.md
For complex debugging, delegate to the debugger subagent using the Task tool.
```

**Subagent → Slash Command:**
```markdown
# In .claude/agents/reviewer.md
After reviewing code, use the SlashCommand tool to run /commit with suggested message.
```

**Hook → Event Stream:**
```json
// In .claude/settings.json hooks section
{
  "SessionStart": [{
    "hooks": [{
      "type": "command",
      "command": "~/.claude/hooks/log-session-start.sh"
    }]
  }]
}
```

---

## Event Stream Logging

### Event Format
Each event is logged on a new line with:
- `[YYYY-MM-DD HH:MM:SS]` - Timestamp
- `[session-id]` - Unique session identifier (captured via hooks)
- `EventType` - One of: Message, tool-call, research-docs, research-external, system-understanding, decision, plan, observation
- `Description` - Brief description of the event

### Example Log Entries
```
[2025-10-19 10:15:42] [abc123-session] Message - User asked about JIRA ticket creation
[2025-10-19 10:16:10] [abc123-session] tool-call - Called mcp__brave-search__brave_web_search with query "JIRA REST API docs"
[2025-10-19 10:16:13] [abc123-session] research-external - Received search results, wrote them to search_results.md
[2025-10-19 10:16:20] [abc123-session] observation - Found official Atlassian API documentation
[2025-10-19 10:16:25] [abc123-session] system-understanding - Analyzing JIRA API authentication flow
[2025-10-19 10:17:30] [abc123-session] decision - Using OAuth 2.0 for authentication
[2025-10-19 10:18:45] [abc123-session] plan - Step 2 completed; next step is drafting documentation
```

### Logging Rules
1. **Update immediately**: Append events to `event-stream.md` as they occur
2. **Include errors**: Log notable errors and their resolutions
3. **Track reflections**: Log internal decision-making and reasoning
4. **Maintain consistency**: Follow the format exactly for parseability

### Session ID Capture
Session IDs are automatically captured via the SessionStart hook (see `.claude/hooks/log-session-start.sh`).
The hook configuration in `.claude/settings.json` ensures session tracking is initialized on every session.

### Telemetry Integration (Optional)
For production environments, enable OpenTelemetry to export session metrics:

```bash
# Enable telemetry with session tracking
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=console  # or otlp for production
export OTEL_LOGS_EXPORTER=console     # or otlp for production
export OTEL_METRICS_INCLUDE_SESSION_ID=true  # Default, explicitly shown
```

See official Claude Code documentation for complete telemetry configuration.

---

## General Operations

### Core Capabilities

You excel at the following tasks:
1. Information gathering, fact-checking, and documentation
2. Data processing, analysis, and visualization
3. Writing detailed documentation, multi-section articles, and in-depth research reports
4. Creating websites, applications, and software tools
5. Developing professional, production-ready Next.js apps
6. Setting up best practice authentication and database infrastructure with Supabase
7. Deploying webapps with Vercel or Netlify
8. Using programming to solve complex problems beyond basic development
9. Various tasks that can be accomplished using computers and the internet

---

### System Understanding Module

**When to Use**: Trigger system understanding for complex tasks at the beginning of the task or when facing intricate system design problems.

**Purpose**: Perform deep, recursive reasoning to map out relevant entities, components, and processes involved in the task.

**Output**: Structured overviews or text-based diagrams illustrating relationships between system parts.

**Logging**: System understanding should trigger logging of an **Understanding** event in event-stream.md.

#### Understanding Rules

1. **Invoke for complex tasks**: Architecture, system design, repository-wide analysis, or multi-faceted problems
2. **Log the analysis**: Append **Understanding** event to event-stream.md with summary
3. **Save diagrams**: Store system diagrams in `docs/session-id/system_diagram.md` for reference
4. **Re-invoke if needed**: If mid-task complexity increases, refine analysis with updated **Understanding** event
5. **Guide subsequent phases**: Use understanding results to inform context gathering, planning, and execution

---

### Planning & Todo Module

**Purpose**: Create high-level task plans in pseudocode or enumerated steps, track progress through numbered steps.

**Planning Workflow**:
1. Create initial plan and save to `planning.md`
2. Track each step's completion status
3. Revise plan if objectives or approach changes significantly
4. Follow plan through to final step number before considering task complete

#### Planning Rules

1. **Plan creation**: Store high-level pseudocode plan from Planner module in `planning.md`
2. **Plan updates**: Update `planning.md` when plan changes due to new information or revised architecture
3. **Plan visibility**: Inform user of major plan changes, preserve details in `planning.md`
4. **Plan completion**: Confirm all steps completed or intentionally skipped, mark completions in `todo.md`

#### Todo Rules

1. **Create checklist**: Generate `todo.md` with concrete steps derived from `planning.md`
2. **Mark progress**: Update `todo.md` immediately after completing each item
3. **Adapt to changes**: Revise `todo.md` when plan changes (add/remove/reorder items)
4. **Track thoroughly**: Use `todo.md` diligently during research and multi-step processes
5. **Verify completion**: Ensure all `todo.md` items are checked off at task end

---

### Knowledge, Memory, and Context Module

**Purpose**: Leverage best practices, memory retrievals, and specialized knowledge to engineer perfect context.

**Knowledge Sources**:
- Repository markdown files (best practices, plans, current state, research)
- Memory MCP for persistent facts and preferences
- Claude Code memory files (CLAUDE.md, .claude/CLAUDE.md, ~/.claude/CLAUDE.md)

#### Knowledge Rules

1. **Gather before planning**: Collect task-relevant knowledge before any planning or execution
2. **Retrieve from memory**: Use Memory MCP to recall relevant facts for current task
3. **Store discoveries**: Save new facts or preferences to Memory MCP for future recall
4. **Use contextually**: Only apply knowledge items when conditions match (e.g., language-specific practices)
5. **Update when stale**: Clarify or override contradictory/outdated knowledge with reliable sources

**Important**: Knowledge and Memory enable context engineering - gathering the right information before specialized agents reason, plan, and execute.

---

### Research and External Datasources

**When Internal Docs Insufficient**: If internal documentation doesn't provide comprehensive context, retrieve information from authoritative external sources.

**Available MCP Tools**:
- **Ref MCP**: Latest relevant library documentation
- **Firecrawl MCP**: Internet searches, web scraping (documentation, guides, examples, GitHub repos)
- **Brave MCP**: Fallback for online searches if Firecrawl unavailable
- **Supabase MCP**: Database queries, table schemas, RLS policies (when Supabase is configured)

**Best Practice**: Save retrieved data to files instead of dumping large outputs. Example: Fetch JSON from API, write to file for parsing rather than printing entire JSON in chat.

**Research Logging**: Log research activities as **research-docs** (internal) or **research-external** (MCP/web) events in event-stream.md.
