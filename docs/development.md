# Development

| Field | Value |
| --- | --- |
| Parent | [AGENTS.md](../AGENTS.md) |

Project-wide development notes (build, tooling, conventions). To be expanded as the workflow is documented.

## Specifications

User-visible behavior **must** have a functional spec in the matching product tree (host app or keyboard). Do not put feature contracts in this file.

| Situation | Action |
| --- | --- |
| New distinct feature | Create a **child spec** in that tree’s child folder, add a row to the root feature index, set Parent / Documents to the parent only, fill Acceptance criteria before `Active` |
| Existing feature change | Edit the child spec; bump **Version** and **Last changed** in its metadata table (same calendar day) |
| How to write | Open the documentation map (parent) and follow the **Specification writing** entry. Do not invent structure, IDs, or linking |

## Code quality

Changes merged into the tree **must** leave the project in a clean compile state for the targets they touch.

| Rule | Expectation |
| --- | --- |
| Warnings and errors | New or modified code **must not** introduce compiler warnings or errors. Do not “fix” unrelated legacy warnings in the same change unless the task explicitly includes that cleanup. |
| Fixes | Prefer the platform- and framework-supported API (SwiftUI/UIKit as intended). **Must not** ship workarounds (“кастылі”): fragile view-hierarchy walks, duplicate dismiss paths, availability shims that only silence the compiler without correct runtime behavior, or gestures that fight scroll views. |
| Verification | See **After every change** below. |

When the deployment target blocks a modern API, use a deliberate availability split with equivalent user-visible behavior on older OS versions—not a no-op stub on unsupported releases unless the spec documents that gap.

## Platform support

Host app deployment target is **iOS 14.7** (`Drukarnik` target). **Apply when designing and implementing any host UI** (SwiftUI, UIKit, sheets, modals)—before choosing layout or presentation.

| Rule | Expectation |
| --- | --- |
| Universal layout | **One** layout implementation for every supported form factor. **Must** look correct on **iPhone portrait**, **iPad portrait**, and **iPad landscape** without separate “phone vs iPad” trees, `UIDevice` / idiom branches, or `horizontalSizeClass` forks for the same screen. Cap and center wide content (see **Wide layout**). Presentation follows **system** per device (bottom sheet on phone, centered sheet on iPad)—do not reimplement that split in view code with custom detents or host walkarounds unless a spec requires it. |
| iOS 14 | Code **must** compile for the deployment target. APIs above iOS 14 **must** use `#available` with a **real** fallback (same required user outcome—not an empty branch). Availability splits are for **OS API** gaps only, not for iPhone vs iPad layout. |
| SwiftUI on iOS 14 | Avoid iOS 15+ syntax without guards: e.g. `PlainButtonStyle()` not `.plain`; `.foregroundColor` not `.foregroundStyle`; `background(_:)` / `overlay(_:)` not trailing-closure `.background { }` / `.overlay { }`; `.edgesIgnoringSafeArea` where 14 needs it instead of `.ignoresSafeArea()` only. |
| Sheets and modals | Same sheet **content** layout on all form factors. Let the system choose sheet placement (bottom vs centered). **Must not** force phone-only chrome on iPad or iPad-only sizing on phone. |
| Wide layout | Cap and center primary content (~387pt where legacy parity applies); avoid full-bleed text and button rows on wide iPad sheets unless specified. |
| UI testing | There are **no** automated UI tests. Platform support is a **design and code** obligation only—**must not** require Simulator, device, or Canvas preview runs as part of agent or PR verification (compile/lint in **After every change** still applies). |

Optional Canvas preview setup is documented under **SwiftUI previews** below; it is not required for platform support.

## After every change

Anyone landing code (human or agent) **must** compile and lint before calling the work done or opening a PR.

| Step | Requirement |
| --- | --- |
| Compile | Build every target the change touches (host app: scheme `Drukarnik`; keyboard logic in tests: same scheme, `tests` profile — procedure is the **Testing** entry on the documentation map). Fix all new errors. |
| Lint | Clear new issues in the IDE and in Xcode’s Issue Navigator for touched files. Do not leave new warnings in modified code. |
| Done | No “should compile” without a fresh build log or MCP/Xcode confirmation for this tree. |

If compile or lint fails, fix the cause; do not document around a broken tree.

## Xcode build hygiene

If a build fails with `database is locked`, `unable to attach DB`, or a follow-on `invalid reuse after initialization failure`, stop parallel builds (Xcode + agents), quit Xcode, remove this project’s folder under `~/Library/Developer/Xcode/DerivedData/`, then **Product → Clean Build Folder** and rebuild. The last message is usually llbuild retrying after an earlier DB init failure, not a Swift compile error.

### Cursor **Stop** during agent `build_sim`

`build_sim` uses **XcodeBuildMCP**, not Shell. Cursor **Stop** does not cancel that MCP run today; the ios-dev plugin `stop` / `sessionEnd` hook (`hooks/agent-session-lifecycle.sh`) only kills **tracked shell** PIDs from skill scripts, not project `xcodebuild`. Aborting mid-build often leaves `build.db` locked until processes are cleared manually.

| Situation | What to do (host, until plugin is fixed upstream) |
| --- | --- |
| After **Stop** | Quit parallel Xcode builds / Canvas refresh. From host repo root, run ios-dev `simulator-hygiene.sh kill-xcodebuild` (see plugin `ios-simulator-browser` skill). |
| Lock persists | Quit Xcode, delete this project’s folder under `~/Library/Developer/Xcode/DerivedData/`, **Clean Build Folder**, rebuild. |
| Upstream fix | Spec for the **ios-dev** plugin repo: [ios-dev-stop-mcp-build-brief.md](ios-dev-stop-mcp-build-brief.md). Do not add host `.cursor/hooks` or edit the installed plugin copy locally. |

## Code style

| Rule | Expectation |
| --- | --- |
| Source folders | Group files by **feature / module** (e.g. `ScreenSettings`, `ScreeenTabs`, `ScreenConvertor`), not by technical type. **Do not** add folders named `Views`, `ViewModels`, `Models`, `Controllers`, or similar type buckets. Shared UI for a module lives in that module’s folder; cross-cutting helpers go in an existing shared area (e.g. `Categories`) only when they are not owned by one screen. |
| View vs ViewModel | **ViewModel** holds business logic (state, side effects, localization mapping, persistence callbacks). **View** holds UI only (layout, styling, bindings). One screen → paired `*View.swift` + `*ViewModel.swift`, same as legacy XIB + view controller split. |

## SwiftUI previews

Optional Canvas helpers only—not required for platform support or verification (see **Platform support**).

| Rule | Expectation |
| --- | --- |
| Shape | One `#Preview` in the same file as the view. Pass the paired view model in the closure (e.g. `MyView(viewModel: MyViewModel())`). **Do not** add preview-host wrapper views, duplicate `PreviewProvider` entries, or pinned `.previewDevice` / `.previewDisplayName` for routine screens. |
| Device | Pick iPhone or iPad in Xcode Canvas; universal layout is validated in code, not by hard-coding simulator names in previews. |
| Build | Preview code **must** compile with the app target (`build_sim` in **After every change**). Running Canvas is **not** required. |
| Canvas build errors | `ResourceInvalidationError`, `database is locked`, or `invalid reuse after initialization failure` during preview usually indicate DerivedData or parallel build contention—not missing preview wrappers. See **Xcode build hygiene**. |

## Topics (TBD)

- Repository layout
- Dependencies (SPM, KeyboardKit, BelarusianLacinka)
- Local build and run (see **After every change**)
