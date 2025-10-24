# Code Intelligence Skill: Overview

**Target Audience**: AI coding agents
**Purpose**: Understand the code-intelligence skill as primary example of CoD^Σ + project-intel integration

## Why Code Intelligence as Primary Example?

The **code-intelligence** skill exemplifies advanced skill patterns:

1. **CoD^Σ Ultrathink Integration**: Token-efficient reasoning discipline
2. **CLI Tool Orchestration**: Wraps project-intel.mjs for repository analysis
3. **Progressive Disclosure**: Metadata → Workflows → CLI → References
4. **Structured Outputs**: JSON contracts with evidence linking
5. **Multi-Mode Operation**: Quick, standard, deep analysis modes

This makes it an ideal teaching example for building sophisticated skills.

## Problem Statement

### The Challenge

Agents analyzing codebases face:

**Token Explosion**:
- Reading entire files indiscriminately
- Loading full dependency trees
- Repeating analysis across conversations
- No caching or structured context

**Inconsistent Analysis**:
- Ad-hoc exploration patterns
- Missing critical dependencies
- Overlooking hotspots
- No systematic coverage

**Unclear Reasoning**:
- Hidden chain-of-thought
- No traceable evidence
- Difficult to verify claims
- Can't reproduce analysis

### The Solution

Code-intelligence skill provides:

**Token Efficiency via CoD^Σ**:
```
Compressed symbolic reasoning (≤5 tokens/line)
    ↓
Full prose only in final deliverables
    ↓
Systematic plan before execution
```

**Structured Analysis via project-intel**:
```
PROJECT_INDEX.json (static, cached)
    ↓
project-intel.mjs CLI (bounded queries)
    ↓
Structured JSON outputs (evidence-linked)
```

**Transparent Reasoning**:
```
<cod_sigma> block (public reasoning)
    ↓
Evidence references (f, g, deps, d, stats)
    ↓
Reproducible results
```

## System Architecture

### Components

```
┌─────────────────────────────────────────────────────┐
│            Code-Intelligence Skill                   │
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌──────────────────────────────────────────────┐  │
│  │        CoD^Σ Ultrathink Reasoning           │  │
│  │  (≤5 tokens/line symbolic notation)         │  │
│  └────────────┬─────────────────────────────────┘  │
│               ↓                                      │
│  ┌────────────────────────────────────────────────┐│
│  │        project-intel.mjs CLI                   ││
│  │  stats | tree | search | debug | callers |    ││
│  │  callees | trace | dead | docs | metrics      ││
│  └────────────┬───────────────────────────────────┘│
│               ↓                                      │
│  ┌────────────────────────────────────────────────┐│
│  │         PROJECT_INDEX.json                     ││
│  │  .f (files/symbols)  .g (call edges)          ││
│  │  .deps (imports)     .d (doc previews)        ││
│  │  .stats (metrics)                              ││
│  └──────────────────────────────────────────────┬─┘│
│                                                  │  │
│  ┌──────────────────────────────────────────────┘  │
│  │  Structured Deliverables                         │
│  │  • Evidence-linked findings                      │
│  │  • Relationship maps (calls, imports, routes)    │
│  │  • Actionable recommendations                    │
│  └──────────────────────────────────────────────────┘
└─────────────────────────────────────────────────────┘
```

### Data Flow

```
User Query: "What are the hotspots in this codebase?"
  ↓
[Skill Auto-Loads via Description Match]
  ↓
CoD^Σ Planning:
  Goal→hotspots
  Index→stats∧metrics
  Commands→report --json; metrics --json
  ↓
Execute CLI:
  $ project-intel report --json
  $ project-intel metrics --json
  ↓
CoD^Σ Synthesis:
  Hotspots→topInbound∧topOutbound
  Evidence→metrics.topInbound: [stringOrDefault, pdfTranslate]
  ↓
Structured Deliverable:
  {
    "findings": [{
      "id": "K1",
      "claim": "Hot inbound: stringOrDefault (50 callers)",
      "proof": "metrics.topInbound"
    }],
    "cod_sigma": "Goal→hotspots\n...",
    "commands_used": ["project-intel report --json", ...]
  }
```

## Key Innovations

### 1. CoD^Σ Ultrathink Reasoning

**Token Efficiency**:
```
Traditional:
  "First, I'll check the overall statistics of the repository
   to understand the size and scope. Then I'll analyze the
   hotspots by looking at functions with the most inbound calls..."
   (50+ tokens)

CoD^Σ:
  Goal→repo intel
  Index→stats∧top fns
  Hotspots→inbound∧outbound
  (12 tokens)
```

