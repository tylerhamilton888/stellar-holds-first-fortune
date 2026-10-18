# Build 0.49.0 — Hands of the Dwarf
Checkpoint `hands-0.49.0`.

## Hands of the Dwarf: first playable stage — 0.49.0
Player-built stonebreakers, sawbenches, stone/log stockpiles, processed-material pallets and handcarts are integrated into the existing game. Shift+B opens the workshop board; J links its practical checklist. Crafting spends real pack materials only after valid local placement. Homes, claim grounds, Pinewood and clear Deepworks floors accept equipment. Doors, stairs, other facilities and authored town buildings remain protected. House floor recovery checks the new facilities at their own Z.

Some ordinary stone tiles deterministically release a persistent raw chunk instead of bucket stone. The actual felling stroke and subsequent trunk cuts in Pinewood release raw logs instead of duplicate pack timber. Other small yields and existing automation remain as before. Each raw record has one owner and retains its ID, kind, source and explicit yield: ground → shoulders → rack/cart → reserved station input → output. E lifts/deposits; Q drops; Shift+E withdraws. One substantial load initially; eight productive forestry/masonry credits unlock two shoulders. Handling/deposit loops award no experience.

Hold E at a supplied stonebreaker or sawbench for three 0.42-second work strokes. Input can come from shoulders, the bench or a compatible local rack/cart within 150 world units and a clear route. Mid-job input and progress save safely. Stonebreaking has cracks/hammer contact, timber processing a reciprocating saw, with sound at the contact phase. Output remains in a local buffer or nearby pallet until collected into the existing inventory. Processed stone was used in a real house floor during native testing. No stamina or new intermediate-resource tax.

Raw racks show one object per stored load and carts show their load; processed pallets build up in bundles. Stockpiles have typed input limits (12 large loads); handcarts carry 8. E can gather nearby loose items into a cart in a batch and unload compatible cart cargo to a nearby rack. C pushes/parks. Carts stay in their local zone/depth on travel; shoulders travel with the Dwarf. Existing mine wheelbarrows and their stair navigation are retained separately. This first-stage general handcart does not yet travel through zone portals or Z links.

Visual continuity is explicit: one raw_sprite renderer draws the SAME rock or log texture at the SAME scale on the ground, shoulders, rack, cart and workstation. Station bases are empty artwork; actual input is overlaid only when present. The fallen trunk shares the timber illustration. Hotbar labels distinguish carrying, pushing and working; conflicting local prompts quiet during labor. Original generated atlas and exact prompts are in assets/handworks-v49.

This is a coherent A–C milestone, not completion of the full attached brief. Deferred: optional precision smithing/quality grades; complete Miner/Mason/Forester/Smith progression trees and blueprint unlocks; raw ore/geode/specimen processing; new station operation by workers; generic cart portal/Z navigation; craftable standalone forge/furnace blueprints. Existing forge, masonry bench, research, worker production, hauling and automation remain functional. Do not mark deferred work complete.

# Build 0.48.0 — Clear tools, consistent Dwarfs
Updated 2026-10-18 UTC. Checkpoint `readability-0.48.0`.

## Readability and animation consistency — 0.48.0
Ten visual slots use keyboard 1–0 or mouse selection. 1–4 select pick, shovel, axe and hammer; 5 is the existing unlock-gated slagcaster. Slots 6–0 pin carried supplies, reassigned beside resources in I → Pack. Icons, live quantities, empty/locked states, a gold selection border and a Holding label show current equipment. Supplies remain references to pack inventory: no duplication, remote chest access or new consumption mechanics. Materials are used through existing workstations/trading/storage. Assignments and selection persist additively under surface.hotbar. Selecting a supply stops tool work; selecting a tool cancels stale pending work. Menus suppress hotkeys; clicking the bar does not mine/build behind it. The bar moves above the player near the lower screen and avoids the depth readout. The redundant text resource strip is hidden.

A single rig now renders the original 0.47 directional artwork for all eight movement directions, player mining/chopping/construction/carrying, and surface/underground Folk. Sideways movement uses the matching three-quarter view instead of switching to a legacy silhouette. Segmented arms and boots animate anticipation, contact/recovery and grounded stepping; tools attach to the same rig's palm, while existing world contact and production clocks remain authoritative. Idle equipped tools and selected supplies are visible on the character. Five male/female sculpts and palette customization are retained. No new borrowed game assets. The authored throne, story slides and separate practice-bay combat remain specialized art paths; this release does not claim a top-down combat rewrite or fully hand-drawn per-direction frame atlases.

