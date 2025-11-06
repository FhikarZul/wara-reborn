# IOS Project Rules

## Code Style — Typography & Font (SwiftUI)

This guide enforces consistent, accessible typography across the app by using SwiftUI’s built-in text styles (Dynamic Type) instead of hardcoded font sizes.

### Core Principles

- Use SwiftUI text styles: `.largeTitle`, `.title`, `.title2`, `.title3`, `.headline`, `.subheadline`, `.body`, `.callout`, `.footnote`, `.caption`, `.caption2`.
- Avoid `.font(.system(size:, weight:, design:))` and any `.system(...)` variants.
- Respect Dynamic Type for accessibility; do not lock font sizes manually.

### Defaults & Hierarchy

- Body text: `.font(.body)`.
- Labels, short descriptions, and control text (buttons, chips, badges): default to `.font(.subheadline)`.
- Section/group headers: `.font(.headline)`.
- Page or large block titles: `.font(.title2)` or `.font(.title3)` as appropriate.
- Metadata, hints, or very small text: `.font(.caption)` or `.font(.caption2)`.

### Prohibited

- Using `.font(.system(size: ..., weight: ..., design: ...))` for UI text styling.
- Using `.font(.custom(...))` without a strong branding reason and design approval.

### Exceptions (Require Justification)

- Specific branding/marketing needs that cannot be achieved with built-in text styles.
- Special components explicitly approved by design to use particular sizes/weights.

If an exception is used:

- Wrap custom font usage in a helper/theme (e.g., `Typography.brandHero`) to localize and audit easily.
- Include justification in the PR along with screenshots and the impact on Dynamic Type.

### Examples

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

### Rationale

- Visual consistency: maintains a coherent typographic hierarchy across screens/components.
- Accessibility: SwiftUI text styles automatically support Dynamic Type (user text size settings).
- Maintainability: avoids scattered, hard-to-audit size/weight duplication.

### Code Review Checklist

- No `.font(.system(...))` in UI components.
- Text uses the appropriate SwiftUI text style according to hierarchy.
- Any exceptions are wrapped in helper/theme and justified in the PR.

### Audit & Migration

- When touching SwiftUI files, replace `.system(...)` with the appropriate text style (`.body`, `.subheadline`, `.headline`, etc.).
- For bulk audits, search for `font(.system` and plan a staged migration.

---
Note: This guide standardizes `.font(.subheadline)` for labels/control text. Use `.body` for primary content, and choose other styles to match the established design hierarchy.

---

## File Headers — Author Tag

- For new files, set the author line to: `Created by Meow on <DD/MM/YY>`.
- Keep existing author lines as-is unless you are the original author and updating the file substantially.
- Date format follows the existing convention used across the project.

## Naming — Swift Models & DTOs

### Core Principles for Swift Models & DTOs

- Use PascalCase for type names; avoid abbreviations unless widely accepted (e.g., `DTO`, `ID`).
- Domain models should be nouns without the `Model` suffix (preferred): `User`, `Category`, `Ingredient`, `DetectionResult`, `TextRecognitionResult`.
- Data Transfer Objects (DTOs) must end with `DTO`, with explicit roles when applicable:
  - Requests: `CreateUserRequestDTO`, `UpdateProfileRequestDTO`
  - Responses: `ApiResponseDTO<T>`, `CategoriesResponseDTO`
  - Payloads/Items: `CategoriesPayloadDTO`, `CategoryItemDTO`, `IngredientDTO`
- SwiftUI views keep the `View` suffix and stay in View folders; do NOT place them in `Model`.
- View models keep the `ViewModel` suffix and live under `Wara/ViewModel`.

### Folder Placement

- Domain models: `Wara/Model/Domain`
- DTOs (API/request/response/payload): `Wara/Model/DTO`
- Network and service helpers (e.g., remote sources, HTTP clients) remain in their respective `Data/Remote`, `Service`, or `Utils` folders.

### File Naming

- File name MUST match the primary type declared: `User.swift` defines `struct User { ... }`.
- One top-level type per file; supporting nested types are allowed inside the primary type.

### Conformance Guidelines

- Domain models: conform to `Identifiable` when shown in lists; adopt `Codable` only if persisted or directly serialized.
- DTOs: conform to `Decodable/Encodable` as needed; avoid `Identifiable`.

### Examples for Swift Models & DTOs

Bad (avoid):

```swift
struct CreateUserReqModel: Encodable {}
struct UserModel: Codable, Identifiable {}
struct BasicResponseDTO<T: Decodable>: Decodable {}
```

Good (follow):

```swift
struct CreateUserRequestDTO: Encodable {}
struct User: Codable, Identifiable {}
struct ApiResponseDTO<T: Decodable>: Decodable {}
```

### Review Checklist

- Domain types do not use the `Model` suffix in new code; prefer plain nouns.
- DTO types consistently end with `DTO` and use specific role suffixes where applicable (`RequestDTO`, `ResponseDTO`, `ItemDTO`, `PayloadDTO`).
- Files and types are named consistently (file name equals type name).
- Types are placed in the correct folders (`Model/Domain`, `Model/DTO`, `ViewModel`, `View`).

### Audit & Migration for Swift Models & DTOs

- Gradually migrate legacy names for consistency:
  - `UserModel` → `User`
  - `CategoryModel` → `Category`
  - `CreateUserReqModel` → `CreateUserRequestDTO`
  - Unify response wrappers to `ApiResponseDTO<T>` (replace `ResponseDTO`/`BasicResponseDTO`)
  - `EmptyObjectDTO` → `EmptyDTO`
- Search patterns:
  - `struct .*Model` for legacy model suffixes
  - `struct .*DTO` to audit DTO naming consistency
  - Perform staged renames to minimize disruption; update imports and references accordingly.

## Tooling — MCP and XcodeBuildMCP

When you run into difficulties (build failures, codesigning, device install/launch, flaky simulator), prefer using MCP tooling from Trae — especially XcodeBuildMCP — to perform build/test/device actions reproducibly and keep logs attached to your workspace.

### Capabilities Overview

- Discover projects/workspaces and schemes: `discover_projs`, `list_schemes`, `show_build_settings`.
- Build and clean:
  - iOS device builds: `build_device`, `clean`.
  - macOS builds: `build_macos`, `build_run_macos`.
- Devices and simulators:
  - List devices: `list_devices`.
  - Boot simulator: `boot_sim`.
- Install, launch, and bundle info:
  - Get bundle ID / app path: `get_app_bundle_id`, `get_device_app_path`, `get_mac_app_path`, `get_mac_bundle_id`.
  - Install and launch on device: `install_app_device`, `launch_app_device`.
- Tests and logs:
  - Run tests on device: `test_device`.
  - Capture logs: `start_device_log_cap` / `stop_device_log_cap`, `start_sim_log_cap` / `stop_sim_log_cap`.

### Usage Guidelines

- Prefer MCP for repeatable CLI operations tracked in Trae when Xcode UI is unreliable.
- Keep commands non‑interactive and document the exact invocation in PRs when used to unblock build/test (include reason and summarized output).
- Sanitize any secrets/tokens before sharing logs.
- For UI‑visible changes, open a preview and verify the change before considering the task complete.

### Example Workflows

- Build for iOS device and install:
  - `build_device` → `get_device_app_path` → `install_app_device` → `launch_app_device`.
- Inspect build settings for a scheme:
  - `discover_projs` → `list_schemes` → `show_build_settings` and review codesigning/team settings.
