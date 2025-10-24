# Developing Agent Skills for Claude Code

**Complete guide from fundamentals to advanced implementation**

---

## Part 1: Skill Development Fundamentals

### Introduction

Claude agent skills provide a powerful mechanism to extend the model's capabilities with domain‑specific workflows, code and documentation. They differ from subagents and slash commands because they are **automatically discovered and invoked** when the user's request matches the skill's description[\[1\]](https://github.com/anthropics/skills#:~:text=Example%20Skills). This guide offers a comprehensive, step‑by‑step process for creating custom skills. It consolidates best practices from the official documentation and real examples such as the **skill‑creator**, **algorithmic‑art**, and **docx** skills. By following these steps, you can design skills that are reliable, efficient and easy for Claude to use.

### What Makes a Skill

A skill is a **filesystem directory** containing instructions and resources. The required file is SKILL.md, which consists of a YAML front‑matter (Level 1 metadata) and a Markdown body (Level 2 instructions). Optional resources reside in scripts/, references/ and assets/ directories. Claude employs **progressive disclosure**: only the metadata (name and description) is always in context; instructions are loaded when the skill triggers, and resources are used only on demand[\[2\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=). This structure keeps the context window lean while enabling deep functionality.

### When to Use a Skill

Use a skill when you need Claude to perform a complex, repeatable workflow without manual invocation. Tasks such as **document editing**, **database management**, **art generation** or **web‑app testing** are prime candidates. If the task requires isolated context (e.g., separate QA agent) consider a subagent instead; if it is a simple prompt shortcut, a slash command suffices; if it is a universal rule, put it in CLAUDE.md[\[1\]](https://github.com/anthropics/skills#:~:text=Example%20Skills).

---

## Step‑by‑Step Creation Process

### Step 1 – Understand the Use Cases and Triggers

1. **Gather concrete examples** of how the skill will be used. Ask stakeholders to describe typical queries ("Rotate this PDF by 90°", "Build a responsive todo app") and note any terminology they use. The skill‑creator guide emphasizes starting with examples to understand functionality and trigger phrases[\[3\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,Skill%20with%20Concrete%20Examples).

2. **Identify triggers**. Extract keywords and phrases from your examples that should cause the skill to activate. Ensure the trigger phrases align with what users would naturally say. Avoid overly broad triggers—specificity reduces false positives.

3. **Clarify scope**. Decide what the skill will *not* do. If a task requires a different pattern (e.g., external API calls requiring separate context), consider a subagent or different skill.

### Step 2 – Plan Reusable Resources

For each example, determine what code or documentation will make the workflow repeatable:

* **Scripts**: Use Python, Bash or JavaScript scripts for deterministic logic that would otherwise be written in the chat. For example, a PDF rotation skill benefits from a scripts/rotate\_pdf.py script; a database migration skill needs migration and schema validation scripts[\[4\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,Reusable%20Skill%20Contents). Scripts are token‑efficient because only their output is read into context[\[5\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,without%20reading%20into%20context%20window).

* **Reference files**: Long or detailed documentation, schemas or API specs should live in references/. For instance, the docx skill stores extensive documentation on OOXML and a JavaScript library, instructing Claude to read them before editing[\[6\]](https://raw.githubusercontent.com/anthropics/skills/main/document-skills/docx/SKILL.md#:~:text=,document). For large files, include search guidance or specific headings to help Claude find relevant sections[\[7\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,md%3B%20move%20detailed).

* **Assets**: Templates, images or fonts used in outputs belong in assets/. The algorithmic‑art skill could include template p5.js sketches or placeholder images.

Document all planned resources before creating the skill. Remove resources that are unnecessary; avoid bloating the skill with unused files.

### Step 3 – Initialize the Skill Structure

Run the initialization script provided by the skill‑creator example to generate a scaffold. This script ensures proper naming and directory layout:

\# Install the skill‑creator tools if not already present
python scripts/init\_skill.py \<skill-name\> \--path \<output-directory\>

This command creates a directory named after your skill (e.g., database-management/) with the following structure[\[8\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=When%20creating%20a%20new%20skill,much%20more%20efficient%20and%20reliable):

skill-name/
├── SKILL.md        \# Placeholder front‑matter and instructions
├── scripts/        \# Example script (to be customized or removed)
├── references/     \# Example reference file
└── assets/         \# Example asset file

If you prefer to build from scratch, manually create this structure. Ensure the folder lives in .claude/skills/ for project‑wide skills or \~/.claude/skills/ for personal skills.

### Step 4 – Develop Scripts and References

1. **Write scripts** in the scripts/ directory for deterministic operations. Use descriptive names and handle errors gracefully. For example, a database migration script might look like this:

\#\!/usr/bin/env python3
"""Run database migrations with validation."""
import sys

def run\_migration(migration\_file: str) \-\> None:
    \# Pseudo‑implementation; replace with real migration logic
    if not migration\_file.endswith('.sql'):
        print(f"Error: expected a .sql file, got {migration\_file}")
        sys.exit(1)
    \# Perform migration...
    print(f"Migration {migration\_file} applied successfully.")

if \_\_name\_\_ \== '\_\_main\_\_':
    if len(sys.argv) \!= 2:
        print("Usage: run\_migration.py \<migration-file\>")
        sys.exit(1)
    run\_migration(sys.argv\[1\])

This script checks input validity and prints clear messages instead of raising uncaught exceptions, following the best practice described in the documentation[\[5\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,without%20reading%20into%20context%20window).

1. **Prepare reference files** with detailed documentation, schemas or examples. For a database skill, include references/schema.md describing tables and relationships and references/query-examples.md with common queries. Ensure reference files are shallow—avoid linking multiple levels deep[\[7\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,md%3B%20move%20detailed).

2. **Add assets** when outputs rely on template files. For example, a presentation skill may include a PowerPoint template in assets/.

### Step 5 – Write the SKILL.md File

#### *YAML Front‑Matter*

The SKILL.md file begins with a YAML block that defines the skill's metadata. It must contain at least name and description. Use gerunds for the name ("Managing Databases", "Generating Art") and write the description in third person, explaining what the skill does and when to use it[\[2\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=). The description should include trigger phrases identified in Step 1. Optionally, include a license field and other metadata as needed.

Example front‑matter:

\---
name: Database Management
description: \>
  Manages database tasks such as migrations, schema validation and data seeding.
  Use this skill when the user mentions databases, migrations, schema changes or
  seeding.  It validates migration files, checks schema consistency and runs
  database migrations reliably.
license: Apache-2.0
\---

#### *Body and Instructions*

After the front‑matter, provide the skill's guidance. Follow these principles:

* **Be concise and organized.** Use headings to break down workflows. For complex tasks, include **checklists** so Claude can track progress. For example:

\#\# Workflow: Running a Migration

Copy this checklist and mark steps as complete:

Task Progress:
\* \[ \] Step 1: Analyze migration files.
\* \[ \] Step 2: Validate the schema (run \`bash scripts/validate-schema.sh\`).
\* \[ \] Step 3: Run the migration (run \`python scripts/run-migration.py\`).
\* \[ \] Step 4: Report status to the user.

Checklists force the agent to execute steps in order and expose its reasoning to the user.[\[5\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,without%20reading%20into%20context%20window)

* **Link to resources explicitly.** Instruct Claude when to read reference files or run scripts. For example: "To understand the schema, read reference/schema.md" or "Run python scripts/run\_migration.py to execute the migration."

* **Provide feedback loops.** For tasks where quality matters (e.g., editing documents), instruct Claude to validate its output and repeat if errors occur. The document skills include validation loops where changes are batched and tested[\[9\]](https://raw.githubusercontent.com/anthropics/skills/main/document-skills/docx/SKILL.md#:~:text=This%20workflow%20allows%20you%20to,must%20implement%20ALL%20changes%20systematically).

* **Maintain third‑person, imperative style.** Write instructions as objective actions, not as direct commands to "you"[\[10\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=To%20begin%20implementation%2C%20start%20with,references).

#### *Putting It All Together: SKILL.md Template*

Below is a skeleton template you can adapt for your own skills:

\---
name: \<Skill Name\>
description: |
  \<Third‑person description explaining what the skill does and when it should be used.\>
license: \<License Identifier\>
\---

\# \<Skill Title\>

\<Short introduction explaining the purpose of the skill.\>

\#\# Workflow: \<Primary Task\>

Copy this checklist and track progress:

Task Progress:
\* \[ \] Step 1: \<Describe the first action (e.g., read a reference file).\>
\* \[ \] Step 2: \<Describe the second action (e.g., run a script).\>
\* \[ \] ...

\#\# Available Resources

\* \*\*Scripts\*\* – List and describe each script.  Example: "\`run-migration.py\`: applies database migrations."
\* \*\*References\*\* – List and describe each reference file.  Example: "\`schema.md\`: describes tables and relationships."
\* \*\*Assets\*\* – Optional; list any templates or assets.

\#\# Additional Guidance

Include any decision trees, validation loops or domain‑specific tips here.  Reference external documentation as needed.

### Step 6 – Validate and Package

Before sharing the skill, run the packaging script to validate its structure and metadata. This step checks the YAML front‑matter, ensures files are properly organized, and packages everything into a zip archive:

python scripts/package\_skill.py \<path/to/skill-folder\> \--output ./dist

If validation fails, the script will display errors; fix them and rerun. Packaging ensures other users can install the skill easily. Include a README or release notes alongside the zip file if distributing publicly.

### Step 7 – Test and Iterate

Install the new skill in a fresh Claude Code session and run your evaluation queries. Observe whether the skill triggers correctly and whether Claude follows the workflow. Ask follow‑up questions to refine triggers, instructions, or resources. Iteration is essential—skills often require several revisions to perform reliably[\[11\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=).

---

## System Prompt for an Agent to Create a Skill

To instruct Claude (or another agent) to build a new skill, provide a detailed system prompt that sets clear expectations. The prompt should include:

* **Goal and context.** Describe the domain and the purpose of the skill. For example: "Create a skill named 'Database Management' to handle migration tasks whenever a user mentions databases or migrations."

* **Triggers.** List keywords or phrases that should activate the skill.

* **Resources to generate.** Specify scripts, reference files and any assets required. Mention that the agent should use init\_skill.py to bootstrap the structure and fill in the contents accordingly.

* **Instructions style.** Remind the agent to write the SKILL.md body in third person, include checklists, link to resources and implement feedback loops.

* **Packaging and validation.** Instruct the agent to run package\_skill.py after editing and to fix any validation errors.

Here is a template system prompt:

**System Prompt:**

You are tasked with creating a new Claude skill called **"Database Management"**. This skill should trigger when users mention "database", "migration", "schema" or "seeding". Use the init\_skill.py script to scaffold the skill in .claude/skills/. Populate the scripts/ directory with Python scripts to validate schemas and apply migrations. Create a references/ directory containing a schema.md file that documents the database schema and a query-examples.md file with common queries. In the SKILL.md file, write a third‑person description explaining that the skill handles database tasks and when it should be used. In the body, include a checklist guiding Claude through analyzing migration files, validating the schema and running migrations. Clearly reference your scripts and reference files. Maintain an imperative tone and include validation loops if errors occur. After building the skill, run package\_skill.py to validate and produce a zip file. Ask clarifying questions if any details are ambiguous.

Adjust the template for other skill domains by changing the goal, triggers and resource types.

---

## Lessons from Real‑World Examples

* **Algorithmic Art Skill** – Shows how a skill can guide creative work. The instructions separate the high‑level philosophy (creating an algorithmic art movement) from the implementation, emphasize seeded randomness and emergent behavior, and call for poetic descriptions before code[\[12\]](https://raw.githubusercontent.com/anthropics/skills/main/algorithmic-art/SKILL.md#:~:text=Algorithmic%20philosophies%20are%20computational%20aesthetic,js%20files%20%28generative%20algorithms). This demonstrates the flexibility of skills: they are not limited to technical operations but can orchestrate creative processes.

* **DOCX Skill** – Illustrates how to manage complex file formats. It provides decision trees for creating, reading and editing documents, instructs the agent to read large reference files (docx-js.md, ooxml.md) in full and includes code snippets for performing tracked changes[\[13\]](https://raw.githubusercontent.com/anthropics/skills/main/document-skills/docx/SKILL.md#:~:text=). This example underscores the importance of clear workflows, external documentation and explicit command instructions.

* **Skill‑Creator** – Encapsulates the process of creating skills itself. It offers a procedural checklist for understanding use cases, planning resources, initializing, editing, packaging and iterating[\[5\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,without%20reading%20into%20context%20window). Reviewing this skill can help ensure you follow the same best practices when building your own.

---

## Conclusion and Best Practices

Creating effective Claude skills involves more than writing a prompt. It requires understanding the user's needs, planning reusable code and documentation, structuring the skill according to progressive disclosure, and validating the final product. Key practices include:

* **Craft precise metadata** with a clear, third‑person description and well‑chosen trigger phrases[\[2\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=).

* **Keep instructions concise** and use checklists to enforce step order and provide transparency[\[5\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,without%20reading%20into%20context%20window).

* **Offload complex logic to scripts** and provide reference documents for detailed information[\[7\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,md%3B%20move%20detailed).

* **Iterate based on testing**, refining triggers and instructions until the skill performs reliably[\[11\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=).

By following this guide and studying existing skills, you can design skills that extend Claude's abilities in robust, token‑efficient ways while maintaining clarity and maintainability.

---

## Part 2: Code Intelligence Skill - Advanced Implementation Example

This section demonstrates the complete implementation of a sophisticated **Code Intelligence** skill that combines all the fundamentals from Part 1 with advanced patterns: intelligence-first architecture using `project-intel.mjs`, CoD^Σ Ultrathink reasoning discipline, and progressive disclosure.

### Overview

The Code Intelligence skill automatically gathers detailed repository intelligence using the local CLI (`project-intel.mjs`) and enforces the CoD^Σ Ultrathink reasoning discipline across all steps. It demonstrates:

- **Token efficiency**: Draft reasoning in short symbolic lines (≤5 tokens per line) using micro-notation
- **Complete transparency**: All intermediate reasoning appears in `<cod_sigma>` blocks
- **Universal enforcement**: Every agent or subagent using this skill follows the same reasoning discipline
- **Progressive disclosure**: Concise metadata, instructions loaded on demand, resources loaded only when needed

### Skill Architecture

The code-intelligence skill produces a directory with:

```
code-intel/
├── SKILL.md                              # YAML metadata + instructions
├── scripts/
│   ├── run_project_intel.py              # Wrapper for deterministic CLI calls
│   └── helper_parse_json.py              # Result parsing utilities
├── references/
│   ├── project-intel-cheatsheet.md       # CLI command usage
│   ├── cod_sigma_ultrathink.md           # Micro-notation & reasoning patterns
│   └── workflows.md                      # Gate→Interpret→Plan→Execute→Validate→Synthesize
└── assets/
    └── flow_diagram.png                  # Visual flow & dependency diagram
```

### Philosophy and Guiding Principles

**Truthfulness & Determinism**: All claims must be grounded in the index (files `f`, edges `g`, dependencies, docs `d`, stats). Use CLI queries first; if unknown, propose the next command.

**Progressive Disclosure**: Keep `SKILL.md` concise; offload long data (e.g., command cheat sheets) into separate reference files. Scripts run externally and only output results.

**Reproducibility**: Use stable commands (e.g., `--json`, `-l <N>`, `--max-depth <N>`) to bound output. Document each step clearly.

**Extensibility**: Structure the skill so it can be extended or delegated to subagents (e.g., "index analyzer") in separate contexts.

**Security & Isolation**: Avoid network calls; use only local CLI and index. When delegating to subagents, share only necessary context and ensure they adhere to CoD^Σ Ultrathink.

### CoD^Σ Ultrathink Framework

The CoD^Σ (Chain of Density Sigma) Ultrathink framework enforces:

**Micro-notation**: Use provided symbols for dependencies (`⇐`), calls (`⇒`), flows (`→`), parallel (`∥`), choice (`⊕`), guards (`→[cond]`), fanout/fanin (`→{B,C}`, `{B,C}⇒D`), risks (`r := p·impact`).

**Draft blocks**: Write compact lines (≤5 tokens) in `<cod_sigma>` tags. Example:

```
<cod_sigma>
Goal→repo intel
Index→stats∧top fns
Hotspots→inbound∧outbound
Modules→top importers
Docs→count∧locations
#### snapshot ready
</cod_sigma>
```

**Standard fallback**: If reasoning complexity exceeds 6 lines or there is ambiguity, mark the segment as `AUTO-FALLBACK` and use normal prose reasoning.

**Quality gates**: Ensure each flow includes at least one `Entry`, one `Service`, and one `Guard` in CoD^Σ. Every claim in deliverables must reference source evidence (from `f`, `g`, `deps`, `d`, `stats`).

### Workflow Mapping

For each user intent (e.g., locate, explain, trace, map), the skill creates a workflow using project-intel commands. Each workflow includes steps:

1. **Gate**: Check index presence and validity
2. **Interpret**: Classify user intent (hotspots, trace, map, etc.)
3. **Plan**: Determine which project-intel commands to run
4. **Execute**: Run commands with proper options (`--json`, bounds)
5. **Validate**: Verify results meet expected structure
6. **Synthesize**: Structure outputs (JSON, diagrams, lists)
7. **Cache**: Store results for potential reuse
8. **Decide Next**: Optionally delegate to subagent or propose follow-up

### Project-Intel Workflows Summary

- **Hotspots & metrics**: Use `report --json`, `metrics --json`, and `stats --json` to generate snapshots
- **PDF & email flows**: Use `search`, `debug`, and `docs` commands to map file paths and risk patterns
- **Docs consolidation**: Use `report`, `docs <basename>` and plan canonicalization
- **Hygiene & dead code**: Combine `dead --json`, `metrics --json`, and targeted `search` to find unused functions and cycles
- **User journey mapping**: Use `tree --max-depth 3`, `search`, and `debug` to map route flows
- **Tech stack inference**: Use `report --json` and `importers` to identify key libraries
- **Downstream dependencies**: Use `debug`, `callees`, and `trace` to find call chains
- **Complex pipelines**: Combine multiple commands to build comprehensive maps

### Flow Diagram

```
User Query
  → Interpret
  → (index presence check)
  → classify intent
  → plan commands
  → execute project-intel commands
  → validate results
  → CoD^Σ drafts
  → structured deliverables (JSON, diagrams)
  → cache results
  → optionally delegate to subagent or propose next action
```

### Dependency Tree

```
Code Intelligence Skill
├─ SKILL.md (guidance & metadata)
├─ scripts/
│   ├─ run_project_intel.py (wraps CLI commands)
│   └─ helper_parse_json.py (parses results)
├─ references/
│   ├─ project-intel-cheatsheet.md (command usage & default patterns)
│   ├─ cod_sigma_ultrathink.md (micro-notation, grammar, examples)
│   └─ workflows.md (Gate → Interpret → Plan → Execute → Validate → Synthesize)
└─ assets/
    └─ flow_diagram.png (flow & dependency diagram)
```

### Implementation Approach

1. **Define metadata & triggers**: Name ("Code Intelligence"), description (what it does, when to use it), trigger phrases ("code intel," "project-intel," "hotspots," "call graph")

2. **Map workflows**: For each intent (locate, explain, trace, map), create workflow using project-intel commands (`report`, `metrics`, `debug`, `callers`, `callees`, `trace`, `docs`)

3. **Implement CoD^Σ Ultrathink**: Provide reasoning discipline reference file with micro-notation, grammar, examples, patterns, quality gates. Use `<cod_sigma>` blocks for draft reasoning

4. **Write scripts**: Wrap CLI calls with proper options, produce JSON outputs. Validate file existence, parse results, return structured JSON

5. **Create diagrams**: Flow chart illustrating decision tree for handling code-intelligence requests (Entry → Gate → Action → Synthesis → Next Action)

6. **Build dependency tree**: Outline which workflow depends on which script and reference file

7. **Document everything**: In `references/`, include quick reference for project-intel commands (stats, tree, search, callers, callees, trace, dead, docs, report) and examples of CoD^Σ Ultrathink reasoning

8. **Package & iterate**: Validate using packaging script; refine based on test queries (hotspots, PDF flows, doc consolidation)

### Expected Output Structure

```
code-intel/
  ├─ SKILL.md
  ├─ scripts/run_project_intel.py
  ├─ references/project-intel-cheatsheet.md
  ├─ references/cod_sigma_ultrathink.md
  ├─ references/workflows.md
  └─ assets/flow_diagram.png
```

Each file is referenced from `SKILL.md` and loaded only when relevant (progressive disclosure).

### Key Takeaways from Code Intelligence Example

This advanced example demonstrates:

1. **Intelligence-First Architecture**: Always query indexes before reading files (80%+ token savings)
2. **Reasoning Discipline**: CoD^Σ Ultrathink ensures transparent, reproducible, token-efficient reasoning
3. **Progressive Disclosure**: Metadata always loaded, instructions on trigger, resources on demand
4. **Workflow Orchestration**: Clear gates and decision points for handling complex queries
5. **Extensibility**: Structured for subagent delegation and future enhancements

By studying this implementation alongside the fundamentals in Part 1, you can create sophisticated skills that combine token efficiency, transparency, and reliability.

---

## References

[\[1\]](https://github.com/anthropics/skills#:~:text=Example%20Skills) GitHub \- anthropics/skills: Public repository for Skills

[https://github.com/anthropics/skills](https://github.com/anthropics/skills)

[\[2\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=) [\[3\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,Skill%20with%20Concrete%20Examples) [\[4\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,Reusable%20Skill%20Contents) [\[5\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,without%20reading%20into%20context%20window) [\[7\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=,md%3B%20move%20detailed) [\[8\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=When%20creating%20a%20new%20skill,much%20more%20efficient%20and%20reliable) [\[10\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=To%20begin%20implementation%2C%20start%20with,references) [\[11\]](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md#:~:text=) raw.githubusercontent.com

[https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md](https://raw.githubusercontent.com/anthropics/skills/main/skill-creator/SKILL.md)

[\[6\]](https://raw.githubusercontent.com/anthropics/skills/main/document-skills/docx/SKILL.md#:~:text=,document) [\[9\]](https://raw.githubusercontent.com/anthropics/skills/main/document-skills/docx/SKILL.md#:~:text=This%20workflow%20allows%20you%20to,must%20implement%20ALL%20changes%20systematically) [\[13\]](https://raw.githubusercontent.com/anthropics/skills/main/document-skills/docx/SKILL.md#:~:text=) raw.githubusercontent.com

[https://raw.githubusercontent.com/anthropics/skills/main/document-skills/docx/SKILL.md](https://raw.githubusercontent.com/anthropics/skills/main/document-skills/docx/SKILL.md)

[\[12\]](https://raw.githubusercontent.com/anthropics/skills/main/algorithmic-art/SKILL.md#:~:text=Algorithmic%20philosophies%20are%20computational%20aesthetic,js%20files%20%28generative%20algorithms) raw.githubusercontent.com

[https://raw.githubusercontent.com/anthropics/skills/main/algorithmic-art/SKILL.md](https://raw.githubusercontent.com/anthropics/skills/main/algorithmic-art/SKILL.md)
