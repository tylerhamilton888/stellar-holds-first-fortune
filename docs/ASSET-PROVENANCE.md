# Asset provenance

Every game-specific visual and sound in this project was newly authored or generated for
The Stellar Holds during this build. No marketplace packs, stock art, stock
audio, ripped sprites, borrowed game animations, or third-party fonts were used.

| Material | Source / method |
|---|---|
| Dwarfs, female merchant, miner, automaton | Original geometric pixel silhouettes and layered drawing routines in `scripts/art.gd` |
| Walking, breathing, work and tool animation | Original time-based transforms in `art.gd` and `main.gd`; pick head interpolates to the hit surface |
| Architecture, lamps, foliage, machinery, ship | Hand-authored primitives, palettes, layouts and runic motif in `art.gd` / `main.gd` |
| Terrain | Seeded layered geology and connected vein walks in `geology.gd`; original surface marks in `art.gd` |
| UI and icons | Original Godot theme, framed panels and tool silhouettes in `main.gd`; icon.svg authored for this project |
| Hold Runic typeface | Original 5x7 character matrices in `assets/create_assets.py`, compiled into a TrueType font with fontTools |
| Seven impact / interaction effects | Original deterministic synthesis in `assets/create_assets.py`; tones, noise and exponential envelopes |
| Hold at Dusk music | Original 32-note modal motif with synthesized struck tones and drones; same generator |
| Screenshots | Captured from the running Godot game, not concept illustrations |

The runtime uses Godot's normal UI controls and rendering primitives. The
bundled engine and its libraries are third-party software, not game assets.
Their notices are included. The optional font-generation tool is not bundled
or required at runtime; fontTools itself is an open-source development tool.

No third-party voice recordings are used. There is no generative AI service
or network dependency in the game. Source code and assets are editable and
packaged locally.


## Version 0.2 additions

`assets/characters/portrait-bases.png` was generated with the built-in image
generation tool specifically for this project: one male and one female bald,
clean-shaven original dwarf portrait base on a transparent atlas. The original
output is preserved unchanged. In v0.2 the compositor sampled each half and applied
skin-color mapping; all hair, beard, clothing, tattoos and jewelry are reusable
code-authored pixel layers in `scripts/portrait.gd`. This avoids making unique
portrait images for each NPC. World sprites are authored in
`scripts/character_art.gd`; both renderers read `scripts/appearance.gd`.

The base image prompt is recorded in `PORTRAIT-PROMPT.txt`. No existing game
characters or borrowed sprites were used. The work draws on the broad visual
language of cozy pixel-art RPG portraits and original Norse/Celtic motifs.

## Version 0.3 coherence pass

The live portraits now use fully code-authored faces in `portrait.gd`, with
four warm skin tones, compact pixel features and common outlines. The v0.2
generated atlas and its shader remain as historical source assets but are
excluded from the playable pack. Hair, clothing and faces now share the same
96-pixel construction canvas. Braids use overlapping tapered locks, and world
sprites use broader, shorter proportions.

Visual references consulted (not included or copied into the game):
- Stardew Valley media: https://www.stardewvalley.net/media/
- Dwarf Fortress developer post, Representing dwarves graphically:
  https://steamcommunity.com/games/975370/announcements/detail/2891832587105130224

Reference lessons: compact color clusters, restrained shading, readable
hair silhouettes, sturdy dwarf proportions. All shipped character shapes
remain original to this project.

## Version 0.4 mountain scenery

Three new original raster panoramas were generated specifically for this
project using the built-in image-generation tool (no external asset packs):

- `assets/scenery/keldrath-hall.png`: monumental interior, carved kings,
  bronze freight machinery and aether conduits.
- `assets/scenery/king-road-valley.png`: the gate, alpine valley, deep strata,
  distant ridges and engineered viaducts.
- `assets/scenery/independent-ridge.png`: remote claim cliff and old entrance,
  forested ravine, distant home hold and snow peaks.

All three output images are included unchanged. Runtime drawing scales and
pans them behind the foreground. Prompt specifications are recorded in
`SCENERY-PROMPTS.md`. Interactive foreground geometry, firs and machinery
are original code in `scripts/scenery.gd`. No third-party game artwork is
contained in the build. Godot engine/license notices remain unchanged.

## Version 0.5 additions

`assets/scenery/foreground-workshops.png` and
`assets/scenery/pithead-beacon.png` are original built-in image-generation
outputs made specifically for this project, with transparent alpha. Source
images are preserved unchanged; the renderer selects regions and draws them
at gameplay scale. An original image-tool edit, `foreground-workshops-cold.png`, supplies the
unlit forge state until the coal commission is delivered.

`docs/FOREGROUND-PROMPTS.md` records the complete prompts. Character sheets
are rendered from the original modular code, not borrowed or generated from
an existing game's sprites. The sheets in docs/screenshots are runtime
examples; custom appearances generate their own matching sheets on demand.