Native verification: dedicated hotbar/save/input/held-mining run, surface regression 35, Deepworks 45, masonry 25 and campaign 43 checks; see testing/readability-0.48.0.md. Full Windows launcher execution and subjective audio remain human checks. Prior releases and the verified pre-readability-0.48.0 checkpoint remain recoverable.

# 0.47.0 — Build upward from your own hearth

## Hearthcraft and directional Dwarfs — 0.47.0
Freeform building is integrated into the existing claim yard via O → Build a house. Paint stone/oak foundations, walls, windows, operable doors and roofs; furnish with beds, tables, lamps and local chests. Costs come from the carried pack. Hold LMB builds without repeated charges on an existing tile. Recovery returns paid materials, with contents, occupancy, route and support checks.

Houses have real persistent Z-levels. A roof creates a corresponding walkable roof-floor one level above; stairs and ladders connect matching XY landings. E climbs, Shift+E descends. Upper construction requires supporting tiles beneath it. Z0–Z4 are building storeys and Z5 is the accessible top roof deck. Upper edges prevent walking into unsupported air. Current Z, every level's cells, doors, links and level-specific furniture/chest contents survive reload. Removing occupied/supporting floors or the access to an established upper storey is refused. Clear an upper storey before recovering its passage. Roofs fade from below, and lower-level floor context remains visible from above.

Keldrath's three existing walkable wards are explicitly labeled by elevation: Hearthward Z0, Crownward Z+1, Forgeward Z-1, with their existing connected stairs, lift, interiors and NPC quests. These are authored protected city zones, not player-demolishable house grids. Navigation wording now uses the actual gates/trails; the journal includes a practical house-building lesson that credits construction, shelter, ascent and return. Existing mine depths remain independent geological areas entered through their established mine mouths; there is no arbitrary basement-to-mine teleport.

Forty original view drawings cover front, rear and diagonal views across all five male and five female sculpts. Mirrored diagonals and the retained original side views give eight-direction locomotion. New views use a procedural grounded gait with boot lifts/body motion, not newly hand-drawn full walk-frame sequences. Hair/cloth/skin palette choices and sculpt identity remain in the profile. Existing side-view contact, carrying, smithing and combat frames remain for those specialized actions. Original new stone/oak/slate textures and a carved bed extend the existing style.

The starter cottage and all previous progression remain. Building data is additive under surface.homes[claim].building; prior furniture defaults to Z0. No new stamina, production chain, remote storage spending or automatic demolition. The sparring practice bay retains its older mechanics.

# 0.46.0 — A home beside the claim

## Walkable world and homestead — 0.46.0
The same character now walks freely through Hearthward, Crownward, Forgeward, the High Trail, Pinewood, the claim yard and building interiors. Doors, stair landings and the hold lift connect local areas. G gives directions instead of swapping to a world-map avatar. Normal settlement/trail movement is eight-directional with collision and footsteps; the separate practice bay retains its existing sparring mechanics.

Claim ownership supplies a small cottage, bed and one local storage chest. I shows carried supplies; E at a chest transfers actual quantities, and remote crafting/selling cannot spend stored items. O at home opens a short practical checklist, a cottage improvement and placement of chests, tables and lamps. Clear paths around entrances are protected. Empty chests and placed decorations can be recovered. Existing mine buckets, carts, stockpiles, rooms, masonry and workers retain their separate ownership rules.

Original customizable Dwarf animation frames are retained at a consistent scale, with shadows and foreground ordering; eight-direction locomotion currently uses the existing left/right-facing artwork. Original painted rooms, throne hall and transparent props extend the oak/slate/teal visual style. The Lord remains visibly seated on his throne. Pinewood uses its original tree/log art and yields, now with top-down axe targeting. Quiet contextual prompts replace map instructions; existing quest objectives lead through actual doors and stairs.

