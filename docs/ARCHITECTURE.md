# Architecture
## Runtime and conventions
Godot 4.4.1, GDScript, GL Compatibility. `project.godot` launches `main.tscn`, a Node2D attached to `scripts/main.gd`. Logical viewport 960×540, stretched to the window. There is no collection of independent level scenes or autoload-manager hierarchy: main owns state, input, movement, drawing and UI, with named helper classes and instantiated subsystems. Most UI is built programmatically. Preserve resource paths and `.uid`/`.import` sidecars.

## Module map
| Area | Source files under scripts/ |
|---|---|
| State, economy, progression | state.gd, data.gd, campaign.gd, industry.gd |
| Excavation and generation | geology.gd, mountain.gd, legacy_geology.gd, world_style.gd |
| Terrain rendering and discoveries | terrain_view.gd, world_details.gd, field_survey.gd |
| Construction and danger | construction.gd, combat.gd, practice.gd, mining_gun.gd |
| Crew and emerging stories | outpost.gd, outpost_ui.gd, frontier.gd, claim_stories.gd |
| Opening and quests | onboarding.gd, conversation.gd, culture.gd, anniversary.gd, quest_markers.gd |
| Locations and NPC presence | hold_map.gd, hold_floor.gd, region_map.gd, interiors.gd, npc_presence.gd, npc_activity.gd, royal_hall.gd |
| Character rendering | appearance.gd, character_designs.gd, character_art.gd, character_materials.gd, painted_walk.gd, sprite_atlas.gd, equipment_rig.gd, shield_actor.gd, portrait.gd |
| Presentation | art.gd, scenery.gd, sound.gd, opening_scene.gd, anniversary_scene.gd, cinematic.gd |

`assets/` retains versioned art, masks and rig data; `audio/` contains runtime sound. Do not consolidate historical art directories without checking every preload and export filter. `dev/` and `tools/` hold authoring utilities; `tests/` holds regressions and captures. Old documents and tests are historical evidence, not automatically current requirements.

## Data and generation
HoldState owns dictionary-based gameplay state. Save schema `version:1` is distinct from game version. Slot 1: `user://first_fortune_v1.json`; slots 2/3: `first_fortune_slot_2.json` / `_3.json`. JSON saves contain inventory, queue, research, appearance, quests/outpost, travel, per-site worlds, terrain cells/damage, grain bank, structures and mountain metadata (including surveys). Writes use a temporary file followed by rename. Audio settings also use `user://audio_settings.cfg`.

Loading accepts current 384×176 cells and legacy 96×44 grids, normalizes identities and state, and may regenerate mountains with metadata version below 2. Never promise every old save preserves excavation without checking this migration. Keep project name/user-data location unchanged. No real player save was supplied for this task.

Geology uses 7-pixel cells; HoldMountain generates seeded surface, overburden, strata, veins and caves. HoldWorldStyle version 2 hashes galaxy/planet/region/channel into deterministic seeds. This address system is scaffolding, not a complete galaxy. Excavation feeds inventory/grain accounting and dirty terrain rendering. Main drives actor collision, contact targeting and crew mining. Research/equipment affects extraction; outpost roles affect production and surveying.

## Safe changes
Read handoff/status, then relevant modules. Work from a clean checkpoint; preserve unknown fields and identifiers. Keep generation changes versioned. Test affected save/economy/terrain dependencies. Visually inspect art/contact/UI changes. Update status, backlog and changelog. See TESTING.md for commands and RECOVERY.md for backups.
