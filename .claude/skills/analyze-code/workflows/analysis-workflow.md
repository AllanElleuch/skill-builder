# Analysis Workflow: Intelligence-First Code Analysis

**Purpose**: Step-by-step process for code analysis using intel-first approach, achieving 80-95% token savings.

**Constitutional Authority**: Article I (Intelligence-First Principle)

---

## The Process

Copy this checklist to track progress:

```
Analysis Progress:
- [ ] Phase 1: Scope (analysis-spec.md created)
- [ ] Phase 2: Intel Queries (4 query types executed)
- [ ] Phase 3: MCP Verification (findings verified)
- [ ] Phase 4: Report (CoD^Σ trace complete)
```

---

## Phase 1: Define Scope

**Create analysis-spec.md** using `@.claude/templates/analysis-spec.md` template to define:

### 1. Objective: What question are we answering?

**Examples**:
- "Why does LoginForm re-render infinitely?"
- "What causes 500 error on checkout?"
- "Is there circular dependency in auth module?"
- "What are the performance bottlenecks in data processing?"

**Requirements**:
- Clear, specific, answerable question
- Focused on single aspect (bug, architecture, performance, or security)
- Success criteria defined upfront

### 2. Scope: What's in/out of scope?

**In-Scope** (what we will analyze):
- Specific components, files, functions
- Related dependencies and data flows
- Immediate context for the issue

