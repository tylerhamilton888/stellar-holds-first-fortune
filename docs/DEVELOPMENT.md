# First Fortune — development record

## Delivered in version 0.1

- Title screen, New Game confirmation, Continue, settings and save-on-close.
- Side-view Keldrath settlement with quarters, tavern, exchange, forge,
  survey office, timber mine entrance and eastern launchyard.
- Original animated dwarf characters, a braided-haired merchant, a work-clad
  miner and the MOTE-1 mechanical miner; lamps, smoke, forge fire, crates,
  barrels, fir trees, tracks and layered mountain scenery.
- Keyboard movement, jump, collision substeps, mouse-directed tool use,
  visible tool-head contact, four tools with distinct use/effectiveness,
  damage cracks, fragments, sparks, collectible drops and subtle screen shake.
- A survey winch for vertical movement and a no-loss recall for recovery.
- Seeded 96x44 excavation with folded strata, connected veins, loose earth,
  caverns, basalt, aether crystals and immutable claim boundaries.
- Shared persistent inventory, ore refining, timed production queue, batching,
  machine parts, drive assemblies and a forged steel pick upgrade.
- Extraction, precision metallurgy and clockwork research.
- Local bid/ask prices, supply effects, recovery of demand, freight contracts,
  and trust/hospitality-based bargaining. Quotes remain stable while trading.
- Tavern meals and hospitality, free water pump, limited harvestable trees.
- Recruitable Brann and buildable MOTE-1. Agents find open-tunnel paths to real
  exposed blocks, travel by survey cable, excavate, consume fuel/provisions,
  and deliver yields to shared storage. Material priority and pause controls.
- Three visibly distinct ship construction stages and an animated launch,
  victory screen and continuing sandbox afterward.
- Original pixel font, seven sound effects, a synthesized musical motif,
  adjustable master volume and optional screen shake.
- Atomic single-slot save with seed, cells, damage, inventory, money, research,
  crew ownership, production, trees, market and construction state.
- Full GDScript sources, original asset-generation code, packed game and a
  Windows launcher using the bundled official Godot 4.4.1 runtime.

## Validation performed

Godot 4.4.1 Linux: imported and compiled the project, rendered and inspected
actual gameplay screenshots, executed the system integration suite, and ran
a progression scenario using only materials mined, chopped, produced or
purchased through the modeled economy.

The system suite passed **46 checks** covering seeded geology, reachable
routes, real block destruction, transaction atomicity, recipe locks,
reserved ingredients, production, research prerequisites, market effects,
bid/ask spread, ship costs, save/load, partial terrain damage, keyboard
movement, collision, winch travel, actual worker excavation, paused crews,
all principal menus and the launch-to-victory transition.

The no-grants progression scenario (seed 27419) completed extraction,
metallurgy, automation, steel pick, worker recruitment, automaton construction,
and all three ship stages. It mined 374 blocks with 695 simulated impacts,
completed 87 forge jobs and five contracts, and retained 95 crowns.
Travel and production waiting were accelerated in that test: it verifies
reachability and resource accounting, **not a measured human completion time**.
The 30–60 minute experience remains a design target requiring player testing.

The bundled PCK was also boot-tested with the matching Linux runtime.
Windows executable/launcher execution was not available in this environment;
the Windows runtime is the unmodified official Godot build of the same version.
Audio files were generated and validated as PCM; this environment lacks an
audio output device, so subjective speaker/headphone listening remains open.

Actual runtime captures are under `docs/screenshots/`. Some captures use
controlled setup states (crew enabled or ship complete) to show those systems;
they are screenshots of gameplay, not illustrations or evidence of a human run.
Test logs are in `docs/testing/`.

## Problems found and corrected

- JSON reads numeric array values as floats: normalize terrain and inventory
  integers during load, preserving equality and predictable tile lookups.
- Ground contact could flicker between substeps: probe the feet after movement.
- Character drawing reset the camera transform: preserve the world offset.
- Modal confirmation could render behind title controls: give panels their
  own foreground draw order.
