# Hands of the Dwarf — original asset provenance

Generated with the built-in image generation tool for this project; no third-party game assets.

Initial atlas: `workshop.png` (exec-21ae5c36-ec71-40b0-8f01-c8122c3e85f4).
Production atlas: `workshop-empty.png` (exec-d5f2128d-7de2-4b5d-8314-7cce82b90ea1).

## Initial prompt
Original game sprite atlas for The Stellar Holds, charming robust Dwarven crafting world. A perfectly regular 3 columns by 3 rows grid, nine separate centered objects, generous transparent margins within every square cell. Orthographic elevated three-quarter top-down view, consistent 2D hand-painted cartoon illustration with dark crisp outlines, oak, iron, slate, copper fastenings and small carved Celtic motifs, readable chunky shapes. No text, no gridlines, no characters, no background. Row 1: a stout stonebreaker's bench with a large grey raw rock on its iron-braced stone slab; a Dwarven oak sawbench with a clamped log and large horizontal handsaw; an EMPTY low stone-storage corral of four stout corner posts and low timber rails. Row 2: an EMPTY low timber storage rack; an EMPTY processed-materials pallet with iron corner bands; a sturdy EMPTY one-wheel oak wheelbarrow, two handles projecting toward bottom of image. Row 3: one substantial jagged raw grey granite chunk; one bark-covered cut pine log lying diagonally with visible endgrain; three neatly dressed stone blocks stacked together. All nine isolated, matching lighting from upper left and same perspective. Truly transparent alpha everywhere between objects. Production game assets, charming meticulous details, no labels.

## Refinement prompt
Edit this original 3x3 sprite atlas minimally. ONLY change the first two objects in the TOP ROW: remove all rock and stone fragments from the stonebreaker's tabletop (top-left), leaving an EMPTY clean stone slab work surface with its same iron bands, tools and legs; remove the log AND the handsaw from the sawbench (top-middle), leaving the EMPTY wooden sawbench and its clamps and legs. Preserve all other seven sprites EXACTLY including the separate raw grey rock in bottom-left and raw log bottom-middle, preserve the precise 3x3 positions, object scale, perspective, outlines, wood/slate/iron palette. Transparent background and margins remain truly transparent. No new objects or labels. These benches will receive the separate raw-material sprites dynamically in the game, so no baked-in workpieces.

## Identity rule
`HoldHandworks.raw_sprite` draws one cached texture per material at the same 40-pixel width on the ground, shoulders, stockpiles, cart and active station. A raw record retains its ID, kind, units and source across transfers. The station image itself is empty. Completed output changes representation only when the recipe completes. The fallen source trunk uses the same timber illustration at its larger uncut size. Body animation reuses the established directional Dwarf rig.

Raw racks render all stored records (capacity 12), carts all 8; processed cargo builds up in bundles of 20 with exact numerical readouts.

0.49.2: explicit runtime atlas bounds correct cross-row bleed without editing original images. Mine face surfaces sample the canonical raw stone texture, with geological tints and saved-damage fractures. Old mine haulage bases share this atlas; processed cargo uses existing item art.
