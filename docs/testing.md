# Testing

| Field | Value |
| --- | --- |
| Parent | [AGENTS.md](../AGENTS.md) |

Project-wide test procedure. Feature-level acceptance criteria and which suites prove them live in the relevant functional spec, not here.

## KeyboardTests

Unit tests for keyboard memory and shared logic live in the `KeyboardTests` target. They compile shared keyboard logic a second time (no `@testable` on the appex).

### Run on Simulator

Use XcodeBuildMCP with one in-flight test run at a time:

1. `session_show_defaults`
2. `session_use_defaults_profile` → `tests`
3. `test_sim` with scheme `Drukarnik` and destination from session defaults

If `derivedDataPath` is missing, run `plugins/ios-dev/skills/build-ios-apps/scripts/resolve-derived-data-path.sh --write-local` and set it via `session_set_defaults` for profiles `app` and `tests`.

### Simulator destination

| Rule | Expectation |
| --- | --- |
| Default device | **iPhone 17 Pro**, iOS **26.5** — `simulatorId` / `simulatorName` in `.xcodebuildmcp/config.yaml` profiles `app` and `tests`. |
| No clones | Agents **must not** create or clone simulators (`Clone N of …`, second UDID, parallel test destinations, or `simctl` device creation). Use only the configured simulator. |
| No device tests | Agent verification runs on the **Simulator** from config, not on a plugged-in iPhone, unless the user asks. |
| Clone / stuck errors | `simulator-hygiene.sh shutdown-all`, retry the same configured UDID; do not pick another simulator from `list_sims` as a workaround. |
| Parallel runs | At most one in-flight `test_sim` / `build_sim` per agent; narrow with `-only-testing:…` instead of extra simulators. |

### Memory budget (Simulator baseline — update after first XCTMemoryMetric run)

| State | Goal |
| --- | --- |
| Idle alphabetic | Minimal RSS; no emoji collection until emoji opens |
| Peak emoji scroll | Short spike only; visible cells ≈ `ceil(width / itemWidth + 2) × rows` |
| Headroom | Reserve RSS for future on-device suggestion/translation models |

Delta rules (not absolute MB):

- 200× lexicon load: RSS must not grow linearly (shared lexicon cache)
- 1000× single cell configure: growth ≪ 1–2 MB
- 200× same-layout layout apply: RSS delta ≈ simulator noise
- N× keyboard appear with same layout: no new lexicon/provider instances

Record first-run idle/peak deltas here after `KeyboardMemoryTests` on your simulator.

### Scope-specific overrides

If a memory suite hits timeout, add a row to `docs/testing-specific-rules-by-classes.md` before marking verification done.

## Manual UI checks (Simulator)

For toolbar, autosuggest, or keyboard chrome (not covered by `KeyboardTests`):

### Simulator hygiene

Before UI work on a slow Mac: one booted simulator only. Run `plugins/ios-dev/skills/ios-simulator-browser/scripts/simulator-hygiene.sh shutdown-all` (or `cleanup`) if stale simulators or background `xcodebuild` remain from earlier runs.

### Install the latest extension

1. XcodeBuildMCP profile `app` → `build_run_sim` (scheme `Drukarnik`) so the Keyboard appex matches the tree under test.
2. Host app for checks is often Safari (search field), not the Drukarnik app.

### Enable Drukarnik in the keyboard list

The extension does **not** become the system default by itself. In the host app text field:

1. Focus the field (keyboard visible).
2. Switch input via 🌐 / «Next keyboard» until **Drukarnik** is active (Accessibility label often `Next keyboard`, value `Drukarnik`).

Without this step, UI checks exercise the stock keyboard, not Drukarnik.

### Example: autosuggest bar

Safari → focus search → select Drukarnik → type a word with emoji suggestions (e.g. Cyrillic `сэрца`) → scroll the suggestion row if emoji overflow → confirm clip/mask at the top corners (screenshot or live mirror).