- Stop and release sound streams before shutdown to avoid playback leftovers.
- Hold market quotes stable while its menu is open.
- Flush collectible drops before travel/save so broken blocks cannot lose yield.

## Deliberate reductions and known limitations

This is a small prototype, not a finished commercial game.

- One settlement and one claim; no space map, second asteroid, auction,
  galactic simulation, combat, dynasties or Worldforging yet.
- Town and mine use the same side-view grammar. Visuals are authored layered
  pixel primitives, not a large painted tile atlas or full frame-by-frame set.
- NPCs have authored short dialogue and idle/work motion, not daily schedules.
- Worker navigation uses hovering survey-cable movement. Workers collect
  directly into shared storage; no pathfinding carts, stockpile capacity or
  player-built logistics network yet.
- Workers avoid basalt. Your upgraded pick opens deeper routes for them.
- Worker positions, current paths and partial fuel batches reset on reload.
  Ownership persists, but a restarted agent consumes fresh provisions/coal.
- Timber trees do not regrow. Purchased wood remains available.
- Inventory capacity is unlimited. Food powers workers, not a hunger meter.
- Bargaining is a deterministic relationship/contract choice, not a rich
  multi-offer negotiation conversation.
- Production status refreshes on interaction or with its refresh button;
  progress continues while the panel is open. No offline processing.
- Three original 64-second synthesized arrangements now crossfade by environment. No character voices. Subjective speaker/headphone listening remains open.
- Keyboard/mouse only. One save slot. Fixed aspect-ratio presentation; no
  gamepad support, rebinding screen or localization yet.
- Ship stages consume costs immediately and appear on the pad; there is no
  multi-minute construction-site animation or component placement minigame.
- No claim regeneration within a running save. New Game creates a fresh seed.

## Recommended next milestone

**The Living Claim.** First, get one full human playthrough and tune mining
reach, speed, recipes and the time to recruit Brann. Then add persistent crew
positions and fuel, a visible hauling route and depot, and richer geology
silhouettes. Expand the hand-authored character animation set and settlement
inhabitant routines. Keep the first hour polished before adding another world.

## Source map

| File | Responsibility |
|---|---|
| scripts/data.gd | Resource, recipe, research, terrain and ship definitions |
| scripts/state.gd | Inventory, transactions, production, market and persistence |
| scripts/geology.gd | Seeded terrain, damage and reachable excavation routes |
| scripts/art.gd | Original character, structure, terrain and prop drawing |
| scripts/sound.gd | Playback, sound pool and volume |
| scripts/main.gd | Scene orchestration, movement, mining, agents, menus and camera |
| assets/create_assets.py | Reproducible original font and audio generation |
| tests/test_systems.gd | Engine-level functional checks |
| tests/test_progression.gd | No-grants economy progression scenario |

The single scene keeps the small prototype easy to run. Before larger content
expansion, separate the settlement renderer, actor controllers and menu builders
from the orchestration script into individual scenes. Data and persistence are
already independent of rendering.

## Running tests

Use an isolated user-data directory to avoid replacing a player save. On Linux:

```
XDG_DATA_HOME=/tmp/stellar-holds-tests godot --headless --path Source --script res://tests/test_systems.gd
godot --headless --path Source --script res://tests/test_progression.gd
```

The system suite intentionally writes a test save. The progression test does
not write saves. First import Source in Godot if the class cache is absent.

## Version 0.2 — Faces of Keldrath

A shared, persistent appearance record now drives both the portrait compositor
and the in-world dwarf renderer. This release focuses on character visuals.

- Character naming (up to 24 characters), male/female bases and live previews.
- Six hairstyles per gender; six male beard options including clean shaven.
- Eight hair colors and independently selectable beard colors; eight clothing
  colors, three outfits, four fair complexions, four tattoo settings and four
  ornament settings. No tattoo and plain fittings are available.
- Swept crests, braids, crowns, knots and waves; forked and braided beards;
  Norse/Celtic-inspired embroidery, clasps, amber jewelry and woad markings.
