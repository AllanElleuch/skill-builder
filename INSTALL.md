# Intelligence Toolkit Installation Guide

Complete guide for installing the Claude Code Intelligence Toolkit in any project.

---

## Quick Start

```bash
# Download and run installer
curl -fsSL https://raw.githubusercontent.com/yangsi7/skill-builder/master/install-toolkit.sh | bash -s -- /path/to/your/project

# Or clone and run locally
git clone https://github.com/yangsi7/skill-builder.git
cd skill-builder
./install-toolkit.sh /path/to/your/project
```

---

## Installation Methods

### Method 1: Direct Install (Recommended)

Download and run the installer in one command:

```bash
curl -fsSL https://raw.githubusercontent.com/yangsi7/skill-builder/master/install-toolkit.sh | bash -s -- /path/to/your/project
```

### Method 2: Clone Repository

Clone the repository and run the installer:

```bash
# Clone the toolkit
git clone https://github.com/yangsi7/skill-builder.git
cd skill-builder

# Run installer
./install-toolkit.sh /path/to/your/project
```

### Method 3: Manual Installation

For advanced users who want complete control:

1. **Install project-index tool**:
```bash
curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-project-index/main/install.sh | bash
```

2. **Copy toolkit files**:
```bash
cp -r .claude /path/to/your/project/
cp project-intel.mjs /path/to/your/project/
chmod +x /path/to/your/project/project-intel.mjs
```

3. **Update CLAUDE.md**:
   - See `.claude/templates/BOOTSTRAP_GUIDE.md` for CLAUDE.md content
   - Append toolkit sections to your existing CLAUDE.md

---

## Installer Options

### Command Line Flags

```bash
./install-toolkit.sh [OPTIONS] <target-directory>
```

| Option | Description |
|--------|-------------|
| `--dry-run` | Preview changes without modifying files |
| `--force` | Skip confirmation prompts (use with caution) |
| `--verbose` | Show detailed output during installation |
| `--bootstrap` | Copy bootstrap templates (planning.md, todo.md, etc.) |
| `--help` | Show help message |

### Examples

**Interactive install** (recommended for first-time):
```bash
./install-toolkit.sh /path/to/project
```

**Preview changes** before installing:
```bash
./install-toolkit.sh --dry-run /path/to/project
```

**Install with bootstrap templates**:
```bash
./install-toolkit.sh --bootstrap /path/to/project
```

**Automated install** (skip prompts):
```bash
./install-toolkit.sh --force /path/to/project
```

**Verbose output** for debugging:
```bash
./install-toolkit.sh --verbose /path/to/project
```

**Combined options**:
```bash
./install-toolkit.sh --dry-run --verbose --bootstrap /path/to/project
```

---

## What Gets Installed

### Core Components

1. **project-index tool** (via external installer)
   - Installed globally in your system
   - Generates PROJECT_INDEX.json for intelligence queries

2. **.claude/ directory** (copied to your project)
   - `agents/` - 4 specialized subagents
   - `skills/` - 10+ auto-invoked workflows
   - `commands/` - 7+ slash commands
   - `templates/` - 18+ structured output templates
   - `shared-imports/` - Core frameworks (CoD_Σ, constitution, guides)
   - `hooks/` - Workflow automation scripts
   - `settings.json` - Hook configurations

3. **project-intel.mjs** (copied to your project root)
   - CLI tool for querying PROJECT_INDEX.json
   - Intelligence-first queries for 80%+ token savings

4. **CLAUDE.md** (created or updated in your project root)
   - Project-agnostic toolkit documentation
   - Intelligence workflow instructions
   - Component integration guides

5. **.gitignore** (merged with existing or created)
   - Toolkit-specific exclusion patterns
   - Session artifacts (event-stream.md, docs/sessions/, etc.)

### Optional Components

6. **Bootstrap templates** (with --bootstrap flag)
   - `planning.md` - Master plan template
   - `todo.md` - Task tracking template
   - `event-stream.md` - Event logging template
   - `workbook.md` - Context notepad template

---

## Installation Scenarios

### New Project (No Existing Files)

