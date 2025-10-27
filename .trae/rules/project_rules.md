# Code Style — Typography & Font (SwiftUI)

This guide enforces consistent, accessible typography across the app by using SwiftUI’s built-in text styles (Dynamic Type) instead of hardcoded font sizes.

## Core Principles

- Use SwiftUI text styles: `.largeTitle`, `.title`, `.title2`, `.title3`, `.headline`, `.subheadline`, `.body`, `.callout`, `.footnote`, `.caption`, `.caption2`.
- Avoid `.font(.system(size:, weight:, design:))` and any `.system(...)` variants.
- Respect Dynamic Type for accessibility; do not lock font sizes manually.

## Defaults & Hierarchy

- Body text: `.font(.body)`.
- Labels, short descriptions, and control text (buttons, chips, badges): default to `.font(.subheadline)`.
- Section/group headers: `.font(.headline)`.
- Page or large block titles: `.font(.title2)` or `.font(.title3)` as appropriate.
- Metadata, hints, or very small text: `.font(.caption)` or `.font(.caption2)`.

## Prohibited

- Using `.font(.system(size: ..., weight: ..., design: ...))` for UI text styling.
- Using `.font(.custom(...))` without a strong branding reason and design approval.

## Exceptions (Require Justification)

- Specific branding/marketing needs that cannot be achieved with built-in text styles.
- Special components explicitly approved by design to use particular sizes/weights.

If an exception is used:
- Wrap custom font usage in a helper/theme (e.g., `Typography.brandHero`) to localize and audit easily.
- Include justification in the PR along with screenshots and the impact on Dynamic Type.

## Examples

Bad (avoid):
```swift
Text("Product Name")
    .font(.system(size: 22, weight: .semibold))
```

Good (follow):
```swift
// For labels/short descriptive text
Text("Product Name")
    .font(.subheadline)

// For section headers
Text("Featured Products")
    .font(.headline)

// For main body text
Text("Long product description...")
    .font(.body)
```

## Rationale

- Visual consistency: maintains a coherent typographic hierarchy across screens/components.
- Accessibility: SwiftUI text styles automatically support Dynamic Type (user text size settings).
- Maintainability: avoids scattered, hard-to-audit size/weight duplication.

## Code Review Checklist

- No `.font(.system(...))` in UI components.
- Text uses the appropriate SwiftUI text style according to hierarchy.
- Any exceptions are wrapped in helper/theme and justified in the PR.

## Audit & Migration

- When touching SwiftUI files, replace `.system(...)` with the appropriate text style (`.body`, `.subheadline`, `.headline`, etc.).
- For bulk audits, search for `font(.system` and plan a staged migration.

---
Note: This guide standardizes `.font(.subheadline)` for labels/control text. Use `.body` for primary content, and choose other styles to match the established design hierarchy.

---

## File Headers — Author Tag

- For new files, set the author line to: `Created by Meow on <DD/MM/YY>`.
- Keep existing author lines as-is unless you are the original author and updating the file substantially.
- Date format follows the existing convention used across the project.