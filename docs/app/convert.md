# Text converter (Latin ↔ Cyrillic)

| Field | Value |
| --- | --- |
| Document ID | `APP-FS-CONVERT` |
| Version | `1.1.1` |
| Status | Active |
| Product | Drukarnik host application |
| Component | Converter tab |
| Last changed | 2026-09-10 |
| Parent | [app.md](../app.md) |

## Summary

Functional contract for the in-app **Канвертар лацінкі** tab: bidirectional full-text transliteration between Belarusian Cyrillic and Latin, with orthography and Latin variant pickers. Shared converter settings persist in the App Group and align with the keyboard extension.

## Goals

Give users a standalone place to convert arbitrary multi-line text without opening the keyboard extension.

## Non-goals

- Word-level toolbar autocomplete (keyboard extension).
- Editing keyboard layout, languages, or installation flow.
- Replacing Return with “done” on the software keyboard (multi-line input stays multi-line).

## User-visible behavior

The converter is the second tab in the main tab bar (`DKTabsView`: Settings, Converter, About). The navigation title is the full converter title (`DKLocalizationApp.converterTitleFull`, localized via `processedWord` where applicable).

### Layout

| Area | Content |
| --- | --- |
| Chrome | `NavigationView` with inset grouped `List` on `Color.secondarySystemBackground` |
| Section header | Segmented **Latin variant** (traditional / geographic) and **Cyrillic orthography** (Taraškievica / Narkamaŭka) |
| First row | Multi-line Cyrillic `TextEditor`; placeholder when empty |
| Second row | Multi-line Latin `TextEditor`; placeholder when empty |

Placeholders use `DKLocalizationApp.converterTextCyrillic` and `converterTextLatin` (fixed strings, not `processedWord`).

Both fields use multiline editors. **Return** inserts a new line in the focused field.

### Live conversion

| User edits | Other field updates |
| --- | --- |
| Cyrillic | Latin, using current Latin variant and orthography |
| Latin | Cyrillic, using current Latin variant and orthography |

Changing either segmented control **must** re-run conversion on the field that drives the pair (Latin variant change refreshes Latin from Cyrillic; orthography change refreshes Cyrillic from Latin).

Conversion uses `DKKeyboardSettings.shared.lacinkaConverter` (`BLConverter`) with the selected `BLVersion` and `BLOrthography`.

### Settings persistence

Latin variant and orthography on this screen **must** read and write the same App Group keys as keyboard settings (`converterVersion`, `converterOrthography` via `DKKeyboardSettings`).

### Software keyboard

Current implementation:

| Behavior | Detail |
| --- | --- |
| Focus | Standard `TextEditor` focus and system keyboard |
| Return | Inserts newline only |
| Dismiss | While scrolling the `List`, a `simultaneousGesture` (`DragGesture`, `minimumDistance` 10) calls `DKConverterViewModel.onDrag()` → `resignFirstResponder`. There is **no** input accessory toolbar and **no** `scrollDismissesKeyboard` |
| Tab bar | May sit under the software keyboard until focus ends |

`DKLocalizationApp.converterTextViewKeyboardDone` (**Добра**) exists in localization but is **not** wired to the converter screen in the current code.

### Interface language

When app interface transliteration changes (`Notification.Name.interfaceChanged`), the view model **must** emit `objectWillChange` so labels that use `DKLocalizationApp.processedWord` refresh.

## Acceptance criteria

- [ ] Empty Cyrillic and Latin fields show their placeholders.
- [ ] Typing in Cyrillic updates Latin in real time with the selected variant and orthography.
- [ ] Typing in Latin updates Cyrillic in real time with the selected variant and orthography.
- [ ] Changing Latin variant updates the Latin field from current Cyrillic text.
- [ ] Changing orthography updates the Cyrillic field from current Latin text.
- [ ] Variant and orthography choices persist after leaving the tab and relaunching the app.
- [ ] Return in an editor adds a newline; it does not dismiss the keyboard or change tabs.
- [ ] Layout matches inset grouped list with settings in the section header and two editor rows.
- [ ] Scrolling the list while the software keyboard is visible dismisses the keyboard.

## Edge cases and limitations

- Very large pasted text may lag; no explicit size limit is defined in the UI.
- Two linked fields use a `disableAutoChanges` guard during programmatic updates; rapid edits should not oscillate.
- Cyrillic and Latin placeholders are fixed strings (not passed through interface transliteration).
- Keyboard dismiss relies on simultaneous drag recognition during list scroll; behavior may differ from system `scrollDismissesKeyboard` on some OS versions.

## Configuration

| Key | Effect on converter |
| --- | --- |
| `DKKeyboardSettings.converterVersion` | Traditional vs geographic Latin |
| `DKKeyboardSettings.converterOrthography` | Classic (Taraškievica) vs academic (Narkamaŭka) |

## References

### Documents

| ID | Title | Relation |
| --- | --- | --- |
| `APP-FS-ROOT` | [app.md](../app.md) | Parent |

### External dependencies

| Dependency | Usage |
| --- | --- |
| [BelarusianLacinka](https://github.com/pikoshyk/belarusianlacinka) | `BLConverter` transliteration |

### Source code

| Path | Role |
| --- | --- |
| `Drukarnik/ScreenConvertor/DKConverterView.swift` | List UI, editors, scroll drag → dismiss hook |
| `Drukarnik/ScreenConvertor/DKConverterViewModel.swift` | Bidirectional conversion, persistence, `onDrag()` |
| `Drukarnik/ScreeenTabs/DKTabsView.swift` | Tab entry |
| `Drukarnik/Settings/DKKeyboardSettings.swift` | Shared settings and converter instance |
| `Drukarnik/Localization/DKLocalizationApp.swift` | Converter copy (including unused `converterTextViewKeyboardDone`) |

### Verification

Manual on Simulator or device: open Converter tab; confirm live sync, pickers, persistence, placeholders, and Return behavior. No dedicated automated test target for this screen at present.
