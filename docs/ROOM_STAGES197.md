# Room planning and construction — acceptance candidate

On branch `feature/room-stages197`, based on master `328c0ca` (clarity196).
This is a source review candidate, not a published Windows release. The public
release remains 0.124.0. The missing 0.125 crafted menu source is not restored.

Dragging a room rectangle now renders its completed architecture in translucent
light green, using the same floor, wall, doorway and pitched-roof painters as
the real house. Invalid previews turn red and explain the obstruction. Preview
validation and placement share the existing eligibility and access checks.
The roof checkbox switches between exterior and cutaway. No furniture or new
windows are invented; optional finishes follow the selected room appearance.

Releasing the drag saves stakes and foundation marking without payment. Work
uses the existing paid Hearthcraft transactions, completing the floor before
walls/doors and completing walls before roofing. The real tiles determine the
visible foundation, walls and partial roof; temporary supports and roof framing
disappear when construction/finishing completes. Supports are visual only.
Progress is derived from saved tiles rather than a new timer or save schema.

The change applies to editable room plans. Prefabricated building transactions
and fine-construction costs remain unchanged. Existing partial buildings retain
their pieces and continue from their earliest unfinished construction phase.
The missing decorative menu restoration remains a separate integration task.

Acceptance: `tests/room_stages197.gd` creates and builds the same seven-by-six
room, captures the actual planner and world at each phase, and checks preview
immutability, invalid placement, phase barriers, exact costs, partial save/load,
completion idempotence and preservation after removing the plan. The source
case is registered in gameplay-4 and the exact-package catalogue. Native
regressions include blueprints152, blueprint_manor152, upper158 and cottage189.

Verified: 210 distinct native assertions across the five affected cases; 42 Python tooling tests; output-policy and whitespace checks. Final room/cutaway captures passed 25 assertions and the final blueprint rerun passed 69. No script errors.

User visual approval and final publication remain pending. Do not treat these
development captures as a release or as approval of the missing 0.125 menus.
