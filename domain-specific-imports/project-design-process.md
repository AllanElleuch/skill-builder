# Project Design Process

**Purpose**: Design workflow for Les Formations du TAO **Last Updated**:
2025-10-23 **Status**: Active

**shadcn MCP Workflow**: @.claude/domain-specific-imports/shadcn-mcp-usage-protocol.md

---

## Design Philosophy (CoD^Σ)

```
Aesthetic := Wellness ∧ TCM_Training

Core_Principles := {
  animations[subtle] ⇐ calm ∧ ¬flashy,
  palette: {Sage, Terra} ⊂ nature_inspired,
  typography ⊃ french_chars,
  responsive: mobile_first,
  a11y: WCAG_AA
}
```

---
## PATTERNS AND ANTI-PATTERNS

// ✅ Good: Use path aliases
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader } from '@/components/ui/card'
import { FormField } from '@/components/forms'

// ❌ Avoid: Relative imports for ui components
import { Button } from '../../../components/ui/button'
```

### ✅ Best UI components Practices

- Clean project structure with proper component organization
- Server Components by default, Client Components when needed
- Utility-first Tailwind CSS approach
- Proper component composition from shadcn/ui primitives
- Accessibility compliance with ARIA labels and keyboard navigation
- Performance optimization with lazy loading and bundle optimization
- Comprehensive error handling and loading states
- Regular component updates and maintenance

### ❌ Avoid

- Inline styles instead of Tailwind utilities
- Manual style definitions for every component
- Ignoring accessibility requirements
- Heavy client-side components when Server Components suffice
- Direct style manipulation without variants
- Importing entire component libraries

## Workflow (CoD^Σ)

```
DesignFlow := Req → Discovery → Validate → Customize → Test

Phase_1 (Req):
  Understand(need) → Review(design-system.md) → Explore(options) → Gather(inspiration)

Phase_2 (Discovery):
  MCP_Flow ⊂ @docs/shadcn-mcp-usage-protocol.md
  Selection ⊂ @docs/shadcn-mcp-usage-protocol.md

Decision_Tree:
  ∀comp∈Need:
    comp[standard] ⇒ @ui              // button, input, card
    comp[audio] ⇒ @elevenlabs
    comp[animated] ∧ subtle ⇒ @magicui
    comp[layout] ⇒ originui[manual]
```

Phase_3 (Validate): ∀comp: comp ⊂ Design_System

Design_System := {Colors, Typography, Spacing, Radii}

Colors := { primary: Sage(hsl 95 12% 57%), accent: Terra(hsl 7 49% 59%), bg:
Warm(hsl 30 20% 95%), text: Charcoal(hsl 156 11% 19%) }

Typography := { family: Inter | Outfit | Source_Sans_3, french_chars:
{é,è,ê,à,ô,ç} }

Spacing := {base: 4px, scale: [xs:4, sm:8, md:16, lg:24, xl:32...]} Radii :=
{sm:4px, md:8px, lg:12px, xl:16px, full:9999px}

Phase_4 (Customize): Install → Adapt → Test

Adapt := { colors: hardcoded → tokens, // bg-blue-500 → bg-primary animations:
bounce → fade ∧ duration ≤ 300ms, typography: _ → Inter, labels: _ → french //
aria-label="Soumettre..." }

∀comp: prefers-reduced-motion ⇒ animations = ∅

Phase_5 (Test): Test := Responsive ∧ A11y ∧ French ∧ Visual_QA

Responsive := {mobile:375px, tablet:768px, desktop:1920px} A11y := {kbd_nav,
screen_reader, contrast} French := verify({é,è,ê,à,ô,ç}[render])

```

## Component Sources (CoD^Σ)

```

Sources ⊂ @docs/shadcn-mcp-usage-protocol.md

R_mcp := {@ui, @elevenlabs, @magicui} ⇒ npx_shadcn_add R_copy := {originui,
21st, shadcn-form} ⇒ manual[Browse→Copy→Adapt→Test]

```

---

## Design System Reference (CoD^Σ)

