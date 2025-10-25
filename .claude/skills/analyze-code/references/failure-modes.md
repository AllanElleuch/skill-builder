# Failure Modes: Common Analysis Issues

**Purpose**: Identify and fix the 5 most common intelligence-first analysis failures.

---

## Failure 1: PROJECT_INDEX.json Missing or Stale

### Symptom
```bash
$ project-intel.mjs --overview --json
Error: PROJECT_INDEX.json not found

# OR

$ project-intel.mjs --search "LoginForm" --json
{
  "results": []
}
# (Expected files exist but not found)
```

### Impact
- Intelligence queries fail or return empty results
- Cannot perform intel-first analysis
- Forces direct file reading (token waste)

### Solution

**Immediate Fix**:
```bash
# Generate PROJECT_INDEX.json
/index
```

**Verify Generation**:
```bash
# Check index exists
ls -la PROJECT_INDEX.json

# Verify contents
project-intel.mjs --overview --json
```

### Prevention
- Hook auto-generates index on file changes (configure in .claude/settings.json)
- Run `/index` at session start if index missing
- Check index timestamp vs latest code changes

### Diagnostic Commands
```bash
# Check if index exists
ls -la PROJECT_INDEX.json

# Check index age
stat -f "%Sm" PROJECT_INDEX.json

# Verify index contents
project-intel.mjs --stats --json
```

---

## Failure 2: Intelligence Queries Return No Results

### Symptom
```bash
$ project-intel.mjs --search "auth" --type tsx --json
{
  "results": []
}

$ project-intel.mjs --symbols src/components/LoginForm.tsx --json
Error: File not found in index
```

### Impact
- Cannot locate relevant code
- May incorrectly conclude code doesn't exist
- Forces guessing file locations

### Root Causes
1. **File excluded by .gitignore**: Common with node_modules/, .next/, dist/
2. **Wrong file type filter**: Searching --type tsx but file is .ts
3. **Typo in search pattern**: "lgin" instead of "login"
4. **File not yet indexed**: New file created after index generation

### Solution

**Step 1: Verify File Exists**:
```bash
# Check file exists on filesystem
ls -la src/components/LoginForm.tsx

# Check if excluded by .gitignore
git check-ignore -v src/components/LoginForm.tsx
```

**Step 2: Regenerate Index**:
```bash
/index
```

**Step 3: Verify Index Contents**:
```bash
# Check total files
project-intel.mjs --stats --json

# Try broader search
project-intel.mjs --search "login" --json  # No type filter
```

**Step 4: Adjust Search Strategy**:
```bash
# Try partial match
project-intel.mjs --search "Login" --json

# Try different type
project-intel.mjs --search "auth" --type ts --json
```

### Prevention
- Run `/index` after creating new files
- Use broader search terms initially
- Check .gitignore patterns
- Verify file type extensions

### Diagnostic Workflow
```
Empty results
    ↓
1. File exists? → ls -la path
    ↓ YES
2. In .gitignore? → git check-ignore -v path
    ↓ NO
3. Index fresh? → regenerate with /index
    ↓ YES
4. Broader search? → remove --type filter
    ↓ STILL EMPTY
5. Check index stats → project-intel.mjs --stats
```

---

## Failure 3: MCP Tools Not Available

### Symptom
```bash
Tool call failed: mcp__Ref__ref_search_documentation
Error: MCP server 'Ref' not configured
```

### Impact
- Cannot verify library behavior
- Must rely on memory (less accurate)
- Cannot provide authoritative sources

### Solution

**Check MCP Configuration**:
```bash
# Verify MCP servers configured
cat .mcp.json

# OR check settings
/mcp
```

**Configure Missing MCP**:

For Ref MCP (library documentation):
```json
{
  "mcpServers": {
    "ref": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-ref"]
    }
  }
}
```

**Workaround** (if MCP unavailable):
- Skip external library verification
- Note in report: "MCP verification unavailable"
- Focus analysis on internal code only
- Use web search as fallback

### Prevention
- Verify MCP servers at session start
- Include .mcp.json in project repository
- Document required MCP tools in README

### Diagnostic Commands
```bash
# Check MCP configuration
cat .mcp.json

# List available MCP tools
/mcp

# Test MCP connection
# (Use built-in /mcp command to check status)
```

---

## Failure 4: Analysis Scope Too Broad

### Symptom
```
Token limit exceeded
Analysis incomplete
Multiple unrelated issues found
Report exceeds 1000 tokens
```

### Impact
- Cannot complete analysis
- Findings lack depth
- Token budget exhausted
- Context window filled with irrelevant data

### Root Causes
1. **No scope defined**: Analyzing entire codebase
2. **Overly broad search**: Searching for common terms like "component" or "function"
3. **Reading full files**: Not using targeted reads after intel queries
4. **Multiple unrelated issues**: Trying to solve everything at once

### Solution

**Step 1: Define Narrow Scope**:
```markdown
# analysis-spec.md
## Objective
Identify why LoginForm component re-renders infinitely

## In-Scope
- LoginForm.tsx only
- Related hooks (useEffect, useState)
- Direct dependencies only

## Out-of-Scope
- Other components
- Backend API
- Routing
```

**Step 2: Use Targeted Searches**:
```bash
# ❌ Too broad
project-intel.mjs --search "component" --json

# ✅ Specific
project-intel.mjs --search "LoginForm" --type tsx --json
```

