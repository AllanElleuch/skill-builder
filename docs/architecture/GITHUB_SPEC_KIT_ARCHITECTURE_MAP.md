# GitHub Spec-Kit System Architecture Map

**Generated**: 2025-10-19
**Source**: github/spec-kit (Specification-Driven Development toolkit)
**Purpose**: Complete dependency graph and process flow analysis for comparison with Intelligence Toolkit

---

## I. System Hierarchy

```
GitHub Spec-Kit (SDD Framework)
├── User Interface Layer
│   ├── Specify CLI (init, check commands)
│   └── Slash Commands (8 total)
│       ├── /speckit.constitution
│       ├── /speckit.specify
│       ├── /speckit.clarify
│       ├── /speckit.plan
│       ├── /speckit.tasks
│       ├── /speckit.implement
│       ├── /speckit.analyze
│       └── /speckit.checklist
│
├── Automation Layer (Bash Scripts)
│   ├── common.sh (shared functions: get_repo_root, get_current_branch, check_feature_branch)
│   ├── create-new-feature.sh (auto-number, create dirs, git branch)
│   ├── setup-plan.sh (validate branch, copy template)
│   ├── check-prerequisites.sh (validate workflow state, block invalid ops)
│   └── update-agent-context.sh (parse plan.md, update CLAUDE.md/GEMINI.md/etc)
│
├── Constitutional Layer (Documentation)
│   └── memory/constitution.md (immutable principles, not enforced)
│
├── Specification Layer
│   ├── spec.md (WHAT/WHY, technology-agnostic)
│   ├── Clarification workflow (max 5 questions per iteration)
│   └── Quality checklists (validate before planning)
│
├── Planning Layer
│   ├── plan.md (HOW with tech stack)
│   ├── research.md (decisions & rationale)
│   ├── data-model.md (entities without implementation)
│   ├── contracts/ (API specs, GraphQL schemas)
│   └── quickstart.md (validation scenarios)
│
├── Execution Layer
│   ├── tasks.md (user-story-organized tasks)
│   ├── TDD implementation (constitution recommends tests-first)
│   ├── Progressive execution (story-by-story)
│   └── Checklist validation (quality gates before implementation)
│
└── Template Engine
    ├── spec-template.md
    ├── plan-template.md
    ├── tasks-template.md
    └── agent-file-template.md
```

---

## II. Core Innovation

### Their Key Insights

1. **Scripts Provide Determinism**
   - Auto-numbering (not LLM-dependent)
   - Workflow validation (block invalid operations)
   - Context gathering (exact file paths)

2. **Constitution Provides Discipline**
   - Immutable architectural principles
   - Complexity limits (max 3 projects initially)
   - Anti-abstraction rules (trust framework)

3. **Specification-First Workflow**
   - Separate WHAT/WHY (spec.md) from HOW (plan.md)
   - Technology-agnostic requirements
   - Clarification eliminates ambiguity early

4. **User-Story-Centric Organization**
   - Tasks grouped by user story (not layer)
   - Independently testable MVP increments
   - Progressive delivery (P1 → validate → P2...)

---

## III. Process Flows

### A. Specification Creation (`/speckit.specify`)

```
1. User: /speckit.specify "Build authentication system"
   ↓
2. Command: Execute create-new-feature.sh --json
   Script Actions:
   - fd --type d '^[0-9]{3}-' specs/ | sort | tail -1  # Get highest number
   - NEXT_NUM=$((HIGHEST + 1))  # Increment
   - mkdir -p specs/$NEXT_NUM-<name>
   - git checkout -b $NEXT_NUM-<name>
   - cp .specify/templates/spec-template.md specs/$NEXT_NUM-<name>/spec.md
   Output: {"BRANCH_NAME":"004-auth-system","SPEC_FILE":"specs/004-auth-system/spec.md"}
   ↓
3. Command body: Claude processes with template context
   - Extract WHAT/WHY from user description
   - Create user stories with priorities (P1, P2, P3)
   - Document functional requirements
   - Mark ambiguities [NEEDS CLARIFICATION] (max 3)
   ↓
4. Result: specs/004-auth-system/spec.md created
```

**Key Scripts**:
- `create-new-feature.sh` (~200 lines): Auto-numbering, branch creation, directory setup
- `common.sh` (~150 lines): Shared functions (get paths, validate branch)

