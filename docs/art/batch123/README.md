# Final named cast batch 123

Dagr, Odrin, Osvik, Tovan and Kelvar complete the 24-character named world cast. The five receive 184 whole painted poses: four resting views and sixteen walking keys each, four drinking keys for each recruit, four hammer keys for all five, and twelve directional mining keys for each recruit. Yrsa receives sixteen missing hammer/mining keys because her existing recruitment roles also permit physical work. Her original 24 resting, walking and drinking poses remain unchanged. Existing 62px stature (58px for Yrsa), identities and gameplay remain intact.

The built-in image generator painted every complete figure, using established portrait identities and approved gait/work references. Exact prompts and selected source paths are in the adjacent JSON records. Source PNG paths record provenance; shipped WebPs preserve their pixels losslessly and are the durable runtime sources. No limbs, hands or tools were synthesized by code.

Two Osvik action attempts had an opaque brown backdrop and were rejected (exec-8ae97309-3595-49e2-b5de-7ceda98d01fd and exec-1f903cf8-8288-4223-bbb5-8c0acd27b8f0). A complete replacement, exec-884483f8-dcbb-4bd5-8f73-e58fe1cd970d, supplies the selected transparent poses. No rejected sheet is shipped.

`import_actions.py` measures whole-figure bounds, boot baselines and body height. A fixed body calibration across each four-key work row prevents raised tools from shrinking the body. Extraction masks omit disconnected background fringes; the runtime paints each intact figure. Native gait and work boards were visually reviewed for alternating feet, connected wrists, tool heads, beard/costume continuity, alpha edges and body scale.

Existing hiring, conversations, recruitment, role reassignment, directional mining, workshop routing and save/reload are exercised by `tests/story_batch123.gd`. The established workplace case exercises Odrin's discovery, route, supplied production, interruption and persistence. Unknown identities and unsupported future activities retain their working fallback. Named cache revision 23 refreshes derived frames. No new gameplay or save schema is introduced.

Final local/export and hosted validation results are recorded in the delivery evidence. Technical checks do not establish owner visual acceptance. No Windows release is created in this art pass.

All 7,264 source assertions and 7,239 exact-export assertions passed across eighteen cases each. All 3,821 package entries were verified, including exact matches for seventeen affected metadata files. Hosted run 41519827785 passed all five jobs by 2026-11-02T20:55:09Z. PR #93 merged as 25206199b22ee4e66dde2374c230b968f18ee0c3 with the identical tested source tree. Final evidence is preserved in the batch123 delivery documentation.
