# Session handoff — room construction acceptance

The latest visual revision is the cottage frontage on the same review branch. Review native cottage189 (door clearance, expanded exterior and upper storey) and room_stages197 (planner and paid construction) before interpreting older screenshots.

User requested a light-green finished-room preview, foundation marking on placement, progressive construction phases, and acceptance images. Branch feature/room-stages197 starts from master 328c0ca. Read ROOM_STAGES197.md and CURRENT_STATUS.md.

The ghost uses the real house architecture renderer through read-only tile snapshots. Same rectangle and placement validation feed preview and commit. New plans remain free markings; work uses original Hearthcraft payment/locality checks with floor, walls/doors, then roof barriers. Progress is derived from saved physical tiles. Existing partial structures remain; no new saved stage or inventory ownership. Roof framing is drawn below installed tiles; temporary supports vanish on completion. Map controls expose exterior/cutaway and stage counts.

Native regressions stages197-r4: 24 room-stage assertions, 69 blueprints, 48 manor, 51 upper-floor, 17 cottage passed. Final framing/caption/cutaway verification passed at stages197-final: room_stages197 25, blueprints152 69, zero script errors. All five affected cases account for 210 distinct assertions. Tooling: 42 passed; output policy and whitespace passed. The new case is registered in gameplay-4 and exact-package catalogue. No full package or Windows acceptance is claimed.

Engine: ../godot441/Godot_v4.4.1-stable_linux.x86_64. Native wrapper ../run_native197.py runs Xorg with TCP inside the same execution namespace; ordinary Unix display sockets failed here. Evidence stays in test-results. Persistent source destination is feature/room-stages197. Three acceptance PNGs plus Stellar-Holds-Room-Construction-Captures.zip were saved for user review.

The missing presentation/holding191 and book195 visual source has not been restored. Current screenshots deliberately show the plain 0.124-based menu shell. Do not describe these as the approved ornate UI or publish them as the earlier 0.125 candidate.

User asked to approve/correct acceptance images; retain a review candidate until that feedback. No routine merge permission needs asking once visual acceptance and required checks pass. Previous handoff: history/SESSION_HANDOFF-before-room-stages197.md.
