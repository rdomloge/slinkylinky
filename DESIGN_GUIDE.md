# SlinkyLinky Design System — Connection-Inspired Aesthetic

## Overview

The refreshed SlinkyLinky design emphasizes **connections** and **networks** with a sophisticated, minimal palette. Moving from bright primary colors to refined pastel accents creates a more elegant, professional interface.

## Design Philosophy

- **Sleek & Modern**: Clean lines, sophisticated typography, refined spacing
- **Connection Theme**: Visual hints of networks and nodes throughout
- **Pastel Palette**: Soft, complementary colors instead of bright primaries
- **Minimal Shadows**: Subtle depth with refined shadow hierarchy
- **Organic Motion**: Smooth, flowing animations that suggest connection and flow

## Color Palette

### Base Colors
- **Off-White**: `#fafbfc` — Primary background
- **Light Grey**: `#f5f5f5`, `#efefef` — Secondary backgrounds
- **Soft Dark**: `#2c3e50` — Primary text
- **Muted Grey**: `#5a6c7d` — Secondary text
- **Border**: `#e8e8e8` — Subtle dividers

### Entity Colors (Pastels)
- **Supplier (Soft Mint)**: `#6db89d` — Growth, connection
- **Demand (Soft Peach)**: `#d4a574` — Warmth, movement
- **DemandSite (Soft Lavender)**: `#a89dbd` — Aspiration, elegance

## Typography

- **Display Font**: Space Grotesk (700–800 weight)
  - Modern, distinctive, with geometric precision
  - Used for headings, logo, nav
- **Body Font**: Space Grotesk (400–600 weight)
  - Clean, legible, contemporary
- **Mono Font**: DM Mono (400–500 weight)
  - Data, entity badges, technical elements

## Key Design Elements

### Login Page
- Gradient background (off-white → light grey → very light grey)
- Subtle SVG network visualization with connection nodes and lines
- Soft drifting orbs (low opacity, pastel colors) for ambient motion
- Fine dot grid overlay for texture
- Refined, elegant typography with clear hierarchy
- Soft pastel button gradient (lavender → mint)

### Authenticated UI
- **Sidebar**: Light background with pastel-colored nav indicators
  - Formerly dark; now light grey/white for minimal elegance
  - Active nav items show soft pastel accent with subtle glow
  - Fine borders instead of bright glows
- **Main Content**: Off-white background with minimal shadow hierarchy
- **Cards**: White with refined borders, subtle shadows
- **Header**: Translucent with backdrop blur, minimal visual weight

### Animations

Updated animations emphasize smooth flow and connection:

- `sl-node-drift-*` — Soft, organic drifting (replaces bouncy orbs)
- `sl-fade-up` — Elegant entrance with subtle upward motion
- `sl-callback-breathe` — Soft, calming pulse (not aggressive)
- `sl-ping-ring` — Gentle expanding ring (lower opacity)
- `sl-line-flow` — Connection lines flowing (subtle, background)
- `sl-loading-dot` — Refined three-dot loader
- `sl-entry-reveal` — App entry animation for returning users

## Implementation Details

### CSS Variables
All colors are defined as CSS variables in `:root`, making theme adjustments straightforward:
```css
--bg-primary: #fafbfc
--text-primary: #2c3e50
--supplier-color: #6db89d
--demand-color: #d4a574
--demandsite-color: #a89dbd
```

### Shadow Hierarchy
- **Subtle**: `0 2px 8px rgba(0,0,0,0.03)` — Default card
- **Lifted**: `0 8px 24px rgba(0,0,0,0.06)` — Hover states
- **None**: Elements on light backgrounds use borders instead

### Border Styling
- Primary border: `var(--border-light)` (#e8e8e8)
- Secondary border: `var(--border-softer)` (#f0f0f0)
- No strong lines; subtle separation via color contrast

## Visual Metaphors

The design subtly reinforces the platform's core concept of *connections*:
- Network visualization on login (nodes + connecting lines)
- Pastel color coding for entity types (Supplier/Demand/Site)
- Flowing animations that suggest data moving through networks
- Refined, elegant presentation reflecting professional B2B context

## Design Tokens

| Element | Value | Usage |
|---------|-------|-------|
| Border Radius (cards) | 12px | Subtle, modern |
| Border Radius (buttons) | 8–12px | Friendly, refined |
| Spacing Unit | 4px | Consistent rhythm |
| Font Weight (headings) | 700–800 | Bold but elegant |
| Font Weight (body) | 400–500 | Clear, readable |
| Shadow Blur | 8–24px | Soft, subtle depth |
| Animation Duration | 0.3–0.6s | Responsive, not sluggish |

## Migration Notes

This design refresh updates:
- `frontend/react/src/styles/globals.css` — New color system, refined animations
- `frontend/react/src/components/layout/Layout.jsx` — Light sidebar, pastel buttons, connection-themed login
- `frontend/react/src/components/layout/Menu.jsx` — Updated nav colors for light sidebar
- `frontend/react/src/components/layout/Header.jsx` — Refined styling with new color variables

Entity color badges, card styles, and all other components automatically inherit the new palette via CSS variables.

## Future Extensions

This refined foundation enables:
- Dark mode variant (invert palette, maintain refinement)
- Accent color customization per tenant
- Motion preferences (reduced motion support)
- Additional connection visualizations (e.g., flow diagrams, network graphs)
