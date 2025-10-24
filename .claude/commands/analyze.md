---
description: Perform intelligence-first code analysis using analyze-code skill to understand bugs, architecture, dependencies, performance, or security concerns (project)
allowed-tools: Bash(project-intel.mjs:*), Bash(sed:*), Bash(jq:*), Read, Grep, Glob
---

## Pre-Execution

!`project-intel.mjs stats --json > /tmp/project_overview.json`

# Analyze Command - Intelligence-First Code Analysis

You are now executing the `/analyze` command. This command performs comprehensive code analysis using the **intelligence-first approach** to understand bugs, architecture, dependencies, performance issues, or security concerns.

## Your Task

Analyze this codebase or specific issue using the **analyze-code skill** (@.claude/skills/analyze-code/SKILL.md).

## Process Overview

Follow the analyze-code skill workflow:

1. **Define Scope** (Phase 1)
   - Create @.claude/templates/analysis-spec.md
   - Define objective, scope (in/out), and success criteria
   - Save as: `YYYYMMDD-HHMM-analysis-spec-{id}.md`

2. **Execute Intel Queries** (Phase 2)
   - **CRITICAL:** Query project-intel.mjs BEFORE reading ANY files
   - Use @.claude/shared-imports/project-intel-mjs-guide.md for query syntax
   - Execute all 4 query types:
     - Overview (already done: /tmp/project_overview.json)
     - Search for relevant files
     - Symbol analysis for each file
     - Dependency tracing
   - Save intel results to /tmp/analysis_*.json for evidence

3. **MCP Verification** (Phase 3)
   - Verify findings with authoritative sources
   - Use Ref MCP for library behavior
   - Use Supabase MCP for database schema
   - Document all MCP queries using @.claude/templates/mcp-query.md

4. **Generate Report** (Phase 4)
   - Use @.claude/templates/report.md
   - Include complete CoD^Σ trace with evidence
   - Every claim must have file:line or MCP source
   - Save as: `YYYYMMDD-HHMM-report-{id}.md`

## Intelligence-First Enforcement

**NEVER read full files before intel queries.**

Example workflow:
```bash
# 1. Search for relevant files
project-intel.mjs --search "pattern" --type tsx --json > /tmp/analysis_search.json

# 2. Analyze symbols
project-intel.mjs --symbols src/file.tsx --json > /tmp/analysis_symbols.json

# 3. Trace dependencies
project-intel.mjs --dependencies src/file.tsx --direction upstream --json > /tmp/analysis_deps.json

# 4. NOW read targeted lines only
sed -n '40,60p' src/file.tsx  # Read only 20 lines, not entire file
```

## Token Budget

Your target: **1500-3000 tokens** for complete analysis (vs 15000-30000 without intel-first)

Breakdown:
- Intel queries: ~500 tokens
- MCP verification: ~300 tokens
- Targeted reads: ~500 tokens
- Report generation: ~1500 tokens

## Reasoning Framework

Use **@.claude/shared-imports/CoD_Σ.md** for all reasoning traces.

Every step in your analysis must use CoD^Σ notation:
- `→` for intel queries
- `⇄` for dependency queries
- `⊕` for MCP verification
- `∘` for conclusions

## Expected Outputs

1. **analysis-spec.md** - Scope definition (Phase 1)
2. **report.md** - Final analysis with CoD^Σ trace (Phase 4)
3. *Optional:* **mcp-query.md** - MCP verification results (Phase 3)

## Success Criteria

Before completing, verify:
- [ ] All intel queries executed before file reads
- [ ] Complete CoD^Σ trace documented
- [ ] Every claim has evidence (file:line or MCP)
- [ ] Report uses template structure
- [ ] Token usage 80%+ less than direct reading

## Start Now

Begin by defining the analysis scope using @.claude/templates/analysis-spec.md. If the user hasn't specified what to analyze, ask them:

- What specific issue are you investigating?
- Which components/files should be in scope?
- What does success look like (what question should be answered)?

Then proceed with the analyze-code skill workflow.
