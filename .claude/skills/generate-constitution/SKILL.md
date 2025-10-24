---
name: Generate Constitution
description: Derive technical development principles FROM user needs in product.md using evidence-based reasoning. Creates constitution.md with architecture decisions, tech stack choices, and development constraints - all traced back to specific user needs. Use when user mentions "technical principles", "constitution", "architecture decisions", or after creating product.md.
---

# Generate Constitution Skill

@.claude/shared-imports/CoD_Σ.md

## Overview

This skill derives technical principles FROM user needs documented in product.md. Every technical decision must trace back to a user need via CoD^Σ reasoning chain.

**Critical Boundary**:
- **product.md** = WHAT users need (no tech)
- **constitution.md** = HOW we build it (tech derived FROM user needs)

**Derivation Pattern**:
```
User Need (product.md) ≫ Capability Required → Technical Approach ≫ Specific Constraint (constitution.md)
```

---

## Workflow Decision Tree

**Creating new constitution?** → Follow [Derivation Workflow](#derivation-workflow)

**Updating existing constitution?** → Follow [Amendment Workflow](#amendment-workflow)

**Validating constitution?** → Run [Validation Checks](#validation-checks)

---

## Derivation Workflow

### Step 1: Load Product Definition

```bash
Read product.md
```

**Extract user needs from**:
- Persona pain points (specific frustrations)
- User journey requirements (what must work)
- "Our Thing" (key differentiators)
- North Star metric (measurement needs)

---

### Step 2: Map User Needs to Technical Requirements

For each user need, identify the technical implication using CoD^Σ:

**Pattern**: User Need ≫ Capability → Technical Approach ≫ Constraint

**Example 1: From Pain Point**
```
product.md:Persona1:Pain1: "Manually copying data from 7 tools wastes 2 hours/week"
  ≫ Automated cross-platform data sync required
  → API integrations with automatic refresh
  ≫ <15 minute data latency constraint
```
→ **Constitution Article**: Real-Time Data Sync (<15min latency, NON-NEGOTIABLE)

**Example 2: From "Our Thing"**
```
product.md:OurThing: "Instant cross-platform visibility"
  ≫ Dashboard load in <2 seconds required
  → Optimized queries + caching strategy
  ≫ Performance budget: <2s p95 load time
```
→ **Constitution Article**: Performance Standards (<2s dashboard, NON-NEGOTIABLE)

**Example 3: From Persona Demographics**
```
product.md:Persona1:Demographics: "Age 65-75, low tech comfort"
  ≫ Extreme accessibility requirements
  → Large text, high contrast, simple UI
  ≫ 20px minimum font, 7:1 contrast ratio, <3 taps to goal
```
→ **Constitution Article**: Accessibility Standards (20px font, 7:1 contrast, NON-NEGOTIABLE)

---

### Step 3: Derive Technical Principles

For each technical requirement, create a principle with full evidence chain:

**Structure**:
```markdown
## Article N: [Principle Name] (NON-NEGOTIABLE | SHOULD | MAY)

### User Need Evidence
From product.md:[section]:[line]
- [Quote exact user need]

### Technical Derivation (CoD^Σ)
[User Need]
  ≫ [Capability Required]
  → [Technical Approach]
  ≫ [Specific Constraint]

### Principle
[Clear, specific technical constraint]

### Rationale
[Why this serves the user need]

### Verification
[How to validate compliance]
```

**Full Example**:
```markdown
## Article II: Real-Time Data Synchronization (NON-NEGOTIABLE)

### User Need Evidence
From product.md:Persona1:Pain1:118
- "Manually copying campaign metrics from 7 different tools... wastes 2 hours/week"

From product.md:OurThing:283
- "See all your marketing campaigns in one dashboard, updated in real-time"

### Technical Derivation (CoD^Σ)
Manual data collection pain (product.md:Persona1:Pain1:118)
  ⊕ Real-time visibility promise (product.md:OurThing:283)
  ≫ Automated cross-platform sync required
  → API polling or webhooks for each platform
  ≫ <15 minute maximum data latency

### Principle
1. All connected platforms MUST sync data automatically with <15 minute maximum latency
2. NO manual data entry workflows permitted
3. All integrations MUST use webhooks where available, polling otherwise (max 5min interval)

### Rationale
Users chose this product specifically to eliminate 2 hours/week of manual copying. Any sync latency >15 minutes breaks the "real-time" promise that differentiates us.

### Verification
- Monitor data staleness: alert if any source >15min stale
- Analytics: zero manual export/import events
- Integration health dashboard: all sources ≤15min sync time
```

---

### Step 4: Organize by Category

Group principles into standard Articles:

1. **Article I: Architecture Patterns** - System-level (microservices, event-driven, etc.)
2. **Article II: Data & Integration** - Database, API, sync patterns
3. **Article III: Performance & Reliability** - SLAs, latency, uptime
4. **Article IV: Security & Privacy** - Auth, encryption, compliance
5. **Article V: User Experience** - UI constraints, accessibility
6. **Article VI: Development Process** - Testing, deployment, quality
7. **Article VII: Scalability** - Growth constraints, capacity

**Priority within each Article**:
- NON-NEGOTIABLE first (breaks user promises if violated)
- SHOULD next (strong preferences)
- MAY last (flexibility allowed)

---

### Step 5: Create Derivation Map

Document complete traceability:

```markdown
## Appendix: Constitution Derivation Map

| Article | Product.md Source | User Need | Technical Principle |
|---------|-------------------|-----------|---------------------|
| Article II | Persona1:Pain1:118 | Eliminate 2hr/week manual copying | <15min sync latency |
| Article V | Persona2:Demographics:65 | Age 65-75, vision decline | 20px min font size |
| Article III | OurThing:283 | "Instant visibility" | <2s dashboard load |
```

This enables:
- Tracing any principle back to user need
- Identifying orphaned principles (REMOVE THEM)
- Validating all user needs are addressed

---

### Step 6: Version & Metadata

```markdown
---
version: 1.0.0
ratified: YYYY-MM-DD
derived_from: product.md (v1.0)
---

# Development Constitution

**Purpose**: Technical principles derived FROM user needs

**Amendment Process**: See Article VIII

**Derivation Evidence**: See Appendix
```

---

## Amendment Workflow

### When to Amend

**Trigger**: Product.md changes → Constitution MUST update

**Version Semantics**:
- **MAJOR (X.0.0)**: Article added/removed (architectural shift)
- **MINOR (1.X.0)**: Article modified (principle change)
- **PATCH (1.0.X)**: Formatting, typos, clarifications

### Amendment Process

1. Identify which user needs changed in product.md
2. Update affected Articles
3. Bump version number
4. Update ratified date
5. Update derivation map
6. Add amendment history entry

**Amendment Entry**:
```markdown
### Version 1.1.0 - YYYY-MM-DD

**Changed**: Article III (Performance)

**Reason**: Product.md updated North Star to include "report <10s"

**Before**: Dashboard <2s only

**After**: Dashboard <2s AND reports <10s

**Evidence**: Product.md:NorthStar:line:15
```

---

## Validation Checks

### Quality Checklist

**For each Article**:
- [ ] Has explicit product.md reference (file:section:line)
- [ ] User need quoted verbatim
- [ ] CoD^Σ derivation chain documented
- [ ] Principle is specific and measurable
- [ ] Verification method defined
- [ ] Classification clear (NON-NEGOTIABLE | SHOULD | MAY)

**Overall**:
- [ ] No orphaned principles (all trace to user needs)
- [ ] All "Our Thing" items have NON-NEGOTIABLE principles
- [ ] All pain resolutions have technical support
- [ ] Derivation map complete
- [ ] Version metadata current

### Quick Tests

1. **"Can I delete this without breaking a user promise?"**
   - YES → Might not be needed
   - NO → Should be NON-NEGOTIABLE

2. **"Can I trace this to a specific user pain?"**
   - YES → Good principle
   - NO → Remove it

3. **"Does this enable 'Our Thing'?"**
   - YES → Upgrade to NON-NEGOTIABLE
   - NO → Evaluate if needed

---

## Anti-Patterns

### ❌ Tech Preferences Without User Justification

**Bad**:
```markdown
Use React because it's popular
```

**Good**:
```markdown
## Article V: Responsive UI Updates (NON-NEGOTIABLE)

### User Need Evidence
From product.md:OurThing:42
- "Real-time updates"

### Technical Derivation
Real-time visibility ≫ <100ms UI updates → Reactive framework → React + state mgmt

### Principle
Frontend MUST use React for <100ms UI reactivity
```

---

### ❌ Over-Constraining Without Evidence

**Bad**:
```markdown
MUST use PostgreSQL exclusively
```

**Good**:
```markdown
## Article III: Data Integrity (NON-NEGOTIABLE)

### User Need Evidence
From product.md:Persona1:Pain2:25
- "Executives distrust inconsistent data"

### Technical Derivation
Executive trust ≫ Strong consistency → ACID transactions → Relational DB

### Principle
Data storage MUST provide ACID transactions. Preferred: PostgreSQL. Acceptable: MySQL.
```

---

## Example

**Complete Constitution**: See [examples/b2b-saas-constitution.md](examples/b2b-saas-constitution.md)

This shows:
- Full derivation chains with CoD^Σ reasoning
- 7 Articles covering Architecture, Data, Performance, Security, UX, Testing
- Complete derivation map tracing principles to product.md
- Amendment history example
- NON-NEGOTIABLE vs SHOULD classifications

**Template**: Use `@.claude/templates/product-constitution-template.md`

---

## Key Reminders

1. **Every principle MUST trace to user need** - No orphaned tech preferences
2. **"Our Thing" drives NON-NEGOTIABLE** - Core differentiators are non-negotiable
3. **Use CoD^Σ for all derivations** - Evidence chain required
4. **Version amendments** - Track why principles change
5. **Validate bidirectionally** - Product → Constitution AND Constitution → Product

---

**Next Step**: Use constitution.md to guide all architectural and implementation decisions in plan.md

---

## Prerequisites

Before using this skill:
- ✅ product.md exists (REQUIRED - created by define-product skill)
- ✅ product.md has personas with pain points
- ✅ product.md has "Our Thing" (key differentiator)
- ✅ product.md has North Star metric
- ✅ product.md has user journeys
- ⚠️ Optional: Existing constitution.md to amend (will be versioned)
- ⚠️ Optional: @.claude/templates/product-constitution-template.md (for structure)

**Note**: constitution.md CANNOT be created without product.md. All technical principles MUST derive from user needs documented in product.md.

## Dependencies

**Depends On**:
- **define-product skill** - MUST run before this skill (provides product.md)
- @.claude/shared-imports/CoD_Σ.md - For derivation chains and evidence traces
- product.md - Source of ALL user needs (critical input)

**Integrates With**:
- **create-implementation-plan skill** - Uses constitution.md for architecture decisions
- **specify-feature skill** - References constitution.md constraints in features
- **/generate-constitution command** - User-facing command that invokes this skill

**Tool Dependencies**:
- Read tool (to load product.md)
- Write tool (to create constitution.md)
- CoD^Σ operators (for derivation chains)

## Next Steps

After constitution.md creation completes, typical progression:

**Main Development Flow**:
```
generate-constitution (creates constitution.md)
    ↓ (manual invocation)
specify-feature (user runs /feature with feature idea)
    ↓ (references constitution.md constraints)
create-implementation-plan (tech stack FROM constitution)
    ↓ (automatic)
generate-tasks → /audit → /implement
```

**Amendment Flow** (when product.md changes):
```
product.md updated (personas, pain points, or differentiators changed)
    ↓ (manual invocation)
generate-constitution --amend (user runs /generate-constitution)
    ↓
constitution.md updated (version bumped, derivation map updated)
    ↓
Review affected features/plans for constitutional compliance
```

**User Action Required**:
- Review constitution.md for completeness and accuracy
- Validate all Articles have derivation chains to product.md
- Share constitution.md with team for alignment
- Use as guide for ALL technical decisions going forward

**Outputs Modified**:
- `constitution.md` - Technical principles derived from user needs (project root)
- Version number incremented if amending existing constitution
- Derivation map updated with all product.md traces

**Commands**:
- **/generate-constitution** - Create or amend constitution.md
- **/feature** - After constitution exists, create features with constitutional constraints
- **/plan** - After constitution exists, plans must comply with principles

## Failure Modes

### Common Failures & Solutions

**1. Constitution created without product.md**
- **Symptom**: Technical principles with no user need evidence
- **Solution**: STOP. Create product.md with define-product skill first
- **Enforcement**: This skill MUST NOT run without product.md existing
- **Prevention**: Skill checks for product.md in Step 1, exits if missing

**2. Technical preferences without CoD^Σ derivation**
- **Symptom**: "Use React" without user need justification
- **Solution**: Add full derivation chain: User Need ≫ Capability → Technical Approach ≫ Constraint
- **Article II**: Evidence-Based Reasoning requires CoD^Σ traces
- **Prevention**: Every Article MUST have "Technical Derivation (CoD^Σ)" section

**3. Orphaned principles (no product.md trace)**
- **Symptom**: Article exists but derivation map has no product.md reference
- **Solution**: Either add evidence FROM product.md OR delete the principle
- **Validation**: Run "Can I trace this to a specific user pain?" test
- **Prevention**: Derivation map MUST be complete (no gaps)

**4. "Our Thing" not marked NON-NEGOTIABLE**
- **Symptom**: Key differentiator has "SHOULD" classification
- **Solution**: Upgrade to NON-NEGOTIABLE (breaks user promise if violated)
- **Test**: "Can I delete this without breaking a user promise?" → NO = NON-NEGOTIABLE
- **Prevention**: All "Our Thing" items from product.md become NON-NEGOTIABLE

**5. Over-constraining tech stack**
- **Symptom**: "MUST use PostgreSQL exclusively" when requirement is "ACID transactions"
- **Solution**: Constrain by capability, not specific technology
- **Pattern**: "Data storage MUST provide ACID. Preferred: PostgreSQL. Acceptable: MySQL."
- **Prevention**: Ask "Does this constrain HOW or WHAT?" (WHAT = correct)

**6. Missing verification methods**
- **Symptom**: Principle defined but no way to validate compliance
- **Solution**: Add "Verification" section with specific checks
- **Example**: "Monitor data staleness: alert if any source >15min stale"
- **Prevention**: Every Article MUST have "Verification" section

**7. Amendment without version bump**
- **Symptom**: Constitution changed but version still 1.0.0
- **Solution**: Follow semantic versioning (MAJOR.MINOR.PATCH)
- **Pattern**: Article added/removed = MAJOR, modified = MINOR, formatting = PATCH
- **Prevention**: Amendment workflow (Step 2 in Amendment Process)

**8. Derivation map incomplete or stale**
- **Symptom**: Articles exist but not in derivation map
- **Solution**: Update derivation map table with ALL Articles
- **Validation**: Every Article row MUST appear in map
- **Prevention**: Generate map as Step 5 in Derivation Workflow

**9. User needs from product.md not addressed**
- **Symptom**: Key pain point in product.md has no corresponding Article
- **Solution**: Add Article with derivation chain for that pain
- **Validation**: All "Our Thing", North Star, and top 3 pains per persona MUST have Articles
- **Prevention**: Bidirectional validation (Product → Constitution complete)

**10. Classification incorrect (NON-NEGOTIABLE vs SHOULD)**
- **Symptom**: Nice-to-have marked NON-NEGOTIABLE OR core promise marked SHOULD
- **Solution**: Run 3 quick tests (see Validation Checks section)
- **Tests**: "Can I delete?" / "Trace to pain?" / "Enables Our Thing?"
- **Prevention**: Review classification after drafting each Article

**11. No amendment history**
- **Symptom**: Constitution changed but no record of what/why
- **Solution**: Add amendment entry with before/after comparison
- **Pattern**: Version X.Y.Z - Date, Changed, Reason, Before, After, Evidence
- **Prevention**: Amendment workflow Step 6 (add history entry)

**12. Technical jargon in evidence quotes**
- **Symptom**: Quoting technical terms from product.md (which shouldn't have them)
- **Solution**: If product.md has technical terms, fix THAT first (it's wrong)
- **Enforcement**: product.md boundary violation check
- **Prevention**: define-product skill enforces user-centric language only

## Related Skills & Commands

**Direct Integration**:
- **define-product skill** - MUST run before this skill (provides product.md input)
- **create-implementation-plan skill** - Uses constitution.md for architecture decisions (successor)
- **specify-feature skill** - References constitution.md constraints in specifications
- **/generate-constitution command** - User-facing command that invokes this skill

**Workflow Context**:
- Position: **Phase 2** of product development (after product.md, before features)
- Triggers: User mentions "technical principles", "constitution", OR after product.md created
- Output: constitution.md with technical principles derived FROM user needs

**Constitution Chain**:
```
User Context (define-product: product.md)
    ↓ (this skill derives technical principles)
Technical Principles (this skill: constitution.md)
    ↓ (guides all technical decisions)
Feature Specifications (specify-feature: spec.md with constitutional constraints)
    ↓
Implementation Plans (create-implementation-plan: tech stack FROM constitution)
```

**Core Principle**: ALL technical decisions derive from user needs. constitution.md is the bridge between user-centric product.md and technical implementation.

**Quality Gates**:
- **Traceability**: Every Article MUST trace to product.md (file:section:line)
- **CoD^Σ Evidence**: Every derivation MUST use Chain of Decisions operators
- **Classification**: NON-NEGOTIABLE for "Our Thing", SHOULD for preferences, MAY for flexibility
- **Verification**: Every Article MUST have verification method
- **Derivation Map**: Complete bidirectional traceability

**Integrations**:
- **create-implementation-plan skill** - References constitution for architecture gates
- **CoD^Σ framework** - Uses operators for evidence-based derivation chains
- **Validation tools** - Quick tests for classification and traceability

**Amendment Process**: When product.md changes, re-run this skill to update constitution.md with version bump and amendment history.

**Workflow Recommendation**: Run this skill IMMEDIATELY after define-product to establish technical foundation before any feature development.

---

**Version:** 1.0
**Last Updated:** 2025-10-22
**Owner:** Claude Code Intelligence Toolkit
