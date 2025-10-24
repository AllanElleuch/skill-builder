# CoD^Σ (Chain-of-Draft Sigma) Ultrathink Reasoning Framework

**Target Audience**: AI coding agents
**Purpose**: Master token-efficient, transparent reasoning for code intelligence
**Context**: Primary reasoning discipline for code-intelligence skill

---

## Table of Contents

1. [Overview](#overview)
2. [Micro-Notation Grammar](#micro-notation-grammar)
3. [Traditional vs CoD^Σ Comparison](#traditional-vs-codσ-comparison)
4. [AUTO-FALLBACK Pattern](#auto-fallback-pattern)
5. [Quality Gates](#quality-gates)
6. [Examples from project-intel Workflows](#examples-from-project-intel-workflows)
7. [Best Practices](#best-practices)

---

## Overview

### What is CoD^Σ Ultrathink?

CoD^Σ (Chain-of-Draft Sigma) Ultrathink is a **token-efficient reasoning framework** designed for AI agents performing code analysis. Instead of verbose, hidden chain-of-thought reasoning, CoD^Σ uses **compressed symbolic notation** to make intermediate reasoning steps:

- **Public**: All reasoning visible in `<cod_sigma>` blocks
- **Compressed**: ≤5 tokens per line using mathematical symbols
- **Systematic**: Structured approach to planning and execution
- **Verifiable**: Every step traceable and reproducible

### Why Token Efficiency Matters

Traditional reasoning consumes excessive tokens:

```
Traditional approach (verbose, hidden):
"First, I need to understand the overall structure of the repository
by analyzing the statistics. Then I should identify the hotspots by
examining functions with the most inbound and outbound calls. After
that, I'll need to trace the critical paths through the call graph
to understand dependencies..."

Token count: ~50+ tokens for planning alone
```

CoD^Σ achieves **70-80% token reduction**:

```xml
<cod_sigma>
Goal→repo intel
Index→stats∧top fns
Hotspots→inbound∧outbound
Modules→top importers
Docs→count∧locations
#### snapshot ready
</cod_sigma>

Token count: ~15 tokens for complete plan
```

This efficiency enables:
- **Longer context usage**: More room for actual data
- **Faster reasoning**: Less to process means quicker results
- **Clearer plans**: Compressed notation forces precision
- **Better caching**: Structured reasoning easier to reuse

### Core Principle: ≤5 Tokens Per Line

Every CoD^Σ line must contain **at most 5 tokens**:

```
✅ Goal→pdf flow                    (3 tokens)
✅ Entry→submit api                 (3 tokens)
✅ Deps→pdf-lib∧puppeteer          (3 tokens: Deps→, pdf-lib∧puppeteer)
✅ Guard⇒auth∧rate‑limit           (3 tokens: Guard⇒, auth∧rate‑limit)
✅ Risk⇒attachment anti‑pattern    (4 tokens)

❌ Goal is to map the PDF generation flow     (9 tokens - too verbose)
❌ Entry point is the submit questionnaire API (8 tokens - use symbols)
```

**Why this limit?**
- Forces **elimination of filler words** (is, the, to, etc.)
- Encourages **symbolic thinking** over prose
- Maintains **scanability** and quick comprehension
- Enables **consistent parsing** and analysis

### Transparency: No Hidden Chain-of-Thought

Unlike traditional hidden reasoning, CoD^Σ makes **all reasoning public**:

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

This `<cod_sigma>` block appears **directly in the output**, allowing:
- Users to **verify reasoning steps**
- Other agents to **understand the approach**
- Debugging when results are unexpected
- Learning patterns from successful analyses

**Contract**: You MUST emit `<cod_sigma>` blocks for all intermediate reasoning. No hidden thinking steps.

---

## Micro-Notation Grammar

### Symbol Reference

CoD^Σ uses mathematical and logical symbols for maximum compression:

#### Flow and Relationships

| Symbol | Meaning | Example |
|--------|---------|---------|
| `→` | Flow, maps to, leads to | `Entry→submit api` |
| `↦` | Transforms to, renders as | `Email→templates↦resend-client` |
| `⇒` | Calls, invokes, implies | `Guard⇒auth∧rate‑limit` |
| `⇐` | Depends on, imported by | `B ⇐ A` (B depends on A) |
| `↔` | Bidirectional, mutual | `reducer↔dispatch` |

#### Logical Operators

| Symbol | Meaning | Example |
|--------|---------|---------|
| `∧` | And, conjunction | `puppeteer∧pdf-lib` |
| `∨` | Or, disjunction | `format∨validate` |
| `¬` | Not, negation | `¬auth` (not authenticated) |
| `⊕` | Exclusive or, choice | `X ⊕ Y` (X or Y, not both) |
| `∥` | Parallel execution | `X ∥ Y` (concurrent) |

#### Set Operations

| Symbol | Meaning | Example |
|--------|---------|---------|
| `∘` | Composition | `f∘g` (f composed with g) |
| `∪` | Union | `A∪B` |
| `∩` | Intersection | `shared∩utils` |
| `⊂` | Subset | `A⊂B` |
| `⊆` | Subset or equal | `auth-utils⊆utils` |
| `⊃` | Superset | `B⊃A` |
| `⊇` | Superset or equal | `utils⊇auth-utils` |

#### Comparison and Math

| Symbol | Meaning | Example |
|--------|---------|---------|
| `≤` | Less than or equal | `depth≤3` |
| `≥` | Greater than or equal | `count≥10` |
| `≈` | Approximately, similar | `files≈400` |
| `~` | Similar to, matches | `dup~content` |
| `≠` | Not equal | `A≠B` |
| `=` | Equals, assigns | `r := p·impact` |
| `·` | Multiply, and | `risk·impact` |
| `∑` | Sum, aggregate | `∑files` |
| `∏` | Product, combination | `∏modules` |

#### Special Symbols

| Symbol | Meaning | Example |
|--------|---------|---------|
| `⊥` | Bottom, empty, none | `result⊥` (no result) |
| `⊤` | Top, all, complete | `coverage⊤` (full coverage) |
| `\|E\|` | Edge count | `\|E\|=150` |
| `\|V\|` | Vertex count | `\|V\|=400` |
| `⌊x⌋` | Floor | `⌊3.7⌋=3` |
| `⌈x⌉` | Ceiling | `⌈3.2⌉=4` |
| `∂` | Partial, delta | `∂changes` |

### Entity Tokens

Entities (files, functions, modules, concepts) use **kebab-case or snake_case** naming, limited to **≤3 words**:

```
✅ Good entity tokens:
   submit-api
   pdf-lib
   auth-guard
   rate-limit
   combined-generator
   fillable-orchestrator
   email-templates
   resend-client

❌ Bad entity tokens:
   submitQuestionnaireAPI          (camelCase - harder to read)
   generate_fillable_pdf_route     (too long - 4+ words)
   the-submission-handler          (includes filler word "the")
```

**Hyphenation for compound terms**:
```
rate‑limit    (not rate limit - hyphen clarifies it's one token)
anti‑pattern  (not anti pattern)
dead‑code     (not dead code)
```

### Line Structure

Each line follows the pattern: **concept symbol concept**, ≤5 tokens total.

**Basic structures**:

```
Goal→<target>                          # State objective
Entry→<file-or-route>                  # Identify entry point
Deps→<lib1>∧<lib2>                     # List dependencies
Service→<endpoint>                     # Identify service
Guard⇒<check1>∧<check2>               # List guard conditions
Flow→<step1>→<step2>→<step3>          # Trace flow
Risk⇒<issue>                           # Flag risk
#### <completion-marker>                # Mark section complete
```

**Advanced structures**:

```
# Fanout (one to many)
A→{B,C,D}

# Fanin (many to one)
{B,C}⇒D

# Conditional flow
A →[cond] B

# Parallel execution
X ∥ Y ∥ Z

# Risk calculation
r := p·impact

# Count or measurement
files≈400; TS≈270
```

### Examples in Context

#### Example 1: Simple Flow
```xml
<cod_sigma>
Goal→pdf flow
Entry→generate-api
Service→render-endpoint
Deps→puppeteer∧pdf-lib
#### flow mapped
</cod_sigma>
```

**Translation**: "The goal is to map the PDF flow. The entry point is the generate API. The service is the render endpoint. Dependencies are puppeteer and pdf-lib. Flow mapping is complete."

#### Example 2: Complex Flow with Branches
```xml
<cod_sigma>
Goal→submit→pdf→email
Entry→/api/questionnaire/submit
PDF_A→fillable→puppeteer
PDF_B→combined→pdf-lib
Service→/api/pdf/render
Email→templates↦resend-client
Auth⇒token-signer
RateLimit⇒doctor rate‑limit
Risk⇒attach misuse
#### pipeline done
</cod_sigma>
```

**Translation**: "Map the submit to PDF to email pipeline. Entry is the submit API. There are two PDF paths: A uses fillable forms with puppeteer, B uses combined generation with pdf-lib. Both use the render service. Email uses templates transformed via resend-client. Auth invokes token-signer. Rate limiting invokes doctor rate-limiter. Risk identified: attachment misuse. Pipeline mapping complete."

#### Example 3: Analysis Planning
```xml
<cod_sigma>
Goal→hygiene scan
Dead→fn no callers
Cycles→SCC hints
Dupes→name≥3 files
Warn⇒framework magic
#### hygiene candidates
</cod_sigma>
```

**Translation**: "Scan code hygiene. Look for dead code (functions with no callers). Identify cycles using strongly connected component hints. Find duplicates (names appearing in 3+ files). Warning: framework may hide entrypoints via dynamic routing. Hygiene candidate identification complete."

---

## Traditional vs CoD^Σ Comparison

### Side-by-Side Example 1: Repository Analysis

**Traditional (Hidden Chain-of-Thought)**:
```
First, I need to understand the overall structure and size of this
repository. I'll start by examining the statistics to get counts of
files, directories, TypeScript files, and markdown documentation.
Then, I should identify the hotspot functions - those with the most
inbound calls, as they're likely critical dependencies - and the
functions with the most outbound calls, as they orchestrate complex
operations. I'll also need to understand the module ecosystem by
looking at the most frequently imported external libraries. Finally,
I should count and locate documentation files to understand coverage.

Tokens: ~105
Result: Hidden from user, can't verify reasoning
```

**CoD^Σ (Public, Compressed)**:
```xml
<cod_sigma>
Goal→repo intel
Index→stats∧top fns
Hotspots→inbound∧outbound
Modules→top importers
Docs→count∧locations
#### snapshot ready
</cod_sigma>

Tokens: ~15 (85% reduction)
Result: Public, verifiable, systematic
```

### Side-by-Side Example 2: Feature Flow Analysis

**Traditional**:
```
To map the PDF generation and email flow, I'll begin by searching for
PDF-related code and identifying the main entry points. There appear
to be multiple PDF generation paths - one using fillable forms with
puppeteer for rendering, and another using pdf-lib for composing PDFs
directly. I need to trace how these connect to the rendering service.
For email, I should find the template definitions and the client
responsible for sending. I also need to identify potential risks,
particularly around attachment handling which can be error-prone.

Tokens: ~95
Result: Scattered, hard to extract structure
```

**CoD^Σ**:
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

Tokens: ~17 (82% reduction)
Result: Structured, clear branches, risk flagged
```

### Token Savings Analysis

Across typical code intelligence tasks:

| Task Type | Traditional Tokens | CoD^Σ Tokens | Savings |
|-----------|-------------------|--------------|---------|
| Repository overview | 80-120 | 12-20 | 75-85% |
| Feature flow mapping | 100-150 | 15-30 | 70-80% |
| Dependency analysis | 60-90 | 10-18 | 75-83% |
| Documentation audit | 70-100 | 12-22 | 71-83% |
| Hygiene scan | 90-130 | 15-25 | 75-83% |

**Average savings**: 70-80% token reduction

### Clarity Benefits

**Traditional** reasoning often:
- Buries key decisions in prose
- Mixes planning with justification
- Lacks clear structure
- Difficult to scan quickly

**CoD^Σ** reasoning:
- **Scannable**: Read entire plan in 2-3 seconds
- **Structured**: Clear sections (Goal, Entry, Deps, etc.)
- **Focused**: No filler, only essential information
- **Pattern-based**: Reusable templates emerge naturally

Example - spotting the critical path:

Traditional:
```
[User must read 100+ words to find:
 entry → fillable orchestrator → puppeteer generator → render service]
```

CoD^Σ:
```
Entry→/api/generate-*
PDF_A→fillable→puppeteer
Service→/api/pdf/render
[Path visible immediately in 3 lines]
```

### Traceability Improvements

**Traditional**:
```
Reasoning: Hidden
Evidence: Unclear what was checked
Verification: Can't reproduce
Commands: Not linked to reasoning steps
```

**CoD^Σ**:
```xml
<cod_sigma>
Goal→pdf flow
Entry→search pdf -l 50
Service→debug render route
Deps→check pdf-lib∧puppeteer
#### flow mapped
</cod_sigma>

<commands_used>
project-intel search pdf -l 50
project-intel debug app/api/pdf/render/route.ts
project-intel search pdf-lib -l 20
project-intel search puppeteer -l 20
</commands_used>
```

**Traceability**:
- Each CoD^Σ line maps to 1-3 commands
- Commands produce evidence (file paths, symbols)
- Evidence linked back to claims
- Anyone can re-run commands to verify

---

## AUTO-FALLBACK Pattern

### When Complexity Exceeds CoD^Σ Limits

CoD^Σ excels at **systematic, structured analysis**. However, some situations require **standard prose reasoning**:

**Trigger AUTO-FALLBACK when**:

1. **Complexity > 6 steps per segment**
   ```
   If a single flow has >6 conditional branches or decision points,
   symbolic notation becomes harder to parse than prose.
   ```

2. **Ambiguity in requirements**
   ```
   When the goal is vague ("improve the codebase"), you need prose
   to clarify objectives before planning in CoD^Σ.
   ```

3. **Novel or creative analysis**
   ```
   Brainstorming refactoring approaches or architectural options
   benefits from free-form thinking.
   ```

4. **Explaining complex trade-offs**
   ```
   Comparing 3+ solution approaches with multiple criteria
   requires nuanced prose.
   ```

5. **Deep conceptual modeling**
   ```
   Building mental models of domain concepts or business logic
   flows better in narrative form.
   ```

### How to Mark AUTO-FALLBACK

When switching to prose reasoning, **mark the segment explicitly**:

```xml
<cod_sigma>
Goal→refactor auth
Entry→login-flow
Deps→supabase∧jwt

AUTO-FALLBACK: Multiple architectural options need evaluation

</cod_sigma>

[Standard prose reasoning:]

The authentication system has three potential refactoring paths:

1. **Centralized session management**: Move all session logic to a
   dedicated service. Pros: single source of truth, easier testing.
   Cons: potential bottleneck, more complex deployment.

2. **Distributed tokens with verification**: Keep tokens at the edge,
   verify on-demand. Pros: lower latency, more scalable. Cons: harder
   to revoke, more complex security model.

3. **Hybrid approach**: Session for long-lived, tokens for API calls.
   Pros: balanced, leverages strengths of both. Cons: dual systems to
   maintain, complexity in edge cases.

Recommendation: Hybrid approach for this codebase size and traffic pattern.

<cod_sigma>
Decision→hybrid auth
Session→long-lived state
Token→api calls
#### approach selected
</cod_sigma>
```

**Key points**:
- Mark `AUTO-FALLBACK` with reason
- Use prose for complex section
- **Resume CoD^Σ** when decision is made
- Final deliverable still includes CoD^Σ summary

### When to Resume CoD^Σ

Resume after:
- **Clarification achieved**: Vague goal now concrete
- **Decision made**: From multiple options, one selected
- **Complex explanation complete**: Back to systematic execution
- **Creative phase done**: From brainstorming to implementation plan

**Example flow**:
```
CoD^Σ planning → AUTO-FALLBACK for complex decision →
prose reasoning → decision made → resume CoD^Σ execution
```

### Balance Guideline

**Aim for**:
- 80-90% of reasoning in CoD^Σ (systematic, token-efficient)
- 10-20% in prose (where genuine complexity demands it)

**Warning**: Don't abuse AUTO-FALLBACK to avoid CoD^Σ discipline. Use it only when symbolic notation genuinely impedes clarity.

---

## Quality Gates

Quality gates ensure CoD^Σ reasoning produces **complete, verifiable, actionable** results.

### Coverage Requirements

**For flow-based tasks**, ensure CoD^Σ includes:

1. **Entry point(s)**
   ```xml
   Entry→/api/questionnaire/submit
   ```
   Every flow needs a starting point identified.

2. **Service(s) or core logic**
   ```xml
   Service→/api/pdf/render
   ```
   The main processing units.

3. **Guard(s) or validation**
   ```xml
   Guard⇒auth∧rate‑limit
   ```
   Security and validation layers.

**Checklist**:
```
✅ At least one Entry line
✅ At least one Service or core logic line
✅ At least one Guard, validation, or error handling line
```

**Example of INCOMPLETE coverage**:
```xml
<cod_sigma>
Goal→pdf flow
Entry→generate-api
Service→render-endpoint
#### flow mapped
</cod_sigma>
```
**Missing**: Guards, dependencies, error handling, risks

**Example of COMPLETE coverage**:
```xml
<cod_sigma>
Goal→pdf flow
Entry→/api/generate-fillable-pdf
Service→/api/pdf/render
Guard⇒auth∧rate‑limit
Deps→puppeteer∧pdf-lib
Error→retry∧fallback
Risk⇒chromium timeout
#### flow mapped
</cod_sigma>
```

### Evidence Linking

**Every claim** in deliverables must reference index fields:

**Index fields**:
- `f`: Files and symbols
- `g`: Call graph edges
- `deps`: Module dependencies
- `d`: Documentation previews
- `stats`: Repository statistics

**Evidence format**:
```json
{
  "findings": [
    {
      "id": "K1",
      "claim": "Total files≈400, dirs≈255, TS≈270, MD≈118",
      "proof": "stats.total_files, stats.total_directories, stats.typescript_files, stats.markdown_files"
    },
    {
      "id": "K2",
      "claim": "Hot inbound: stringOrDefault (52 callers)",
      "proof": "metrics.topInbound[0]"
    },
    {
      "id": "K3",
      "claim": "generatePDF → lib/pdf/combined-generator.ts:45",
      "proof": "f['app/api/generate-patient-instructions/route.ts'].imports['combined-generator']"
    }
  ]
}
```

**Verification example**:
```bash
# Verify K1
$ project-intel stats --json | jq '.total_files'
400

# Verify K2
$ project-intel metrics --json | jq '.topInbound[0]'
{"symbol": "stringOrDefault", "count": 52}

# Verify K3
$ project-intel debug app/api/generate-patient-instructions/route.ts --json | jq '.imports'
[{"module": "./combined-generator", "line": 3}]
```

**Quality gate**:
```
✅ Every finding has "proof" field
✅ Proof references f, g, deps, d, or stats
✅ Proof is specific (path.to.field or command)
✅ Proof is verifiable (can re-run command)
```

### Token Budgets

Use **limiting flags** on all commands to prevent token explosions:

**Always bound with**:

1. **`--json`**: Structured output, easier to parse
   ```bash
   project-intel report --json
   ```

2. **`-l <n>`**: Limit results to n items
   ```bash
   project-intel search pdf -l 50
   project-intel callers submitForm -l 20
   project-intel dead -l 200
   ```

3. **`--max-depth <n>`**: Limit recursion depth
   ```bash
   project-intel tree --max-depth 3
   project-intel trace fnA fnB --max-depth 2
   ```

**Token budget targets**:

| Analysis Mode | CoD^Σ Budget | Command Output Budget | Total |
|---------------|--------------|----------------------|-------|
| Quick | ~5k | ~5k | ~10k |
| Standard | ~10k | ~30k | ~40k |
| Deep | ~20k | ~80k | ~100k |

**Example budget adherence**:
```xml
<cod_sigma>
Goal→hotspots
Commands→report --json; metrics --json
Limit→top 10 each
#### hotspots identified
</cod_sigma>

<commands_used>
project-intel report --json           # ~5k tokens
project-intel metrics --json          # ~3k tokens
</commands_used>

Total: ~8k tokens (within Standard budget)
```

**Quality gate**:
```
✅ All search commands have -l flag
✅ All tree commands have --max-depth
✅ All commands use --json when available
✅ Total output ≤ mode budget
```

### Validation Checklist

Before marking analysis complete, verify:

**Structural**:
```
✅ <cod_sigma> block present
✅ All lines ≤5 tokens
✅ Completion marker (####) present
✅ Goal clearly stated
```

**Coverage**:
```
✅ Entry points identified
✅ Services/core logic mapped
✅ Guards/validation noted
✅ Dependencies listed
✅ Risks flagged (if any)
```

**Evidence**:
```
✅ <commands_used> section present
✅ All commands include bounds (-l, --max-depth, --json)
✅ Every finding links to proof
✅ Proof references index fields or commands
```

**Deliverables**:
```
✅ Findings structured (id, claim, proof)
✅ Recommendations actionable
✅ Relationships mapped (calls, imports, routes)
✅ Output matches user's request
```

**Token efficiency**:
```
✅ Within mode budget
✅ No unbounded queries
✅ CoD^Σ compressed (not prose)
✅ Minimal redundancy
```

---

## Examples from project-intel Workflows

### FS-1: Repository Intelligence Snapshot

**User Request**:
```
Produce a code intelligence snapshot as shared context for other agents.
Focus: hotspots, imports, doc counts, test counts, key APIs.
```

**CoD^Σ Reasoning**:
```xml
<cod_sigma>
Goal→repo intel
Index→stats∧top fns
Hotspots→inbound∧outbound
Modules→top importers
Docs→count∧locations
#### snapshot ready
</cod_sigma>
```

**Commands Executed**:
```bash
project-intel report --json
project-intel metrics --json
project-intel stats --json
```

**Evidence Gathered**:
```json
{
  "stats": {
    "total_files": 400,
    "total_directories": 255,
    "typescript_files": 270,
    "markdown_files": 118
  },
  "metrics": {
    "topInbound": [
      {"symbol": "stringOrDefault", "count": 52},
      {"symbol": "pdfTranslate", "count": 38},
      {"symbol": "t", "count": 35}
    ],
    "topOutbound": [
      {"symbol": "addFieldAsync", "count": 45},
      {"symbol": "createPDFStreamTransform", "count": 30}
    ]
  },
  "report": {
    "topModules": ["react", "next/server", "pdf-lib"]
  }
}
```

**Deliverable**:
```json
{
  "goal": "Repository intelligence snapshot",
  "scope": "global",
  "findings": [
    {
      "id": "K1",
      "claim": "Total files≈400, dirs≈255, TS≈270, MD≈118",
      "proof": "stats.*"
    },
    {
      "id": "K2",
      "claim": "Hot inbound: stringOrDefault (52), pdfTranslate (38), t (35)",
      "proof": "metrics.topInbound"
    },
    {
      "id": "K3",
      "claim": "Hot outbound: addFieldAsync (45), createPDFStreamTransform (30)",
      "proof": "metrics.topOutbound"
    },
    {
      "id": "K4",
      "claim": "Top modules: react, next/server, pdf-lib",
      "proof": "report.topModules"
    }
  ],
  "deliverables": {
    "summary": "Stable snapshot with hotspots and module gravity for agent context."
  }
}
```

**Flow**: CoD^Σ planning → bounded commands → evidence extraction → structured findings

### FS-2: PDF and Email Flow Mapping

**User Request**:
```
Map end-to-end PDF generation variants and email attachment pipeline.
Show entry routes, core libs, service handoffs.
```

**CoD^Σ Reasoning**:
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

**Commands Executed**:
```bash
project-intel search pdf -l 50
project-intel debug app/api/generate-fillable-pdf/route.ts
project-intel debug lib/pdf/puppeteer-generator.ts
project-intel debug app/api/pdf/render/route.ts
project-intel docs supabase/functions/_shared/ATTACHMENT_HANDLING.md
```

**Evidence Gathered**:
- Entries: `app/api/generate-fillable-pdf/route.ts`, `app/api/generate-patient-instructions/route.ts`
- Libraries: `puppeteer`, `pdf-lib`, identified via imports
- Service: `app/api/pdf/render/route.ts` (called by generators)
- Email: `supabase/functions/_shared/email-templates.ts`, `resend-client.ts`
- Documentation: `ATTACHMENT_HANDLING.md` warns about anti-patterns

**Deliverable**:
```markdown
### PDF Flow Variants

**Variant A (Fillable PDFs)**:
app/api/generate-fillable-pdf/route.ts
  → lib/pdf/fillable/orchestrator.ts
  → lib/pdf/puppeteer-generator.ts
  → app/api/pdf/render/route.ts (chromium rendering)

**Variant B (Composed PDFs)**:
app/api/generate-patient-instructions/route.ts
  → lib/pdf/combined-generator.ts (uses pdf-lib directly)

**Variant C (Doctor Instructions)**:
app/api/generate-doctor-instructions/route.ts
  → lib/pdf/combined-generator.ts

### Email Pipeline

**Templates**: `supabase/functions/_shared/email-templates.ts`
**Transport**: `supabase/functions/_shared/resend-client.ts`
  - Methods: sendEmail, decodeAttachmentContent

### Risks
- Attachment encoding mistakes (see ATTACHMENT_HANDLING.md)
- Rate limits on render service
- Chromium timeout in render route
```

**Flow**: CoD^Σ plan → debug key files → extract call paths → map variants → document risks

### FS-4: Hygiene Scan (Dead Code, Cycles, Duplicates)

**User Request**:
```
List exported functions with no callers, surface likely cycles,
flag duplicated utilities by name across files.
```

**CoD^Σ Reasoning**:
```xml
<cod_sigma>
Goal→hygiene scan
Dead→fn no callers
Cycles→SCC hints
Dupes→name≥3 files
Warn⇒framework magic
#### hygiene candidates
</cod_sigma>
```

**Commands Executed**:
```bash
project-intel dead -l 200 --json
project-intel metrics --json
project-intel search formatSwissDate -l 50
project-intel search generateReferralCode -l 50
project-intel search formatSwissPhone -l 50
```

**Evidence Gathered**:
```json
{
  "dead": [
    {"symbol": "unusedHelper", "file": "lib/utils/old.ts", "line": 23},
    {"symbol": "deprecatedFormatter", "file": "lib/format.ts", "line": 67}
  ],
  "duplicates": {
    "formatSwissDate": [
      "lib/utils/date.ts",
      "components/DatePicker/utils.ts",
      "app/helpers/format.ts"
    ],
    "generateReferralCode": [
      "lib/referral/generator.ts",
      "app/api/referral/utils.ts",
      "lib/utils/codes.ts"
    ]
  },
  "cycle_hints": [
    "use-toast: reducer ↔ dispatch"
  ]
}
```

**Deliverable**:
```json
{
  "goal": "Code hygiene scan",
  "findings": [
    {
      "id": "K1",
      "claim": "Dead code: 2 functions with no callers",
      "proof": "dead command results",
      "items": ["unusedHelper", "deprecatedFormatter"]
    },
    {
      "id": "K2",
      "claim": "Duplicate utilities: formatSwissDate in 3 files",
      "proof": "search results",
      "files": [
        "lib/utils/date.ts",
        "components/DatePicker/utils.ts",
        "app/helpers/format.ts"
      ]
    },
    {
      "id": "K3",
      "claim": "Duplicate utilities: generateReferralCode in 3 files",
      "proof": "search results"
    }
  ],
  "cautions": [
    "Framework routing may hide dynamic entrypoints - verify before deleting dead code"
  ],
  "recommendations": [
    "Consolidate formatSwissDate into lib/utils/date.ts",
    "Consolidate generateReferralCode into lib/referral/generator.ts",
    "Add eslint rule to detect duplicate function names",
    "Verify dead code candidates aren't used via dynamic imports"
  ]
}
```

**Flow**: CoD^Σ scan plan → run dead/metrics/search → identify patterns → recommend consolidation

### Common Pattern Across Examples

**All workflows follow**:

```
1. CoD^Σ Planning
   ↓
2. Execute Bounded Commands (with -l, --json, --max-depth)
   ↓
3. Extract Evidence (from f, g, deps, d, stats)
   ↓
4. Link Evidence to Claims (proof field)
   ↓
5. Structured Deliverable (findings, recommendations, cod_sigma)
```

**Key success factors**:
- ✅ CoD^Σ ≤5 tokens/line
- ✅ Commands always bounded
- ✅ Evidence always linked
- ✅ Recommendations actionable
- ✅ Complete coverage (Entry, Service, Guard)

---

## Best Practices

### 1. Start with Goal

Every CoD^Σ block begins with `Goal→<objective>`:

```xml
✅ Good:
<cod_sigma>
Goal→pdf flow
...
</cod_sigma>

❌ Bad:
<cod_sigma>
Entry→/api/generate-pdf  (no goal stated)
...
</cod_sigma>
```

### 2. Use Completion Markers

End each CoD^Σ block with `####` marker:

```xml
<cod_sigma>
Goal→auth flow
Entry→login-api
Guard⇒jwt∧role
#### auth mapped
</cod_sigma>
```

Markers signal:
- Section complete
- Ready for next phase
- Provides semantic closure

### 3. Layer Complexity Gradually

Build from simple to complex:

```xml
<!-- Layer 1: High-level -->
Goal→submit flow
Entry→questionnaire-api

<!-- Layer 2: Add detail -->
PDF_A→fillable
PDF_B→combined

<!-- Layer 3: Add dependencies -->
Deps→puppeteer∧pdf-lib∧qrcode

<!-- Layer 4: Add guards/risks -->
Guard⇒auth∧rate‑limit
Risk⇒timeout∧encoding
```

### 4. Be Consistent with Symbols

Pick one symbol for each relationship type:

```
✅ Consistent:
Entry→api
Flow→step1→step2
Deps→lib1∧lib2

❌ Inconsistent:
Entry⇒api        (mixing → and ⇒)
Flow→step1⇒step2 (inconsistent flow symbol)
```

### 5. Hyphenate Multi-Word Entities

```
✅ rate‑limit (clearly one token)
❌ rate limit (ambiguous - 1 or 2 tokens?)
```

### 6. Document Complex Symbols

If using advanced notation, add legend:

```xml
<cod_sigma>
# Legend: A⊲B (A owns B), A≺B (A precedes B)

Routes⊲pages
Auth≺submission
...
</cod_sigma>
```

### 7. Link CoD^Σ to Commands

Make command usage explicit:

```xml
<cod_sigma>
Goal→hotspots
Cmd→report --json
Cmd→metrics --json
Parse→topInbound∧topOutbound
#### hotspots ready
</cod_sigma>

<commands_used>
project-intel report --json
project-intel metrics --json
</commands_used>
```

### 8. Balance Compression and Clarity

Don't over-compress to the point of obscurity:

```
✅ Balanced:
PDF_A→fillable→puppeteer
PDF_B→combined→pdf-lib

❌ Over-compressed:
P_A→f→p
P_B→c→pl
(meaning lost)
```

### 9. Use AUTO-FALLBACK Judiciously

Reserve for genuine complexity:

```
✅ Appropriate:
AUTO-FALLBACK: Three architectural options need comparative analysis

❌ Inappropriate:
AUTO-FALLBACK: Listing dependencies
(simple task, doesn't need prose)
```

### 10. Validate Before Delivery

Run through quality checklist:
- ✅ ≤5 tokens per line
- ✅ Entry, Service, Guard present
- ✅ Evidence linked to claims
- ✅ Commands bounded
- ✅ Completion marker present

---

## Summary

**CoD^Σ Ultrathink** provides:

1. **Token Efficiency**: 70-80% reduction via symbolic notation
2. **Transparency**: All reasoning public in `<cod_sigma>` blocks
3. **Systematicity**: Structured planning with ≤5 tokens/line
4. **Verifiability**: Evidence-linked findings, reproducible results
5. **Flexibility**: AUTO-FALLBACK for genuine complexity

**Core principles**:
- ≤5 tokens per line
- Symbolic notation over prose
- Bounded commands always
- Evidence-linked claims
- Complete coverage (Entry, Service, Guard)

**When to use**:
- Code intelligence tasks
- Systematic analysis (flows, dependencies, architecture)
- Token-constrained environments
- Reproducible/verifiable results required

**When to AUTO-FALLBACK**:
- >6 steps in complex decision trees
- Ambiguous requirements needing clarification
- Creative/brainstorming phases
- Nuanced trade-off explanations

Master CoD^Σ to analyze codebases efficiently, transparently, and systematically.

---

**Navigation**:
- [← Code Intelligence Overview](code-intel-overview.md)
- [Next: Project-Intel Workflows →](project-intel-workflows.md)
