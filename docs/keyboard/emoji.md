# Emoji picker — catalog updates for new iOS releases

| Field | Value |
| --- | --- |
| Document ID | `KEYBOARD-FS-EMOJI` |
| Version | `1.0.4` |
| Status | Active |
| Product | Drukarnik keyboard extension |
| Component | Emoji keyboard (`DKEmojiModel`) |
| Last changed | 2026-09-22 |
| Parent | [keyboard.md](../keyboard.md) |

## Summary

Operational guide for **adding or refreshing emoji** when Apple ships a new iOS (or iOS dot-release) that changes the system emoji keyboard. Audience is implementers and automation agents: where to look up facts, how to map them to this project, and how to verify the change. This document does not duplicate the full emoji list; it defines the **research and edit process**.

## Goals

The in-app emoji picker must expose the same **grid-visible** emoji as the Apple emoji keyboard on the **highest iOS version the extension targets**, without showing sequences that the OS cannot render on older devices.

## Grid scroll vs long-press (sub-keys)

The catalog mirrors **only what appears as its own cell in Apple’s category scroll** (one tap inserts that sequence). It does **not** mirror every sequence Apple ships in the emoji font or exposes through **touch-and-hold** popovers.

| Apple exposes it as… | In `DKEmojiModel` |
| --- | --- |
| A **new scroll cell** in a category (new concept or an extra key that only appears in the grid, not in a popover) | **Must** add that exact string, in Apple scroll order, in the correct category array. |
| **Touch-and-hold** on an existing scroll cell (single-person Fitzpatrick row, multi-person two-row tone picker, mixed-tone couples, etc.) | **Must not** add those variants as extra array entries. Keep the **same base scroll key(s)** as before (typically default / yellow presentation). |

**Do not confuse release totals with grid size.** Emojipedia and Unicode may count hundreds of **new RGI sequences** in a release (e.g. iOS 26.4 / Emoji 17.0: 163 new designs including ~150 👯 / 🤼 mixed-tone sequences and five 🧑‍🩰 skin tones). Most of those are **long-press-only** on Apple’s keyboard, not new scroll positions. For Emoji 17.0, the usual **grid** delta vs the prior iOS era is the **eight new concepts** (e.g. 🫪, 🫯, 🧑‍🩰, 🫈, 🫍, 🪊, 🛘, 🪎), not the tone-combination expansions.

This project’s picker has **no long-press tone UI**; users get the default grid keys we list. Do not “fill the gap” by pasting Fitzpatrick or mixed-tone sequences from `emoji-zwj-sequences.txt` unless manual scroll comparison on target iOS shows them as **separate scroll cells**.

**Research rule:** Prefer **Simulator or device scroll** (or Emojipedia’s iOS keyboard layout for that version) over changelog headline counts. When in doubt, treat tone sequences as long-press-only.

When copying an `#available` branch, **preserve** all entries from the source snapshot; when **extending** for a new iOS release, add only **verified new scroll keys**.

## Non-goals

- Maintaining a custom emoji design or font (the OS renders glyphs).
- Long-press skin-tone or multi-person tone pickers (Apple has them; this picker does not).
- Adding Unicode sequences that are **not** scroll cells on Apple’s keyboard for the target iOS (including sequences listed only in release notes or `emoji-test.txt` diffs).
- Changing autosuggest lexicon emoji (`docs/keyboard/autosuggest.md`); that is a separate data source.
- Emoji search / keywords (not implemented in the picker).

## User-visible behavior

| iOS on device | Emoji shown in picker |
| --- | --- |
| Highest supported branch (newest `#available` block in `DKEmojiModel`) | Full catalog for that branch, eight category tabs |
| Older iOS | Catalog from the matching lower `#available` branch |
| Sequence not in any branch | Must not appear in the grid |

Category tabs map to `DKEmojiModel` arrays as follows:

| UI section (`DKEmojiSectionType`) | `DKEmojiModel` property |
| --- | --- |
| Smileys & People | `smileys` |
| Animals & Nature | `nature` |
| Food & Drink | `fooddrink` |
| Activity | `activity` |
| Travel & Places | `travelplaces` |
| Objects | `objects` |
| Symbols | `symbols` |
| Flags | `flags` |

## Process: research when a new iOS ships

Follow these steps **in order**. Use web search or a research subagent when the exact Unicode / iOS mapping is unclear.

### 1. Separate “new emoji” from “font revision”