**Transparency**:
```xml
<cod_sigma>
Goal→pdf+email map
PDF→puppeteer∧pdf-lib
Entry→/api/generate-*
Service→/api/pdf/render
Email→templates∧resend-client
Risk⇒attachment anti‑pattern
#### flow mapped
</cod_sigma>
```

All reasoning visible, no hidden COT.

**Auto-Fallback**:
```
If reasoning becomes complex (>6 steps) or ambiguous:
→ Mark segment AUTO-FALLBACK
→ Switch to standard prose reasoning
→ Resume CoD^Σ when appropriate
```

### 2. Bounded CLI Queries

**Problem**: Unbounded queries can return massive results

**Solution**: Always use limiting flags

```bash
# ✅ Good: Bounded
project-intel search <term> -l 10 --json
project-intel callers <fn> -l 20 --json
project-intel tree --max-depth 3

# ❌ Bad: Unbounded
project-intel search <term>  # Could return 1000s of results
rg <pattern>                 # No max-count limit
```

**Benefits**:
- Predictable token usage
- Fast execution
- Focused results
- Repeatable analysis

### 3. Evidence-Linked Findings

Every claim references source:

```json
{
  "findings": [
    {
      "id": "K1",
      "claim": "Total files≈400, dirs≈255, TS≈270, MD≈118",
      "proof": "stats.*"
    },
    {
      "id": "K2",
      "claim": "Hot inbound: stringOrDefault, pdfTranslate, t",
      "proof": "metrics.topInbound"
    }
  ]
}
```

**Verification**:
```bash
# Anyone can verify K1
$ project-intel stats --json | jq '.total_files, .total_directories'
400
255

# Anyone can verify K2
$ project-intel metrics --json | jq '.topInbound[:3]'
["stringOrDefault", "pdfTranslate", "t"]
```

**Benefits**:
- Reproducible
- Verifiable
- Traceable
- Debuggable

### 4. Multi-Mode Operation

**Quick Mode** (~5 min, depth 1-2):
```
Commands: stats, tree --max-depth 2
Output: Top findings + 3 recommendations
Token budget: ~10k
```

**Standard Mode** (~30 min, depth ~3):
```
Commands: report, metrics, targeted search/debug
Output: Balanced report, 5-7 recommendations
Token budget: ~40k
```

**Deep Mode** (~1-4 hours, full depth):
```
Commands: Adaptive, comprehensive coverage
Output: Exhaustive map, risks, roadmap
Token budget: ~100k+
```

**Selection**:
- Quick: Initial exploration, narrow questions
- Standard: Feature planning, refactoring prep (default)
- Deep: Architecture review, comprehensive audit

## Workflow Patterns

### Pattern 1: Top-Down (System Map)

```
Goal→system map
  ↓
Commands: report --json; tree --max-depth 3
  ↓
Output: Routes∧APIs∧modules∧doc count
```

**Use**: Initial codebase understanding

### Pattern 2: Bottom-Up (Function Impact)

```
Goal→fn impact
  ↓
Commands: debug <fn>; callers <fn>; callees <fn>; trace <a> <b>
  ↓
Output: Call tree∧dependencies∧impact radius
```

**Use**: Understanding specific function's role

### Pattern 3: Docs Sweep (Documentation Audit)

```
Goal→doc inventory
  ↓
Commands: docs <term> -l 50 --json; group by basename
  ↓
Output: Duplicates∧canonical paths∧consolidation plan
```

**Use**: Documentation cleanup

### Pattern 4: Hygiene (Code Health)

```
Goal→dead∧cycles∧dupes
  ↓
Commands: dead -l 200 --json; metrics --json; search <util>
  ↓
Output: Candidates+risks∧potential refactorings
```

**Use**: Technical debt identification

## Integration with Skill System

### Auto-Discovery

**Triggering Description**:
```yaml
description: Use when analyzing codebases for hotspots, dependencies,
  call graphs, documentation, or code intelligence - provides
  structured analysis using project-intel CLI with CoD^Σ reasoning
  discipline for token-efficient, evidence-based insights
```

**Keywords**:
- "code intelligence", "codebase analysis"
- "hotspots", "dependencies", "call graph"
- "architecture", "documentation audit"
- "dead code", "cycles", "complexity"

### Progressive Disclosure

**Level 1: Metadata** (50 tokens):
```yaml
name: code-intelligence
description: [see above]
```

**Level 2: Instructions** (500-1000 tokens):
- CoD^Σ quick reference
- Workflow patterns
- CLI command cheatsheet
- Mode selection guidance