```

Full_System ∈ design-system.md

Palette := { Primary: {Sage:#8B9D83, Teal:#5C8D89}, Neutral: {Warm:#F5F3F0,
Stone:#E8E4DD, Charcoal:#2C3531, Slate:#5A6B65}, Accent: {Terra:#C97064,
Coral:#E8A598}, Semantic: {Success:#6B9D7B, Warn:#D4A373, Error:#C97064,
Info:#5C8D89} }

Typography := { fonts: {heading: Inter|Outfit, body: Inter|Source_Sans_3,
accent: Playfair[optional]}, scale: {H1:64px|700, H2:48px|600, H3:32px|600,
H4:24px|600, Body:16px|400, Small:14px|400, Caption:12px|500}, line_heights:
{heading:1.2, body:1.6, caption:1.4} }

Layout := { containers: {mobile:100%-16px, tablet:768px, desktop:1024px,
wide:1280px, max:1536px}, breakpoints: {sm:640px, md:768px, lg:1024px,
xl:1280px, 2xl:1536px} }

```

## Component Organization (CoD^Σ)

```

Structure := {ui/, forms/, layout/, features/}

ui/ := R_mcp[installed] // shadcn base components forms/ := ui[composed] //
contact-form, questionnaire layout/ := {header, footer, mobile-nav} features/ :=
{course-card, teacher-card, testimonial-card}

Naming := {files: kebab-case, components: PascalCase}

```

---

## Decision Matrix (CoD^Σ)

```

∀need∈Needs: need[Button] ⇒ @ui ⊕ @magicui[anim] ⊕ originui[manual] need[Form] ⇒
@ui ⊕ @shadcn-form ⊕ originui[manual] need[Card] ⇒ @ui ⊕ @magicui[anim]
need[Audio] ⇒ @elevenlabs ⊕ Custom need[Animation] ⇒ @magicui ⊕ FramerMotion ⊕
21st[manual] need[Layout] ⇒ @ui ⊕ originui[manual]

Animation_Rules (Wellness): ✓: {fade, slide[small], scale[1.0→1.05],
color_transition} ✗: {bounce, rotation[excessive], zoom[excessive],
fast_movement} ∀anim: prefers-reduced-motion ⇒ disable ∀anim: duration ≤ 300ms ∧
easing = ease-in-out

```

---

## Accessibility & French (CoD^Σ)

```

A11y_Checklist := { kbd_nav ∧ focus_visible, aria_labels[lang=fr], contrast ≥
4.5:1, screen_reader[VoiceOver|NVDA], semantic_HTML, focus_states[visible ∧
distinct] }

French_Requirements := { chars: {é,è,ê,à,ô,ç,œ...}, quotes: «» ∧ ¬"", spacing: «
text », caps: months|days → lowercase }

```

---

## Quality Gates (CoD^Σ)

```

∀commit: lint() ⇒ warnings = 0 type-check() ⇒ errors = 0 format() ⇒ prettier ✓
visual_qa({mobile, tablet, desktop}) ⇒ ✓ a11y_audit(axe) ⇒ ✓ ∀text: lang = 'fr'
∧ encoding = UTF-8

```

---

**Related**: @design-system.md | @docs/shadcn-mcp-usage-protocol.md | @docs/nextjs/shadcn-ui-best-practice.md | @docs/nextjs/hydration-best-practices.md | @docs/design/css-styling-architecture.md

---

## Quick Start (CoD^Σ)

```

QuickAdd := Search → View → Example → Install → Customize → Validate

MCP_Flow ⊂ @docs/shadcn-mcp-usage-protocol.md

Customize := {colors: _ → tokens, labels: _ → french, a11y: test()} Validate :=
npm_run(validate) ⇒ {type-check ✓, lint ✓, format ✓}

```

---

## Process Summary (CoD^Σ)

```

Flow := Req → Research → Discover[MCP] → Select → Validate → Install → Customize
→ Test → QualityGates → Commit

Key_Rule := design_system[first] ∧ MCP[discovery] ∧ wellness[aesthetic] ∧
a11y[validate]

```

```
