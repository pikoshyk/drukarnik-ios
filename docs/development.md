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

## Topics (TBD)

- Repository layout
- Dependencies (SPM, KeyboardKit, BelarusianLacinka)
- Local build and run (see **After every change**)
- Code style (see **Code quality** above)