**Level 3: Resources**:
- `scripts/run_project_intel.py`: CLI wrapper
- `references/project-intel-cheatsheet.md`: Complete command reference
- `references/cod_sigma_ultrathink.md`: Detailed reasoning guide
- `references/workflows.md`: Complete workflow examples

### Subagent Dispatch

Code-intelligence can dispatch specialized subagents:

```markdown
For parallel analysis:
  - Dispatch index-analyzer (quick mode)
  - Dispatch parallel-index-analyzer (concurrent queries)
  - Dispatch deep-index-analyzer (comprehensive, includes code reading)

Each subagent uses CoD^Σ Ultrathink and returns structured JSON.
```

## Example Queries and Outputs

### Query 1: "What are the hot paths in the authentication flow?"

**CoD^Σ Reasoning**:
```
<cod_sigma>
Goal→auth flow
Entry→search "auth"∧"login"
Hotspots→callers∧callees
Trace→entry→db
#### auth mapped
</cod_sigma>
```

**Commands Used**:
```bash
project-intel search auth -l 20 --json
project-intel debug app/api/auth/login/route.ts --json
project-intel callers loginUser -l 30 --json
project-intel trace loginUser supabase.auth.signIn --json
```

**Output**:
```json
{
  "goal": "Map authentication flow hot paths",
  "evidence": {
    "files": ["app/api/auth/login/route.ts", ...],
    "symbols": ["loginUser", "validateCredentials", ...],
    "docs": []
  },
  "graphs": {
    "calls": [
      {"from": "LoginForm", "to": "loginUser"},
      {"from": "loginUser", "to": "validateCredentials"},
      {"from": "validateCredentials", "to": "supabase.auth.signIn"}
    ]
  },
  "findings": [
    {
      "id": "K1",
      "claim": "Entry: LoginForm → loginUser (app/api/auth/login/route.ts:45)",
      "proof": "f['app/api/auth/login/route.ts'].symbols['loginUser']"
    }
  ]
}
```

### Query 2: "Find duplicate utility functions"

**CoD^Σ Reasoning**:
```
<cod_sigma>
Goal→find dupes
Search→formatDate∧parseDate
Count→files with same name
Report→candidates
#### dupes found
</cod_sigma>
```

**Commands Used**:
```bash
project-intel search formatDate -l 50 --json
project-intel search parseDate -l 50 --json
project-intel metrics --json
```

**Output**:
```json
{
  "goal": "Identify duplicate utility functions",
  "findings": [
    {
      "id": "K1",
      "claim": "formatDate appears in 3 files with similar implementation",
      "proof": "search results show lib/utils/date.ts, components/DatePicker/utils.ts, app/helpers/format.ts"
    }
  ],
  "recommendations": [
    "Consolidate formatDate into lib/utils/date.ts",
    "Update imports in components/DatePicker and app/helpers",
    "Add deprecation comments to old locations"
  ]
}
```

## Benefits Summary

### For Agents

✅ **Clear process**: Explicit workflows, no guessing
✅ **Token efficient**: CoD^Σ reduces reasoning tokens by 70-80%
✅ **Reproducible**: Same index → same results
✅ **Verifiable**: Evidence links enable verification
✅ **Systematic**: No missed dependencies or hotspots

### For Users

✅ **Fast**: Bounded queries complete in seconds
✅ **Accurate**: Grounded in index, not hallucinations
✅ **Actionable**: Recommendations with priorities
✅ **Transparent**: Can see reasoning process
✅ **Cacheable**: Results can be reused

### For System

✅ **Scalable**: Works on codebases of any size
✅ **Composable**: Integrates with other skills/tools
✅ **Testable**: CLI commands testable independently
✅ **Maintainable**: Skills, CLI, and index evolve separately

## Next Steps

1. **Understand CoD^Σ** → Read `cod-sigma-reasoning.md`
2. **Learn CLI** → Read `project-intel-workflows.md`
3. **See Build Process** → Read `building-code-intel-skill.md`
4. **Study Working Example** → Examine `../../skill-templates/examples/code-intelligence/`
5. **Try It Out** → Use code-intelligence skill on a repository

## References

- **CoD^Σ Material**: `@docs/architecture/cod-sigma-framework.md`
- **Skill Development Guide**: `@docs/guides/developing-agent-skills.md` (see Part 2: Code Intelligence Skill example)
- **PROJECT_INDEX Docs**: See project-intel.mjs --help or `@docs/reference/project-intel-cli.md`
- **System Architecture**: `@docs/architecture/system-overview.md`

---

**Navigation**:
- [← Creating Skills Fundamentals](../../03-creating-skills-fundamentals.md)
- [Next: CoD^Σ Reasoning →](cod-sigma-reasoning.md)
