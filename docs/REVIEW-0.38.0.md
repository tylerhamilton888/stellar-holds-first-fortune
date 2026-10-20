# 0.38.0 implementation review

## Changes

- WIP signs on all six unopened painted hold doors, disabled entry with an explanation, and overview counts. Build-status page from Pause/Guide lists unavailable wings, full planets/interstellar travel/Great Works and marriage/family/succession. Ship and chronicle panels repeat the relevant boundary at the point of use. Implemented progression gates retain their actual requirements.

- Dedicated Eirik world sprite, normal dwarf scale. His original painting remains the dialogue and audience portrait.
- Three related painted hold districts with floor collisions and entry coordinates fitted to the artwork. Stairs and the lift connect levels; doors enter real rooms. Earlier district coordinates migrate to a valid landing.
- Dedicated resident dialogue layout with named portrait, readable speech and compact choices. Gold diamonds mark quests; casual questions and service actions use ordinary arrows. Talking checks the resident's physical location.
- Separate Orla and Hedrik requests, local acceptance/preparation/delivery, journal entries only after acceptance. No shared offer from Ivar. Delivery order records the inviter; each spouse has a different invitation. Existing gifts and ceremony rewards remain compatible.
- Expedition tables on the concourse and Hearthward connect to basin travel. Walking across former scene seams is disabled. Old Workings has a distinct mountain backdrop. Regional travel still requires the entrance or surface.
- Fixed source-space tool grips. Near targets rotate the tool without sliding the grip or stretching it. Work poses take priority over airborne poses; world scale applies to the body, tool and foreground fingers together. Foreground finger coverage uses the skin material mask.

## Verification

The opening was exercised through the actual dialogue button signals: Ivar employment, three introductions, coal delivery, royal audience, lift commission, separate gift requests, second-host invitation and exchange completion.

Focused checks cover both gift orders for both player genders, remote-interaction rejection, undiscovered quest privacy, single rewards, floor connectivity and portals, saved-map migration, deep-mine travel restrictions, and tool grip/scale invariants across all ten designs and both directions. The existing anniversary domain and hold navigation regressions also pass.

The WIP pass also verifies all six unfinished doors cannot enter a room, the royal hall keeps its working quest gate, and the status page pauses play. The overview uses shorter doorway labels to keep the expedition table visible.

Native Godot captures reviewed: King in the hall and audience, conversation and secret-request menus, all three districts, overview and lift/table, mine arrival, and every work frame. The exported game pack is checked independently before packaging.

Validation runs use Godot 4.4.1 on Linux with software rendering. The included official Windows executable and launcher have not been executed on Windows in this environment.

## Review media

The mining clip repeats the eight rendered work poses with a brief contact-frame hold. It is an isolated visual review without audio. Actual game captures separately cover aimed strikes facing both ways, including airborne poses. The contact frame's tool orientation can vary with the player's target.
