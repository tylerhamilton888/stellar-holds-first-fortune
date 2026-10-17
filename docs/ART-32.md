# Anniversary illustration and continuity

The images are original assets generated for this game with the built-in image
generation tool. No third-party game artwork was used. The reference was the
game's own canonical portrait/sprite sheet, followed by its approved couple atlas.
Generated PNG masters were converted to WebP without painting or recoloring the
generated art in a script. Character palette classification fixes are in the
portrait and sprite renderers, separate from these illustrations.

## Included assets

- `assets/story-v32/anniversary-poses.webp`: kettle presentation, table
  presentation and toast. Master: exec-26699ff0-50f8-47e7-b9d5-ecc19b08010f.png.
- `assets/story-v32/anniversary-reactions.webp`: shared-secret reaction,
  beard/steam reaction and affectionate admiration. Master:
  exec-12dad0de-d826-44ec-8144-9c2be14bb02f.png.

Earlier variants with an older-looking Hedrik, changing architecture, changing
table proportions or a gold hairline were rejected and are not runtime assets.

## Prompt specification

Base identity: youthful adult stocky dwarf couple, Hedrik left, chestnut high
knot and forked beard, chestnut eyebrows and hairline, red shirt, leather
suspenders with brass fittings; Orla right, copper crown braids, blue shirt,
matching practical suspenders. Polished painted cartoon art consistent with
the game's portrait references. Three equal rows of separate waist-up poses on
genuine transparency, without scenery or furniture. Base poses: empty-handed
kettle presentation with an open palm, Orla presenting her table with empty
hands, both holding bronze mugs for the toast. The final targeted edit removed
the inherited gold strip and eyebrows while preserving all poses and costumes.

Reaction prompt: use the approved base atlas as exact identity, clothing,
palette, scale and style reference; three rows with Hedrik left and Orla right.
Row 1: Orla turns to the player with amused mock accusation, raised eyebrow
and gentle pointing finger; Hedrik gives the player a grateful conspiratorial
grin. Row 2: Hedrik holds his beard back against his chest and leans slightly
away from the center with playful alarm; Orla laughs with a hand near her mouth.
Row 3: both smile affectionately at each other with hands near the waist.
Keep the middle clear for game-rendered props. No mugs, kettle, table, steam,
background or text; preserve chestnut hairline, costumes and facial identity.

## Beat-to-image alignment

| Dialogue beats (zero based) | Illustration | Props |
| --- | --- | --- |
| 0-2: Hedrik reveals his kettle | Kettle presentation | Kettle rests on his open palm. |
| 3-5: Orla reveals her table | Table presentation | The shared table asset appears; kettle is set aside. |
| 6-7: The gifts complement each other | Affectionate admiration | Same table. |
| 8-9: Both secrets and the player's help | Both look toward player | Same table. |
| 10: Perfect fit | Affectionate admiration | Kettle settles onto tabletop. |
| 11: Keep your beard out of the steam | Beard reaction and laughter | Kettle emits drifting steam. |
| 12-14: Anniversary, Brann's aside, invitation | Both hold mugs | Assembled gifts remain. |

Brann is labeled as speaking from the hall and shown in the speaker portrait.
The shared hall plate never changes. The table always uses the same 250 by 142
game-unit rectangle, and the kettle always uses 90 by 89 units. Only kettle
position changes between hand and tabletop. Dialogue is live UI text, never
baked into an illustration. No voiced lines or lip-sync are promised.

Expression changes, short fades, kettle placement and steam provide movement.
These are illustrated poses, not a fully animated character rig. Captures under
`docs/screenshots` show the actual runtime framing and dialogue layout.
