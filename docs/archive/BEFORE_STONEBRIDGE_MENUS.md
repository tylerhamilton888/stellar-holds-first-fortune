# Current status — room stages197 acceptance candidate

The cottage grounds preview adds a fellable rowan, cuttable grass, reversible paving and saw wear at the actual worksite. The dedicated Windows playtest starts at the stocked west bench. See COTTAGE_GROUNDS_PREVIEW.md.

Timber wing prototype on prototype/timber-wing-anchors adds playable west and east attachments to the seeded family cottage. Review the two working examples before extending the pattern to other trades. See TIMBER_WING_PROTOTYPE.md.

The owner requested a wider cottage doorway and a frontage that matches the established buildings. The working review includes an arched oak entrance, projecting gable, eaves, chimney and an upper gallery. See ROOM_STAGES197.md.

Public Windows release remains 0.124.0. This branch is based on master 328c0ca (clarity196 merged). No new Windows release or final visual acceptance is claimed.

Room plans now show a translucent light-green finished-room preview while dragging, red blocked previews, and an exterior/cutaway switch. Placement marks the foundation without payment. Building progresses through paid floor, walls/doorways, roofing and finishing. Actual tiles determine progress and partial save/load; costs, belongings and save formats remain unchanged. Temporary supports/roof framing disappear on completion. See ROOM_STAGES197.md.

Implementation is in scripts/room_construction197.gd, room_blueprints.gd, room_blueprint_view.gd and house_art189.gd. Native room acceptance captures show the same seven-by-six room throughout construction. Prefabricated buildings and fine construction retain their existing transactions.

Native Godot 4.4.1 regression run stages197-r4 passed room_stages197 (24), blueprints152 (69), blueprint_manor152 (48), upper158 (51) and cottage189 (17). Final framing/caption/checkbox verification passed in stages197-final: room_stages197 25 and blueprints152 69 assertions, no script errors. Across the five affected cases, 210 distinct assertions passed. All 42 Python tooling tests passed; output policy and whitespace checks passed.

The approved 0.125 ornate menu source remains missing; saved artwork/captures survive. This candidate uses the current plain menu shell and does not claim restoration of the Mason's Book. Preserve that work if recovered.

User requested implementation and acceptance images. Source review branch: feature/room-stages197 (not merged). Acceptance PNGs and the original capture ZIP are saved as Stellar-Holds-Room-Construction-Acceptance.png and Stellar-Holds-Room-Construction-Captures.zip. Await the user's visual response. Prior delivery details: history/CURRENT_STATUS-before-room-stages197.md.


# Session handoff — room construction acceptance

Cottage grounds preview is the newest trial on prototype/timber-wing-anchors. See COTTAGE_GROUNDS_PREVIEW.md for isolated startup and the same-save west-to-east gardening test.

The timber wing trial is on prototype/timber-wing-anchors, based on feature/room-stages197. See TIMBER_WING_PROTOTYPE.md for entry points, featured layouts, and scope.

The latest visual revision is the cottage frontage on the same review branch. Review native cottage189 (door clearance, expanded exterior and upper storey) and room_stages197 (planner and paid construction) before interpreting older screenshots.

User requested a light-green finished-room preview, foundation marking on placement, progressive construction phases, and acceptance images. Branch feature/room-stages197 starts from master 328c0ca. Read ROOM_STAGES197.md and CURRENT_STATUS.md.

The ghost uses the real house architecture renderer through read-only tile snapshots. Same rectangle and placement validation feed preview and commit. New plans remain free markings; work uses original Hearthcraft payment/locality checks with floor, walls/doors, then roof barriers. Progress is derived from saved physical tiles. Existing partial structures remain; no new saved stage or inventory ownership. Roof framing is drawn below installed tiles; temporary supports vanish on completion. Map controls expose exterior/cutaway and stage counts.

Native regressions stages197-r4: 24 room-stage assertions, 69 blueprints, 48 manor, 51 upper-floor, 17 cottage passed. Final framing/caption/cutaway verification passed at stages197-final: room_stages197 25, blueprints152 69, zero script errors. All five affected cases account for 210 distinct assertions. Tooling: 42 passed; output policy and whitespace passed. The new case is registered in gameplay-4 and exact-package catalogue. No full package or Windows acceptance is claimed.

Engine: ../godot441/Godot_v4.4.1-stable_linux.x86_64. Native wrapper ../run_native197.py runs Xorg with TCP inside the same execution namespace; ordinary Unix display sockets failed here. Evidence stays in test-results. Persistent source destination is feature/room-stages197. Three acceptance PNGs plus Stellar-Holds-Room-Construction-Captures.zip were saved for user review.

