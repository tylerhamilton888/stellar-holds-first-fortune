# Foes Beneath the Hold acceptance

Runtime: HoldEnemyRoster owns stable kind definitions, whole-frame texture regions, foot anchors and animation selection. HoldSkirmish owns encounters, motion, hit resolution, defensive responses and one-time salvage/mastery. Legacy kinds 0 (goblin) and 1 (ironback beetle) remain valid; new kinds 2 and 3 are orc and troll.

New encounter records save lead/companion kinds in an additive encounter_roster dictionary. Older records without it preserve their previous occupants. No cleared enemy respawns; wounds remain keyed by the same persistent IDs. Troll encounters require extra open space. Safe first-level and practice behavior are retained.

Run tools/check.py --suite enemies-preview for the isolated native enemy and combat cases. Both are in the full 28-case gameplay gate; the enemy case also joins the 18-case exact-export gate. Tests cover natural cavern spawning, persistent identities, legacy occupants, atlas bounds/alpha, armor, troll damage/block/parry/dodge, matching telegraph geometry, ranged awareness, material rewards, one-time mastery, fallen-body fade and actual JSON save reload.

Visual review: all 54 extracted poses, front/side/rear orientation, planted-foot registration, in-world scale beside the approved Dwarf, heavy warning/impact and a captured movement cycle. Initial atlas review caught neighboring-sprite fragments; final sheets were regenerated with wider gutters and measured whole-silhouette extraction. Opposite walk contacts were repaired through image generation. Original art and generated source iterations remain preserved.

Final local native run passed 80 enemy assertions and 31 existing combat assertions (111 total), with zero script errors. Natural untouched caverns contain the new orcs and trolls. All 54 pose regions, in-world scale, heavy warning/impact and the movement keys were visually reviewed. Hosted source/exact-export results and release hashes will be recorded after completion. Windows hardware performance/audio and player feedback on pacing remain hands-on checks.

Art production and prompt set: assets/enemies84/PRODUCTION.md. Image generation used the built-in tool; no separate procedural body parts or replacement Dwarf art.

## Hitbox and impact pass

Combat now uses explicit ground-plane body circles (player 10 px; goblin 12, beetle 14, orc 17, troll 26), shared sector geometry for hits and telegraphs, and a 3 px carbine projectile radius. Damage lands on the authored contact key at 52% of the action, once per strike, with direction locked through recovery. Brief 25–70 ms combat-only hit-stop, bounded wall-safe recoil, sparks and existing impact audio distinguish hits, blocks and parries. Hammers recoil farther; trolls resist displacement and retain stagger protection. F8 toggles a live hitbox inspection overlay. No global slowdown or camera shake is added.

Additional regression coverage exercises outer/side/behind sector boundaries, projectile width, locked direction, anticipation versus contact, contact drawing selection, one-hit resolution, frozen actors/timers with buffered input preserved, prompt movement recovery, weapon-specific recoil, troll resistance and wall tunnelling. Native captures 04-hitboxes and 05-contact-feedback show the actual geometry and impact rendering. The earlier 111-assertion result predates this pass; final updated results will be recorded after verification.
