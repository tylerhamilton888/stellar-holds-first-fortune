# Three Hearths verification — 0.64.0

Native source verification: 315 checks passed across seven gameplay cases plus import. See civic68/source-results.json. The clean local Windows export passed all 3,165 PCK entry audits and ZIP integrity; see civic68/local-build.json. Exact-pack gameplay verification and hosted gates remain pending.

Original assets, measured prop bases, authored ward composition, fixed freight chest persistence and open interior thresholds are covered by tests/civic68.gd. Suite civic also runs living, hold, orientation, world, modular and ambient cases. tools/check_pack.py repeats civic against the exported pack without editor-only dependencies.

Early native checks found the starting-quarters lamp obstructed Ivar's route; it was moved beside the approach. The initial storage fixture stood between two solid chest bases and was corrected to use the actual clear approach. Visual review replaced flat paving with clipped stone courses, removed captions per user feedback and framed the Works Below clear of the hotbar.

Native captures reviewed: all three ward centers/frontages/services, residential and depth views, plus home, tavern, forge and family exits. Doors retain their original action coordinates; side leaves block movement and the center remains clear. Background architecture stays behind the solid perimeter. Existing player artwork was not changed.

Final counts, recovery and delivery references will be recorded after verification. Windows hardware/audio remains a player-device check.
