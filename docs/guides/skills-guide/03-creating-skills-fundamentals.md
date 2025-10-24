# Creating Skills: Complete Fundamentals Guide

**Target Audience**: AI coding agents
**Purpose**: Step-by-step skill creation process with best practices

## Overview

This guide walks through creating effective skills from ideation to deployment. It covers the complete process: identification, testing, implementation, and iteration.

**Core Philosophy**: Skills are documentation that must be tested like code. Use TDD approach: RED (baseline) → GREEN (write skill) → REFACTOR (close loopholes).

## Prerequisites

Before creating a skill:

1. **Understand TDD** → Read `~/.claude/skills/test-driven-development/SKILL.md`
2. **Understand skill testing** → Read `~/.claude/skills/writing-skills/SKILL.md`
3. **Review examples** → Examine `~/.claude/skills/*/SKILL.md`

## Step 1: Identify Need for a Skill

### Create a Skill When:

✅ **Reusable Pattern**: Technique applies across multiple projects
```
Example: "Condition-based waiting" for async tests
→ NOT project-specific, applies to any async code
```

✅ **Non-Obvious**: You had to figure it out, not intuitively obvious
```
Example: "TDD workflow" enforces non-intuitive discipline
→ Agents need explicit guidance to follow correctly
```

✅ **Repeatable**: You'd want to apply this again
```
Example: "PDF form filling" has repeatable steps
→ Same workflow each time, worth documenting
```

✅ **Shareable**: Others would benefit
```
Example: "MCP server best practices"
→ Any agent building MCP servers can use this
```

### Don't Create a Skill For:

❌ **One-Off Solutions**: Solved once, unlikely to repeat
```
Bad: "Fix broken build in project X on 2024-10-15"
→ Use commit message or CLAUDE.md note
```

❌ **Well-Documented Elsewhere**: Standard practices with good docs
```
Bad: "JavaScript syntax guide"
→ Abundant documentation exists, not needed
```

❌ **Project-Specific**: Only applies to one codebase
```
Bad: "Our team's code style"
→ Use CLAUDE.md for project conventions
```

❌ **Narrative**: Story of how you solved something
```
Bad: "How we debugged the auth flow"
→ Extract generalized pattern if creating skill
```

## Step 2: Determine Skill Type

Choose the appropriate skill type (affects structure):

### Technique Skill
**When**: Step-by-step procedure for specific operation

**Structure**:
- Overview (core principle)
- When to use (triggering conditions)
- The Process (sequential steps)
- Implementation (code patterns)
- Common mistakes

**Example**: `condition-based-waiting`

### Pattern Skill
**When**: Mental model or architectural approach

**Structure**:
- Overview (philosophy)
- When to use (recognition criteria)
- Core pattern (before/after)
- Trade-offs
- Counter-examples

**Example**: `flatten-with-flags`

### Reference Skill
**When**: API documentation, command reference, toolkit

**Structure**:
- Quick start (minimal example)
- Decision tree (which approach when)
- Reference (comprehensive, often separate files)
- Examples (real-world)

**Example**: `pdf`, `xlsx`, `mcp-builder`

### Discipline-Enforcing Skill
**When**: Process enforcement, quality standards

**Structure**:
- Overview + "violating letter = violating spirit"
- The Iron Law (rule with no exceptions)
- Red flags (warning signs)
- Rationalization table (excuses + rebuttals)
- Process (with checkpoints)

**Example**: `test-driven-development`, `writing-skills`

## Step 3: Plan Directory Structure

### Self-Contained Skill

```
skill-name/
  SKILL.md              # Everything inline (< 500 words)
```

**When to use**:
- All content fits comfortably in one file
- No heavy reference needed
- No reusable scripts

**Examples**: `test-driven-development`, `brainstorming`

### Skill with Scripts

```
skill-name/
  SKILL.md              # Overview + workflows
  scripts/
    operation_1.py      # Executable script
    operation_2.py
    helper.py
```

**When to use**:
- Deterministic operations (validation, extraction)
- Token efficiency (output only, not script source)
- Reusable tools

**Examples**: `pdf`, `webapp-testing`