Additive state.surface saves area/return area, local positions, homes, chest contents, decorations and introduction facts. Pre-homestead saves are copied to a timestamped .pre-homestead-*.bak file before migration; backup failure stops loading. Inventory, claims, research, mines and all earlier progression remain. This is a starter homestead and furnishing system, not unrestricted house construction or a full directional sprite redraw.

## 0.45.1 — Masonry visual pass
Compact original mason’s mallet replaces the full mining hammer at the bench. Its raised pose stays beside the face, the striking face meets the chisel cap at the material-contact phase, and worker sound/chips follow the saved job clock. Duplicate worker chisel rendering is removed. The bench has a bevelled slab, braced timber legs and iron fixings; partial dressing now reads the correct bench cell before the drawing offset. Existing menus remain bounded with fixed tabs and scrolling.
Human checks remaining: Windows launcher, audible impact balance and subjective animation feel.

## 0.45.0 — A sound block, a lasting floor
Integrated rough-block quarrying, physical stockpile/bench conversion, dressed-floor construction and Brann's practical lesson. Existing miners can take over fetching, dressing and returning stone through real routes; carried job materials survive reload/release. Original procedural chiseling/carrying/bench animation and new material/finish visuals. No stamina or mandatory recipe rewrite. Fix residual construction swing cancellation and refreshed Living Works menu bounds.

## 0.44.0 — Routes and stories worth keeping
Real ladder shafts and cart-ready stairs, safe upgrades and round-trip quest proof; below-layer survey lesson with legacy credit retained. Enthroned Lord Eirik. Six expressive anniversary plates and matching tea station. Material-specific successful construction feedback with actual room-quality gains. Save-compatible, no recipe or stamina rewrite.

## 0.43.1 — Visual and menu polish
Pinned Living Works tabs, complete furniture catalog, grouped research, concise current help, quieter mine HUD and planning-only room markings. Warmer lanterns and original floor/furniture details. Existing economy/saves unchanged.

## 0.43.0 — The Living Works
Functional workshops/bedrooms, nine furnishings, seven finishes, three research capabilities, physical crew occupancy, capped room benefits, persistent preferences and Brann carving opportunity. Fracture hammer and selective extraction extend existing mining. Additive save compatibility and focused native tests.

# Changelog
Historical detail remains in DEVELOPMENT.md and versioned reviews. This is the concise current record.

| Build/checkpoint | Date | Change / compatibility |
|---|---|---|
| 0.38.1 | 2026-10-17 session record | Overhead mining, opaque cave background, dialogue/quest layout, removal of Royal Stair office shortcut; legacy throne return repaired. |
| 0.38.2 | 2026-10-17 | Removed repeated edge strips; room artwork fills width with floor anchor preserved. |
| 0.39.0 | 2026-10-17 | Persistent mineral bearings, mineral selection, paused notebook, deterministic bonus sifting with mountain-local saved progress. Existing save schema retained. |
| 0.39.1 | 2026-10-17 | Lower downward contact pose and footing-aware targeting; Shift retains precise cuts. Existing saves supported by unchanged schema. |
| continuity-1 | 2026-10-17 | Documentation, isolated smoke runner, Git baseline/checkpoint and portable recovery. Gameplay version stays 0.39.1. No runtime scripts, assets, scenes, settings or save format changed. |

| 0.40.0 / pinewood-0.40.0 | 2026-10-18 UTC | Pinewood forest art and seven firs; two-stage timber recovery, grounded reach/aim checks, progress and saved logs; useful field board and map travel. Existing five tree-cut values retained, two new trees added. Additive forestry save field; schema remains 1. |

| 0.41.0 / deepworks-0.41.0 | 2026-10-18 UTC | Integrated top-down, five-layer excavation; same-XY stairs, below-layer survey, connected veins/caverns, discoveries, lamps, physical multilevel crew and existing economy/slagcaster. Additive saves and mandatory legacy backup; old terrain/structures archived. Pinewood retained. |

| 0.42.0 / weight-0.42.0 | 2026-10-18 UTC | Physical fracture/breakup, conserved bucket/cart/pile transfers, actual movable wheelbarrow, graded ores and new iron lenses, existing-cost project ledger. Additive cargo saves; preexisting inventory/terrain unchanged. Crews retain delivery advantage. Rails deferred. |
