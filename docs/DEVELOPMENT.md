## Menu presentation

HoldMenuView owns the shared book shell, scoped parchment theme, persistent peer tabs and Page Up/Down cycling. The HUD/title keep their existing theme. HoldPlayerBook reads the authoritative pack, hotbar, people and recipe data; it never owns item stacks or performs manufacturing. Inventory/recipe/skill selection is transient UI state. HoldDisciplineView separates the overview from existing technique/research actions. Conversation callbacks and locality stay with HoldConversation/HoldPeople. Preserve existing shortcuts and Escape history when adding tabs. All new menu resources must appear in source and exact-export acceptance.

## Architectural material collections

`architecture_styles.gd` owns collection definitions, normalization, source rectangles and shared floor/wall/roof painters. `architecture_view.gd` owns the visual catalogues and studies; its previews use the same building and furnishing painters as the world. Gameplay transactions stay in `architecture.gd`. Player instances retain `surface.architecture86`; optional `style87` fields are additive. Freeform construction stores its collection in the existing per-claim building dictionary. Missing/unknown choices resolve to plan defaults. Finish payment is atomic and adds to shell-paid materials for exact empty-shell recovery. Original façade images are not replaced or recoloured.

## Player bench output

Handworks owns finished player output through collect_output. begin also recovers older bench cargo with plain E, independently of whether a new input is available. Do not restore the extra Shift+E collection step or automatically drain nearby stored materials. First-shift crew output stays in its hold-owned bench. Internal legacy bucket keys/capacity remain save-compatible; its old player overlay is retired. Upright workshop props use the shared Handworks texture path; preserve original atlases and approved whole-character sources.

## Character continuity owner

Town contact poses inherit current core metadata, including corrected source overrides; never copy historical PNG paths back into a second animation table. appearance74 frames override full sequences/crops only where authored. Hair calibration is measured by tools/calibrate_appearance74.py after registration; regenerate it when source selection changes. Keep tests/appearance74.gd in source and exact-export acceptance. Preview, actors and generic art.dwarf use the whole-character backend.

# Development workflow

## One source of truth

The verified source history is joined to GitHub's delivery history on main, without force-pushing or rewriting old tags. `v0.60.0` and `v0.61.0` remain delivery tags; `ambient-0.61.0` identifies the earlier editable source. CURRENT_STATUS records the verified merge.

All active assets stay at their existing resource paths. The current source contains substantial historical art/evidence. Do not delete originals or introduce Git LFS pointers without a separate migration and clean-checkout test. Future large recordings belong in release evidence, not runtime dependencies. Ordinary source commits should exclude editor caches, saves, build outputs and test captures.

## Working with another assistant or developer

Use a short-lived branch for one coherent task. Read AGENTS.md and the current handoff first. Open a pull request describing the player-visible problem, behavior changed, tests run and limitations. Merge only after required checks and appropriate visual review. Do not commit credentials or personal saves. Keep the release baseline available throughout.

No special architecture or assistant-specific instruction file is needed: all contributors use AGENTS.md. Avoid simultaneous edits to the same subsystem. Resource paths, .uid files and .import sidecars are part of the project contract.

## Ancestral progression owner

`ancestral_claim.gd` owns the saved rescue/research/appointment state machine. It uses existing mine cells, Handworks-independent NPC walking, conversation locality, outpost records and claim fields. Rescue paths are cached between waypoint advances and replanned when blocked. No ancestry logic belongs in generic mining damage or inventory.

## Current worksite owner

`first_shift.gd` retains Ivar’s commission panel and owns the practical mine lesson plus bounded crew demonstration. All material/equipment records remain in Handworks. `owner: hold` protects crew inputs, jobs and output; `owner: loan` permits player work without dismantling fixed borrowed equipment. Do not grant communal stock access as part of early onboarding.

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

GitHub status can lag actual execution. During 0.67.1 both API and browser reported a queued job while later logs showed passing cases. Do not restart solely because a status display says queued: inspect available job logs and artifact timestamps, and allow the expected native-run duration. A cancellation correctly blocks the dependent release gate. Keep final evidence/documentation on a separate docs branch so it does not restart an active runtime PR's checks. The 34-case source gate is partitioned into three disjoint native suites with a 45-minute budget per job. The release waits for the entire identical-source workflow, not an individual shard. Its 110-minute budget includes up to 60 minutes waiting for source checks and the exact-package checks. All cases remain mandatory; fail-fast is disabled to retain complete failure evidence.

## Next refactors, only with evidence

1. Expand current save migration fixtures as systems change.
2. Extract further cohesive menu presenters/session transitions in small PRs.
3. Audit legacy renderer references before removing dead paths or preloads.
4. Centralize prop geometry where measured visual/collision drift is demonstrated.
5. Consolidate actor animation orchestration only with player/NPC/cutscene regression coverage.

The foundation pass does not alter mining balance, movement, economy or save schema.

## Discipline progression owner

`scripts/disciplines.gd` contains stable path/node IDs, migration, eligibility, completed-work credit and recipe modifiers. `scripts/discipline_view.gd` is presentation and explicit learn/research actions only. Adding a path requires a definition, an actual completed-work event, an implemented effect and a behavioral test; never advertise a placeholder as a usable unlock. Keep technology in state.tech and appointments in ancestral_claim. No new top-level save field is needed. Do not remove legacy hauling counters while existing mechanics consume them. Unlocks do not spend experience or impose new locks on previously usable features.

## Derived animation cache

Whole-frame textures use `HoldWholeFrames.CACHE_REVISION`, independent of the game release number. Bump it whenever source artwork, crop metadata or palette conversion changes. The 0.66 fallback is deliberately gated to its compatible artwork revision; it must not be reused for a new revision. These files are derived artwork, never player saves. Room preparation includes current local residents; outdoor preparation retains the adjoining-ward cast.

Starter-quarter plans live in `HoldQuarters` and reuse `HoldFurnishings` costs/art/footprints plus existing `surface.decor`, `surface.chests` and additive `surface.facts`. Keep fixed hold furniture protected and preserve the doorway aisle and service approaches.

## Connected countryside

`scripts/roads.gd` owns directional path/door thresholds, local resident routes, fixed loan initialization, delivery orders and the allotment lease. `surface.gd` calls its movement crossing once after collision resolution; gates remain in Surface. Rooms and outdoor areas retain separate active scenes. Reuse HomesteadLife beds, Handworks facilities and State recipes/inventory. Keep IDs stable, ownership explicit, arrival positions outside the outbound plane and room access clear. Old saves receive an exact pre-roads backup before migration. The roads75 source/exact-package case checks movement, cargo, local services and preservation.

## Calendar and rest

HoldCalendar owns surface.calendar91: a saved day index, minute and annual festival journal. One game minute takes 1/.6 active seconds; menus and offline time do not advance it. Sleep advances passive state.tick in one-second steps so all queued recipes finish correctly; actors, attacks and manual work are not simulated. Energy recovery follows the time skip. Seasons do not destroy crops or close services. Feasts use existing public tables, item art and bounded energy/comfort benefits, and remain available after their dates. Calendar UI browsing never changes simulation time.