### Skill with References

```
skill-name/
  SKILL.md              # Overview + quick reference
  references/
    api-docs.md         # Heavy documentation
    examples.md         # Comprehensive examples
    cheatsheet.md
```

**When to use**:
- API documentation (> 1000 lines)
- Comprehensive examples
- Multiple reference domains

**Examples**: `mcp-builder`, `docx`

### Skill with Assets

```
skill-name/
  SKILL.md
  assets/
    template.html       # Template files
    schema.json         # Data structures
    diagram.png         # Visual aids
```

**When to use**:
- Template files for outputs
- Visual diagrams
- Schema definitions

**Examples**: `algorithmic-art`

### Combined Structure

```
skill-name/
  SKILL.md
  scripts/
    *.py
  references/
    *.md
  assets/
    *.*
```

**When to use**: Complex skills needing all resource types

**Examples**: `pptx` (with OOXML schemas), future `code-intelligence` skill

## Step 4: Write YAML Frontmatter

**Requirements**:
- Only `name` and `description` fields supported
- Max 1024 characters total
- No special characters in name (letters, numbers, hyphens only)

### Name Field

**Format**: `kebab-case-name`

**Guidelines**:
```yaml
# ✅ Good names
name: test-driven-development
name: condition-based-waiting
name: creating-skills

# ❌ Bad names
name: TDD                        # Too cryptic
name: Test Driven Development    # Spaces not allowed
name: test_driven_development    # Underscores (prefer hyphens)
name: tdd-workflow (best-practice) # Parentheses not allowed
```

**Naming Philosophy**:
- Use gerunds (-ing) for processes: `creating-skills`, `testing-skills`
- Use verb-first: `flatten-with-flags` not `flag-flattening`
- Descriptive over cryptic: `condition-based-waiting` not `cond-wait`

### Description Field

**Format**: Third-person, includes triggering conditions and purpose

**Structure**:
```
Use when [specific symptoms/situations] - [what it does and how]
```

**Length**: < 500 characters ideal (must be < 1024 total frontmatter)

**CSO (Claude Search Optimization)**:

```yaml
# ❌ Bad: Vague, no triggers
description: For async testing

# ❌ Bad: First person
description: I help with flaky tests

# ❌ Bad: Missing when-to-use
description: Provides condition polling patterns

# ✅ Good: Triggers + symptoms + solution
description: Use when tests have race conditions, timing dependencies,
  or pass/fail inconsistently - replaces arbitrary timeouts with
  condition polling for reliable async tests

# ✅ Good: Tech-specific when applicable
description: Use when using React Router and handling authentication
  redirects - provides patterns for protected routes and auth state
  management in React Router v6
```

**Keyword Coverage**:
- **Error messages**: "Hook timed out", "ENOTEMPTY", "race condition"
- **Symptoms**: "flaky", "hanging", "inconsistent", "intermittent"
- **Tools**: Actual library names, commands, file types
- **Synonyms**: "timeout/hang/freeze", "cleanup/teardown/dispose"

**Technology Specificity**:
- **Generic problem** → Keep triggers technology-agnostic
  ```yaml
  # Good: Generic testing issue
  description: Use when tests pass/fail inconsistently due to timing...
  ```

- **Technology-specific solution** → Make explicit in triggers
  ```yaml
  # Good: React Router specific
  description: Use when using React Router v6 and need auth routing...
  ```

## Step 5: TDD Phase - RED (Baseline Testing)

**CRITICAL**: You MUST run baseline tests BEFORE writing the skill.

### For Technique/Reference Skills

**Test**: Can agents apply the technique without the skill?

1. Create application scenario (realistic task)
2. Run subagent WITHOUT skill loaded
3. Document what goes wrong:
   - Which steps do they skip?
   - Where do they get confused?
   - What assumptions do they make?

**Example** (condition-based-waiting):
```
Scenario: Write async test that waits for element
Baseline (no skill): Agent uses setTimeout(1000)
Problem: Arbitrary timeout, flaky on slow systems
```

### For Discipline-Enforcing Skills

**Test**: Will agents violate the rule under pressure?