The installer will:
1. Create target directory (with confirmation)
2. Install all components cleanly
3. Create new CLAUDE.md with toolkit integration
4. Copy .gitignore
5. Optionally copy bootstrap templates

**Example**:
```bash
./install-toolkit.sh --bootstrap /Users/you/projects/new-app
```

**Result**:
```
new-app/
├── .claude/           # Full toolkit
├── CLAUDE.md          # New with toolkit sections
├── .gitignore         # New with toolkit patterns
├── project-intel.mjs  # Intelligence query tool
├── planning.md        # (if --bootstrap)
├── todo.md            # (if --bootstrap)
├── event-stream.md    # (if --bootstrap)
└── workbook.md        # (if --bootstrap)
```

### Existing Project (With Files)

The installer will:
1. Detect existing files and warn
2. Offer to create backups
3. Merge toolkit content with existing CLAUDE.md
4. Merge toolkit patterns with existing .gitignore
5. Skip existing bootstrap files

**Example**:
```bash
./install-toolkit.sh /Users/you/projects/existing-app
```

**Interactive prompts**:
```
⚠ .claude/ directory already exists
⚠ CLAUDE.md already exists
⚠ project-intel.mjs already exists

Existing files detected. Create backup? (y/n)
```

**If backup chosen**:
```
existing-app/
├── .toolkit-backup-20251024-140000/  # Backup of existing files
│   ├── .claude/
│   ├── CLAUDE.md
│   └── project-intel.mjs
├── .claude/                           # Updated toolkit
├── CLAUDE.md                          # Merged with toolkit sections
└── project-intel.mjs                  # Updated
```

### Updating Existing Installation

To update an existing toolkit installation:

```bash
# Dry run to see what would change
./install-toolkit.sh --dry-run /path/to/project

# Force update (creates backup first)
./install-toolkit.sh --force /path/to/project
```

The installer will:
- Overwrite .claude/ directory components
- Append new sections to CLAUDE.md (if not already present)
- Update project-intel.mjs
- Preserve your custom configurations

---

## Safety Features

### Automatic Backups

When existing files are detected, the installer offers to create backups:

**Backup location**: `.toolkit-backup-YYYYMMDD-HHMMSS/`

**Backed up files**:
- `.claude/` directory
- `CLAUDE.md`
- `project-intel.mjs`
- `.gitignore`

### Dry Run Mode

Preview all changes before applying them:

```bash
./install-toolkit.sh --dry-run /path/to/project
```

**Output shows**:
- What would be installed
- What would be overwritten
- What would be merged
- Preview of CLAUDE.md additions

### Interactive Prompts

The installer asks for confirmation before:
- Creating new directories
- Overwriting existing files
- Creating backups

**Use `--force` to skip all prompts** (automated environments).

---

## Post-Installation

### Immediate Next Steps

1. **Navigate to your project**:
```bash
cd /path/to/your/project
```

2. **Generate project index**:
```bash
./project-intel.mjs --overview --json
```

3. **Review CLAUDE.md**:
   - Open `CLAUDE.md`
   - Add project-specific information
   - Customize as needed

4. **(Optional) Copy bootstrap templates**:
```bash
cp .claude/templates/planning-template.md planning.md
cp .claude/templates/todo-template.md todo.md
cp .claude/templates/event-stream-template.md event-stream.md
cp .claude/templates/workbook-template.md workbook.md
```

5. **Start using the toolkit**:
```bash
# In Claude Code
/feature "Your first feature"
```

### Verify Installation

Check that everything installed correctly:

```bash
# Verify .claude directory
ls -la .claude/

# Verify project-intel.mjs
./project-intel.mjs --help

# Verify CLAUDE.md has toolkit sections
grep "Intelligence Toolkit" CLAUDE.md

# Test intelligence query
./project-intel.mjs --overview --json
```

---

## Troubleshooting

### Error: "Command not found: project-intel.mjs"

**Problem**: project-intel.mjs not executable

**Solution**:
```bash
chmod +x project-intel.mjs
```

### Error: "Source .claude/ directory not found"

**Problem**: Running installer from wrong directory

**Solution**:
```bash
# Run from toolkit repository root
cd /path/to/skill-builder
./install-toolkit.sh /path/to/target
```

