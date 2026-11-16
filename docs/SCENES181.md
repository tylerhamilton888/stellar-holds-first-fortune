# Faces and first deeds — 0.121.0 candidate

A first set of short, skippable scenes uses existing in-world locations, character portraits and story owners.

- The saved Stonebridge arrival now introduces Rurik and Sigrid beside Ivar. Existing opening beats retain their order; completed introductions never replay.
- At the cold communal forge, **Meet Borin · a word at the anvil** introduces the smith before inspection. It is local and optional, and does not inspect, spend fuel or grant rewards.
- The actual **Relight the communal forge** button commits the existing fuel/payment/unlock transaction before its two-beat first-firing scene.
- Opening the provisioned Winter Stores commits the stocked interior/counter before a two-beat acknowledgment.
- Accepting the rescue through Ivar's quest choice commits dispatch before a three-beat briefing. The journal keeps the exact refuge, support and return-route instructions.

Enter/Space advances and Escape skips. A saved scene resumes its current beat in the same location. Finishing/skipping only clears presentation state and records the scene as seen. It never completes a quest, pays money, grants friendship or repeats construction. Completed older quests do not trigger retroactive scenes. Unknown or incompatible pending scenes are cleared without teleporting or changing quest progress. Existing larger story scenes keep their owners.

The additive surface.quest_scene181 record contains version, active ID, beat and seen IDs. New scene logic lives in quest_scene181.gd; UI callbacks invoke it only after successful existing transactions. It uses the current portrait renderer's refresh method when identities change. No artwork, save IDs or resource paths are replaced.

Expanded opening146, ledger137 and campaign138 checks cover introductions, real quest-button transactions, once-only payments, skipping, reload, incompatible state and native views. mountain104 protects the existing rescue/story flow. Pinned Godot 4.4.1 focused validation covers 367 assertions across four cases; 42 tooling tests pass. Native views were reviewed for the opening portraits, Borin, first firing, Winter Stores and Ivar briefing; ordinary interaction prompts are hidden while scenes play. Public delivery remains tracked in CURRENT_STATUS.md. Normal-speed Windows reading pace, controls and audio remain playtest feedback.