Apple often bumps the **emoji font** (e.g. iOS 26.6 on [Emojipedia — Apple iOS](https://emojipedia.org/apple)) without adding codepoints. **New grid emoji** usually arrive in a **feature iOS release** tied to a **Unicode Emoji version** (e.g. Emoji 17.0 with iOS 26.4).

| Question | Where to answer it |
| --- | --- |
| Did Unicode add new emoji? | [Unicode Emoji Charts](https://unicode.org/emoji/charts/) → release notes; compare `emoji-test.txt` between versions |
| Which iOS version first shipped that Unicode release? | [Emojipedia — Apple iOS](https://emojipedia.org/apple) version pages (e.g. `ios-26.4`) |
| Is this dot-release only a glyph refresh? | Emojipedia iOS page: if no new entries vs previous iOS, **no catalog change** in `DKEmojiModel` |

**Rule:** If Emojipedia shows the same emoji set as the previous iOS, stop after confirming no new codepoints in `emoji-test.txt`.

### 2. List **new scroll keys** (grid candidates)

Primary sources (use all that apply):

| Source | Use for |
| --- | --- |
| [Emojipedia — Emoji X.Y](https://emojipedia.org/) (e.g. “Emoji 17.0”) | What Unicode added; **not** a scroll checklist by itself |
| [Unicode `emoji-test.txt`](https://unicode.org/Public/emoji/latest/emoji-test.txt) | Authoritative RGI sequences; diff for **research only** — many diff lines are long-press variants |
| Emojipedia page for **target iOS** | Category layout; confirm each candidate is a **scroll cell** |
| Target iOS **Simulator / device** | Definitive scroll grid when docs are ambiguous |

Classify each **new** item:

1. **New scroll cell** on target iOS (usually a new concept code point or one new default key) → **must** add on the new `#available` branch.
2. **Tone or ZWJ variant** reachable only by touch-and-hold on a scroll cell → **must not** add (e.g. Emoji 17.0 mixed-tone 👯 / 🤼 sequences, 🧑‍🩰 Fitzpatrick variants).
3. **Component-only** code points → **must not** add as a scroll cell if Apple does not.

Record for each new grid key: **glyph**, **Unicode name / code**, **category** (table above).

### 3. Choose the `#available(iOS …)` version

| Situation | Version string |
| --- | --- |
| New Unicode emoji release | Use the **first iOS version** that Emojipedia documents as shipping that set (e.g. `iOS 26.4` for Emoji 17.0), not a later font-only dot release |
| Project convention / deployment target | May use a later patch (e.g. `26.6`) **only if** the new emoji are already present on all devices you support at that minimum OS; document the choice in the PR |

The catalog uses a **descending ladder** of `if #available` / `else if #available` blocks in `DKEmojiModel.init()`. The **newest** block must be first; each block is a **full snapshot** of all eight arrays for that OS era.

**Skipping intermediate iOS versions:** If the newest branch jumps over a release that shipped new scroll keys (e.g. `iOS 17.4` → `iOS 26.6` with no `iOS 18.4` block), the top branch must still include **every** scroll key from all intermediate Unicode emoji releases that the target OS renders. Example: Emoji 16.0 (first on iOS 18.4) adds eight grid keys; they belong on the `iOS 26.6` snapshot even though that branch name is not `18.4`. Lower branches are unchanged unless you explicitly backport.

### 4. Edit `DKEmojiModel.swift`

Implementation rules:

1. **Add a new top branch** `if #available(iOS x.y, *) { … }` and change the previous top branch to `else if #available(…)`.
2. **Copy** the entire previous newest branch (all eight assignments).
3. **Insert** only the new emoji strings into the correct arrays.
4. **Preserve Apple keyboard order** within each array: use the Emojipedia iOS keyboard layout for that version (scroll the category on the iOS page) or the order in Unicode’s “emoji ordering” for that release. **Do not** sort alphabetically or by code point unless Apple does.
5. **String form:** use the same representation Apple uses in the picker (fully-qualified sequence as a Swift string). Multi-codepoint emoji (flags, ZWJ professions) are one array element, e.g. `"🧑‍🩰"`.
6. **Do not** remove or reorder unrelated emoji when adding new ones unless Apple’s order changed in that release (rare; then realign the whole affected array from Emojipedia).
7. Leave older `#available` branches unchanged unless backporting is explicitly requested.

### 5. Gap check against the previous top branch

Before opening a PR, diff **new grid keys** from research (Emojipedia iOS keyboard layout for the target version) against the **previous** newest branch:

```text
grep -F 'NEW_GLYPH' Keyboard/Keyboards/Emoji/DKEmojiModel.swift
```

Every **new scroll key** from step 2 must appear exactly once in the new branch (correct category, Apple scroll order). Emoji from **intermediate** Apple releases must appear in the new branch if they were missing from an older top branch. Do **not** bulk-import tone sequences from Unicode or Emojipedia release totals.

## Acceptance criteria

- [ ] Research notes cite Emojipedia iOS version and/or Unicode `emoji-test.txt` diff for the claimed Emoji version.
- [ ] New `#available` branch is first in `DKEmojiModel.init()` and contains complete copies of all eight arrays.
- [ ] Every new **scroll key** verified on target iOS (or Emojipedia iOS keyboard layout) is present in the correct category array on the new branch — default form for people emoji; no long-press-only tone expansions.
- [ ] No duplicate entries within the same array on the new branch.
- [ ] Older `#available` branches are unchanged unless the task explicitly includes backfill.
- [ ] `KeyboardTests` still pass, including `DKEmojiModelCatalogInvariantTests` (each newer `#available` branch must contain every emoji from the next older branch, per category).
- [ ] Extend runtime `#available` tests in `DKEmojiModelTests` when a new minimum iOS gate is added.
- [ ] Manual check on Simulator (or device) at target iOS: new emoji render in the picker and match system keyboard presence for grid keys.

## Agent workflow (checklist)

When the user asks to “add emoji for iOS X.Y”:

1. Confirm on Emojipedia whether **X.Y** adds emoji or only updates glyphs.
2. If new emoji exist, identify **Unicode Emoji version** and **first shipping iOS**.
3. Build the list of **new scroll keys** (step 2); ignore Emojipedia/Unicode sequence counts that include long-press variants unless scroll proof says otherwise.
4. Open `Keyboard/Keyboards/Emoji/DKEmojiModel.swift`; add new top `#available` block; copy-paste-edit arrays.
5. Run `grep` for each new glyph; fix category or omissions.
6. Run unit tests per [testing.md](../../testing.md) (`KeyboardTests`, scheme `Drukarnik`).
7. Summarize in the PR: iOS version, Unicode Emoji version, count of new **scroll** keys added, and how scroll was verified.

## Edge cases and limitations

- **Ladder gaps:** A new top `#available` block copied from an older snapshot does not inherit emoji from releases between the copy source and the new gate. Diff Emojipedia for each skipped iOS emoji release (e.g. Emoji 16.0 on iOS 18.4) before closing the PR.
- **Release totals vs scroll:** iOS 26.4-style changelogs may cite 100+ “new emojis” while the People scroll gains only a handful of new cells; see **Grid scroll vs long-press**.
- **Simulator vs device:** Rendering depends on the host OS emoji font; testing on the **lowest** supported iOS for the new branch is required for `#available` correctness. Compare **scroll** side-by-side with the system emoji keyboard when validating catalog changes.
- **Flags:** New subdivision or country flags are single elements in `flags`, typically in ISO-oriented order as on Apple’s flags tab.
- **VS / FE0F:** Prefer the same sequence Apple lists; inconsistent variation selectors can cause duplicate-looking keys on some OS versions.
- **Shared singleton:** `DKEmojiModel.shared` is initialized once per process; catalog is fixed at first access for that OS version.

## Verification

| Artifact | Role |
| --- | --- |
| `KeyboardTests/DKEmojiModelTests.swift` | Non-empty sections on supported OS; extend when adding a new availability gate |
| Manual | On target iOS, scroll each affected category next to the system keyboard; confirm new cells only, not popover-only tones |
| `grep` / ripgrep | Confirm each researched glyph exists in the new branch |

## References

### Documents

| ID | Title | Relation |
| --- | --- | --- |
| `KEYBOARD-FS-ROOT` | [keyboard.md](../keyboard.md) | Parent |
| — | [testing.md](../../testing.md) | How to run `KeyboardTests` |

### External dependencies

| Resource | Usage |
| --- | --- |
| [Emojipedia — Apple iOS](https://emojipedia.org/apple) | iOS ↔ emoji set, keyboard layout, font-only vs new emoji |
| [Emojipedia — Emoji versions](https://emojipedia.org/) | New-in-version lists (e.g. Emoji 16.0, 17.0) |
| [Unicode Emoji `emoji-test.txt`](https://unicode.org/Public/emoji/latest/emoji-test.txt) | Authoritative RGI sequences; version diffs under `unicode.org/Public/emoji/` |

### Source code

| Path | Role |
| --- | --- |
| `Keyboard/Keyboards/Emoji/DKEmojiModel.swift` | Versioned emoji catalogs (`#available` ladder) |
| `Keyboard/Keyboards/Emoji/DKKeyboardEmojiViewModel.swift` | Maps model arrays to UI sections |
| `Keyboard/Keyboards/Emoji/UIKit/DKKeyboardEmojiCollectionView.swift` | Emoji grid UI |

### Verification artifacts

| Path | Role |
| --- | --- |
| `KeyboardTests/DKEmojiModelTests.swift` | Catalog smoke tests |
