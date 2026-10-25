# Steel & Footwork acceptance

Runtime owner: `scripts/skirmish.gd`; equipment definitions and menus remain in `scripts/combat.gd`. This milestone implements the first combat stage of Steel & Spoils. The equipment-instance, schematic and production loop remains deferred.

Run `tools/check.py --suite combat-preview` with Godot 4.4.1 and a native display. `tests/combat83.gd` uses the shared isolated-save fixture and is included in full gameplay and exact-export validation.

Coverage: additive companion records and stable IDs, legacy occupants/cleared passages, directional shield/brace/parry/dodge, actual Sure footing cooldown, shell resistance, bounded hammer stagger, one-time salvage/mastery, first-kill migration, nearest-target shots, stone obstruction, empty ammunition, attack/recovery slots, menu pause, actual impact on either side of the drawn cone, equipment-button cancellation, safe practice and real save reload.

Native captures: pair with shield/telegraph, hammer, carbine, and equipment menu. Inspect at 1280×720 using the established whole-character artwork. No source artwork is replaced.

Local preliminary runs passed 24 then 28 assertions with zero script errors. Final focused verification and delivery evidence will be recorded after completion. Full source and exact-export gates remain required before publication. Windows hardware performance/audio and player feedback on encounter pacing are not established by automated checks.

Save contract: existing `encounters` arrays keep their original `deep53/<seed>/<context>/<index>` IDs and do not gain companions. Only first-time records receive optional `encounter_companions` positions keyed by site index. Companion IDs append `/companion`; wounds and cleared IDs use existing combat maps. Companion positions are persisted, not reselected after excavation. No new top-level state field or destructive migration.
