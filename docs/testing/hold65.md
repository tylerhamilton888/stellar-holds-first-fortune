# Keldrath galleries and clean floors — 0.62.0

Native Godot 4.4.1, OpenGL compatibility, Linux software rendering and isolated saves. Focused suite `hold` covers household traversal/collision plus opening escort, ambient citizens, existing world travel and modular construction. The five-case regression completed 199 checks: hold 80, orientation 20, ambient 36, world 35, modular 28. Final corner-pressure, resident-route and painted-stair changes passed a separate exact-source 80-check hold rerun with no script errors; these assertions are not counted twice.

The new hold case checks all nine household thresholds, same-coordinate upstairs/downstairs transitions, no upstairs street exits, upper-room save/reload, correct doorstep return, ward bounds, shaft/rail solidity, building side/corner movement, citizen route clearance, actual movement across/against the bridge and both original/residential ward stairs. Collision footprints are ground-plane geometry: roofs and upper facades remain depth-sorted, fading artwork.

Visually review starter-home, family-hearth, upper-room, bridge, gallery and forge-stair captures beside the current whole-character sprite. New architectural floors use continuous staggered courses, restrained grain and a cached mesh rather than repeatedly pasted strips. No imported/source art was overwritten. The stairs reuse the original painted assets, fitted to the same measured rail envelope. Cold frame preparation is unchanged; this pass is not a Windows performance claim.

Recovery: pre-keldrath65 points to the prior local source; merged PR #4 preserves the corresponding GitHub milestone. This is a source update, not a new Windows release. Private legacy houses remain closed, while nine additional two-floor homes are enterable. Neighbor schedules are simple deterministic street/hearth routines, not an occupational economy simulation. Old story, mine, claim and trade systems remain intact.

Working evidence: animations61/qa/hold65-pass (focused suite), hold65-reviewed (final native case). Early failures caught doorway interaction stealing, a missing draw_mesh argument and a too-short bridge movement fixture; these runs are superseded, not counted as passing evidence.

Final native captures: [starter floor](hold65/starter-home.jpg), [gallery](hold65/gallery.jpg), [upper rooms](hold65/upper-room.jpg). These show the current geometry and original painted art; no mockup or generated preview substitutes for gameplay.
