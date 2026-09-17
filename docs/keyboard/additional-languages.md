# Additional languages (long-press letters)

| Field | Value |
| --- | --- |
| Document ID | `KEYBOARD-FS-ADDITIONAL-LANGUAGES` |
| Version | `1.1.0` |
| Status | Active |
| Product | Drukarnik keyboard extension |
| Component | Callouts / host settings |
| Last changed | 2026-09-17 |
| Parent | [keyboard.md](../keyboard.md) |

## Summary

Contract for optional **extra letters** on long-press, not separate keyboard layouts. The user enables languages in the host app; the Latin or Cyrillic layout stays the same. Audience is implementers, reviewers, and QA.

## Goals

Let users type letters from other languages (Polish, German, Spanish, Italian, Portuguese, Ukrainian, and others in the catalog) via long-press on the active Belarusian layout.

## Non-goals

- Separate QWERTZ, Spanish, or per-language keyboard layouts.
- A dedicated `ñ` key or layout reordering.
- Cyrillic callouts for Latin-only languages (and the reverse).
- Duplicating punctuation callouts already on `DKCalloutActionProvider` (e.g. `¿` / `¡` on `?` / `!`).

## User-visible behavior

| Surface | Behavior |
| --- | --- |
| Host app → Settings → Languages | Lists catalog entries in **Cyrillic layout** and **Latin layout** sections. User toggles languages; selection persists in App Group. |
| Latin keyboard | Long-press on a base key shows Belarusian extras first, then merged extras from all enabled **latin** catalog entries for that key. |
| Cyrillic keyboard | Same for enabled **cyrillic** catalog entries. |
| Multiple languages enabled | Extras for the same key **merge**; duplicate characters appear once. Order follows enabled languages, then deduplication. |
| Case | Lookup uses the lowercased key. When the pressed key is uppercase, `DKCalloutStringCasing.uppercased` applies to the callout string (including `ß` → `ẞ`, not `SS`). |

### Latin catalog (extra letters per language)

| `id` | Base keys → extras |
| --- | --- |
| `german` | `a` ä; `o` ö; `u` ü; `s` ß |
| `spanish` | `a` á; `e` é; `i` í; `o` ó; `u` ú, ü; `n` ñ |
| `italian` | `a` à; `e` é, è; `i` ì; `o` ò; `u` ù |
| `portuguese` | `a` á, à, â, ã; `c` ç; `e` é, ê; `i` í; `o` ó, ô, õ; `u` ú |

Other latin entries (`polish`, `lithuanian`, `latvian`, `czech`) remain as in `additional_languages.json`.

### Configuration

| Key | Storage | Default |
| --- | --- | --- |
| `DKKeyboardSettings.additional_language_ids` | App Group `UserDefaults` | On first launch, IDs derived from `Locale.preferredLanguages`, or `ukranian` + `polish` if none match |

## Acceptance criteria

- [ ] `additional_languages.json` decodes; entries `german`, `spanish`, `italian`, and `portuguese` use `layout: latin` with the character maps above.
- [ ] With German enabled, long-press on `s` offers `ß`; uppercase `S` long-press offers `ẞ` (not two `S` cells from `SS`).
- [ ] With Spanish, Italian, or Portuguese enabled, long-press on the listed base keys offers the specified extras.
- [ ] Enabling overlapping languages does not duplicate the same character on one key in the callout.
- [ ] Disabling a language removes its extras on the next keyboard session (settings reload).
- [ ] No new rows appear in the keyboard layout grid beyond the existing Latin / Cyrillic keys.

## Edge cases and limitations

- JSON `chars` keys must match the **base key** on the keyboard (`a`, not `á`).
- `extendedChars` joins array values in JSON order; merge order across languages follows `supportedAdditionalLanguages` order.
- Catalog stores lowercase extras only; uppercase callouts use `DKCalloutStringCasing`.
- Typo `ukranian` in catalog `id` is stable; do not rename without a migration.

## References

### Documents

| ID | Title | Relation |
| --- | --- | --- |
| — | [keyboard.md](../keyboard.md) | Parent |

### Source code

| Path | Role |
| --- | --- |
| `Drukarnik/Resources/additional_languages.json` | Catalog (bundled in app and extension) |
| `Drukarnik/Settings/Languages/DKAdditionalLanguage.swift` | Decoded model |
| `Drukarnik/Settings/Languages/DKAdditionalLanguages.swift` | Load from bundle |
| `Drukarnik/Settings/DKKeyboardSettings.swift` | `supportedAdditionalLanguages` |
| `Drukarnik/ScreenSettings/Languages/DKSettingsLanguagesViewModel.swift` | Settings UI |
| `Keyboard/Keyboards/DKCalloutStringCasing.swift` | Uppercase callout string (`ß` → `ẞ`) |
| `Keyboard/Keyboards/Lacin/DKLatinCalloutActionProvider.swift` | Latin long-press merge |
| `Keyboard/Keyboards/Cyrillic/DKCyrillicCalloutActionProvider.swift` | Cyrillic long-press merge |
| `Keyboard/Keyboards/DKCalloutActionProvider.swift` | Punctuation callouts; `calloutActions(for:)` casing |

### Verification artifacts

| Artifact | Role |
| --- | --- |
| `DrukarnikTests/DKAdditionalLanguagesTests.swift` | Catalog decode and `extendedChars` |
