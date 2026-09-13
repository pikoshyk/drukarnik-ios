# Interface transliteration choice

| Field | Value |
| --- | --- |
| Document ID | `APP-FS-TRANSLITERATION-CHOICE` |
| Version | `1.0.2` |
| Status | Active |
| Product | Drukarnik host application |
| Component | First-run interface language |
| Last changed | 2026-09-11 |
| Parent | [app.md](../app.md) |

## Summary

Functional contract for the **first-run sheet** where the user picks whether the host app interface uses Belarusian Latin (Łacinka) or Cyrillic. The choice persists in App Group settings and drives `DKLocalizationApp.processedWord` across the app.

## Goals

On first launch, require an explicit interface transliteration before the user continues; preview copy in both directions via a non-committing segmented control.

## Non-goals

- Changing keyboard layout or converter settings.
- Showing this sheet again after `interfaceTransliteration` is set (Settings tab handles later changes).
- Swipe-to-dismiss or a Cancel control; only the two commit buttons apply.

## User-visible behavior

### Trigger

When the scene becomes active and `DKKeyboardSettings.shared.interfaceTransliteration` is **nil**, the app **must** present the choice sheet after a short delay (see `SceneDelegate.askInterfaceTransliteration`). A second request **must not** open a duplicate sheet while one is already visible.

### Presentation

| Rule | Detail |
| --- | --- |
| Container | SwiftUI `.sheet` from the main tab UI |
| Dismiss | **Must not** allow interactive swipe dismiss (`interactiveDismissDisabled`) |
| Cancel | **Must not** show a Cancel button |
| iOS 16+ | Medium detent (or equivalent height), visible drag indicator (non-functional dismiss) |
| iOS 15 | Standard sheet height; swipe dismiss disabled via SwiftUI |
| iOS 14 | Standard sheet height; swipe dismiss disabled via `isModalInPresentation` on the presented controller |

### Layout

| Area | Content |
| --- | --- |
| Chrome | Top separator (~0.5pt); grouped background edge-to-edge in the sheet |
| Content column | Title (center), segmented preview, history paragraph, appeal headline, two equal commit buttons, footnote |
| Width | Background full sheet width; primary content **must not** exceed ~387pt width, centered; **must** keep at least 16pt horizontal inset from sheet edges on narrow phones (legacy XIB parity) |
| iPad | Same centered column on wide sheets (portrait and landscape); buttons and segmented control **must not** stretch to full sheet width |

Spacing: 24pt between major blocks; 8pt between title and segmented control. Commit buttons: 60pt height, 16pt gap, 8pt corner radius, accent background, white title and subtitle.

### Preview segmented control

| Segment index | Label | Copy direction |
| --- | --- | --- |
| 0 | `DKLocalizationApp.transliterationSegmentedLatin` | `BLDirection.toLacin` for title, history, appeal, note |
| 1 | `DKLocalizationApp.transliterationSegmentedCyrillic` | `BLDirection.toCyrillic` |

Changing the segment **must** update preview strings only; it **must not** persist interface transliteration.

### Commit buttons

| Button | Persists | Dismisses sheet |
| --- | --- | --- |
| Latin (title + subtitle from `DKLocalizationApp`) | `DKKeyboardLayout.latin` | Yes |
| Cyrillic (title + subtitle from `DKLocalizationApp`) | `DKKeyboardLayout.cyrillic` | Yes |

Persistence **must** go through `DKKeyboardSettings.shared.interfaceTransliteration` (posts `interfaceTransliterationChanged`).

### On-appear demo

After the sheet appears, the preview segment **must** animate once for onboarding: select segment 0 after ~0.6s, then segment 1 after an additional ~1.0s, updating preview copy each time.

## Acceptance criteria

- [ ] Sheet appears on first run when `interfaceTransliteration` is nil; does not stack duplicates.
- [ ] No Cancel; swipe dismiss does not close the sheet.
- [ ] Preview segment updates title, history, appeal, and note per direction table.
- [ ] Latin button saves `.latin` and closes; Cyrillic saves `.cyrillic` and closes.
- [ ] On-appear demo runs segment 0 then 1 with documented delays.
- [ ] Layout: grouped background full width; content column max ~387pt centered, min 16pt side inset.
- [ ] iPad (portrait/landscape): content stays centered and width-capped; controls not full-bleed.
- [ ] Settings and other tabs reflect the chosen interface after commit.

## Edge cases and limitations

- If the tab host is unavailable when the scene requests the sheet, the app **must** fall back to `defaultInterfaceTransliteration` (same as legacy nib load failure).
- Very large Dynamic Type may increase vertical size; horizontal max width **must** remain capped.

## References

### Documents

| ID | Title | Relation |
| --- | --- | --- |
| `APP-FS-ROOT` | [app.md](../app.md) | Parent |

### Source code

| Path | Role |
| --- | --- |
| `Drukarnik/SceneDelegate.swift` | Programmatic window, transliteration trigger, holds `DKTabsViewModel` |
| `Drukarnik/ScreeenTabs/DKTabsView.swift` | Sheet attachment |
| `Drukarnik/ScreeenTabs/DKTabsViewModel.swift` | Sheet orchestration |
| `Drukarnik/ScreenTransliteration/DKTransliterationChoiceView.swift` | Sheet UI |
| `Drukarnik/ScreenTransliteration/DKTransliterationChoiceViewModel.swift` | Preview segment, demo, commit |
| `Drukarnik/Localization/DKLocalizationApp.swift` | Transliteration copy |
| `Drukarnik/Settings/DKKeyboardSettings.swift` | `interfaceTransliteration` storage |

### Verification

XcodeBuildMCP: `test_sim` scheme `Drukarnik` (profile `tests`) — `DrukarnikTests` (localization, `interfaceChanged`, duplicate sheet guard) and `KeyboardTests`. `build_sim` for host compile.