## Version 0.6 illustrated characters and items
Three original generated RGBA atlases in assets/character-parts provide reusable body, hair/beard, and item layers. Original outputs are preserved unchanged. Prompts are recorded in v06_*_prompt.txt. Runtime cloth recoloring preserves leather and metal; saved appearance values control all character layers. Character poses are baked into 32-frame sheets; tools, loot, cargo, and inventory/market icons share item regions. Portraits retain their existing renderer and shared appearance settings.

## Version 0.7
The portrait renderer now shares character_art.gd and the exact original body/hair assets with world sprites. No independent portrait faces remain active. terrain.png is a newly generated original rock material atlas; the source is preserved unchanged. Runtime region sampling provides rock faces; roots/spring accents and impact cracks are code-authored. The prompt is in v07_terrain_prompt.txt.

## Version 0.7.3 anatomical and perspective correction
Two original built-in image-generation outputs replace the mismatched facial layers: connected-bases.png contains anatomically joined male/female head-neck-shoulder bases; frontal-hair.png contains near-frontal hair and beards fitted to these faces. Original PNG outputs are retained unchanged in assets/character-parts. Prompts are recorded in v073_base_prompt.txt and v073_hair_prompt.txt. Runtime palette mapping, layer placement and limb animation are code-authored. The earlier disconnected head and torso pieces are no longer assembled for active portraits or character bodies. Original arm, boot and shoulder armor parts remain in use.


## 0.8 audio and interior assets
- dev/compose_audio.py authors three 64-second scores (Mountain Oath, Beneath the Roots, Hearth and Hammer), six seamless environment beds, and layered foley from deterministic mathematical synthesis. No samples or third-party recordings.
- assets/scenery/interiors-hearths.png and interiors-workrooms.png: original generated three-room atlases, created specifically for this build with the built-in image-generation tool. interiors-hearths-cold.png is an original edit preserving the room geometry while extinguishing the forge and machinery. Full prompts: docs/INTERIOR-PROMPTS.md.
- scripts/interiors.gd fits atlas regions to walkable floor coordinates and animates light/embers. Characters retain their existing original appearance sheets.

## 0.10.0 — approved visual direction implemented

Three original production atlases were generated with the built-in image-generation tool for this game, using the user-approved right-hand mockup as the visual reference:

- `assets/actors-v10/rig.png`: six outfit torsos, articulated limb/boot parts, satchel, pick and accessories.
- `assets/actors-v10/heads.png`: six male hairstyles, six female hairstyles, five beard overlays. These are gameplay sprite heads, independent of the unchanged dialogue portraits.
- `assets/actors-v10/mine.png`: continuous stone/earth textures, cavern backdrop, carved king doorway, riveted timber arch and lantern.

Prompts requested broad, stocky original dwarf pixel-art anatomy; warm leather/copper and teal clothing; isolated transparent rig parts with matching right-facing heads; large coherent slate strata, restrained sci-fi runes, and sparse texture noise. No borrowed game assets were used. Original atlases remain unmodified; the Godot renderer selects regions, substitutes appearance palettes and assembles eight-frame sequences. The runtime renders those sequences into bounded sprite-sheet caches. Terrain samples stone in continuous world coordinates and adds procedural mineral lodes; digging remains a seven-pixel cellular simulation.

## 0.11.0 — Whole-frame source artwork

Built-in image generation created original assets in assets/actors-v11, using the user-approved mockup's bottom-right dwarf as a visual reference. male.png and female.png contain sixteen complete body poses each, with tools removed so the selected tool can follow a live mining target. male-base.png and female-base.png are complete bald/clean-shaven alternatives for customization. hair.png contains isolated male/female hairstyles and beard overlays, with no facial skin or portrait heads. slate.png is an original dense fine slate material, replacing the earlier large-stone sampling. These original PNG outputs are preserved unchanged; Godot performs crop selection, nearest-neighbor gameplay scaling, palette changes and layer placement.

Character generation brief: broad stocky dwarf with golden swept hair and beard, teal short-sleeved tunic, muscular bare forearms, leather belt/satchel, charcoal trousers, planted brown boots, cohesive cartoon pixel-art anatomy. Create eight neutral/walking and eight two-handed mining poses with consistent right-facing proportions. Female counterpart has feminine features and braided golden hair, no facial hair, matching outfit and body scale. Subsequent edits remove tools and provide bald/clean-shaven complete-body underlays. Hair atlas provides only hair and beards for fitted overlays. These are production briefs, not verbatim transcripts of every generation/edit call.

The complete slate prompt is recorded in v11_slate_prompt.txt. Existing portraits, backgrounds, tool art, and audio retain their earlier provenance. No reference-game assets are included.