- Two original generated portrait bases, with runtime-composited hair, beard,
  clothing and tattoo layers. Individual portraits are not pre-generated NPC
  images. There are no per-character image-generation calls during gameplay.
- Original modular world-sprite renderer: eight walking phases, bent legs,
  arm movement, bobbing, blinking, beard motion, and a separate working pose.
- Portrait dialogue cards, matching sprite thumbnails, greetings that use
  the player's name, a resident gallery in the quarters and three townsfolk
  with persistent generated appearances and conversation text.
- Named characters keep their names, roles and genders; seeded randomization
  selects their compatible appearance options. Each hold retains its own cast.
- New Game opens the creator after the existing-save replacement confirmation.
  C or the quarters opens the wardrobe. Applying saves immediately; canceling
  leaves the original appearance unchanged. Randomize Look keeps the typed
  name and chosen gender; Suggest Name changes only the name.
- v0.1 saves remain compatible: missing appearance fields get safe defaults,
  preserving the terrain, economy, inventory, research and progression.

Validation: all 46 previous gameplay checks passed again, plus 27 new checks
for appearance determinism, option normalization, names, persistence, v0.1
migration, creator acceptance/cancellation and matching portrait/sprite
profiles across all twelve gender/hairstyle combinations. Creator screens and
NPC dialogue were rendered and visually inspected in Godot. Packed build
boot-tested in Linux; Windows launch remains untested in this environment.

The portraits deliberately have more facial detail than the small world
sprites. They share palette and option semantics rather than identical pixel
geometry. Clothing, facial hair and hair are code-authored composited layers;
the base faces are generated original art. Animation is procedural, rendered
at a fixed small pixel resolution for previews, with no network service needed.

New source modules: appearance.gd, portrait.gd, portrait_base.gdshader,
character_art.gd, creator.gd and sprite_preview.gd. New checks:
`tests/test_appearance.gd` (use isolated user data like test_systems.gd).

## Version 0.3 — Coherent pixel characters

Replaced the raster face layer with original native pixel geometry; simplified
portrait backgrounds; rebuilt braid segments and broad beard locks; widened
and shortened animated world sprites. Portraits and sprites retain the same
appearance data, color selections, names, and stable NPC randomization.
Existing saves remain compatible. Historical v0.2 asset notes above describe
the previous renderer, not the current runtime.

Validation: 27 appearance checks and 46 gameplay/system checks pass under
Godot 4.4.1 Linux. Runtime screenshots reviewed for male/female creators and
world scenes. Windows launcher remains untested on Windows.

## Version 0.4 — Beneath the Crown of Stone

New employment chapter: Lord Eirik's introduction, three paid restoration
commissions, Ingrid's live journal, restored forge/lift/conduits, a charter
reference, three permanent claim choices, and three visible founding works.
Added King's Road and independent-claim surface zones, free return travel,
separate geological persistence, and old-save migration to an established
freehold. The starship milestone remains after founding. Brann now requires
a charter; crew pause outside the owned claim.

Original panoramic art gives the hold, road and new ridge distinct settings.
Foreground workshops are stone service recesses rather than timber houses;
engraved cornices, chisel marks, marked firs, conduits and freight cages tie
traditional architecture to practical technology. Background structures are
matte scenery; they are not all accessible. All claim variants currently share
one ridge panorama, with separate generated geology and economic advantages.

The supplied economy test now completes employment, purchases Old Delving,
founds a hold and constructs the ship without granting money or minerals.
Travel and production waits are accelerated; this does not measure human
playtime. Result: 570 blocks, 1,121 impacts, 108 forge jobs, five freight
contracts, 45 crowns remaining. Campaign tests cover reward consumption,
charter costs, separate saved mines, legacy migration, travel, and real trees.
Windows launch remains untested; Godot 4.4.1 Linux is the verification runtime.

Known scope: no rent, hunger drain, combat, interplanetary travel, offline
production or seamless world simulation. Crew positions and partial fuel
cycles reset on site travel as on reload. Generated panoramas are more
detailed than the native foreground sprites; both use the same muted stone,
bronze and teal direction, with future foreground art refinement possible.

