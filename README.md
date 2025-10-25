# Claude Code Intelligence Toolkit

A meta-system for building intelligence-first AI agent workflows with Claude Code.

**Core Innovation**: Intelligence-first architecture achieving 80-95% token savings by querying lightweight indexes before reading files.

---

## Quick Start

### One-Command Install (Works from Anywhere!)

```bash
# Run from any directory - no cloning needed!
# Fully automated (creates directories, auto-backups, installs project-intel via curl)
curl -fsSL https://raw.githubusercontent.com/yangsi7/skill-builder/master/install-toolkit.sh | bash -s -- --force /path/to/your/project
```

**Note**: The installer automatically:
- Clones toolkit repo to temp location
- Installs project-intel.mjs via curl from GitHub
- Copies all Intelligence Toolkit components
- Cleans up temp files

### Verify Installation

After installing, verify everything is working:

```bash
# In Claude Code
/bootstrap

# Expected: System Health Score 100/100 ✅ PRODUCTION READY
```

### Alternative: Clone and Install

```bash
git clone https://github.com/yangsi7/skill-builder.git
cd skill-builder

# Automated with bootstrap templates
./install-toolkit.sh --force --bootstrap /path/to/your/project

# Or interactive (asks for confirmation)
./install-toolkit.sh /path/to/your/project
```

See **[INSTALL.md](INSTALL.md)** for complete installation guide.

---

## What Is This?

The Intelligence Toolkit is a development framework for creating:
- **Skills** - Auto-invoked workflows (10 included)
- **Agents** - Specialized subagents (4 included)
- **Slash Commands** - Quick workflow triggers (14 included: /feature, /plan, /implement, /verify, /audit, /analyze, /bug, /bootstrap, /index, and more)
- **Templates** - Structured outputs (24 templates: 20 workflow + 4 bootstrap)
- **Hooks** - Workflow automation (8 hooks)
- **Installer** - One-command installation system

All components follow **intelligence-first** principles:
1. Query `project-intel.mjs` (lightweight index)
2. Query MCP tools (external intelligence)
3. Read targeted file sections only

**Result**: 80-95% token savings vs reading full files.

**System Health**: This toolkit achieved **100/100 score** in comprehensive validation. See [VALIDATION_REPORT.md](VALIDATION_REPORT.md) for details.

---

## Features

### 🧠 Intelligence-First Architecture

Never read files before querying intelligence:

```bash
# Always start with intelligence queries
project-intel.mjs --overview --json
project-intel.mjs --search "auth" --type tsx --json
project-intel.mjs --symbols src/file.ts --json

# THEN read targeted sections
Read src/auth/login.tsx
```

### 📋 Specification-Driven Development (SDD)

Automated workflow from specification to implementation:

```bash
# User runs ONE command
/feature "I want user authentication"

# System automatically:
# 1. Creates spec.md (technology-agnostic)
# 2. Runs clarification (if needed)
# 3. Invokes /plan (creates plan.md with tech stack)
# 4. Generates tasks.md (user-story organized)
# 5. Runs /audit (quality validation)
# ✓ Ready for /implement

# User runs ONE more command
/implement plan.md

# System automatically:
# - Implements P1 → /verify --story P1
# - Implements P2 → /verify --story P2
# - Progressive delivery with per-story validation
```

**Result**: 2 commands from idea to verified implementation (85% automation rate).

**Complete Workflow Diagrams**: See [COMPONENT_RELATIONSHIP_ANALYSIS.md](COMPONENT_RELATIONSHIP_ANALYSIS.md) for detailed component relationships across all 6 major workflows.

### 🎯 10+ Auto-Invoked Skills

Skills trigger automatically based on context:

- **analyze-code** - Intel-first code analysis
- **debug-issues** - Systematic bug diagnosis
- **specify-feature** - Technology-agnostic specification
- **create-implementation-plan** - Architecture + tech stack planning
- **generate-tasks** - User-story task breakdown
- **implement-and-verify** - TDD with AC verification
- **clarify-specification** - Ambiguity resolution
- **define-product** - User-centric product definition
- **generate-constitution** - Technical principles from user needs
- Plus more...

### 🤖 4 Specialized Agents

Agents handle complex delegations:

- **workflow-orchestrator** - Routes to appropriate specialist
- **code-analyzer** - Deep code investigation
- **implementation-planner** - Architecture and planning
- **executor-implement-verify** - TDD implementation with verification

### 📝 24 Structured Templates

Templates ensure consistency and provide quick project setup:

**Bootstrap Templates** (for quick project setup):
- `planning-template.md` - Master plan with architecture
- `todo-template.md` - Task tracking with acceptance criteria
- `event-stream-template.md` - Event logging with CoD^Σ
- `workbook-template.md` - Context notepad (300-line limit)

**Workflow Templates** (auto-used by skills/commands):
- Feature specifications
- Implementation plans
- Task breakdowns
- Analysis reports
- Bug reports
- Verification reports
- Data models, research, quality checklists
- And more...

### ⚖️ Constitutional Governance

7 articles enforce quality:

1. **Intelligence-First** - Query before reading
2. **Evidence-Based** - CoD^Σ traces required
3. **Test-First** - TDD with ≥2 ACs per task
4. **Specification-First** - Spec → Plan → Tasks order
5. **Template-Driven** - Consistent outputs
6. **Simplicity** - Anti-abstraction, MVP-first
7. **User-Story-Centric** - Progressive delivery

---

## Project Structure

```
skill-builder/
├── install-toolkit.sh     # One-command installer
├── project-intel.mjs      # Intelligence query CLI
├── INSTALL.md             # Installation guide
├── VALIDATION_REPORT.md   # System health report (100/100 score)
├── COMPONENT_RELATIONSHIP_ANALYSIS.md  # Workflow diagrams
├── README.md              # This file
├── .claude/               # Intelligence Toolkit
│   ├── agents/            # 4 specialized subagents
│   ├── skills/            # 10 auto-invoked workflows
│   ├── commands/          # 14 slash commands (includes /bootstrap, /index)
│   ├── templates/         # 24 structured templates (20 workflow + 4 bootstrap)
│   │   ├── *-template.md  # Bootstrap templates for quick setup
│   │   ├── BOOTSTRAP_GUIDE.md  # Bootstrap guide
│   │   └── README.md      # Templates reference
│   ├── shared-imports/    # Core frameworks (CoD_Σ.md, constitution.md)
│   ├── hooks/             # 8 workflow automation hooks
│   └── domain-specific-imports/  # Project design processes
├── docs/                  # Comprehensive documentation
│   ├── architecture/      # System design + agent-skill-integration.md
│   ├── guides/            # How-to guides
│   └── reference/         # CLI and API references
└── specs/                 # Example specifications
```

---

## Installation

### Prerequisites

- bash
- curl
- git
- Node.js (for project-intel.mjs)

### Installation Options

#### Option 1: Fully Automated (Recommended)

```bash
# Creates directories automatically, auto-backups existing files
curl -fsSL https://raw.githubusercontent.com/yangsi7/skill-builder/master/install-toolkit.sh | bash -s -- --force /path/to/your/project
```

#### Option 2: Preview First (Dry Run)

```bash
git clone https://github.com/yangsi7/skill-builder.git
cd skill-builder

# Preview what will be installed
./install-toolkit.sh --dry-run /path/to/your/project

# Then run the actual install
./install-toolkit.sh --force --bootstrap /path/to/your/project
```

#### Option 3: Manual Install

See **[INSTALL.md](INSTALL.md)** for manual installation steps.

---

## Quick Start After Installation

### 1. Generate Project Index

```bash
cd /path/to/your/project
./project-intel.mjs --overview --json
```

### 2. Copy Bootstrap Templates (Optional)

```bash
cp .claude/templates/planning-template.md planning.md
cp .claude/templates/todo-template.md todo.md
cp .claude/templates/event-stream-template.md event-stream.md
cp .claude/templates/workbook-template.md workbook.md
```

### 3. Start Development

```bash
# In Claude Code, run:
/feature "Your first feature description"

# System automatically creates:
# - specs/###-feature-name/spec.md
# - specs/###-feature-name/plan.md
# - specs/###-feature-name/tasks.md
# And runs /audit for validation

# Then implement:
/implement specs/###-feature-name/plan.md

# System automatically verifies each story progressively
```

---

## Usage Examples

### Intelligence-First Query

```bash
# Overview (always first)
project-intel.mjs --overview --json

# Search for files
project-intel.mjs --search "Button" --type tsx --json

# Get symbols
project-intel.mjs --symbols src/components/Button.tsx --json

# Trace dependencies
project-intel.mjs --dependencies src/auth.ts --direction upstream --json
```

### SDD Workflow

```bash
# Specify feature (auto-invokes /plan, /tasks, /audit)
/feature "Add user authentication with JWT"

# Review generated artifacts
# - specs/###-auth/spec.md (technology-agnostic)
# - specs/###-auth/plan.md (with tech stack)
# - specs/###-auth/tasks.md (user stories: P1, P2, P3...)

# Implement (auto-verifies each story)
/implement specs/###-auth/plan.md
```

