# Procedural environment foundation — 0.12.0

## Implemented now

The seven-pixel mining cells remain the authoritative terrain for collisions,
resources, persistent damage, falling earth and released water. Appearance is
computed separately from those cells and the saved region seed.

`HoldWorldStyle.address_seed(galaxy_seed, planet_id, region, channel)` gives a
repeatable seed without consuming global random state. `Geology.generate_region`
uses this address and saves the full address plus generator version with the
excavation. New games use planet 0, region (0,0), for Keldrath; newly generated
claims use their own region addresses. Existing saved cells are restored as-is.

Visual profiles vary among cool, warm and green-gray stone palettes. Broad
folded bedding and noise fields are evaluated in continuous region coordinates,
so texture and strata do not restart at render-section boundaries. Ore retains
its existing resource identity and procedural distribution. These are visual
profiles, not three fully implemented planet biomes with separate economies.

The foreground is rendered in 32x32-cell sections (224 world pixels). Only
visible sections are initially built. A changed cell invalidates its section
and the sections owning adjoining exposed faces. A bounded texture cache drops
distant sections; revisiting reconstructs them from the saved terrain and seed.
Generation and simulation still hold an entire bounded mine in memory.

Three seeded parallax layers place textured distant rock pillars behind the
excavation, with low-opacity light shafts and dust. Foreground crystal clusters,
root strands and small chips derive from material, exposure and seeded placement.
They disappear immediately when their supporting cell is removed. They are
visual details of that deposit, not extra resource-bearing objects or colliders.
The existing resource yield remains authoritative. Solid overhangs do not gain
structural collapse physics in this update.

## Scaling toward a galactic sandbox

1. Keep an explicit world address: galaxy / star system / planet / region.
   A seed is a reproducible recipe input, not a unique identity or saved world.
2. Generate planet-scale fields first: geology, temperature, moisture, elevation,
   tectonic direction and crust depth. Regions sample those continuous fields.
   Use global coordinates plus border samples so adjacent caves and veins agree.
   Current independently seeded bounded mines are NOT seamless neighboring regions.
3. Separate generation channels for terrain, minerals, ruins, ecology and cosmetic
   decoration. Adding a decorative fern must not rearrange a copper deposit.
4. Stream simulation chunks around active players and machines. Use asynchronous
   generation, rendering budgets, deterministic chunk ownership and boundary halos
   for water, falling material, connectivity and lighting. The current renderer's
   cache is a first step; full simulation streaming is not implemented.
5. Save the versioned generation recipe and sparse player changes (removed cells,
   damage, construction, moved material) rather than every untouched cell. Compact
   heavy edits into snapshots. Current saves still store complete bounded grids.
6. Preserve generator versions. Old regions must keep their terrain when the art
   or generator improves. Never silently rebuild an excavated mine from a new seed
   recipe. Migration should be explicit and tested against resource conservation.
7. Place rare landmarks using region-level rules and exclusion zones: buried king
   halls, machinery, underground aquifers, or faults. Give important discoveries
   gameplay meaning; keep distant background scenery visually subordinate.

Next milestone: demonstrate two adjacent streamed regions with continuous caves,
ore and fluids, edit across their boundary, unload/reload, and prove that neither
terrain nor resources duplicate. Add a second planet only after that works.

## Verification

Environment regression covers seed/channel repeatability, planet distinction,
region reproducibility, saved address restoration, lazy section creation,
cross-boundary invalidation, incremental/full-render equivalence, and cache bounds.
Existing granular and campaign tests cover digging, conservation, migration,
claims and the opening progression. Rendered captures show the actual game.
