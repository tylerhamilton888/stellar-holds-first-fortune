# Mining direction — implementation notes

The user-authored [MINING-VISION.md](MINING-VISION.md) is the controlling creative
brief. These notes track the current foundation and do not replace that standard.
The next polish pass prioritizes tool contact, progressive fracture, distinct
material response and geological discovery before broader content expansion.

The player reads a mountain, finds a seam, excavates it, and makes a reliable
way home. Access, geological clues, valuable material and persistent changes
should drive the route. Repeated jumping between authored platforms should not.

## Implemented foundation

- Seeded surface, dirt cover, bedrock, mineral lodes and irregular cave pockets.
- A shallow graded opening adit with enough coal for the first commission.
- Destructible grains, dirt prospecting, structures, stairs and body-sized ladders.
- Persistent regional destinations, including the first local expedition.
- A deeper equipment gate; restricted underground fast travel.
- Bounded falling-material simulation and incremental terrain texture updates.

## Next generation milestones

1. Generate regional elevation, drainage and geological provinces before local
   terrain. Place settlements and roads against that geography.
2. Give rock formations thickness, dip and faults. Derive ore from host rock,
   contacts and fractures rather than independently scattered reward pockets.
3. Generate cave systems from rock type and drainage. Most valuable seams need
   excavation; caves are discoveries, not a regular movement grid.
4. Expose readable prospecting clues: surface float, stained rock and soil
   traces. Hidden resource distribution should stay hidden until surveyed.
5. Address terrain by planet/region/chunk and generation version. Save player
   changes and depletion; never reset a visited mountain when travelling.
6. Add hauling and industrial extraction after the hand-mining route feels good.
   A stripped mountain must remain stripped on both local and regional views.

The current build stores whole local terrain snapshots and a regional route
graph. Infinite streaming, multi-planet persistence and a fully deformable
top-down regional landscape remain future work.

## Next playtest

Complete the first coal job without steel or rescue. Walk both ways across the
trail/mine boundary while holding movement. Ascend the surface slope. Excavate
a short shaft, build a ladder and climb out; releasing climb should hold position.
Visit Pinewood through G, gather timber, return and verify the same excavation.
Watch feet, jump poses and tool contact while testing sound at your normal
listening volume. Report position and equipped tool with any collision issue.
