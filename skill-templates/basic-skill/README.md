# Basic Skill Template

## Purpose

This template is for creating **self-contained skills** that don't require external scripts, references, or assets. All content fits within a single SKILL.md file.

Perfect for techniques, patterns, simple references, and discipline-enforcing workflows.

## When to Use This Template

### Use this template when:

- All content fits comfortably in one file (< 500 words)
- No complex scripts needed
- No heavy API documentation (< 100 lines of reference)
- Skill is a technique, pattern, or simple reference
- Teaching a mental model or approach
- Enforcing a discipline or process

### Use a different template when:

- **Need executable scripts** → Use `skill-with-scripts/`
- **Have heavy documentation (> 1000 words)** → Use `skill-with-references/`
- **Orchestrating multiple subagents** → Use `skill-with-subagents/`
- **Integrating with MCP tools** → Use `skill-with-mcp/`
- **Event-driven workflows** → Use `skill-with-hooks/`

## Skill Types for This Template

### Technique Skills
Step-by-step how-to guides for concrete methods.

**Examples:** condition-based-waiting, root-cause-tracing, defensive-programming

**Test with:**
- Application scenarios: Can agents apply the technique correctly?
- Variation scenarios: Do they handle edge cases?
- Missing information tests: Do instructions have gaps?

### Pattern Skills
Mental models and ways of thinking about problems.

**Examples:** flatten-with-flags, test-invariants, reducing-complexity

**Test with:**
- Recognition scenarios: Do they recognize when pattern applies?
- Application scenarios: Can they use the mental model?
- Counter-examples: Do they know when NOT to apply?

### Reference Skills
Quick lookup guides for APIs, syntax, or commands.

**Examples:** Command references, API cheat sheets (keep < 100 lines)

**Test with:**
- Retrieval scenarios: Can they find the right information?
- Application scenarios: Can they use what they found correctly?
- Gap testing: Are common use cases covered?

### Discipline Skills
Process enforcement and rule compliance.

**Examples:** test-driven-development, verification-before-completion

**Test with:**
- Academic questions: Do they understand the rules?
- Pressure scenarios: Do they comply under stress?
- Multiple pressures combined: time + sunk cost + exhaustion
- Identify rationalizations and add explicit counters

## How to Use

### Step 1: Copy Template

```bash
cp -r skill-templates/basic-skill ~/.claude/skills/your-skill-name
cd ~/.claude/skills/your-skill-name
```

Replace `your-skill-name` with kebab-case name (letters, numbers, hyphens only).

### Step 2: Customize SKILL.md

#### A. Update Frontmatter

**Name:**
- Use kebab-case: letters, numbers, hyphens only
- NO parentheses, underscores, or special characters
- Use verb-first active voice: `creating-skills` not `skill-creation`
- Name by what you DO: `condition-based-waiting` not `async-test-helpers`

**Description (CRITICAL for discovery):**

Format: `Use when [specific triggers] - [what it does, third person]`

**Include:**
- Concrete symptoms (race conditions, flaky tests, hanging processes)
- Error messages agents might see
- Observable behaviors that trigger this skill
- What the skill does and how it helps

**Keep under 500 characters**

**Examples:**

✅ GOOD:
```yaml
description: Use when tests have race conditions, timing dependencies, or pass/fail inconsistently - replaces arbitrary timeouts with condition polling for reliable async tests
```

✅ GOOD:
```yaml
description: Use when implementing any feature or bugfix, before writing implementation code - write the test first, watch it fail, write minimal code to pass; ensures tests actually verify behavior by requiring failure first
```

❌ BAD (too vague, no triggers):
```yaml
description: For async testing
```

❌ BAD (first person):
```yaml
description: I can help you with async tests when they're flaky
```

#### B. Fill in Sections

**Overview:**
- Core principle in 1-2 sentences
- For discipline skills, add: "Violating the letter of the rules is violating the spirit of the rules."

**When to Use:**
- List specific symptoms and triggering conditions
- Include counter-examples (when NOT to use)
- Add small flowchart ONLY if decision is non-obvious

**Main Content (choose appropriate name):**
- Technique → "The Process" (step-by-step)
- Pattern → "Core Pattern" (before/after transformation)
- Reference → "Quick Reference" (table or bullets)
- Discipline → "The Iron Law" (rule + explicit loophole closures)

**Implementation:**
- One excellent code example (complete and runnable)
- Well-commented explaining WHY
- Choose most relevant language for domain
- Don't implement in multiple languages

**Common Mistakes:**
- Based on actual testing with subagents
- Not hypothetical issues
- What goes wrong + how to fix

**For Discipline Skills Only:**