1. Create pressure scenario combining:
   - **Time pressure**: "This is urgent"
   - **Sunk cost**: "Already have working code"
   - **Authority**: "I'm confident this is correct"
   - **Exhaustion**: "Just this once"

2. Run subagent WITHOUT skill
3. **Document rationalizations verbatim**:
   ```
   Agent said: "Since the code is simple and obvious,
   writing tests first would be overkill. I'll write
   the test after to verify it works."
   ```

4. Build rationalization table from actual failures

### For Pattern Skills

**Test**: Do agents recognize when pattern applies?

1. Present scenario where pattern is appropriate
2. Present counter-example where pattern doesn't apply
3. Run without skill
4. Document:
   - Do they recognize applicability?
   - Do they know when NOT to apply?

### Document Everything

Create `testing-notes.md` (temporary file):
```markdown
## Baseline Tests (RED Phase)

### Test 1: Basic application
Scenario: [describe]
Agent behavior: [exact quotes]
Problems:
- [what went wrong]
- [what was missed]

### Test 2: Pressure scenario
Pressures applied: time + sunk cost
Agent rationalization: "[verbatim quote]"
Violation: [what rule was broken]

### Test 3: Edge case
Scenario: [describe]
Result: [what happened]
Gap in understanding: [what was missing]
```

**This document proves you watched the test fail.**

## Step 6: TDD Phase - GREEN (Write Minimal Skill)

Now write the skill addressing ONLY the specific failures you documented.

### SKILL.md Structure

```markdown
---
name: your-skill-name
description: Use when [triggers from baseline tests] - [solution to observed problems]
---

# Skill Title

## Overview

[Core principle in 1-2 sentences]

[If discipline-enforcing: "Violating the letter of the rules is violating the spirit."]

## When to Use

[Bullet list of specific symptoms from baseline tests]

**When NOT to use:**
[Counter-examples from testing]

## [Main Content Section - varies by type]

[For techniques: The Process with steps]
[For patterns: Core Pattern with before/after]
[For references: Quick Start + Decision Tree]
[For discipline: The Iron Law + Red Flags]

## [Additional Sections]

[Quick Reference table]
[Common Mistakes from testing]
[Examples addressing baseline failures]

## [For Discipline Skills: Rationalization Table]

| Excuse | Reality |
|--------|---------|
| [verbatim from testing] | [counter-argument] |
| [another rationalization] | [another counter] |
```

### Token Optimization

Target word counts:
- **getting-started workflows**: < 150 words each section
- **Frequently-loaded skills**: < 500 words total
- **Other skills**: < 1500 words (still be concise)

**Techniques**:

**1. Use tables over prose**
```markdown
# ❌ Bad: Verbose prose (65 words)
When you need to wait for a condition, you should use condition-based
waiting instead of arbitrary timeouts. This approach polls for a
condition at regular intervals until it becomes true or times out.
It's more reliable than setTimeout because it doesn't depend on
arbitrary delays.

# ✅ Good: Concise table (30 words)
| Approach | When | Why |
|----------|------|-----|
| Condition polling | Async tests | Reliable, self-adjusting |
| Arbitrary timeout | Never | Flaky, system-dependent |
```

**2. Cross-reference other skills**
```markdown
# ❌ Bad: Repeat content (200 words)
[Detailed explanation of TDD workflow...]

# ✅ Good: Reference (20 words)
**REQUIRED BACKGROUND:** Use test-driven-development skill
for the complete TDD workflow.
```

**3. Link to scripts for complexity**
```markdown
# ❌ Bad: Inline 200-line script
```python
[complex validation script]
```

# ✅ Good: Execute script (10 words)
Run `scripts/validate_schema.py` to check consistency.
```

