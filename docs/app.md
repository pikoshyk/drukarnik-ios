# Drukarnik app — functional specification

| Field | Value |
| --- | --- |
| Document ID | `APP-FS-ROOT` |
| Version | `1.0.2` |
| Status | Draft |
| Product | Drukarnik host application |
| Component | App (`Drukarnik` target) |
| Last changed | 2026-09-10 |
| Parent | [AGENTS.md](../AGENTS.md) |

## Summary

Root functional specification for the **Drukarnik** host application (`Drukarnik` target). Implementers, reviewers, and QA use this overview for scope and the feature index. Child specs under `docs/app/` are the source of truth for each feature.

## Scope

Companion app for the Drukarnik keyboard: installation flow, settings, standalone transliteration tools, and about information. Keyboard preferences are shared with the extension through the App Group.

## Non-goals

- Keyboard extension layouts, toolbar, and input behavior (separate documentation tree).
- Child feature contracts until a row in the feature index has a document.

## Architecture (high level)

| Area | Role |
| --- | --- |
| App entry | Window and initial flow |
| Main UI | Tab-based navigation |
| Settings | Keyboard and app preferences |
| Converter | Full-text Latin ↔ Cyrillic |
| Installation | Onboarding and keyboard enablement |
| About | App information |
| Shared settings | App Group preferences used by the keyboard |

## Feature index

| Feature | Document ID | Document | Status |
| --- | --- | --- | --- |
| Settings | — | — | TBD |
| Text converter | `APP-FS-CONVERT` | [convert.md](app/convert.md) | Active |
| Installation / onboarding | — | — | TBD |
| Interface transliteration choice | — | — | TBD |
| About | — | — | TBD |

## References

### Documents

| ID | Title | Relation |
| --- | --- | --- |
| — | [AGENTS.md](../AGENTS.md) | Documentation map (parent) |

### Child specifications

| ID | Document |
| --- | --- |
| `APP-FS-CONVERT` | [app/convert.md](app/convert.md) |

### External dependencies

| Dependency | Usage |
| --- | --- |
| [BelarusianLacinka](https://github.com/pikoshyk/belarusianlacinka) | In-app text converter |

### Source code

| Path | Role |
| --- | --- |
| `Drukarnik/AppDelegate.swift` | Application lifecycle |
| `Drukarnik/SceneDelegate.swift` | Scene and initial flow |
| `Drukarnik/ScreeenTabs/DKTabsView.swift` | Main tab UI |
| `Drukarnik/Settings/DKKeyboardSettings.swift` | Shared keyboard settings |
| `Drukarnik/ScreenConvertor/DKConverterView.swift` | Converter UI |
| `Drukarnik/ScreenConvertor/DKConverterViewModel.swift` | Converter logic |