Add these sections:

**Red Flags - STOP and Start Over:**
- Warning signs from testing
- Actual rationalizations agents used
- Clear action to take

**Rationalization Table:**
- Every excuse from baseline testing
- Counter-argument for each
- Build systematically through RED-GREEN-REFACTOR

#### C. Delete All Comments

Remove all HTML comments (`<!-- ... -->`) before finalizing.

### Step 3: Test with Subagents (MANDATORY)

**REQUIRED BACKGROUND:** You MUST understand test-driven-development skill before writing skills. This is TDD applied to process documentation.

Follow RED-GREEN-REFACTOR cycle:

#### RED: Baseline Testing (Write Failing Test)

1. **Create pressure scenarios** appropriate for skill type (see "Skill Types" above)
2. **Run scenarios WITHOUT skill** - fresh subagent, no access to your draft
3. **Document baseline behavior verbatim:**
   - What choices did they make?
   - What rationalizations did they use? (quote exactly)
   - Which pressures triggered violations?
   - Where did instructions have gaps?

This is "watch the test fail" - you MUST see what agents naturally do wrong.

**For Discipline Skills:**
- Use 3+ combined pressures (time + sunk cost + authority + exhaustion)
- Look for creative rationalizations
- Test under maximum pressure

#### GREEN: Write Minimal Skill

1. **Address specific baseline failures** you documented
2. **Don't add hypothetical content** for issues you didn't observe
3. **Run same scenarios WITH skill** present
4. **Verify agents now comply/succeed**

#### REFACTOR: Close Loopholes

1. **Agent found new rationalization?** Add explicit counter
2. **Update Rationalization Table** with new excuses
3. **Update Red Flags** with new warning signs
4. **Re-test until bulletproof**

For discipline skills, keep pressure-testing until agents can't find workarounds.

**See these skills for complete testing methodology:**
- `~/.claude/skills/writing-skills/SKILL.md` - Complete TDD approach for skills
- `~/.claude/skills/test-driven-development/SKILL.md` - TDD fundamentals

### Step 4: Validate

Run validation if available:

```bash
python ~/.claude/skills/skill-creator/scripts/quick_validate.py your-skill-name/
```

**Manual checks:**

- [ ] Name uses only letters, numbers, hyphens
- [ ] No parentheses, underscores, or special characters in name
- [ ] Description starts with "Use when"
- [ ] Description written in third person
- [ ] Description < 500 characters
- [ ] Description includes concrete triggers and symptoms
- [ ] All sections present and filled (not placeholder text)
- [ ] Examples are concrete and actionable
- [ ] Code examples are complete and runnable
- [ ] Testing completed (RED-GREEN-REFACTOR)
- [ ] For discipline skills: Rationalization Table and Red Flags present
- [ ] All HTML comments removed
- [ ] No multi-language code examples (one excellent example only)

### Step 5: Deploy

Skill is ready to use! It will auto-load when relevant based on description.

**Test discovery:**
1. Start fresh conversation
2. Describe a problem the skill solves (use symptoms from description)
3. Check if Claude loads it automatically
4. If not matching, refine description with better triggers

**Version control (optional but recommended):**
```bash
cd ~/.claude/skills/your-skill-name
git init
git add .
git commit -m "Initial version of your-skill-name skill"
```

## Example Skills Using This Pattern

Study these installed skills for concrete examples:

**Discipline-enforcing:**
- `~/.claude/skills/test-driven-development/` - Iron Law, Red Flags, Rationalization Table

**Technique:**
- Look for skills with "The Process" section showing step-by-step how-tos

**Pattern:**
- Look for skills with "Core Pattern" showing before/after transformations

**Check your ~/.claude/skills/ directory for more examples.**

## Checklist

Use this when creating your skill:

### Planning
- [ ] Identified reusable pattern worth documenting
- [ ] Determined skill type (technique/pattern/reference/discipline)
- [ ] Confirmed all content fits in single file (< 500 words)
- [ ] Verified this is right template (not scripts/references/subagents/mcp/hooks)

### Implementation
- [ ] Copied template to ~/.claude/skills/your-skill-name
- [ ] Updated name (kebab-case, no special chars)
- [ ] Wrote description starting with "Use when..."
- [ ] Description in third person, includes triggers and what it does
- [ ] Description under 500 characters
- [ ] Filled Overview with core principle
- [ ] Listed specific triggering symptoms in "When to Use"
- [ ] Chose appropriate main section name for skill type
- [ ] Added one excellent code example (complete, runnable, well-commented)
- [ ] Deleted all HTML comments from template
- [ ] For discipline skills: Added Red Flags section
- [ ] For discipline skills: Added Rationalization Table section

