# Foes Beneath the Hold acceptance

Runtime: HoldEnemyRoster owns stable kind definitions, whole-frame texture regions, foot anchors and animation selection. HoldSkirmish owns encounters, motion, hit resolution, defensive responses and one-time salvage/mastery. Legacy kinds 0 (goblin) and 1 (ironback beetle) remain valid; new kinds 2 and 3 are orc and troll.

New encounter records save lead/companion kinds in an additive encounter_roster dictionary. Older records without it preserve their previous occupants. No cleared enemy respawns; wounds remain keyed by the same persistent IDs. Troll encounters require extra open space. Safe first-level and practice behavior are retained.

Run tools/check.py --suite enemies-preview for the isolated native enemy and combat cases. Both are in the full 28-case gameplay gate; the enemy case also joins the 18-case exact-export gate. Tests cover natural cavern spawning, persistent identities, legacy occupants, atlas bounds/alpha, armor, troll damage/block/parry/dodge, matching telegraph geometry, ranged awareness, material rewards, one-time mastery, fallen-body fade and actual JSON save reload.

Visual review: all 54 extracted poses, front/side/rear orientation, planted-foot registration, in-world scale beside the approved Dwarf, heavy warning/impact and a captured movement cycle. Initial atlas review caught neighboring-sprite fragments; final sheets were regenerated with wider gutters and measured whole-silhouette extraction. Opposite walk contacts were repaired through image generation. Original art and generated source iterations remain preserved.

Runtime source 2c8919320ece292cb8760454bc5e58a617b0e99b and PR #39 merge f45c61eed282466da3c6e8e284bdbc14d087016f share tree 3d61bfdfe8dc98b12a0fd6d6c5751fdaccddd34a. Source run 40150630929 passed all 28 gameplay cases and people-preview. Local native verification passed 96 enemy/hitbox assertions and 31 combat assertions with zero script errors. A current-entry practice probe also passed held attacks, timed parry, directional dodge and harmless practice damage (5 checks). All 54 enemy poses, in-world scale, heavy warning/contact, movement keys, actual hitbox outlines and impact feedback were visually reviewed.

Release run 40150628875 passed the pack audit and all 18 exact-export cases (1209 assertions). Exported hitbox and impact captures were reviewed. Downloaded build report and verification evidence match their GitHub asset digests; report, source and uploaded ZIP metadata agree.

Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.74.0
Windows ZIP: 729,852,489 bytes; SHA256 06781dfbd4cae4ae9a0b5d3c7d4ec42963077e2b557531804f5c8be1d069094b. Existing saves and cleared encounters remain supported. Extract the complete archive into a new folder. Windows hardware performance/audio and subjective combat pacing remain hands-on playtesting.

Verified enemies84-impact-checkpoint.bundle and remote recovery/enemies84-impact-native-verified retain the runtime source. Preserve enemies84-checkpoint.bundle, recovery/enemies84-native-verified and all earlier backups/releases too. Equipment instances, schematics and the signature crafting expedition remain the next Steel & Spoils milestone. See testing/enemies84.md; art production and exact prompts are in assets/enemies84/PRODUCTION.md.

Art production and prompt set: assets/enemies84/PRODUCTION.md. Image generation used the built-in tool; no separate procedural body parts or replacement Dwarf art.

## Hitbox and impact pass

Combat now uses explicit ground-plane body circles (player 10 px; goblin 12, beetle 14, orc 17, troll 26), shared sector geometry for hits and telegraphs, and a 3 px carbine projectile radius. Damage lands on the authored contact key at 52% of the action, once per strike, with direction locked through recovery. Brief 25–70 ms combat-only hit-stop, bounded wall-safe recoil, sparks and existing impact audio distinguish hits, blocks and parries. Hammers recoil farther; trolls resist displacement and retain stagger protection. F8 toggles a live hitbox inspection overlay. No global slowdown or camera shake is added.

Additional regression coverage exercises outer/side/behind sector boundaries, projectile width, locked direction, anticipation versus contact, contact drawing selection, one-hit resolution, frozen actors/timers with buffered input preserved, prompt movement recovery, weapon-specific recoil, troll resistance and wall tunnelling. Native captures 04-hitboxes and 05-contact-feedback show the actual geometry and impact rendering. Final local total is 127 assertions; the exact-export enemy case independently passes the same 96 enemy/hitbox checks.


Additional diagnostic note: the historical playability54 harness is outside the current manifest and failed obsolete traversal/entrance assumptions before combat. It was stopped; no runtime change was based on that old harness. The isolated current-entry Borin probe passed all five checks.