### Code Analysis

```bash
# Analyze code (intel-first)
/analyze

# Debug issues (systematic diagnosis)
/bug

# Cross-artifact validation
/audit 003-auth
```

---

## Documentation

### Getting Started

- **[INSTALL.md](INSTALL.md)** - Complete installation guide
- **[.claude/templates/BOOTSTRAP_GUIDE.md](.claude/templates/BOOTSTRAP_GUIDE.md)** - Project bootstrap guide
- **[.claude/templates/README.md](.claude/templates/README.md)** - Templates reference
- **[VALIDATION_REPORT.md](VALIDATION_REPORT.md)** - System health validation (100/100 score)

### Architecture

- **[docs/architecture/system-overview.md](docs/architecture/system-overview.md)** - System architecture
- **[docs/architecture/agent-skill-integration.md](docs/architecture/agent-skill-integration.md)** - Component integration patterns
- **[COMPONENT_RELATIONSHIP_ANALYSIS.md](COMPONENT_RELATIONSHIP_ANALYSIS.md)** - Comprehensive workflow diagrams for all 6 major flows
- **[docs/architecture/cod-sigma-framework.md](docs/architecture/cod-sigma-framework.md)** - CoD^Σ reasoning
- **[docs/architecture/project-index-system.md](docs/architecture/project-index-system.md)** - Intelligence system

### Guides

- **[docs/guides/developing-agent-skills.md](docs/guides/developing-agent-skills.md)** - Creating skills
- **[docs/reference/project-intel-cli.md](docs/reference/project-intel-cli.md)** - CLI reference
- **[docs/reference/claude-code-docs/](docs/reference/claude-code-docs/)** - Claude Code docs

---

## Key Concepts

### Intelligence-First

**Traditional Approach** (wasteful):
```
Read 50 files (500 KB) → 125,000 tokens → Find 1 relevant file
```

**Intelligence-First** (efficient):
```
Query index (5 KB) → 1,250 tokens → Read 1 relevant file (10 KB) → 2,500 tokens
Total: 3,750 tokens (97% savings)
```

### CoD^Σ (Chain of Density Sigma)

All reasoning must have evidence traces:

```
❌ Bad:  "The component re-renders because of state"
✅ Good: "Component re-renders due to useEffect([state]) at ComponentA.tsx:45"
```

### Specification-Driven Development

Separate WHAT/WHY from HOW:

1. **Spec** (spec.md) - Technology-agnostic requirements
2. **Clarify** - Resolve ambiguities
3. **Plan** (plan.md) - Tech stack + architecture
4. **Tasks** (tasks.md) - User-story breakdown
5. **Audit** - Quality validation
6. **Implement** - TDD with per-story verification

### User-Story-Centric

Organize by user stories, not technical layers:

```
✅ Good:  Phase 3: User Story P1 (auth) → tests, models, API, UI
❌ Bad:   Phase 3: All Models → Phase 4: All APIs → Phase 5: All UI
```

---

## Success Metrics

**Validated Performance** (See [VALIDATION_REPORT.md](VALIDATION_REPORT.md)):

- **System Health Score**: **100/100** ✅ PRODUCTION READY
- **Token Efficiency**: 80-95% reduction vs reading full files
- **Automation Rate**: 67% average (85% for SDD workflow, 66% for implementation)
- **Component Coverage**: 61 total components (10 skills, 14 commands, 4 agents, 24 templates, 8 hooks, 2 shared imports)
- **Composability**: Every component reused by 2+ components
- **Verifiability**: 100% of plans have testable ACs
- **Quality**: 100% constitutional compliance (7 articles enforced via hooks)
- **Integration Health**: All 59 critical integrations validated and functioning

---

## Contributing

This is an open-source toolkit. Contributions welcome!

### Areas for Contribution

- Additional skills for specialized domains
- More templates for different project types
- Example projects using the toolkit
- Documentation improvements
- Bug fixes and performance improvements

---

## License

MIT License - See LICENSE file for details

---

## Support

- **Documentation**: See `docs/` directory
- **Issues**: https://github.com/yangsi7/skill-builder/issues
- **Discussions**: https://github.com/yangsi7/skill-builder/discussions

---

## Version

**Current Version**: 1.0.0
**Last Updated**: 2025-10-24

---

**Start building intelligence-first AI workflows today!**

```bash
# Run from anywhere - no cloning needed!
# Fully automated installation (creates dirs, auto-backups, includes bootstrap templates)
curl -fsSL https://raw.githubusercontent.com/yangsi7/skill-builder/master/install-toolkit.sh | bash -s -- --force --bootstrap /path/to/your/project
```