Final v0.4 validation: 43 campaign + 46 system + 27 appearance checks = 116 passed; zero failed. Pack boot succeeded. Runtime render captures checked for hold, road, restored machinery, claim, briefing and charter UI.

## Version 0.5 — Unified playable art and animation

Renamed the starting hold Keldrath throughout the UI, narrative and source
asset references. The application/save directory deliberately retains the
same game title; saves and profile identities do not change.

Replaced flat service buildings with original transparent illustrated sprites
for forge, tavern and survey office. Matching pithead and beacon art replace
the flat utility structures. Rebuilt terrace paving and retaining masonry;
added contact shadows and contextual character color modulation. A dedicated
background shader samples a coarser grid, reduces saturation and contrast,
and adds atmospheric color, keeping foreground silhouettes prominent.

HoldSpriteAtlas composes each modular appearance once into a 1280x384 render
target containing four rows of eight 160x96 cells. Walking, work and player
tool-use each have eight distinct images; idle has three unique breathing/blink
poses distributed over eight timings. Playback selects texture regions. A
32-appearance bound limits wardrobe cache memory. Names are excluded from
the appearance key. Headless runs use the native composer fallback.

Reworked planted/swinging feet, knees, body compression, arm arcs, beard
follow-through, cloth folds and boot highlights. Player tool rendering remains
independent for targeting accuracy, but now starts at the actual posed hand.
Forge workers carry hammers; miners carry picks. Alpha-edge tests caught and
resolved a work-tool frame overflow by adding sufficient cell padding.

Verification: actual renderer confirms 3/8/8/8 unique frames, isolated frame
edges, and independent male/female atlas entries. Runtime captures include
a 24-frame walk/tool/idle sequence. Gameplay, campaign and appearance tests
remain unchanged apart from renamed place strings. No Windows runtime is
available here; Godot 4.4.1 Linux is the tested runtime.

Final v0.5 validation: all 116 gameplay/campaign/appearance checks passed; rendered animation/frame-boundary checks passed; complete earned-resource progression passed; packaged boot passed.

## 0.7 playtest readiness
- Portraits compose the same character layers at bust scale, including the corrected moustache anchor.
- New maps retain 96x44 destructible cells. Twelve seeded caverns, correlated veins and finite gathering deposits augment the introductory gallery. Deep strata bias toward aether.
- Roots and sealed springs yield three provisions/water, disappear on extraction, and use ordinary terrain save persistence. No simulated liquid or terrain collapse.
- Character collision height now covers the visible head; dig enough headroom before entering low tunnels. Survey winch and recall remain available.
- Existing mines are preserved exactly; new generation applies to new games and newly generated claims.
- Validated eight geology seeds, campaign/system/appearance suites, full earned-resource progression, rendered animation and exported pack boot on Linux. Windows execution still requires the user's playtest.

## 0.7.1 creator layout fix
Dedicated bust renderer shares source parts but omits world limbs, tools, shadow and gait. Portrait shoulders and facial layers have explicit portrait anchors. Creator uses two option tabs with bounded content and a separate sprite preview. Appearance/save checks, both-tab layout checks, male/female rendered inspection and exported Linux boot passed.

## 0.7.2 character audit
Rendered 24 portrait/sprite pairs covering six male hair styles, six beards, six female hair styles and six outfit/marking/accessory combinations. Shared face-space helpers prevent separate portrait/world anchor drift. Corrected the braided goatee composition, earring anchor, tattoo patterns and pendant parity. Female identity regression checks include 100 random profiles, legacy player/NPC save normalization and rendered equality across every female hair style with all six forced beard values.

## 0.7.3 visual correction
The 0.7.2 coordinate audit was insufficient: faces and overlays had different camera angles, and the separate neck/collar join looked detached. Rebuilt connected bases and aligned near-frontal overlays address the artwork itself. Verified clean-shaven and bald variants, every hair and beard option, outfit combinations, world proportions, and rendered walking/tool frames. Female identity rendered regression, appearance/save and creator-layout checks passed. New source assets and prompts are included.


