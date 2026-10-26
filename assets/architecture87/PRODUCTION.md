# Architecture collections — 0.77.0

Original generated modules for The Stellar Holds. Created with the built-in image-generation tool; transparent `collections.png` and opaque `floors.png` are copied unchanged into this project. Original building façades remain at their existing paths.

The three collections share measured source rectangles, 86px wall courses and consistent window spacing. The runtime crops partial tiles; it does not shrink a complete frontage into a narrow bay. Additional floors form a set-back upper block behind the complete original painting. Materials, roofs, trim and room finishes can be mixed independently. Original façades themselves remain intact.

The game applies muted tinting to floor materials and paints perimeter courses, coping and inlays. No generated UI, text or full room scene is used. Source selection and placement are in `scripts/architecture_styles.gd` and `scripts/building_art.gd`; menus reuse those renderers.

## Module prompt

Use case: stylized-concept. Asset type: production sprite atlas for a top-down illustrated Dwarven building game. Create ONE 1536x1024 transparent PNG sheet of exactly TWELVE separated architectural modules, arranged in a strict 4-column by 3-row grid, equal cells, generous 20px transparent gutters, no labels. All modules are painted, chunky readable stone and timber, warm amber windows, restrained engraved metal, subtle hand-painted texture, dark clean edges; original fantasy, charming adult proportions, not photoreal. Orthographic front elevations with only a small visible top bevel; no isometric rotation. Light from upper left. No cast shadows outside modules.
Each row is a compatible style:
ROW 1 Hearthstone: warm cream-grey chunky limestone blocks, honey oak, blue slate.
ROW 2 Forgehold: charcoal basalt blocks, riveted burnished copper, dark graphite slate.
ROW 3 Oathhall: pale grey cut granite, restrained aged gold knotwork and teal enamel, deep teal slate.
In EVERY ROW:
COLUMN 1: a perfectly rectangular square plain seamless masonry wall patch, staggered wide rectangular blocks, no borders no windows no ornaments, texture fills square edge to edge.
COLUMN 2: a square rectangular masonry wall bay with ONE centered upright warm amber arched window, broad chunky jambs, same wall block sizes as column 1. Window occupies central 45 percent width and 65 percent height, no roof, no ground, no perspective sides.
COLUMN 3: ONE narrow upright structural pilaster, 1:3 width:height, thick feet and cap, color appropriate to row; Hearthstone timber post with stone foot, Forgehold basalt post with copper bands, Oathhall carved stone post with restrained brass knotwork. Transparent around it.
COLUMN 4: a perfectly square seamless roof MATERIAL patch seen flat, overlapping broad slate tiles, no building, no border, no perspective edges. Top row muted blue slate, middle row dark graphite slate with restrained copper seams, bottom row deep teal slate.
These are actual game components to assemble at matching scale. Every square module occupies the same square size centered in its cell. Preserve clear separate alpha gutters so source rectangles can be sampled directly. No text, numbers, grass, characters, scenery, floor slabs or mockup UI.

## Floor prompt

Use case: stylized-concept. Asset type: seamless floor materials for an illustrated top-down Dwarven game. Produce one 1536x1024 opaque production texture atlas split into exactly THREE equal vertical columns, each column filling its 512x1024 area to every edge. No gutters, no labels, no scenery. Every column is a flat orthographic overhead surface with NO perspective, borders, frames, floor edges, cast shadows, objects, glow, or blank margins. Materials should repeat seamlessly within each column in both axes. Hand-painted chunky, warm illustrated fantasy stone/wood, readable beveled edges, subdued natural variation, restrained fine grain. No photoreal grit.
LEFT THIRD: warm honey-brown oak plank flooring, long horizontal boards in staggered rows, subtle knots and worn grain, small pegs, matte finish, cozy dwarf tavern.
MIDDLE THIRD: dark neutral charcoal-blue flagstone floor, broad dressed rectangular basalt slabs in staggered courses, modest worn edges and narrow mortar, occasional tiny copper repair staple, rugged dwarf workshop.
RIGHT THIRD: pale warm grey granite floor, broad square dressed blocks in staggered rows, smooth matte worn stone, subtle carved bevels, dignified dwarf royal hall. No gold lines, no patterns, no runes: the game adds border inlays separately.
Uniform stone/plank physical scale and directional top-left ambient shading across the three columns. Each column contains approximately 10 horizontal courses over its height. The image is only the three continuous floor materials, not a rendered room.
