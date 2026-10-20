# Development workflow

## One source of truth

The completed source import should join the verified source history to GitHub's delivery history, without force-pushing or rewriting old tags. `v0.60.0` and `v0.61.0` remain delivery tags; `ambient-0.61.0` identifies the earlier editable source. Record the actual import/merge commit in CURRENT_STATUS once verified.

All active assets stay at their existing resource paths. The current source contains substantial historical art/evidence. Do not delete originals or introduce Git LFS pointers without a separate migration and clean-checkout test. Future large recordings belong in release evidence, not runtime dependencies. Ordinary source commits should exclude editor caches, saves, build outputs and test captures.

## Working with another assistant or developer

Use a short-lived branch for one coherent task. Read AGENTS.md and the current handoff first. Open a pull request describing the player-visible problem, behavior changed, tests run and limitations. Merge only after required checks and appropriate visual review. Do not commit credentials or personal saves. Keep the release baseline available throughout.

No special architecture or assistant-specific instruction file is needed: all contributors use AGENTS.md. Avoid simultaneous edits to the same subsystem. Resource paths, .uid files and .import sidecars are part of the project contract.

## Boundaries

- `main.gd`: session orchestration, input routing and host facade. Existing calls remain compatible while cohesive responsibilities are extracted.
- `menu_view.gd`: shared widget styling and panel shell. No purchases, save changes or quest decisions.
- `whole_frames.gd`: whole-painted character backend. `folk.gd` provides compatibility entry points; do not restore old composite rendering accidentally.
- `appearance.gd`: canonical cast identity and names.
- `furnishings.gd`: shared prop art, construction costs and footprints.
- `world_zones.gd`: authored town layouts and navigation geometry.
- `deepworks*`, `handworks`, `living_*`, `surface`, `forestry*`: gameplay owners. Similar workflows are not evidence that their distinct rules should be merged.

## Build and release

`HoldBuild` in `scripts/build_info.gd` owns version, title chapter and engine version. `tools/build.py` consumes that metadata, checks engine/runtime identity, imports, exports, audits every PCK entry, and creates one complete ZIP with checksums. Output directories must be new. Do not publish a dirty build as a release.

`tools/check.py` consumes `tests/suites.json`; each case needs exit zero, no script errors and an explicit passing completion marker. Validation runs native rendering and isolated saves, sequentially. The exact-export harness remains standalone because developer tests are excluded from the PCK. Keep this boundary instead of making exported tests depend on editor-only resources.

The GitHub validation workflow has read-only repository access. Publishing remains a deliberate release step after native visual and exact-pack review. CI screenshots and software rendering do not establish player-device performance or audible quality.

## Next refactors, only with evidence

1. Expand current save migration fixtures as systems change.
2. Extract further cohesive menu presenters/session transitions in small PRs.
3. Audit legacy renderer references before removing dead paths or preloads.
4. Centralize prop geometry where measured visual/collision drift is demonstrated.
5. Consolidate actor animation orchestration only with player/NPC/cutscene regression coverage.

The foundation pass does not alter mining balance, movement, economy or save schema.