## 0.8.0 — Audio, interiors, and tactile mining
Original score/foley generator: dev/compose_audio.py (numpy/scipy; not needed to play).
Runtime mixer: Music, Ambience, Effects buses; all three levels persist separately from master volume.
Room coordinates remain transient: save_game records the exterior doorway, avoiding invalid interior loads in older saves.
Six room IDs route back to the existing service panels and economy. Commission delivery recognizes Ingrid's interior office.
Tool contact is at 55% of each tool's duration, with a 45–65 ms contact hold. Intervening solid cells invalidate a queued impact.
Break drops scatter for 260 ms, then attract; saves/travel flush them exactly once. Small particles bounce against solid terrain.
Illustrated room atlas metadata fits actual source floor lines. Interior character magnification makes the closer room view readable.
Automated checks cover interior entry/interactions/exit, persistence, dialogue acceptance, audio resource loading and loops, impact occlusion, crack persistence, and both normal and save-time resource collection. Full progression remains reachable.

Release verification: source campaign 43 checks; systems 46; sound/spaces/mining 66; creator layout passed; full economy progression completed. The exported PCK loads all 50 audio streams and independently passes the same 66 integration checks. Mining motion capture breaks two blocks and collects all drops. Loop-boundary and no-clipping checks passed. No subjective audio listening or Windows execution was available.

## 0.10.0 visual implementation

The approved mockup is implemented using original illustrated gameplay parts, independent from portrait artwork. Sprite sheets now contain four rows of eight 160x128 cells; a shared foot anchor, overlapping joints and fixed face coordinates keep anatomy connected. Head and beard style remain separate; clothing, hair/beard and skin palette choices persist. Female rendering never selects beard overlays. Work-hand anchors drive the visible tool, and all actors flip their complete composed frame consistently.

Continuous stone artwork is sampled across fine terrain cells, with outlines only at exposed contours. New worlds use folded, winding mineral bands; saved worlds keep their excavations and deposits. Disturbed earth and released water retain the prior granular behavior. Original carved doorway, timber supports, lanterns and cavern backdrop replace the simple mining-entry shapes. Collision clearance is 34x72 world pixels for the broader actors. The portraits and existing interior background artwork remain unchanged.

Validation includes rendered animation distinctness and transparent frame borders; graphical female identity regressions; generation over eight seeds; fine excavation/material conservation; legacy migration; broad-body traversal; opening/campaign and production systems; audio/room transitions; and packaged boot/resource checks. Tests are executed on Linux with Godot 4.4.1. The included Windows runtime launcher is not executed here. No claim is made of a complete new end-to-end economy playthrough.

## 0.11.0 — Complete-frame characters and continuous terrain

The v0.10 parts rig did not meet the approved reference. v0.11 replaces its anatomy with original complete male/female sheets (eight walk/neutral and eight work poses each). Default hair/beard styles preserve the original complete artwork. Customized variants use separate complete bald/clean-shaven sheets plus hair-only and beard-only overlays. Per-frame eye/ear and foot landmarks align the layers. Source row gutters are excluded so neighboring boot pixels do not appear above heads. The cached atlas uses 192x128 cells and an (88,108) foot anchor; full-frame mirroring preserves facing direction. The tool shaft is separate and follows the per-gender grip at each work pose. The body is never assembled from a portrait or separate limb pieces. The baseline appearance button preserves given/family names and gender.

Terrain samples an original fine slate texture in continuous world space. Deterministic mineral flecks, root fibers, earth color mapping and edge shading are baked into a cached texture. Dirty cells repaint adjoining exposed faces after destruction or material motion. Surface reflections animate only above exposed water. The seven-pixel grid, world generation, collisions, resource conservation and save format are unchanged in this revision.

Source verification: eight walk/work poses, four distinct idle samples, transparent animation borders, female rendering identity, creator layout and baseline identity preservation, 36 granular checks, 43 campaign checks, 175 systems checks, 27 appearance checks, dynasty checks and 66 sound/spaces checks. Actual mining capture breaks 25 grains and collects all drops. Unchanged portrait source/art hashes verified. Final package checks are recorded below. Windows execution and a new complete end-to-end economy playthrough are not claimed.

