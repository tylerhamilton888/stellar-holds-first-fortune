# First season, version 0.31.0

## Main progression

| Stage | Player action | Result |
| --- | --- | --- |
| Arrival | Watch or skip the coming-of-age journey | Ivar tracked; free movement starts by the east gate |
| Introductions | Report to Ivar, meet Borin, Orla and Hedrik | Four timber, two meals; first commission begins |
| First shift | Deliver eight coal to Ivar | 65 crowns; forge relit; royal audience invited |
| Audience | Take the stair inside Ivar's office, approach Eirik | Claims and the future ship introduced |
| Follow-up | Return to Ivar | Lift commission, anniversary, social errands and early lessons open |
| Repairs | Complete the lift, then conduit commissions | Existing wages and charter eligibility preserved |
| Practice | Complete a return-route lesson and lift repair, train with Borin | Actual combat controls introduced without damage; world encounters enabled after reporting back |
| Founding | Charter, first hire, assignment, workshop | Further lessons guide industry and the first keel |

Onboarding state lives under outpost.onboarding. Existing saves without it
receive completed introductory gates and existing combat access. New fortunes
explicitly initialize the new gates. Save/load preserves pending stories,
choices, facts, reports and refill cooldown. Skips advance the story normally.
Cutscenes pause production, movement and geology and consume keyboard input.

The 15 lesson definitions are authored in scripts/onboarding.gd. They read
actual crafting completion, construction placement, field sampling, tree
cutting, completed contracts, research, equipment, crew assignment, industry,
ship and combat state. Materials are not consumed again when reporting a lesson.

Anniversary routes total two copper, two iron, six timber, four stone and two
meals. Existing social errands remain separate. The tabletop motif and lid
inscription persist; matching mugs are part of the station, not a new inventory
item. The refill yields ordinary expedition provisions, not an undocumented buff.

## Art production

Built-in image generation created the three-prop atlas, throne room and seated
Lord. The atlas's three disconnected alpha components were extracted without
repainting. Runtime props live in assets/anniversary-v31/table.png, kettle.png,
and anvil.png. Royal art lives in assets/opening-v31/throne-room.png and
lord-eirik.png. Source generation paths and prompt specifications are recorded
in ART-31.md. Lord Eirik's portrait uses a crop of his new art. His seated body
is a stable painted sprite; it is not a new walking/combat rig.

## Checks

Validation covers opening gates, local introductions, royal stair transitions,
combat suppression, actual practice attacks/parry/dodge, safe training, save
migration, rewards, anniversary skip/replay, route parity, sound contact, existing
culture/outpost progression, and native visual captures. Tests use fixture
materials to exercise the chain; they do not measure a full player economy run.
Linux Godot 4.4.1 is used for executable validation. The Windows runtime is
packaged, but Windows itself is not exercised here. Some screenshot harness
teardowns retain resources; distinguish these from in-game script errors.

Packaging omits three unused original synth-score WAVs. The supplied OGG scores
and all used effects remain. There are 74 packaged audio streams.
