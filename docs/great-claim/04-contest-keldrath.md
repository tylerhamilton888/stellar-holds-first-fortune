# The rightful claimant

Status: source complete; Windows 0.93.0 published.

## Deliverable

Interactive engineering/crafting tiebreaker using learned skills. Player victory, honorable Master of Works offer and Skarrin’s refusal. First substantial journey to Keldrath; time to explore the three wards before ceremony.

## Read before editing

chapter owner; scripts/journey.gd; scripts/royal_hall.gd; scripts/world_zones.gd

Also read ../CURRENT_STATUS.md, CHECKPOINT.md, OWNER_DIRECTIVE.md sections relevant to this milestone, and ../DEVELOPMENT.md. Code and fresh test evidence override historical completion claims.

## Acceptance

Physical contest task and resource validation; no repeat payouts; interrupted travel/scene recovery; preserve all frontier belongings and relationships.

## Guardrail

Keep the final contest outcome authored without visible rubber-banding.

## Checkpoint record

Record implementation commits, state keys/migrations, tests actually run, reviewed captures, incomplete items and exact next action here before moving on.

## Verified checkpoint — 2026-11-03 UTC

Source PR #101 merged as `1a68d7c808f36175d770e9d01848d811a37af2d5`; tested source `921d72b4bf69e4807c44fd19d44c6d13182a7447`, identical tree `1d712bb95491d620869688231d33e0e601014627`. All five jobs in run 41575490804 passed. Final focused native and exported cases each passed 380 assertions, including real interact input, both seamless Great Stair crossings, interruption at all four scene kinds, every skip, exact material payment, and home/chest/romance preservation. Export inventory verified 3,845 entries. Trial, proof-load/refusal motion, gate arrival and royal reception reviewed.

State is additive `surface.claim127`: `stage`, `built`, `scene`, `beat`, `wards`, `arrived`, `welcomed`. Existing authenticated saves use their recorded work/allowance tally; later work remains intact. Partial manual work is transient and costs nothing until completion. Scenes restage the current saved beat; Skip never substitutes for the construction requirements. The royal reception does not grant Thaneship or resolve the formal ceremony.

Windows [0.93.0 is published](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.93.0). The complete ZIP preserves the older releases and save locations. All 55 cases passed against the release pack in [run 41575487210](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41575487210), completed 2026-11-03T04:52:42Z. Published build metadata confirms the tested source, Godot 4.4.1 and a clean tree; ZIP size and digest match the release asset. Windows hardware and audible presentation still require an owner playtest.

[Acceptance and reviewed captures](../testing/claim127/acceptance.json). [Story-scene requirements](STORY_SCENES.md). After delivery, continue with [milestone 05](05-invasion-trial.md): ceremony responses, substantial invasion encounters, royal intervention and trial. Do not mark those queued encounters complete on the strength of this reception.