## 0.12.0 — Procedural environment treatment

No new third-party or generated raster assets. Original v0.11 slate and v0.10 cavern artwork are reused. Seeded strata, palette variation, textured parallax silhouettes, dust, light shafts, crystal/root/chip details and chunk caching are original Godot code. Tool artwork uses the original item atlas and illustrated pick, with corrected grip/contact coordinates and foreground finger pixels drawn from the complete character frames.

## 0.13.0 — Beard overlays

Original generated transparent atlases: assets/actors-v13/beards.png (nine right-facing three-quarter gameplay overlays, 3x3 cells) and portrait-beards.png (four front-facing grand portrait overlays). Created with image generation using the existing original character hair atlas as style reference. No game artwork was copied. Prompt direction: chunky warm-gold dwarf beard locks with brass braid bands; standalone transparent overlays, no heads/bodies; classic/twin/forked/rounded/goatee and oath/twin-grand/king-mantle/triple-plait variants. Runtime crops, mouth-root anchors and palette conversion fit each image to its intended face. Portrait grand-beard luminance is tinted to the existing portrait palette.

## 0.14 combat additions

Original generated transparent bitmap sheets: `assets/combat-v14/enemies.png` (Goblin scavenger and armored cave beetle; four sequential readable idle/walk/windup/strike poses per creature) and `assets/combat-v14/weapons.png` (bearded axe, industrial piston hammer, brass/steel carbine, round dwarf shield). Generated for this project; no game screenshots or extracted commercial assets are included. Runtime uses explicit region, feet, hand and striking-surface landmarks. The existing portraits remain unchanged.

Two original procedurally synthesized PCM sound effects, `carbine.wav` and `parry.wav`, combine short noise transients with decaying tonal components. No external samples. The audio manifest contains 52 streams in this release.


## 0.15 original axe/shield art

Built-in image generation produced `assets/actors-v15/shield-combat.png` from the project's own male/female bald base references, and `assets/actors-v15/axe-shield.png` from that new combat sheet. Original complete one-handed poses and matching equipment; no commercial game assets. The final full prompts are saved in `SHIELD-ART-PROMPT.txt` and `SHIELD-EQUIPMENT-PROMPT.txt`. Transparency is retained. Rendering uses explicit crops and landmarks, recoloring, runtime deformation and occlusion; source PNGs remain unmodified.


### 0.25 sample mix adjustment
Existing edited user-supplied WAVs were filtered, not replaced with synthetic
substitutes. Pick: 240 Hz high-pass and -3 dB gain. Boots: 180 Hz high-pass and
-5 dB gain. Dirt: 150 Hz high-pass and -2 dB gain. Each uses a 400 Hz, Q 0.8,
-3 dB EQ cut and a tail fade from 0.18 to 0.28 seconds, capped at 0.30 seconds.
Original uploads remain unchanged. These are measured processing changes;
no claim of subjective listening approval is made.


### 0.26 original regional artwork
Built-in image generation created assets/overworld-v26/scenery.png and
assets/overworld-v26/meadow.png specifically for this project. No third-party
pack or game screenshot is included. Runtime atlas rectangles isolate objects;
terrain, collision and destinations are separate from the art.

Scenery prompt: an original transparent 4-column, 2-row atlas for a richly
painted pixel-art dwarf fantasy/science-fiction overworld, elevated top-down
view, warm upper-left sunlight, pine greens/slate rock/copper roofs/teal runes.
Eight isolated objects: snowcapped peak, grassy slate mountain, five-pine grove,
carved king-statue mountain hold, rustic mine, logging lodge, ruined watchtower,
caravan inn. No text, borders or characters. The full prompt is retained in
assets/overworld-v26/PROMPTS.md.

Meadow prompt: original seamless square alpine grass/moss ground texture,
fine pixel art, muted olive/sage/golden greens and gray-brown dirt flecks,
small wildflowers, overhead diffuse light, no roads/trees/buildings/UI/border.


### 0.27 bridge and supplies
Built-in image generation created assets/world-v27/details.png specifically for
this game. Prompt: original painted pixel-art Dwarven fantasy/science-fiction
sprite atlas; isolated low stone arch bridge with horizontal timber deck,
carved abutments, moss and amber rune lanterns; waystone/signpost; miner supply
cache with barrels, braces, cart, rope and lantern; turquoise open geode. Warm
upper-left light, slate/copper/amber palette, no text/UI/people, transparent
background. A second edit requested alpha-zero empty space while preserving
all four objects. Runtime source rectangles isolate the irregular atlas layout.
The geode illustration is reserved; playable geodes use actual terrain cells
and native crystal facets so extraction remains authoritative.

0.28: original rune-industrial bridge generated using the built-in image tool. Asset and prompt: assets/world-v28/bridge.png and PROMPTS.md.
