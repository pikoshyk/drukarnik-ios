# Keyboard extension — functional specification

| Field | Value |
| --- | --- |
| Document ID | `KEYBOARD-FS-ROOT` |
| Version | `1.0.4` |
| Status | Active |
| Product | Drukarnik keyboard extension |
| Component | Keyboard (`.appex`) |
| Last changed | 2026-09-17 |
| Parent | [AGENTS.md](../AGENTS.md) |

## Summary

Root functional specification for the **Drukarnik** keyboard extension (`Keyboard` target). Implementers, reviewers, and QA use this overview for scope and the feature index. Child specs under `docs/keyboard/` are the source of truth for each feature.

## Scope

Belarusian Latin / Cyrillic keyboard: layouts, transliteration, emoji keyboard, and toolbar. Target is an iOS keyboard extension (`.appex`). Preferences are shared with the host app through the App Group.

## Non-goals

- Host-app screens (installation, converter, about). Those belong to the host-app tree.
- Child feature contracts until a row in the feature index has a document.

## Architecture (high level)

| Area | Role |
| --- | --- |
| Lifecycle | Layout selection, services, keyboard state |
| UI shell | System keyboard, toolbar slot, optional conversion overlay, emoji keyboard |
| Toolbar state | Forwards autocomplete suggestions into the toolbar UI |
| Settings | Layout, converter types, feedback |
| Transliteration | Latin ↔ Cyrillic conversion for the active layout |

## Feature index

| Feature | Document ID | Document | Status |
| --- | --- | --- | --- |
| Autosuggest (transliteration + emoji bar) | `KEYBOARD-FS-AUTOSUGGEST` | [keyboard/autosuggest.md](keyboard/autosuggest.md) | Active |
| Layouts (Latin / Cyrillic) | — | — | TBD |
| Emoji picker (catalog / iOS updates) | `KEYBOARD-FS-EMOJI` | [keyboard/emoji.md](keyboard/emoji.md) | Active |
| Callouts / long-press | — | — | TBD |
| Full-text conversion overlay | — | — | TBD |
| Feedback (sound / haptic) | — | — | TBD |
| Additional languages (long-press) | `KEYBOARD-FS-ADDITIONAL-LANGUAGES` | [keyboard/additional-languages.md](keyboard/additional-languages.md) | Active |

## References

### Documents

| ID | Title | Relation |
| --- | --- | --- |
| — | [AGENTS.md](../AGENTS.md) | Documentation map (parent) |

### Child specifications

| ID | Title | Path |
| --- | --- | --- |
| `KEYBOARD-FS-AUTOSUGGEST` | Autosuggest | [keyboard/autosuggest.md](keyboard/autosuggest.md) |
| `KEYBOARD-FS-EMOJI` | Emoji picker catalog | [keyboard/emoji.md](keyboard/emoji.md) |
| `KEYBOARD-FS-ADDITIONAL-LANGUAGES` | Additional languages | [keyboard/additional-languages.md](keyboard/additional-languages.md) |

### External dependencies

| Dependency | Usage |
| --- | --- |
| [KeyboardKit](https://github.com/KeyboardKit/KeyboardKit) | Keyboard UI, input handling, autocomplete infrastructure |
| [BelarusianLacinka](https://github.com/pikoshyk/belarusianlacinka) | Latin ↔ Cyrillic conversion |

### Source code

| Path | Role |
| --- | --- |
| `Keyboard/Keyboards/DKKeyboardViewController.swift` | Extension entry, services wiring |
| `Keyboard/Keyboards/DKKeyboardView.swift` | SwiftUI shell: keyboard, toolbar slot, settings overlay |
| `Keyboard/Keyboards/DKKeyboardToolbarView.swift` | Autosuggest bar vs options row |
| `Keyboard/Keyboards/DKKeyboardConversionOverlayView.swift` | Latin/Cyrillic full-text conversion UI |
| `Keyboard/Keyboards/DKKeyboardViewModel.swift` | Emoji lifecycle, overlay text, autocomplete SwiftUI bridge |
| `Drukarnik/Settings/DKKeyboardSettings.swift` | Shared settings (App Group) |