**Out-of-Scope** (what we won't analyze):
- Backend APIs (if frontend issue)
- Database queries (if UI issue)
- Third-party library internals
- Production environment specifics

**Guidelines**:
- Be explicit about boundaries
- Focus on what's necessary to answer objective
- Defer out-of-scope items to separate analysis

### 3. Success Criteria: How do we know when done?

**Requirements**:
- Testable conditions
- Specific deliverables
- Evidence requirements

**Examples**:
- "Root cause identified with file:line reference"
- "Complete dependency graph generated with mermaid diagram"
- "Performance bottleneck located with ≥90% confidence"
- "Security vulnerability confirmed with CVE reference"

---

### Example Analysis Spec

```markdown
---
spec_id: "analysis-login-rerender"
type: "bug-diagnosis"
created: "2025-01-19"
---

## Objective
Identify why LoginForm component re-renders infinitely in development environment.

## Scope

**In-Scope:**
- LoginForm component (src/components/LoginForm.tsx)
- useEffect hooks and their dependencies
- State management related to login (useState, useReducer)
- Component props and context usage

**Out-of-Scope:**
- Backend API endpoints
- Database queries
- Production environment (issue only in dev)
- CSS/styling issues
- Network requests

## Success Criteria
- [ ] Root cause identified with specific file:line reference
- [ ] Fix approach validated with React official docs (via Ref MCP)
- [ ] CoD^Σ trace shows complete reasoning chain from symptom to root cause
- [ ] Recommended fix includes code example and testing approach

## Context
- Issue appears only in React StrictMode (development)
- Console shows repeated renders without user interaction
- Component was recently modified to add lastLogin tracking
```

---

### Enforcement Checklist

Before proceeding to Phase 2:

- [ ] **Objective is clear and answerable** - Not vague like "make it better"
- [ ] **In-scope/out-of-scope explicitly defined** - Clear boundaries
- [ ] **Success criteria are testable** - Can verify when done
- [ ] **Analysis spec created** in analysis-spec.md file
- [ ] **Context captured** if relevant (recent changes, environment, error messages)

---

## Phase 2: Execute Intel Queries

**CRITICAL:** Execute ALL intel queries BEFORE reading any files.

**Principle**: Query lightweight indexes first (1-2% of tokens), then read targeted sections only.

---

### Query 1: Project Overview (if first analysis in session)

```bash
project-intel.mjs --overview --json > /tmp/analysis_overview.json
```

**Purpose:** Understand project structure, entry points, file counts

**What you get**:
- Total files and directories
- File type distribution (tsx, ts, js, etc.)
- Project structure overview
- Entry points (if identifiable)

**Tokens:** ~50

**When to skip**: If you already ran overview query in current session

---

### Query 2: Search for Relevant Files

```bash
project-intel.mjs --search "<pattern>" --type <filetype> --json > /tmp/analysis_search.json
```

**Purpose:** Locate files related to objective

**Pattern Strategies**:
- Bug diagnosis: Search for error message keywords, component names
- Architecture: Search for module/package names, entry points
- Performance: Search for suspected slow operations (query, render, process)
- Security: Search for auth, validate, sanitize, encrypt

**Type Filters**:
- `--type tsx` for React components
- `--type ts` for TypeScript files
- `--type js` for JavaScript
- Omit `--type` to search all files

**Tokens:** ~100

**Example**:
```bash
# For "login form infinite render" analysis
project-intel.mjs --search "login" --type tsx --json

# Result excerpt:
{
  "results": [
    {"path": "src/components/LoginForm.tsx", "type": "file"},
    {"path": "src/components/LoginButton.tsx", "type": "file"},
    {"path": "src/auth/LoginAPI.ts", "type": "file"}
  ]
}
```

**Now you know:** Which files are candidates for analysis

---

### Query 3: Symbol Analysis

**For each relevant file from Query 2:**

```bash
project-intel.mjs --symbols <filepath> --json > /tmp/analysis_symbols_<filename>.json
```

**Purpose:** Understand functions/classes/exports without reading full file

**What you get**:
- Function names with line numbers
- Class definitions
- Exported symbols
- Import statements

**Tokens:** ~150 per file

**Example**:
```bash
project-intel.mjs --symbols src/components/LoginForm.tsx --json

# Result excerpt:
{
  "symbols": [
    {"name": "LoginForm", "type": "function", "line": 12},
    {"name": "useEffect", "type": "hook", "line": 45},
    {"name": "useState", "type": "hook", "line": 15},
    {"name": "handleLogin", "type": "function", "line": 60}
  ],
  "imports": [
    "react",
    "../auth/LoginAPI"
  ]
}
```

**Now you know:** WHERE specific functions/hooks are (line numbers)

---

### Query 4: Dependency Tracing

**For key files identified in Query 3:**

#### Upstream Dependencies (What does this file import?)

```bash
project-intel.mjs --dependencies <filepath> --direction upstream --json > /tmp/analysis_deps_up.json
```

**Purpose:** Understand what this file depends on

**Example**:
```bash
project-intel.mjs --dependencies src/components/LoginForm.tsx --direction upstream --json

# Result: LoginForm depends on:
# - react (external)
# - ../auth/LoginAPI.ts (internal)
# - ../types/User.ts (internal)
```

#### Downstream Dependencies (What imports this file?)

```bash
project-intel.mjs --dependencies <filepath> --direction downstream --json > /tmp/analysis_deps_down.json
```

**Purpose:** Understand impact of changes to this file

**Example**:
```bash
project-intel.mjs --dependencies src/auth/LoginAPI.ts --direction downstream --json

# Result: LoginAPI is imported by:
# - src/components/LoginForm.tsx
# - src/pages/LoginPage.tsx
# - src/services/AuthService.ts
```

**Tokens:** ~200 total (both directions)

**Now you know:** Complete dependency graph for targeted files

---

### Token Comparison

**Traditional Approach** (reading full files):
```
Reading LoginForm.tsx (1000 lines): ~3000 tokens
Reading LoginAPI.ts (500 lines): ~1500 tokens
Reading AuthService.ts (800 lines): ~2400 tokens
Total: ~6900 tokens
```

**Intelligence-First Approach**:
```
Query 1 (overview): 50 tokens
Query 2 (search "login"): 100 tokens
Query 3 (symbols for 3 files): 450 tokens
Query 4 (dependencies): 200 tokens
Targeted reads (30 lines each × 3): 300 tokens
Total: ~1100 tokens
```

**Savings: 84%** (1100 vs 6900 tokens)

---

### Enforcement Checklist

Before proceeding to Phase 3:

- [ ] **All 4 query types executed** (overview, search, symbols, dependencies)
- [ ] **Intel results saved to /tmp/** for evidence trail
- [ ] **No files read before intel queries complete** - Critical rule
- [ ] **Candidate files identified** (from search results)
- [ ] **Key functions/symbols located** (from symbols query with line numbers)
- [ ] **Dependency graph understood** (from dependencies query)

**If any checklist item fails**: Stop and complete intel queries before reading files

---

## Phase 3: MCP Verification

**Purpose:** Verify findings with authoritative external sources (library documentation, best practices, security advisories)

---

### When to Use Each MCP

| MCP Tool | Use For | Example Queries |
|----------|---------|-----------------|
| **Ref** | Library/framework behavior | React hooks rules, Next.js routing, TypeScript types |
| **Context7** | External package docs | lodash methods, axios config, moment.js usage |
| **Supabase** | Database schema, RLS | Table structure, column types, policies |
| **Shadcn** | Component patterns | shadcn/ui component props, usage examples |
| **Chrome** | Runtime validation | E2E testing, browser behavior, DOM interaction |

---

### MCP Verification Pattern

**Template for documenting verification**:

```markdown
## Intel Finding
[What intelligence queries revealed]

## MCP Verification
**Tool:** [Which MCP tool]
**Query:** [Exact query executed]
**Result:** [What authoritative source says]

## Comparison
- **Intel shows:** [From project-intel.mjs]
- **Docs require:** [From MCP verification]
- **Conclusion:** [Agreement or discrepancy]
```

---

### Example: React Hook Dependencies

```markdown
## Intel Finding
useEffect at src/LoginForm.tsx:45 has dependency array [user]

## MCP Verification
**Tool:** Ref MCP
**Query:** ref_search_documentation "React useEffect dependencies"
**Result:** Official React docs confirm:
"Every value referenced inside the effect body must be included in the dependency array"

## Comparison
- **Intel shows:** useEffect(() => { setUser({...user, lastLogin: Date.now()}) }, [user])
- **Docs require:** All values referenced (user, setUser) should be in dependencies
- **Conclusion:** Missing dependencies confirmed ✓
  - Effect reads `user` (included ✓)
  - Effect calls `setUser` (missing ✗)
  - Effect creates new object spreading user (causes infinite loop when user in deps)
```

---

### Enforcement Checklist

Before proceeding to Phase 4:

- [ ] **At least 1 MCP verification** for non-trivial findings (especially library/framework issues)
- [ ] **MCP results documented** in Evidence section with tool name and query
- [ ] **Discrepancies flagged** if intel and MCP contradict (investigate further)
- [ ] **Source URLs captured** when MCP provides documentation links

**When to skip MCP**: Internal code logic issues that don't involve external libraries

---

## Phase 4: Generate Report

**Create comprehensive report** using `@.claude/templates/report.md` template

---

### Required: CoD^Σ Trace

**Every report MUST include complete reasoning chain** showing step-by-step analysis process.

#### CoD^Σ Trace Structure

```markdown
## CoD^Σ Trace

**Claim:** [Your conclusion with file:line reference]

**Trace:**
```
Step 1: → IntelQuery("search <pattern>")
  ↳ Source: project-intel.mjs --search "<pattern>" --type <type>
  ↳ Data: [What was found]
  ↳ Tokens: [Token count]

Step 2: ⇄ IntelQuery("analyze symbols")
  ↳ Source: project-intel.mjs --symbols <file>
  ↳ Data: [Functions/classes found with line numbers]
  ↳ Tokens: [Token count]

Step 3: → TargetedRead(lines X-Y)
  ↳ Source: Read <file> (lines X-Y only)
  ↳ Data: [Relevant code excerpt]
  ↳ Tokens: [Token count]

Step 4: ⊕ MCPVerify("<tool>")
  ↳ Tool: <MCP tool> - "<query>"
  ↳ Data: [What authoritative source says]
  ↳ Tokens: [Token count]

Step 5: ∘ Conclusion
  ↳ Logic: [Reasoning from data to conclusion]
  ↳ Root Cause: <file>:<line> - [What's wrong]
  ↳ Fix: [How to resolve]
```
**Total Tokens:** [Sum] (vs [baseline] for reading full files)
**Savings:** [Percentage]
```
```

---

### Example Complete CoD^Σ Trace

```markdown
## CoD^Σ Trace

**Claim:** LoginForm re-renders infinitely due to incomplete useEffect dependencies at src/components/LoginForm.tsx:47

**Trace:**
```
Step 1: → IntelQuery("search login")
  ↳ Source: project-intel.mjs --search "login" --type tsx
  ↳ Data: Found LoginForm.tsx, LoginButton.tsx, LoginAPI.ts
  ↳ Tokens: 100

Step 2: ⇄ IntelQuery("analyze symbols")
  ↳ Source: project-intel.mjs --symbols src/components/LoginForm.tsx
  ↳ Data: LoginForm component at line 12, useEffect hook at line 45, useState at line 15
  ↳ Tokens: 150

Step 3: → TargetedRead(lines 40-60)
  ↳ Source: Read src/components/LoginForm.tsx (lines 40-60)
  ↳ Data: useEffect(() => { setUser({...user, lastLogin: Date.now()}) }, [user])
  ↳ Tokens: 100
  ↳ Analysis: Effect depends on [user], mutates user object, creates new reference

Step 4: ⊕ MCPVerify("React docs")
  ↳ Tool: Ref MCP - "React useEffect dependencies"
  ↳ Data: "Every value referenced inside effect must be in dependency array"
  ↳ Source: https://react.dev/reference/react/useEffect
  ↳ Tokens: 200

Step 5: ∘ Conclusion
  ↳ Logic:
    - Effect depends on [user] ✓
    - Effect mutates user → new object reference
    - New user reference triggers effect again → infinite loop
  ↳ Root Cause: src/components/LoginForm.tsx:47 - incomplete dependency array
  ↳ Fix: Use functional setState: setUser(prev => ({...prev, lastLogin: Date.now()}))
         OR remove user from dependencies if not needed
```
**Total Tokens:** 550 (vs 3000+ for reading full file)
**Savings:** 82%
```
```

---

### Report Sections

#### 1. Summary (max 200 tokens)
- **Key Finding**: One-sentence conclusion
- **Root Cause**: file:line reference with specific issue
- **Recommended Fix**: Actionable, specific solution

#### 2. CoD^Σ Trace (as shown above)
- Complete reasoning chain
- Token count for each step
- Final token savings calculation

#### 3. Evidence
- All intel query results (saved to /tmp/ files)
- MCP verification results (tool, query, response)
- Targeted file excerpts (only relevant lines)

#### 4. Recommendations
- **Specific fixes** with code examples
- **Implementation guidance** (what to change, where, how)
- **Testing approach** (how to verify fix works)
- **Prevention** (how to avoid similar issues)

---

### File Naming Convention

Save report as: `YYYYMMDD-HHMM-report-<descriptive-id>.md`

**Examples**:
- `20250119-1430-report-login-infinite-render.md`
- `20250119-1502-report-checkout-500-error.md`
- `20250119-1530-report-circular-dependency-auth.md`

---

### Enforcement Checklist

Before finalizing report:

- [ ] **Report uses template structure** (@.claude/templates/report.md)
- [ ] **CoD^Σ trace complete** with all steps documented
- [ ] **Every claim has evidence** (file:line or MCP reference)
- [ ] **Recommendations are specific** (code examples, not vague advice)
- [ ] **Token savings calculated** (comparison to baseline approach)
- [ ] **Total report ≤ 1000 tokens** when populated (excluding evidence appendix)

---

## Workflow Complete

After Phase 4 completes, you have:
- ✅ Analysis spec defining scope
- ✅ Intel query results saved to /tmp/
- ✅ MCP verification of findings
- ✅ Comprehensive report with CoD^Σ trace
- ✅ 80-95% token savings vs direct file reading

**Next**: Proceed to related skills based on findings (debug-issues for bugs, create-implementation-plan for fixes)