**4. Move heavy docs to references/**
```markdown
# ❌ Bad: 1000-line API reference inline
## Complete API
[extensive documentation]

# ✅ Good: Link to reference (15 words)
For complete API reference, see references/api-docs.md.
Load only when needed.
```

### Address Baseline Failures

For each failure documented in RED phase, add:

**For missing steps**:
```markdown
## Common Mistakes

**Skipping validation step**
Without validation, [specific problem from baseline].
Always [specific instruction].
```

**For rationalizations**:
```markdown
## Red Flags - STOP and Start Over

- "[exact rationalization from testing]"
- "[another rationalization]"

All of these mean: [correct action]
```

**For confusion**:
```markdown
## Decision Tree

When deciding [confusing choice point]:
  → If [condition], use [approach A]
  → If [condition], use [approach B]
```

## Step 7: TDD Phase - GREEN (Verify Passes)

Run the SAME tests with skill loaded:

1. Load skill in agent context
2. Run identical scenarios
3. Verify agents now:
   - Follow correct steps
   - Don't use rationalizations
   - Apply pattern appropriately

**Success Criteria**: All baseline failures are now fixed

**Document**:
```markdown
## Verification Tests (GREEN Phase)

### Test 1: Basic application
Result: ✅ Agent followed correct workflow
Changes: [what improved]

### Test 2: Pressure scenario
Result: ✅ Agent resisted rationalization
Key: Rationalization table prevented "[specific excuse]"

### Test 3: Edge case
Result: ✅ Agent recognized counter-example
Key: "When NOT to use" section clarified boundary
```

## Step 8: TDD Phase - REFACTOR (Close Loopholes)

Run additional tests to find NEW rationalizations:

### Pressure Tests

For discipline-enforcing skills, combine multiple pressures:

**Test Matrix**:
```
Pressure 1: Time constraint
Pressure 2: Sunk cost (existing code)
Pressure 3: Confidence bias ("I'm sure it's right")

Combinations:
- Time + Sunk cost
- Time + Confidence
- Sunk cost + Confidence
- All three combined
```

### Edge Case Tests

For technique/pattern skills:

```markdown
Scenario: [unusual but valid use case]
Does skill cover it? [yes/no]
If no: Add section addressing this case
```

### Iteration

1. Find new failure mode
2. Add explicit counter
3. Re-test
4. Repeat until bulletproof

**Example iteration**:
```
Iteration 1: "Tests after achieve same purpose"
→ Add to rationalization table
→ Add "Tests-after = 'what does this do?' vs Tests-first = 'what should it do?'"

Iteration 2: "It's about spirit not ritual"
→ Add upfront: "Violating letter = violating spirit"

Iteration 3: "This case is different because..."
→ Add "No exceptions:" list with specific non-exceptions
```

### Build Rationalization Table (Discipline Skills)

```markdown
| Excuse | Reality |
|--------|---------|
| [rationalization 1 from Iteration 1] | [counter] |
| [rationalization 2 from Iteration 2] | [counter] |
| [rationalization 3 from Iteration 3] | [counter] |
| ... | ... |
```

## Step 9: Add Supporting Resources

### When to Create Scripts

**Create script when**:
- Operation is deterministic (same inputs → same outputs)
- Operation is complex (> 50 lines of code)
- Operation will be reused

**Script Guidelines**:
```python
#!/usr/bin/env python3
"""
Brief description of what script does.

Usage:
    python script_name.py <arg1> <arg2>

Example:
    python extract_fields.py form.pdf output.json
"""

def main():
    # Handle errors gracefully
    # Print clear messages
    # Exit with appropriate codes

if __name__ == '__main__':
    main()
```

**Script Benefits**:
- Zero tokens until executed
- Only output loaded into context
- Reusable across invocations

### When to Create References

**Create reference file when**:
- Documentation > 1000 words
- API reference with many methods
- Multiple related examples
- Heavy technical content

**Reference Structure**:
```markdown
# Reference: [Topic]

## Quick Lookup
[Table or list for scanning]

## Detailed Documentation
[Comprehensive coverage]

## Examples
[Real-world scenarios]
```

**Loading Pattern** in SKILL.md:
```markdown
For complete [topic] reference, see references/[filename].md

Load when you need detailed information on [specific use case].
```

### When to Create Assets

**Create asset when**:
- Template files for output
- Diagrams clarifying workflows
- Schema definitions
- Example files

**Examples**:
- `templates/report-template.html`
- `assets/workflow-diagram.png`
- `assets/schema-example.json`

## Step 10: Polish for Discoverability

### CSO Checklist

✅ **Description optimization**:
- Starts with "Use when"
- Includes specific symptoms
- Contains searchable keywords
- Written in third person
- Under 500 characters

✅ **Keyword density** in SKILL.md:
- Error messages agents might see
- Symptoms users might describe
- Tool/library names
- Related concepts

✅ **Clear structure**:
- Scannable headings
- Quick reference tables
- Examples up front
- Heavy details in references/

✅ **Cross-references**:
- Use skill names only (not @paths)
- Mark REQUIRED vs optional
- Explain relationship

### Test Discoverability

1. **Describe a problem** the skill solves
2. Check if description matches
3. If low match, add keywords

**Example**:
```
Problem description: "My async tests keep failing randomly"

Keywords to add:
- "flaky", "intermittent", "random failures"
- "timing", "race conditions"
- "async", "asynchronous"
```

## Step 11: Package and Validate

### File Location

**User-level** (general-purpose):
```
~/.claude/skills/skill-name/
```

**Project-level** (project-specific pattern):
```
.claude/skills/skill-name/
```

### Validation Script

Run if available:
```bash
python ~/.claude/skills/skill-creator/scripts/quick_validate.py skill-name/
```

Checks:
- ✅ Valid YAML frontmatter
- ✅ Name format (kebab-case)
- ✅ Description < 1024 chars
- ✅ No special characters in name
- ✅ SKILL.md exists

### Manual Checklist

- [ ] Name uses only letters, numbers, hyphens
- [ ] Description starts with "Use when"
- [ ] Description written in third person
- [ ] Description < 500 characters
- [ ] File structure matches planned type
- [ ] All scripts are executable (`chmod +x`)
- [ ] All references are linked (not @included)
- [ ] RED-GREEN-REFACTOR cycle completed
- [ ] All baseline failures fixed
- [ ] Rationalization table complete (if discipline skill)
- [ ] Examples address real scenarios
- [ ] Cross-references use skill names only

## Step 12: Deploy and Iterate

### Initial Deployment

1. **Commit to git** (if using version control):
   ```bash
   git add ~/.claude/skills/skill-name/
   git commit -m "Add skill: skill-name"
   ```

2. **Test in real usage**:
   - Use in actual projects
   - Note any confusion
   - Watch for new rationalizations

### Iteration Cycle

**When you notice**:
- Agent doesn't apply skill correctly
- New rationalization emerges
- Missing information discovered

**Then**:
1. Document the failure (RED)
2. Update skill to address it (GREEN)
3. Test the update (GREEN verification)
4. Check for new loopholes (REFACTOR)

### Maintenance

**Update when**:
- Technology changes (API updates, new versions)
- Better patterns discovered
- User feedback reveals gaps

**Re-test after updates**:
- Run baseline scenarios again
- Verify fixes still work
- Check no regressions

## Complete Example: Creating "api-error-handling" Skill

### Step 1-2: Identify & Determine Type
- **Need**: Agents handle API errors inconsistently
- **Type**: Technique skill (step-by-step procedure)

### Step 3: Plan Structure
```
api-error-handling/
  SKILL.md                    # Workflow + patterns
  scripts/
    check_error_coverage.py   # Validate error handling
  references/
    http-status-codes.md      # Complete reference
```

### Step 4: Write Frontmatter
```yaml
---
name: api-error-handling
description: Use when building API clients and need consistent error
  handling - provides patterns for retries, exponential backoff,
  circuit breakers, and user-facing error messages for HTTP APIs
---
```

### Step 5: RED Phase
```markdown
## Baseline Test Results

### Test 1: Basic API client
Agent behavior:
- Only handled 200 OK
- No retry logic
- Generic error messages
- No timeout handling

### Test 2: With errors
Agent behavior:
- Caught exceptions but re-threw immediately
- No distinction between retryable vs fatal
- No exponential backoff
```

### Step 6: GREEN Phase
```markdown
# API Error Handling

## Overview
Consistent error handling for HTTP APIs with retries,
backoff, and user-facing messages.

## The Process

### 1. Categorize Errors
| Status | Category | Retry? | User Message |
|--------|----------|--------|-------------|
| 400    | Client error | No | "Invalid request" |
| 401    | Auth failure | No | "Authentication failed" |
| 429    | Rate limit | Yes | "Too many requests, retrying..." |
| 500    | Server error | Yes | "Server error, retrying..." |
| Timeout | Network | Yes | "Request timed out, retrying..." |

### 2. Implement Retry Logic
```python
# (Example addressing baseline failure)
```

### 3. Add Circuit Breaker
[Pattern for preventing cascade failures]

### 4. User-Facing Messages
[Map technical errors to user-friendly messages]

## Common Mistakes

**Retrying non-retryable errors**
[Address from baseline]

**No exponential backoff**
[Address from baseline]
```

### Step 7: GREEN Verification
```markdown
## Verification

### Test 1 (retried):
✅ Agent now categorizes errors
✅ Implements retry with backoff
✅ User-friendly messages

### Test 2 (retried):
✅ Distinguishes retryable vs fatal
✅ Circuit breaker prevents cascade
```

### Step 8: REFACTOR
```markdown
## Additional Iterations

### Found: Agent retries 400 errors
Action: Added explicit "No retry for 4xx (except 429)"

### Found: Infinite retry on network errors
Action: Added max retry count example

### Found: No logging
Action: Added logging guidance section
```

### Step 9: Supporting Resources
```python
# scripts/check_error_coverage.py
"""Validates API client has comprehensive error handling."""
# (Implementation)
```

```markdown
# references/http-status-codes.md
Complete reference of HTTP status codes with handling recommendations
```

### Step 10-12: Polish, Package, Deploy
- ✅ Description optimized for CSO
- ✅ Keywords: "API", "error", "retry", "HTTP", "timeout"
- ✅ Deployed to ~/.claude/skills/
- ✅ Tested in real project
- ✅ Iterated based on usage

## Quick Reference: Skill Creation Checklist

Use this for every skill you create:

### Planning Phase
- [ ] Identified reusable pattern
- [ ] Determined skill type
- [ ] Planned directory structure

### RED Phase (Baseline)
- [ ] Created test scenarios
- [ ] Ran without skill
- [ ] Documented failures verbatim
- [ ] Built rationalization table (if discipline skill)

### GREEN Phase (Implementation)
- [ ] Wrote YAML frontmatter (valid format)
- [ ] Wrote SKILL.md addressing baseline failures
- [ ] Optimized for token efficiency
- [ ] Added supporting resources if needed
- [ ] Ran tests WITH skill
- [ ] Verified all failures fixed

### REFACTOR Phase (Bulletproofing)
- [ ] Found new failure modes
- [ ] Added explicit counters
- [ ] Updated rationalization table
- [ ] Re-tested until bulletproof

### Polish Phase
- [ ] Optimized for CSO (keywords, structure)
- [ ] Cross-references use skill names only
- [ ] No force-loading (@paths)
- [ ] Examples address real scenarios

### Deployment Phase
- [ ] Validation script passed (if available)
- [ ] Manual checklist completed
- [ ] Committed to git
- [ ] Ready for real-world usage

### Iteration Phase (Ongoing)
- [ ] Monitor real usage
- [ ] Document new failures
- [ ] Update and re-test
- [ ] Maintain over time

## Next Steps

1. **Study code intelligence** → Read `examples/code-intelligence/`
2. **Review real skills** → Examine `~/.claude/skills/*/SKILL.md`
3. **Learn testing methodology** → Read `advanced/skill-testing-methodology.md`
4. **Understand integration** → Browse `integration/` directory
5. **Create your first skill** → Apply this guide

## References

- **TDD for Skills**: `~/.claude/skills/writing-skills/SKILL.md`
- **TDD Fundamentals**: `~/.claude/skills/test-driven-development/SKILL.md`
- **Skill Creator Docs**: `~/.claude/skills/skill-creator/SKILL.md`
- **Real Examples**: `~/.claude/skills/*/`

---

**Navigation**:
- [← Skills Overview](02-skills-overview.md)
- [Next: Code Intelligence Overview →](examples/code-intelligence/code-intel-overview.md)
