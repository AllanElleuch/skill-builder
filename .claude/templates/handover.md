---
from_agent: ""
to_agent: ""
chain_id: ""
timestamp: ""
status: "pending"
type: "handover"
naming_pattern: "YYYYMMDD-HHMM-handover-{from}-to-{to}.md"
token_limit: 600
---

# Agent Handover: [From] → [To]

## Essential Context
<!-- ONLY non-obvious context. Assume receiving agent can query intel for basics. -->

**Current Task:**
**Why Handover:**
**Critical Context:**

---

## Pending Tasks

### Task 1: [Task Name]
- **Status:** [not-started | in-progress | blocked]
- **ACs:**
  - [ ] [AC 1]
  - [ ] [AC 2]
- **Blocker:** [if applicable]

### Task 2: [Task Name]
- **Status:**
- **ACs:**
  - [ ] [AC 1]
  - [ ] [AC 2]

---

## Blockers

1. **[Blocker Description]**
   - **Impact:** [what is blocked]
   - **Resolution:** [what needs to happen]
   - **Owner:** [who can unblock]

---

## Intel Links
<!-- File paths ONLY. Receiving agent queries these. NO excerpts. -->

**Relevant Files:**
- `[file:line range]` - [why relevant]
- `[file:line range]` - [why relevant]

**Intel Queries to Run:**
```bash
project-intel.mjs --symbols [file]
project-intel.mjs --dependencies [file]
```

**MCP Queries to Run:**
- [MCP tool] query: [query details]

---

## Overflow Handling
<!-- If this handover exceeds 600 tokens, create report.md and link here -->

**Full Report:** [link to report.md if overflow]

---

**Handover Complete:** [yes/no]
**Confirmed By:** [receiving agent signature]