Final package verification: exported PCK boot passed and loaded all 50 audio streams. The packaged game independently passed 36 granular checks with zero failures.

## 0.12.0 — Environment and grip/contact pass

World style fields and region address metadata are in world_style.gd and geology.gd. Terrain visual cache is split into visible 32-cell sections with adjacent-face invalidation; the simulation grid is unchanged. Existing saves restore their cells without regeneration. Current and planned large-world behavior is documented in GALACTIC-ENVIRONMENT.md.

Tool art uses source-space grip and striking-surface landmarks, mirrored transforms, a short shovel gesture and original foreground finger pixels layered above the handle. Nominal swing reach is consistent per tool; contact correction fits the grip-to-target distance uniformly (this is not a full skeletal arm/hand IK system). Tree swings lock to the chosen trunk. Source checks cover contact mapping in both directions, actual animation frame bounds, opening progression, fine digging, audio/space transitions and render-cache behavior.

Release checks: 10 environment/cache checks; 24 tool contact poses; animation frame separation and distinctness; 43 campaign checks; 66 sound/spaces/mining checks; 36 granular checks. Exported package boots, loads all 50 audio streams, and independently passes 36 granular checks. Actual tool/contact close-ups and mining captures are included. Windows execution remains untested; no full galactic streaming or complete new economy playthrough is claimed.

## 0.13.0 — Mountain approach, character refinement, readability

Keldrath, a 2,000-unit outdoor approach, and the hold mine share contiguous display coordinates. Simulation coordinates shift at the two boundaries while retaining player screen position, velocity, and facing. Adjacent scenery draws before the crossing; no fade/card or door effect runs. The trail descends 18 units into the starter gallery. Only the existing left bedrock border at gallery height is opened, including migrated saves. Mining generation, fine cells, damage, ore deposits, and resource balances are unchanged. Travel to independent claims remains menu based.

Idle atlas frames are stable, avoiding nearest-neighbor breathing shimmer. Visitors walk at 30 units/second for four seconds and pause for eight, with slower gait playback. Beard roots are fitted individually; four new long styles have distinct portrait and right-facing gameplay overlays. Existing beard IDs are stable; female facial hair is normalized away. Creator clothing controls are removed, with old saved colors retained. Actual equippable outfits remain future work.

Body text uses the engine's readable UI font; runic lettering is retained for major titles. Panels have thin borders, muted dark fills, and larger control targets. Character preview labels no longer overlap buttons. The objective has a quiet opaque backing.

Verified: graphical creator layout for both genders; ten-style rendered beard board; stable idle and eight distinct walk/work frames; 27 appearance/save checks; bidirectional boundary and camera invariance tests; physical round-trip walking with collision enabled; trail save/load; NPC pauses and movement speed. Headless font metrics differ from graphical rendering, so layout assertions run with the graphics backend. Export/package checks recorded at release. Windows execution is not available here.

Release verification: 43 campaign checks and 36 granular-mining checks passed. The exported PCK booted successfully and loaded all 50 audio streams. The Windows runtime remains the original bundled Godot 4.4.1 executable; Windows execution itself was not tested.

## 0.13.1 — Foreman and population characterization

Ivar Deepmeasure replaces Ingrid throughout the office, host sprite, portrait, roster, employment briefing, commissions, notifications and help. Ivar is a grey-bearded veteran who values sound work, fair wages and bringing every miner home. Orla remains the established female freight broker. Unspecified procedural NPC gender now has an 85% male / 15% female default, reflecting the requested general ratio of eight or nine male-born dwarfs out of ten. Explicit player gender choices remain unrestricted.

Saved NPC cast version 2 migrates the old supervisor and regenerates only existing anonymous visitor profiles once. Other named NPCs, player appearance, dynasty, quests, inventory and worlds are preserved. Migration/seeded-population checks pass, including a female player's unchanged identity and dynasty. Historical asset prompts remain unchanged as provenance records.

### Next gameplay expansion — design direction, not implemented

