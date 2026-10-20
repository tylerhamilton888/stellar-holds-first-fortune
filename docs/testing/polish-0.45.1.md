# Visual pass 0.45.1
Godot 4.4.1, Linux native Xvfb/Mesa display at 1280×720; isolated test saves. Dummy audio: event timing tested, audible mix not heard.

- Masonry model: 25 passed, including material conservation, actual worker fetch/convert/return, in-flight cargo reload and legacy defaults.
- Native input: 12 passed. Actual UI and held-input extraction, placement, caching, dressing, hauling, finishing, quest, worker handover and save/reload.
- Four rendered manual phases: lift .05, approach .3, contact .53125, recovery .8. Captured actual renderer while gameplay paused, then restored swing state and resumed input. Worker rendering uses saved job.time rather than an unrelated global animation clock. Impact events cross the same .53125 cycle fraction.
- Inspected native bench, carry, quarry, finished room, worker and menu captures in polish-0.45.1/. Bounded menu with fixed tabs confirmed. Existing carry art retained; this is not a new directional character atlas.
- Source import and exported PCK native boot checked separately during packaging. Git bundle restore/fsck and ZIP integrity are packaging gates; see RECOVERY_VERIFICATION_0.45.1.json in Docs archive.

No changes to saved data format, recipes, yield, 2-second worker conversion or unrelated areas. Prior wider 0.45.0 regression evidence is retained, not claimed rerun here. Windows launch and audible mixing remain untested on Linux. Existing ObjectDB/resource warnings at test teardown persist; no gameplay script errors observed.
