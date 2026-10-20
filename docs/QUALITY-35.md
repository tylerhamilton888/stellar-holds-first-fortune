# Visual and presence corrections, 0.35

The previous locomotion renderer sliced an idle body at the hips and rotated separate boot pieces. It caused open knees and displaced feet. Playback now selects complete 112x112 frame textures from assets/walk-v35. Eight frames per gender/sculpt and equipment mode produce 160 finished drawings. Feet use root (56,104); a one-pixel down phase supplies weight without stretching anatomy. Pose-specific equipment sockets are retained in sockets.json. Jump presentation uses a complete raised-foot pose, never split legs.

Source production: a new eight-pose painted lower-body sheet was generated with the built-in image tool using the original male/female sprite sheets as references. It lives in tools/quality35/source-legs.png. bake_walk.gd packs these with original upper-body drawings, stabilizes eye landmarks, retains hands, hair and equipment, and removes gutter flecks. No runtime leg assembly remains. Original upper-body identity is retained for each sculpt. New masks are carried through the same placement as their pixels.

Generation prompt summary: eight equal cells, four columns by two rows, connected dwarf hips/thighs/knees/boots, navy trousers, brown boots, transparent ground, right-facing contact/down/passing/rising phases for both steps. Source generation exec-da32c47f-a1f6-427c-85d7-74d54ca2705c.png. This asset is original; no external asset packs used.

Opening art: assets/opening-v35/arrival.webp, original built-in generation exec-02712d46-ef3e-44e0-be61-7373a254be92.png. Prompt requested three sequential panoramic panels matching existing Keldrath architecture: road with travel pack and wrapped pick; paired king statues and gate; interior concourse with steward's ledger. No fixed protagonist is painted into these panels, preserving customization. Stable camera, manual progression and fade-in transitions replace the former crawl.

Hair: palette-v35 starts from the authored v33 masks and adds adjacent pale/gold boundary pigment, plus explicit sideburn/beard-root corrections. Cloth and fittings are excluded from generic fringe expansion. Runtime never guesses materials. Orla's authored palette is keyed separately in portrait, sprite, shield and atlas caches.

Presence: HoldNpcPresence is the single home-room registry. Named residents are drawn only in that room at the hold. Main concourse and overview show entrance markers, not duplicate bodies. The registry can later select a scheduled destination; do not add a second rendering branch for another location. Available Kettle crew use one ordered roster for both drawing and proximity interaction. Outdoor visitors remain on their current paths.

## Western threshold

The western concourse is closed by a carved stone stair gallery, generated against the existing hall art. It is rooted at the same floor baseline and connects to the concourse node of the hold plan. Travel remembers this entrance so the return does not teleport to a different end of the street. Quarters moved east to leave clearance. The gallery image uses a cropped transparent bounding rectangle; the walk boundary lies inside its solid left wall. Verified in an actual rendered scene and three enter/return assertions.
