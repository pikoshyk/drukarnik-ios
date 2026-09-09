# Testing

## KeyboardTests

Unit tests for keyboard memory and shared logic live in the `KeyboardTests` target. They compile shared keyboard logic a second time (no `@testable` on the appex).

### Run on Simulator

Use XcodeBuildMCP with one in-flight test run at a time:

1. `session_show_defaults`
2. `session_use_defaults_profile` → `tests`
3. `test_sim` with scheme `Drukarnik` and destination from session defaults

If `derivedDataPath` is missing, run `plugins/ios-dev/skills/build-ios-apps/scripts/resolve-derived-data-path.sh --write-local` and set it via `session_set_defaults` for profiles `app` and `tests`.

### Memory budget (Simulator baseline — update after first XCTMemoryMetric run)

| State | Goal |
| --- | --- |
| Idle alphabetic | Minimal RSS; no `DKEmojiModel` / emoji collection until emoji opens |
| Peak emoji scroll | Short spike only; visible cells ≈ `ceil(width / itemWidth + 2) × rows` |
| Headroom | Reserve RSS for future on-device suggestion/translation models |

Delta rules (not absolute MB):

- 200× lexicon load: RSS must not grow linearly (shared `DKEmojiAutocompleteLexicon`)
- 1000× single cell configure: growth ≪ 1–2 MB
- 200× same-layout `applyKeyboardLayout`: RSS delta ≈ simulator noise
- N× keyboard appear with same layout: no new lexicon/provider instances

Record first-run idle/peak deltas here after `KeyboardMemoryTests` on your simulator.

### Scope-specific overrides

If a memory suite hits timeout, add a row to `docs/testing-specific-rules-by-classes.md` before marking verification done.
