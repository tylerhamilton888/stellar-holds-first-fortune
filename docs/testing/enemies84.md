# Foes Beneath the Hold acceptance

Runtime: HoldEnemyRoster owns stable kind definitions, whole-frame texture regions, foot anchors and animation selection. HoldSkirmish owns encounters, motion, hit resolution, defensive responses and one-time salvage/mastery. Legacy kinds 0 (goblin) and 1 (ironback beetle) remain valid; new kinds 2 and 3 are orc and troll.

New encounter records save lead/companion kinds in an additive encounter_roster dictionary. Older records without it preserve their previous occupants. No cleared enemy respawns; wounds remain keyed by the same persistent IDs. Troll encounters require extra open space. Safe first-level and practice behavior are retained.

Run tools/check.py --suite enemies-preview for the isolated native enemy and combat cases. Both are in the full 28-case gameplay gate; the enemy case also joins the 18-case exact-export gate. Tests cover natural cavern spawning, persistent identities, legacy occupants, atlas bounds/alpha, armor, troll damage/block/parry/dodge, matching telegraph geometry, ranged awareness, material rewards, one-time mastery, fallen-body fade and actual JSON save reload.

Visual review: all 54 extracted poses, front/side/rear orientation, planted-foot registration, in-world scale beside the approved Dwarf, heavy warning/impact and a captured movement cycle. Initial atlas review caught neighboring-sprite fragments; final sheets were regenerated with wider gutters and measured whole-silhouette extraction. Opposite walk contacts were repaired through image generation. Original art and generated source iterations remain preserved.

Final local native run passed 80 enemy assertions and 31 existing combat assertions (111 total), with zero script errors. Natural untouched caverns contain the new orcs and trolls. All 54 pose regions, in-world scale, heavy warning/impact and the movement keys were visually reviewed. Hosted source/exact-export results and release hashes will be recorded after completion. Windows hardware performance/audio and player feedback on pacing remain hands-on checks.

Art production and prompt set: assets/enemies84/PRODUCTION.md. Image generation used the built-in tool; no separate procedural body parts or replacement Dwarf art.
