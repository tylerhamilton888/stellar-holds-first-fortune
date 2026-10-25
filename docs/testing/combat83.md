# Steel & Footwork acceptance

Runtime owner: `scripts/skirmish.gd`; equipment definitions and menus remain in `scripts/combat.gd`. This milestone implements the first combat stage of Steel & Spoils. The equipment-instance, schematic and production loop remains deferred.

Run `tools/check.py --suite combat-preview` with Godot 4.4.1 and a native display. `tests/combat83.gd` uses the shared isolated-save fixture and is included in full gameplay and exact-export validation.

Coverage: additive companion records and stable IDs, legacy occupants/cleared passages, directional shield/brace/parry/dodge, actual Sure footing cooldown, shell resistance, bounded hammer stagger, one-time salvage/mastery, first-kill migration, nearest-target shots, stone obstruction, empty ammunition, attack/recovery slots, menu pause, actual impact on either side of the drawn cone, equipment-button cancellation, safe practice and real save reload.

Native captures: pair with shield/telegraph, hammer, carbine, and equipment menu. Inspect at 1280×720 using the established whole-character artwork. No source artwork is replaced.

Final local focused verification passed 31 assertions with zero script errors. Pair/shield, hammer, carbine and both ends of the scrolling gear panel were visually reviewed at 1280×720. The review caught and corrected an equipment-panel overflow after switching weapons. Source commit fc356766975c33af15440220a993bb430f946d10 is backed up in combat73-checkpoint.bundle and recovery/combat73-native-verified. PR #37 merged as 2b812f197a05531405c6b60f75c963724270b908 with identical tree 1bb1bebda840b49a30d62de4b8b38a303349923a.

Source run 40144076473 passed all 27 gameplay cases and people-preview. Release run 40144104224 passed the 3,269-entry PCK audit and all 17 exact-export cases (1,113 assertions, including 31 combat assertions), then published v0.73.0. Exported pair/shield and equipment captures were visually reviewed. Downloaded verification evidence SHA256 e243f9289b2477d6b4a4da71246e5dc02bbbfada1b764e1eb714f5e0b9e78afc matches the upload. Build report SHA256 8f2818f79fb826aba7866064a0b5bcdfcf4d5794cefe7689b8d100533759f261 also matches. The clean report identifies the exact source above and ZIP SHA256 9d6b7d736cdfa990610d3124a6e3a2436d64f7e15526ac06c18694d3d616a2bc, 725,152,730 bytes, matching GitHub's uploaded asset metadata.

Windows hardware performance/audio and player feedback on encounter pacing are not established by automated checks.

Save contract: existing `encounters` arrays keep their original `deep53/<seed>/<context>/<index>` IDs and do not gain companions. Only first-time records receive optional `encounter_companions` positions keyed by site index. Companion IDs append `/companion`; wounds and cleared IDs use existing combat maps. Companion positions are persisted, not reselected after excavation. No new top-level state field or destructive migration.
