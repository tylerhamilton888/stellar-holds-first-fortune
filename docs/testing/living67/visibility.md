# Final shared-stair visibility correction

Native review reproduced a neighbor disappearing behind the active stair/wall while still owned by the adjacent ward. The same neighbor reappeared at the ownership seam. Publication was paused before any 0.63.0 release was created.

WorldZones now removes shared-flight residents from the background plate pass and translates them into the active foreground actor sort. Area ownership, route, appearance and saved clock are unchanged. The living harness verifies translated coordinates, one actor per resident and continuous visibility across the seam; native before/after captures were inspected. The first added assertion incorrectly assumed ordinary street rovers had a resident interaction key; the corrected assertion uses a safe lookup. Final native run: 51 passed, no script errors.

Correction PR #9: 6d2752e4a595c415257b58f00fd2825aea7609be. Baseline PR #8 was already merged at 09666eaf2ba6f06598b3f0ac52249615243d3be2 after full gameplay run 39650360972 passed. The corrected source has its own full gate, 39656307242. Candidate 472e12bf47c0784c84f3e763da7778dc9cbe740e prepares the clean Windows package in parallel with that gate, then requires the successful gate and exact-pack tests before publishing. Publication status remains pending until verified.

The release job allowance is 55 minutes because the earlier 35-minute total also included the source-gate wait. Preparing the package before waiting removes that unnecessary serial delay without weakening a publication gate. No gameplay or resource changes were made for this orchestration adjustment.

Corrected clean local build 2e9b17883c977855f1697c447da4a949cc82062d passed all 3,157 PCK-entry checks and ZIP integrity. The exact exported pack passed 97 checks (ambient 11, continuity 35, living 51) with no script errors. See visibility-local-build.json and visibility-export-results.json. This local ZIP is not the later hosted asset; compare the hosted digest separately at publication.
