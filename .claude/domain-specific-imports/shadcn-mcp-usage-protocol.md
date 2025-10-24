# Shadcn MCP Usage Protocol

**Purpose**: AI-assisted component discovery via MCP **Last Updated**:
2025-10-23 **Status**: Active

---

## CoD^Σ Definitions

```
Registries:
  R_mcp := {@ui, @elevenlabs, @magicui}
  R_copy := {originui, 21st, shadcn-form}

Registry Properties:
  @ui := {url: ui.shadcn.com, type: Core, key: ✗}
  @elevenlabs := {url: ui.elevenlabs.io/r, type: Audio, key: ✗}
  @magicui := {url: magicui.design/r, type: Animated, key: ✗}

  originui := {url: originui.com, type: Layouts, mode: manual}
  21st := {url: 21st.dev, type: Inspiration, mode: manual}
  shadcn-form := {url: shadcn-form.com, type: FormBuilder, mode: manual}
```

## Workflow (CoD^Σ)

```
MCP_Flow := Search → View → Example → Install

Operations:
  Search := mcp__search_items_in_registries(R, query, [limit, offset])
    ↦ {results: Component[]}

  View := mcp__view_items_in_registries(items: string[])
    ↦ {name, type, files[], metadata}

  Example := mcp__get_item_examples_from_registries(R, pattern)
    pattern ∈ {"{name}-demo", "example-{name}", "{name} example"}
    ↦ {code, dependencies, usage}

  Install := mcp__get_add_command_for_items(items[])
    ↦ bash_cmd → npx shadcn@latest add {items}

Usage Pattern:
  ∀component_discovery:
    Search(R_mcp, term) → View(candidates) → Example(selected) → Install(final)
```

## Example: Animated Button

```
Goal: Add sparkle-button
Flow:
  Search({@ui, @magicui}, "button animated")
    → View({@ui/button, @magicui/sparkle-button, @magicui/shine-border})
    → Example(@magicui, "sparkle-button-demo")
    → Install({@magicui/sparkle-button})
    → bash(npx shadcn add sparkle-button)
```

---

## Registry Selection (CoD^Σ)

```
Selection Rules:
  ∀comp∈Components:
    comp[type=core] ⇒ @ui                              // Button, Input, Card, Form
    comp[type=audio] ⇒ @elevenlabs                     // Audio/voice/agent UI
    comp[type=animated] ∧ subtle ⇒ @magicui            // Entrance, hover, transitions
    comp[type=layout] ⇒ originui[manual]               // Advanced patterns

Constraints:
  @ui ⊂ foundation                                      // Check first always
  @elevenlabs ⇐ NextJS_AppRouter_compat                // Verify compatibility
  @magicui ⇒ wellness_aesthetic                        // Use sparingly
  ∀animation: duration ≤ 300ms ∧ prefers-reduced-motion
  ∀magicui_comp: test(performance) ⇒ ✓
```

## Copy-Paste Workflow (R_copy)

```
Manual_Flow := Browse → Copy → Adapt → Install_Deps → Test

∀src∈R_copy:
  Browse(src) → Copy(code) → Create(components/ui/{name}.tsx)
    → Adapt(design_system) → npm_install(deps) → Test(render)
```

---

## Best Practices (CoD^Σ)

```
Discovery:
  ∀search: term[broad] → term[narrow]
  ∀comp: check(R_mcp[multi]) ⇒ variations
  ∀install: Example ⇒[required] Install

Selection:
  @ui ⊂ foundation ∴ check_first
  R_special ⇐ @ui[insufficient]
  ∀comp: test(bundle_size) ∧ verify(a11y) ∧ match(design_system)
  comp.colors ⊂ {--primary, --accent, --bg}
  comp.a11y ⇒ {ARIA, kbd_nav}

Installation:
  Install → Review(code) → Test(render) → Check(conflicts) → Commit[incremental]
  ∀comp: conflicts = ∅
  ∀commit: |components| = 1
```

## Troubleshooting (CoD^Σ)

```
Problems → Solutions:

Search(∅) ⇒ {
  try: alt_terms | view(R[direct]) | verify(components.json)
}

Install[fail] ⇒ {
  verify: components.json[valid_JSON] ∧ R.url[accessible]
  fallback: @ui
}

comp ∉ design_system ⇒ {
  Edit(components/ui/{comp}.tsx)
  Replace: hardcoded → CSS_vars
  Map: bg-{color} → bg-{--token}
}
```

---

## Design System Integration (CoD^Σ)

```
DesignSystem := {Colors, Typography, Spacing}

Colors := {
  --primary: Sage(hsl 95 12% 57%),
  --accent: Terra(hsl 7 49% 59%),
  --background: Warm(hsl 30 20% 95%)
}

Typography := {family: Inter}
Spacing := {base: 4px, scale: [xs:4, sm:8, md:16, lg:24, xl:32...]}

∀comp∈Installed:
  comp.colors ⊂ Colors
  comp.font ⊂ Typography
  comp.spacing ⊂ Spacing
  comp.animations[subtle] ⇐ wellness_aesthetic
  comp.labels[lang] = 'fr'
```

## Quick Reference (CoD^Σ)

```
MCP_Tools := {search, view, example, add, list}

search := mcp__shadcn__search_items_in_registries(R[], query)
view := mcp__shadcn__view_items_in_registries(items[])
example := mcp__shadcn__get_item_examples_from_registries(R[], pattern)
add := mcp__shadcn__get_add_command_for_items(items[])
list := mcp__shadcn__get_project_registries()

Registry_URLs := {
  @ui: ui.shadcn.com,
  @elevenlabs: ui.elevenlabs.io/r,
  @magicui: magicui.design/r
}

Flow_Rule := Search → View → Example → Install
  ∀step: skip(step) ⇒ fail
```

---

**Related**: @design-system.md | @docs/project-design-process.md |
@docs/nextjs/shadcn-ui-best-practice.md