**Step 3: Read Targeted Lines**:
```bash
# ❌ Full file
Read src/components/LoginForm.tsx

# ✅ Specific lines
sed -n '40,60p' src/components/LoginForm.tsx
```

**Step 4: Focus on Single Issue**:
```markdown
# ❌ Multiple issues
- Fix infinite render
- Optimize performance
- Improve error handling

# ✅ Single issue
- Fix infinite render bug
  (address performance and errors in separate analyses)
```

### Prevention
- Define scope in analysis-spec.md before starting
- Use specific search terms
- Target single issue per analysis
- Break complex problems into sub-analyses

### Recovery Strategy
If analysis already too broad:
1. Stop current analysis
2. Create multiple narrower analysis-spec.md files
3. Analyze each scope separately
4. Combine findings in summary report

---

## Failure 5: CoD^Σ Evidence Missing

### Symptom
```markdown
# Report missing evidence
Claim: The bug is in the useEffect
(No file:line, no intelligence query results, no trace)

# OR

Claim: Component has performance issues
Evidence: (empty)
```

### Impact
- Cannot verify findings
- No audit trail
- Others can't reproduce analysis
- Recommendations lack credibility

### Root Causes
1. **Skipped evidence collection**: Made claims without querying
2. **Intel queries not documented**: Ran queries but didn't save results
3. **MCP verification skipped**: Assumed behavior without checking
4. **CoD^Σ trace incomplete**: Missing reasoning steps

### Solution

**Step 1: Complete Intel Queries**:
```bash
# Save all intel query results
project-intel.mjs --search "LoginForm" --json > /tmp/search.json
project-intel.mjs --symbols src/LoginForm.tsx --json > /tmp/symbols.json
project-intel.mjs --dependencies src/LoginForm.tsx --json > /tmp/deps.json
```

**Step 2: Document Every Step in CoD^Σ Trace**:
```markdown
## CoD^Σ Trace

**Claim:** LoginForm re-renders at src/LoginForm.tsx:45

**Trace:**
```
Step 1: → IntelQuery("search LoginForm")
  ↳ Source: project-intel.mjs --search "LoginForm" --type tsx
  ↳ Data: Found src/components/LoginForm.tsx
  ↳ Tokens: 100

Step 2: ⇄ IntelQuery("analyze symbols")
  ↳ Source: project-intel.mjs --symbols src/components/LoginForm.tsx
  ↳ Data: useEffect at line 45
  ↳ Tokens: 150

Step 3: → TargetedRead(lines 40-60)
  ↳ Source: sed -n '40,60p' src/components/LoginForm.tsx
  ↳ Data: useEffect(() => { setUser({...user}) }, [user])
  ↳ Tokens: 100

Step 4: ⊕ MCPVerify("React docs")
  ↳ Tool: Ref MCP - "React useEffect dependencies"
  ↳ Data: "Every value must be in dependency array"
  ↳ Tokens: 200

Step 5: ∘ Conclusion
  ↳ Logic: Effect depends on [user] and mutates user
  ↳ Root Cause: src/LoginForm.tsx:45 infinite loop
  ↳ Fix: Use functional setState
```
**Total Tokens:** 550
```
```

**Step 3: Include Evidence Section**:
```markdown
## Evidence

### Intelligence Query Results
- Search results: /tmp/search.json
- Symbol analysis: /tmp/symbols.json
- Dependencies: /tmp/deps.json

### MCP Verification
- Tool: Ref MCP
- Query: "React useEffect dependencies"
- Source: https://react.dev/reference/react/useEffect

### Targeted Reads
- File: src/components/LoginForm.tsx
- Lines: 40-60
- Content: [relevant excerpt]
```

### Prevention
- Save all intel query results to /tmp/
- Document CoD^Σ trace in real-time
- Include Evidence section in every report
- Verify MCP results are captured

### Enforcement Checklist
```
Evidence Requirements:
- [ ] All intel queries documented with commands
- [ ] Intel results saved to /tmp/*.json
- [ ] CoD^Σ trace shows all 5 steps
- [ ] MCP verification included (if applicable)
- [ ] Targeted read excerpts included
- [ ] Every claim has file:line reference
```

**Report is incomplete until all checkboxes checked**

---

## Diagnostic Workflow for All Failures

When analysis fails:

```
Failure detected
    ↓
1. Check index (Failure 1)
   → PROJECT_INDEX.json exists and fresh?
    ↓
2. Check queries (Failure 2)
   → Intel queries return results?
    ↓
3. Check MCP (Failure 3)
   → MCP tools configured and working?
    ↓
4. Check scope (Failure 4)
   → Scope narrow and well-defined?
    ↓
5. Check evidence (Failure 5)
   → CoD^Σ trace complete with evidence?
```

---

## Quick Reference

| Failure | Symptom | Quick Fix |
|---------|---------|-----------|
| **1. Index Missing** | Intel queries fail | Run `/index` |
| **2. No Results** | Empty search results | Regenerate index, broaden search |
| **3. MCP Unavailable** | MCP tool errors | Configure .mcp.json, use workaround |
| **4. Scope Too Broad** | Token limit exceeded | Define narrow scope in analysis-spec.md |
| **5. Missing Evidence** | Claims lack proof | Save intel results, complete CoD^Σ trace |

**Remember**: Most analysis failures are preventable with proper scope definition and systematic intelligence queries.
