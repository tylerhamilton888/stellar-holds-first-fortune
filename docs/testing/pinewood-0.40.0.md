# Pinewood 0.40.0 verification
Godot 4.4.1, isolated Linux user-data directories. No real player save used.

- Import/export and packaged title boot: passed.
- Forestry regression: 53 checks, zero failures. Includes all ten designs and both facings, old five-tree migration, no rewards from exhausted trees/logs, exact 22 timber per full tree, ground/reach/tool guards, fall lockout, partial-log reload and map round trip.
- Campaign regression: 43 checks, zero failures; old road fixture updated to actual tree position/target.
- Standard smoke: 220 counted checks plus three-slot assertions passed.
- Historical expedition25: 194 passed, 2 failed (mine exit/trail entry continuous movement). Those assumptions predate the user's decision to use map-table travel. No unrelated transition change made to satisfy them.
- Native OpenGL/llvmpipe captures: arrival, eastern coupe, axe and log contact, 12 fall frames, paused board. Found/fixed log orientation, shrinking fall and tree aliasing. Painted textures use a separate mipmapped canvas; characters retain established sampling.
- Audio uses existing wood sound at -14 dB for contact and -18 dB on landing, through Effects. Contact timing follows existing strike event. No actual-speaker mix assessment here.
- Known ObjectDB/resource-in-use teardown warnings remain. Display V-Sync unsupported in virtual graphics. Windows launcher not executed here.

Manual acceptance: travel to Pinewood, read E board, choose axe 3, fell/chop both sides, use timber for mine stairs/supports, reload partial work, return by G. Check aiming and sound comfort with your usual settings. Woodland is a finite local coupe, not procedural forestry or automatic replanting.
