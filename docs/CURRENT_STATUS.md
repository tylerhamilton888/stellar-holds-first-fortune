# Current status — room stages197 acceptance candidate

The owner requested a wider cottage doorway and a frontage that matches the established buildings. The working review includes an arched oak entrance, projecting gable, eaves, chimney and an upper gallery. See ROOM_STAGES197.md.

Public Windows release remains 0.124.0. This branch is based on master 328c0ca (clarity196 merged). No new Windows release or final visual acceptance is claimed.

Room plans now show a translucent light-green finished-room preview while dragging, red blocked previews, and an exterior/cutaway switch. Placement marks the foundation without payment. Building progresses through paid floor, walls/doorways, roofing and finishing. Actual tiles determine progress and partial save/load; costs, belongings and save formats remain unchanged. Temporary supports/roof framing disappear on completion. See ROOM_STAGES197.md.

Implementation is in scripts/room_construction197.gd, room_blueprints.gd, room_blueprint_view.gd and house_art189.gd. Native room acceptance captures show the same seven-by-six room throughout construction. Prefabricated buildings and fine construction retain their existing transactions.

Native Godot 4.4.1 regression run stages197-r4 passed room_stages197 (24), blueprints152 (69), blueprint_manor152 (48), upper158 (51) and cottage189 (17). Final framing/caption/checkbox verification passed in stages197-final: room_stages197 25 and blueprints152 69 assertions, no script errors. Across the five affected cases, 210 distinct assertions passed. All 42 Python tooling tests passed; output policy and whitespace checks passed.

The approved 0.125 ornate menu source remains missing; saved artwork/captures survive. This candidate uses the current plain menu shell and does not claim restoration of the Mason's Book. Preserve that work if recovered.

User requested implementation and acceptance images. Source review branch: feature/room-stages197 (not merged). Acceptance PNGs and the original capture ZIP are saved as Stellar-Holds-Room-Construction-Acceptance.png and Stellar-Holds-Room-Construction-Captures.zip. Await the user's visual response. Prior delivery details: history/CURRENT_STATUS-before-room-stages197.md.