### B. Clarification (`/speckit.clarify`)

```
1. User: /speckit.clarify
   ↓
2. Command: No pre-execution script
   ↓
3. Claude processes:
   - Load spec.md
   - Scan 10+ ambiguity categories
   - Generate max 5 high-impact questions
   - Present with recommendations
   - Sequential questioning (one at a time)
   - Update spec incrementally after each answer
   ↓
4. Result: spec.md updated, [NEEDS CLARIFICATION] markers resolved
```

**No Scripts**: Pure Claude processing with template guidance

### C. Planning (`/speckit.plan`)

```
1. User: /speckit.plan
   ↓
2. Command: Execute setup-plan.sh --json
   Script Actions:
   - eval $(get_feature_paths)  # From common.sh
   - check_feature_branch "$CURRENT_BRANCH"  # Validate on feature branch
   - cp .specify/templates/plan-template.md $IMPL_PLAN
   Output: {"FEATURE_SPEC":"...","IMPL_PLAN":"...","BRANCH":"004-auth-system"}
   ↓
3. Command body: Claude processes
   - Load spec.md
   - Check constitution gates (max 3 projects, no over-engineering)
   - Select tech stack
   - Design architecture
   - Generate research.md, data-model.md, contracts/, quickstart.md
   - Create acceptance criteria (≥2 per user story)
   - Re-check constitution gates
   ↓
4. Command: Execute update-agent-context.sh
   Script Actions:
   - Parse plan.md for tech stack (Language/Version, Primary Dependencies, Storage)
   - Update CLAUDE.md, GEMINI.md, etc. with project info
   - Add to "Active Technologies" section
   - Update "Recent Changes" section (keep last 3)
   ↓
5. Result: plan.md, research.md, data-model.md, contracts/, quickstart.md created
```

**Key Scripts**:
- `setup-plan.sh` (~60 lines): Validate + copy template
- `update-agent-context.sh` (~700 lines): Parse plan, update agent files

### D. Task Generation (`/speckit.tasks`)

```
1. User: /speckit.tasks
   ↓
2. Command: Execute check-prerequisites.sh --json
   Script Actions:
   - eval $(get_feature_paths)
   - Validate plan.md exists (block if missing)
   - Check optional docs: research.md, data-model.md, contracts/, quickstart.md
   Output: {"FEATURE_DIR":"...","AVAILABLE_DOCS":["research.md","data-model.md",...]}
   ↓
3. Command body: Claude processes
   - Load spec.md (user stories with priorities)
   - Load plan.md (tech stack, architecture)
   - Load optional docs
   - Generate tasks organized by user story:
     * Phase 1: Setup
     * Phase 2: Foundational (blocking prerequisites)
     * Phase 3+: User Story P1, P2, P3... (one phase per story)
     * Final Phase: Polish
   - Mark parallel tasks [P]
   - Validate independent test criteria per story
   ↓
4. Result: tasks.md created with user-story-centric breakdown
```

**Key Scripts**:
- `check-prerequisites.sh` (~170 lines): Validate workflow state, list available docs

### E. Implementation (`/speckit.implement`)

```
1. User: /speckit.implement
   ↓
2. Command: Execute check-prerequisites.sh --json --require-tasks --include-tasks
   Script Actions:
   - Validate plan.md exists
   - Validate tasks.md exists (--require-tasks flag)
   - Check checklists/ directory (if exists)
   - For each checklist: count total, completed, incomplete items
   - If incomplete items: Display table, STOP, ask user "Proceed anyway?"
   Output: {"FEATURE_DIR":"...","AVAILABLE_DOCS":["plan.md","tasks.md","research.md",...]}
   ↓
3. Command body: Claude processes
   - Load tasks.md
   - Story-by-story execution:
     * Implement P1 story
     * Verify P1 independently
     * Implement P2 story
     * Verify P2 independently
     ...
   - TDD approach (tests → code per constitution)
   - Mark tasks complete: - [X]
   ↓
4. Result: Feature implemented, tasks.md updated with completion marks
```

**Key Scripts**:
- `check-prerequisites.sh --require-tasks` (~170 lines): Validate all prerequisites + checklist status

---

## IV. Dependency Graph

### Script Dependencies