### Error: "Permission denied"

**Problem**: Insufficient permissions to write to target directory

**Solution**:
```bash
# Change directory ownership
sudo chown -R $USER:$USER /path/to/target

# Or run installer in home directory
./install-toolkit.sh ~/my-project
```

### Warning: "Existing files detected"

**Expected behavior**: Installer warns before overwriting

**Options**:
1. Create backup (recommended): Answer `y` to backup prompt
2. Force overwrite: Use `--force` flag
3. Dry run first: Use `--dry-run` to preview changes

### CLAUDE.md not updated

**Problem**: CLAUDE.md already contains "Intelligence Toolkit Integration" section

**Solution**: The installer skips duplicates automatically. This is expected behavior.

---

## Customization

### CLAUDE.md Customization

After installation, customize CLAUDE.md for your project:

1. **Update Project Overview**:
```markdown
## Project Overview

**Project Name**: Your Awesome App

**Description**: What your project does

**Core Innovation**: What makes it unique
```

2. **Add Project-Specific Sections**:
```markdown
## Technology Stack

### Frontend
- React + TypeScript
- Tailwind CSS

### Backend
- Node.js + Express
- PostgreSQL + Prisma
```

3. **Add Domain-Specific Guidelines**:
```markdown
## Code Style

- Use functional components
- Prefer composition over inheritance
- Document all API endpoints
```

### Template Customization

Customize templates in `.claude/templates/`:

```bash
# Edit templates to match your workflow
edit .claude/templates/feature-spec.md
edit .claude/templates/plan.md
edit .claude/templates/tasks.md
```

### Skill Customization

Add project-specific skills:

```bash
# Create new skill
mkdir .claude/skills/my-custom-skill
edit .claude/skills/my-custom-skill/SKILL.md
```

See `.claude/templates/BOOTSTRAP_GUIDE.md` for creating custom skills.

---

## Uninstallation

To remove the Intelligence Toolkit:

```bash
# Remove toolkit files
rm -rf .claude/
rm project-intel.mjs

# Remove toolkit sections from CLAUDE.md
# (Manual edit required - search for "Intelligence Toolkit Integration")

# Remove bootstrap files (if installed)
rm planning.md todo.md event-stream.md workbook.md
```

**Note**: Keep backups before uninstalling (`.toolkit-backup-*` directories).

---

## FAQ

### Q: Can I install in an existing project with Claude Code setup?

**A**: Yes! The installer safely merges toolkit sections with your existing CLAUDE.md and .gitignore. It will not overwrite your custom configurations.

### Q: What if I already have some .claude/ components?

**A**: The installer will warn you and offer to create a backup. You can choose to overwrite or cancel.

### Q: Can I use this with multiple projects?

**A**: Yes! Install the toolkit separately in each project. The project-index tool is global, but .claude/ and CLAUDE.md are project-specific.

### Q: How do I update the toolkit to the latest version?

**A**: Re-run the installer with `--force` flag. It will update all components while preserving backups.

### Q: Is the installer safe for automated CI/CD?

**A**: Yes! Use `--force` flag to skip interactive prompts. Consider using `--dry-run` first to validate.

### Q: Can I cherry-pick specific components?

**A**: Yes! Use manual installation (Method 3) to copy only the components you need.

---

## Support

### Documentation

- **Bootstrap Guide**: `.claude/templates/BOOTSTRAP_GUIDE.md`
- **Templates Guide**: `.claude/templates/README.md`
- **Skills Guide**: `docs/guides/developing-agent-skills.md`
- **System Overview**: `docs/architecture/system-overview.md`

### Repository

- **GitHub**: https://github.com/yangsi7/skill-builder
- **Issues**: https://github.com/yangsi7/skill-builder/issues

### Quick Reference

```bash
# Preview installation
./install-toolkit.sh --dry-run /path/to/project

# Install with bootstrap
./install-toolkit.sh --bootstrap /path/to/project

# Update existing installation
./install-toolkit.sh --force /path/to/project

# Get help
./install-toolkit.sh --help
```

---

**Intelligence Toolkit Version**: 1.0.0
**Last Updated**: 2025-10-24
**License**: MIT