Current implementation: three technology unlocks (tempered steel, precision forging, clockwork industry); physical resource drops; crafting; a first-crystal discovery bounty. No personal skill XP, equipment loot, health/combat, hostile actors or marriage simulation yet.

Develop personal skills through activity (prospecting, mining, smithing, exploration), separately from hold research (extraction, metallurgy, logistics, automation and later spacecraft). Favor new actions and specialization over compulsory percentage grinds. Findable equipment and relics should complement crafted gear: recover damaged items, repair or dismantle them, and use ordinary resources throughout progression. Persist unique find IDs and seeded discovery sites so reloads cannot reroll rewards.

Introduce danger beyond the safe starter gallery. Use visible fungal growth/spore warnings, territorial burrowing wildlife, and Goblin scavenger camps that leave tracks, scrap and torchlight. Encounters need readable animation, health, damage, retreat and recovery rules before combat is enabled. Noise or breaking into a sealed chamber can trigger an encounter; do not spawn unavoidable attacks directly on the player or turn every seam into a fight. Keep the first wage commissions safe and provide meaningful escape routes and preparation choices. Later marriage/family development should connect to the existing persistent first/family names and dynasty identity; it is not part of this patch.

## 0.14.0 — Combat, equipment, return routes and locating the Folk

Implemented stamina-free axe/shield combat, piston hammer, cartridge carbine, timed parry, dodge, finite seeded Goblin/beetle encounters and persistent salvage. Mail and rune armor recolor the existing garment masks on complete character drawings. Three existing technology unlocks remain; personal skill XP and marriage are future work.

V opens construction: stairs, platforms, ladders and timber roof supports. W/S climbs nearby placed ladders; unrestricted ascent is removed. Supports catch existing loose-earth simulation, not an arbitrary random collapse timer or a complete hard-rock stress model. R requests confirmed rescue at max(25 crowns, ceil(20% cash)); defeat charges the same fee. Unpaid balance is deducted from future income. N opens the Folk roster with actual location tracking; appearance lists are removed.

Validation: 42 combat checks, 14 construction checks, 175 existing system checks and 36 granular checks passed. A rendered live parry/counter/kill sequence produced salvage without player damage. Visual audit covers all ten beard styles, male/female hair, armor and both facing directions. The audit caught static carry grips: weapon carry now uses foreground palm landmarks for each complete walk frame, firearm firing uses the existing extended arm pose, and original fingers are repainted over grips rather than drawing a detached synthetic hand.

The captures use controlled chambers for legible contact checks. Windows execution is not available here; exported PCK is boot-checked using Linux Godot 4.4.1.


## 0.15.0 — Pose-aware appearance and dedicated shield combat

`appearance_rig.gd` supplies jaw roots, bounded head rotation, six-strip flexible hair/beard rendering and per-pose foreground arm masks. The moustache attachment stays fixed while lower lengths lag. `sprite_atlas.gd` bakes the customized poses and keys caches by armor and combat pose. All styles use the same modular layers across locomotion and combat so legacy integrated art cannot change beard length during a state switch. This is authored runtime deformation and compositing, not a claim of individually painted replacement frames for every hair/beard combination.

`shield_actor.gd` renders a new complete eight-frame axe/shield sequence for each gender. The shield arm is part of the drawing; the near arm swings the axe one-handed. Idle carry uses per-frame palm anchors and matching equipment assets. Portrait rendering and serialized appearance choices are unchanged. All ten beard choices and six hairstyles per gender remain. Female facial hair remains prohibited.

42 combat checks and female identity checks passed. Controlled rendered boards cover 34 walk/work/equipment combinations and all 16 male beard/female hair shield configurations. Live parry/counter/kill produced salvage with no player damage. A capture harness emitted one teardown resource warning at immediate exit; gameplay and exported startup are checked separately.


## 0.15.1 — Equipped axe grip

Stationary axe users now retain the complete drawn axe-and-shield ready stance. Walking and other carried tools repaint the full visible fist over the handle, replacing the small palm-only overlap. Checked male/female idle and all eight walking frames in both directions.