```
common.sh (foundation)
    ├→ get_repo_root()
    ├→ get_current_branch()
    ├→ check_feature_branch()
    └→ get_feature_paths()

create-new-feature.sh
    └→ imports: common.sh functions

setup-plan.sh
    └→ imports: common.sh functions

check-prerequisites.sh
    └→ imports: common.sh functions

update-agent-context.sh
    └→ imports: common.sh functions
```

### Command → Script Flow

```
/speckit.specify
    └→ create-new-feature.sh
        └→ common.sh

/speckit.clarify
    └→ (no scripts)

/speckit.plan
    ├→ setup-plan.sh → common.sh
    └→ update-agent-context.sh → common.sh

/speckit.tasks
    └→ check-prerequisites.sh → common.sh

/speckit.implement
    └→ check-prerequisites.sh --require-tasks → common.sh
```

### Template Dependencies

```
Slash Commands → Templates (copy, not reference)

/speckit.specify → spec-template.md (copied to specs/###-name/spec.md)
/speckit.plan → plan-template.md (copied to specs/###-name/plan.md)
/speckit.tasks → tasks-template.md (used as structure guide)
/speckit.implement → (no template, uses tasks.md)
```

---

## V. Key Differences vs Traditional Development

| Aspect | Traditional | Spec-Kit SDD |
|--------|-------------|--------------|
| **Start** | Jump to code | Write specification first |
| **Requirements** | Vague, implicit | Explicit, technology-agnostic |
| **Clarification** | Ad-hoc during dev | Structured, before planning |
| **Planning** | Implementation details | Spec → Plan separation |
| **Organization** | Layer-first (models, services, UI) | User-story-first (P1, P2, P3) |
| **Validation** | Manual testing | Checklists + independent story tests |
| **Automation** | Manual commands | Scripts provide determinism |
| **Constitution** | Ad-hoc decisions | Documented principles with gates |

---

## VI. Strengths

1. **Deterministic Automation**: Scripts handle auto-numbering, path management, validation
2. **Clear Separation**: WHAT/WHY (spec) vs HOW (plan)
3. **Quality Gates**: Checklists validate before proceeding
4. **User-Story Organization**: Delivers value incrementally
5. **Constitutional Discipline**: Prevents over-engineering

---

## VII. Limitations

1. **Manual Invocation**: User must type `/speckit.command` (not auto-triggered)
2. **Template Copies**: Each feature gets copy of template (not centralized)
3. **Script Maintenance**: 5 separate bash scripts (~1,300 lines total)
4. **Constitution Documentation**: Principles documented but not automatically enforced
5. **No Intelligence Integration**: Uses bash find/grep (not project-intel.mjs)
6. **Agent Context Updates**: Requires parsing plan.md and updating multiple agent files

---

## VIII. File Counts

**Scripts**: 5 files (~1,300 lines total)
- common.sh (~150 lines)
- create-new-feature.sh (~200 lines)
- setup-plan.sh (~60 lines)
- check-prerequisites.sh (~170 lines)
- update-agent-context.sh (~700 lines)

**Slash Commands**: 8 files
**Templates**: 4 files
**Total**: ~17 files + constitution

---

## IX. Workflow Validation

**Spec-Kit's Validation Strategy**:
1. **Pre-execution scripts** check prerequisites (plan.md exists before tasks.md)
2. **Exit codes** block invalid operations (exit 1 = error)
3. **Checklist scanning** validates quality before implementation
4. **User confirmation** required if checklists incomplete

**Limitations**:
- Relies on Claude following instructions (not deterministic)
- No automatic enforcement of constitution
- Manual checklist review

---

## X. Conclusion

**Spec-Kit's Core Innovation**: Specification-Driven Development with script automation

**Strengths**:
- Clear workflow separation (spec → clarify → plan → tasks → implement)
- User-story-centric organization (MVP-first delivery)
- Constitutional discipline (documented principles)
- Script automation (deterministic operations)

**Opportunities for Improvement**:
- Auto-invocation (skills vs manual commands)
- Constitutional enforcement (hooks vs documentation)
- Intelligence integration (project-intel.mjs vs bash find/grep)
- Centralized templates (@ imports vs copies)
- Evidence-based reasoning (CoD^Σ traces vs manual references)

**Status**: Analyzed and ready for integration with Intelligence Toolkit

---

**Document Version**: 1.0
**Generated**: 2025-10-19
**Source Analysis**: Complete