The missing presentation/holding191 and book195 visual source has not been restored. Current screenshots deliberately show the plain 0.124-based menu shell. Do not describe these as the approved ornate UI or publish them as the earlier 0.125 candidate.

User asked to approve/correct acceptance images; retain a review candidate until that feedback. No routine merge permission needs asking once visual acceptance and required checks pass. Previous handoff: history/SESSION_HANDOFF-before-room-stages197.md.


Playtest the west-to-east worksite move, garden reclamation, and the rowan/stone verge from the normal walking camera. See COTTAGE_GROUNDS_PREVIEW.md.

Review the two timber-wing layouts beside a working Dwarf. Decide whether to use the same attachment scheme for the next trade.

Review the revised cottage door beside the Dwarf, the upper gallery, the green room preview and paid construction stages. See ROOM_STAGES197.md. Windows remains 0.124.0.

Clarity196 (isolated 0.124-based patch): clearer player-facing names, functional building details and research-filtered plans/recipes. The missing 0.125 visual source still requires recovery and integration. See CLARITY196.md; not released.

# Current backlog — 2026-11-16

## Current work and next milestone

0.124.0 is delivered: coherent editable cottage architecture and explicit E entry into the actual connected interior. PR #189 merged; complete source/package acceptance and public metadata verification passed. See COTTAGE189.md and CURRENT_STATUS.md.

Delivered through 0.124.0: building-grid clarity, family-owned Rise and cottage, tools/materials, cross-craft components, Borin's commissions, civic livelihood routes and first presentation polish. See the [Home and Fortune roadmap](HOME_AND_FORTUNE_ROADMAP.md) and [previous backlog](history/BACKLOG-before-scenes181.md). Preserve existing building, navigation, household and freight owners.

## Playtest the current published build

Use [CURRENT_STATUS.md](CURRENT_STATUS.md) for the verified release and [PLAYTEST_GUIDE.md](PLAYTEST_GUIDE.md) for installation and the current route. Living Forges, NPC conversation presentation, dialogue-state corrections and the first-hour guidance pass are delivered. See [FIRST_HOUR.md](FIRST_HOUR.md) for the staged welcome, optional routes and forge handoff.

Review the first hour: arrival, meeting Ivar, the cottage, bed/chest interaction, parent letter, chosen ambition and optional paid work/forge/civic contributions. Watch unclear directions, excessive text, rushed reveals, ledger visibility, mine doorways, workshop purpose and awkward interaction approaches. Use an empty fortune slot for opening tests; separately check continued progress in existing saves.

Revisit completed favors and projects, restored forges, learned research and relationship responses. Check reply scrolling, keyboard/mouse navigation, readable costs and character voice. New compact forge layouts apply to newly created rooms; existing rooms retain their saved layout, furniture and storage. See [Living Forges notes](LIVING_FORGES148.md).

Continue through the Thane homecoming when testing campaign pacing. Record confusing next steps, repetitive trips and resource bottlenecks before expanding systems. Windows performance, input feel and audio still need ordinary playtesting.

## Delivery

Follow [RELEASE_PIPELINE.md](RELEASE_PIPELINE.md). Preserve validation gates, original assets, evidence and previous builds. Keep conversational output bounded.

[Earlier backlog](history/BACKLOG-before-doc-consolidation-2026-11-10.md) preserves superseded version-specific playtest headings. Use current status and live release metadata for delivery state.

## Surface room blueprint playtest

Test [room plans](BLUEPRINTS.md) on the family-owned holding: connected rooms, doorways, costs, furnishing, renovation and save/reload. Check [underground excavation](EXCAVATION154.md), [cellar stairs](CELLAR156.md) and [upper floors](UPPER158.md) with a cellar workshop/store, ground kitchen/hall and upper bedroom. Check [household-worker routes](WORKERS160.md) and [freight](FREIGHT162.md) in both directions, stopped/returned loads, blocked stairs and saving mid-trip. The 0.115.0 family-owned opening supersedes provisional property-story integration in RISE165.md.

## Freight validation follow-up

0.123.1 fixes the reproduced mid-step corner trap (PR #187; FREIGHT187.md). Source merge, full source/package checks and publication passed. The older unrecorded lower-level failure remains unconfirmed. Preserve replay seeds and per-failure snapshots (TESTING.md); a passing retry alone is not a root-cause fix.
