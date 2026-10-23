# Keldrath building repetition

Player report during Honest Work delivery: buildings appear in multiple places, or carry repeated labels. Audited the current 0.68.1 layout and native 1280×720 civic captures. This is a confirmed presentation/content issue; no building runtime changes are included in 0.68.1.

| Finding | Source | Consequence |
| --- | --- | --- |
| The same Granitehand, Copperbraid and Deepmantle labels recur in every ward. | `HoldNeighborhood.FAMILIES`, `title`, `resident`; `HoldWardDesign.frontage` | Nine separate households look like three places repeated. Residents already have nine distinct first names. |
| All nine family houses use façade 0, with the same three widths and door positions in each ward. The player's quarters and Crownward private house also use façade 0. | `HoldNeighborhood.buildings`; `HoldWorldZones.buildings` | Whole streets repeat the same silhouette and frontage. |
| Family interiors share the same lower/upper furnishing templates across all wards; one family index adds a lamp. | `HoldNeighborhood.room_objects` | Entering a house does little to establish a distinct household. |
| King's Hall and Practice Bay both use façade 3. Survey Office and Foreman's Office both use façade 5. | `HoldWorldZones.facade_index` and `draw_building` | Unrelated public destinations look like copies. |
| Each named public service has one authored door and destination. | `HoldDistrictMap.DOORS`; `HoldWorldZones.points` | This is not duplicated tavern/forge functionality. |

The lower-gallery cutaway deliberately shows part of the actual ward below. Preserve that spatial connection; it is not a second service instance.

Recommended focused follow-up: identify homes by their existing resident/household as well as clan, distinguish domestic fronts and useful interior arrangements, and give the offices and practice bay silhouettes appropriate to their jobs. Review wards side by side and beside the approved Dwarf. Preserve room IDs, door anchors, saved furnishings, household schedules, quests and existing services. Do not solve repetition by deleting homes or relocating story doors without a separate need. Keep original artwork and recovery checkpoints.

Review evidence: the `civic` case's `crownward-kin-gallery.png`, `hearthward-kin-gallery.png` and `forgeward-frontage.png` from local exact-pack acceptance; source inspection covers all three wards. No new runtime test was needed for this read-only diagnosis.