### Testing (RED Phase)
- [ ] Created 3+ pressure scenarios appropriate for skill type
- [ ] Ran scenarios WITHOUT skill (baseline test)
- [ ] Documented failures/rationalizations verbatim
- [ ] Identified patterns in how agents failed

### Testing (GREEN Phase)
- [ ] Addressed specific baseline failures in skill
- [ ] Ran scenarios WITH skill present
- [ ] Verified all baseline failures now fixed
- [ ] Agents successfully apply technique/comply with rules

### Testing (REFACTOR Phase)
- [ ] Identified NEW rationalizations from GREEN testing
- [ ] Added explicit counters for new loopholes
- [ ] Updated Rationalization Table with all excuses found
- [ ] Updated Red Flags with all warning signs
- [ ] Re-tested until bulletproof (especially for discipline skills)

### Quality Checks
- [ ] Code examples use appropriate language for domain
- [ ] Only one code example per pattern (not multi-language)
- [ ] Flowcharts only if decision is non-obvious
- [ ] Common Mistakes based on actual testing (not hypothetical)
- [ ] Quick reference table if applicable
- [ ] No narrative storytelling ("In session X, we found...")
- [ ] Keywords throughout for searchability
- [ ] Token-efficient (< 500 words total)

### Deployment
- [ ] Validation script passed (if available)
- [ ] Manual validation checks passed
- [ ] Tested discovery (fresh conversation with symptoms)
- [ ] Skill auto-loads when expected
- [ ] Committed to git (if using version control)
- [ ] Ready for real-world usage

## The Iron Law (from writing-skills)

```
NO SKILL WITHOUT A FAILING TEST FIRST
```

This applies to NEW skills AND EDITS to existing skills.

**No exceptions:**
- Not for "simple additions"
- Not for "just adding a section"
- Not for "documentation updates"
- Don't keep untested changes as "reference"
- Don't "adapt" while running tests
- Delete means delete

If you write/edit skill before testing: Delete it. Start over with RED-GREEN-REFACTOR.

## Common Mistakes Creating Skills

**Writing before testing:**
Reality: Untested skills have issues. Always. 15 min testing saves hours of debugging bad skill in production.

**"Skill is obviously clear":**
Reality: Clear to you ≠ clear to other agents. Test it.

**"Testing is overkill":**
Reality: Testing is less tedious than debugging bad skill in production.

**Multiple languages for same example:**
Reality: Mediocre quality, maintenance burden. One excellent example beats five mediocre ones.

**Using flowcharts for code:**
Reality: Can't copy-paste, hard to read. Use markdown code blocks.

**Generic placeholders left in:**
Reality: Skill isn't done until all brackets replaced with real content.

## References

**Foundation guides:**
- `docs/skills-guide/03-creating-skills-fundamentals.md` - Complete skill creation guide
- `docs/skills-guide/02-skills-overview.md` - Understanding skill system

**Required background skills:**
- `~/.claude/skills/test-driven-development/SKILL.md` - TDD fundamentals (MUST understand this)
- `~/.claude/skills/writing-skills/SKILL.md` - TDD applied to skill creation

**Testing methodology:**
- RED-GREEN-REFACTOR cycle from TDD skill
- Pressure testing from writing-skills
- Bulletproofing against rationalization

## Questions?

**Q: Can I add multiple code examples?**
A: One excellent example beats many mediocre ones. Choose most relevant language and make it complete, runnable, and well-commented.

**Q: When should I use a flowchart?**
A: Only for non-obvious decisions where agents might go wrong. Not for reference material, code, or linear steps.

**Q: How do I know if my description is good?**
A: Test it. Start fresh conversation, describe problem with symptoms from description. Does skill auto-load?

**Q: Can I skip testing for a "simple" skill?**
A: No. Simple skills break too. Testing takes 15 minutes. Debugging bad skill in production takes hours.

**Q: What if I want to add to existing skill?**
A: Same process. Test WITHOUT change (baseline), add change, test WITH change (verify), iterate.

**Q: My skill is longer than 500 words. Wrong template?**
A: Maybe. If you have heavy reference (>100 lines), use `skill-with-references/`. If you have scripts, use `skill-with-scripts/`. This template works best under 500 words.

**Q: Can I use first person in description?**
A: No. Description is injected into system prompt. Write third person: "Use when..." not "I can help when..."

**Q: What makes a good skill name?**
A: Verb-first active voice, describes what you DO, kebab-case. Good: `creating-skills`, `condition-based-waiting`. Bad: `skill-creation`, `async_helpers`, `tdd-(advanced)`.
