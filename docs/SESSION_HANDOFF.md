# Session handoff — freight work in progress

Published baseline remains **0.111.1**, verified in CURRENT_STATUS.md. Start from current master, not an older ZIP.

## Active work

Branch: feature/estate-freight162. User asked to proceed with the remaining automated household freight slice. New scripts/estate_freight.gd gives existing miners selectable marked-pile/chest routes, direction, material and 32-unit physical loads. Routes reuse existing cellar/upper stairs and deeper mine links. Cargo stays in the order while carried; pack, carts, storage and mining owners remain separate. Finish-and-stop and return-load controls preserve interrupted cargo. Native carried-crate presentation uses existing artwork.

Integration: deepworks_play, estate_workers, room_blueprint_view, surface and deep_haul field accounting. New freight162 acceptance case belongs to source and exact-package manifests. No story integration or new excavation scope.

## Validation checkpoint

Pinned official Godot 4.4.1 checksum verified. Clean asset import/parser completed. All 42 Python tooling checks passed. The expanded native freight run passed 40 assertions. The pack assertion was corrected to measure delivery before normal mining resumes. Existing workers160 regression passed 33 checks. Expanded case also checks an upstairs cold reload and a deeper mine ladder. Current rerun logs and native screenshots are under test-results/freight162-* locally. Native rendering uses locally extracted Xvfb through /tmp/freight-xvfb/run_native.py; server and Godot must share one execution session.

The carried crate was lowered and visually reviewed without covering the worker's face. Perspective mine filtering/cargo and three extra native assertions are in the final rerun. Candidate version is 0.112.0. Finish targeted tests, perspective visual review, source PR and the mandatory complete release pipeline. Nothing from this feature is merged or released yet.

## Safeguards

Read AGENTS.md and current status. Capture noisy commands with tools/capture_command.py and inspect bounded excerpts. Preserve saves, assets and previous releases. Routine source upload, PR, checked merge and verified release are already authorized. No sub-agents. Detailed evidence stays in files.
