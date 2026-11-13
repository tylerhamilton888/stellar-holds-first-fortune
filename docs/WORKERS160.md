# Crew berths and connected household routes

Implementation candidate following 0.110.0; not yet a published release.

In **O → Plan Your Holding**, choose a floor and offer one of its actual beds to a recruited miner. Room designation remains optional. A clear route of constructed floors, existing household stairs and a fitted cellar stair must connect the bed to the existing claim mine. A bed has one assigned crew resident; releasing the berth preserves all furniture and possessions.

HoldEstateWorkers extends the existing mine crew record with an optional household location. The original roster, work depth, underground room assignments, fuel, mining and masonry owners remain authoritative. A worker walks home during the existing crew rest period, reaches a real bedside, rests, then returns to mine work. Long commutes finish with at least ten active seconds of rest rather than reversing halfway when the clock changes. Commute intent, current side/floor and exact position survive reload; transient paths are recalculated.

Each route step rechecks current geometry. Both sides of a cellar or upper stair must remain clear. Changed passages, removed stairs or furniture block travel rather than moving workers through obstructions. Removing or releasing a bed sends its resident back through the remaining route. Rest benefits require actual arrival and provisions. Masons finish returning carried job cargo before setting out; this feature does not haul cargo across the household boundary.

The normal mine renderer excludes workers currently aboveground. Surface rendering uses the same named character on the saved floor, without making a second NPC or changing the player's scene/floor. Unassigned crew retain their previous behavior. No new mine depths, automated freight, excavation or provisional-property story changes are included.

Validation pending: workers160 exercises paid building/furnishing, the real berth control, travel, cold reload on both sides, dynamic obstructions, return and removal. Source and exact-package catalogues include the case. Required affected regressions include upper158, cellar156, living and mineworks143. Inspect native berth and resident captures. Normal-speed Windows feel and performance remain player checks.
