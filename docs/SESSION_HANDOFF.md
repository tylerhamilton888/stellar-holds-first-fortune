# Worker-route delivery — legacy guard candidate

0.111.0 is published and PR #160 merged as `b7a9960838be67064ea27a12271a8daa28e9f594`. Source `9bd7d68c2fbe9dbc8996ca5a426bda78304d2bd0`, release run 43495183270 and PR run 43495194723 passed all gates. Local acceptance passed 31 worker-route assertions and 42 tooling tests; native resident and berth-control images were reviewed. Post-upload verification is on branch `verify/workers160-delivery`.

Final review found that legacy crew can run at a non-claim site, while the new household tick did not explicitly decline that site. Candidate **0.111.1**, branch `fix/worker-claim-site`, adds that explicit guard and two regression assertions without changing household rendering or the established worksite loop.

The local execution environment is unavailable. Source edits and verification continue through GitHub. Required checks, merge and the verified Windows release remain mandatory. Do not claim 0.111.1 is published until its pipeline finishes. After delivery reconcile current status, this handoff, README, playtest guide, backlog and affected feature notes. Automated freight is the next separate blueprint piece.
