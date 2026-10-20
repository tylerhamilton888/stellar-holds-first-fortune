# Travel across scales

The player should inhabit a world with places in it. Regional movement has real
coordinates, continuous controls, terrain obstacles, a following camera and
entrances. A survey is another view of that world, not a replacement for it.

## Present implementation

Keldrath Basin has authored roads and seven named local destinations. Mountain,
forest and landmark sprites are independent reusable art. Seeded dressing avoids
roads; collision uses riverbanks and object footprints. The ground artwork does
not determine where the player can walk. Travel saves a versioned address and
regional position in the active fortune. Local terrain snapshots are retained
when changing scale. Opening a survey underground cannot bypass returning home.

## Reusable contract

Every navigable scale needs an address, a position, destination IDs and persistent
changes. Local mining uses a terrain controller; regional walking uses a planar
controller. A future ship layer should use its own velocity, acceleration and
camera, while retaining the same location identity and save boundary concepts.

Galaxy -> star system -> planet -> region -> local excavation.

These are intended address levels, not five implemented simulations. The first
region currently supplies a galaxy seed, planet index, region coordinate and
version. Interstellar movement is not implemented.

## Next expansion

Generate elevation, watersheds, geological provinces and roads before assigning
settlements and resources. Give each destination a stable address. Persist sparse
changes to chunked terrain, including depletion, construction and ownership.
Derive the regional appearance from those changes: woodland thins, quarries grow,
haulage roads develop and stripped mountains lose their silhouettes. Do not
regenerate a place when the player returns or merely changes viewing scale.

Current scenery is an illustration of regional geography; it is not yet a
destructible top-down terrain layer. Local mines remain the excavation authority.
Planet stripping and Dwarven Worldforging require the later chunked simulation.
