# Release pipeline refinement — validation pending

Implemented four independent exported-test runners, one shared verified Windows candidate and strict full-suite aggregation. All 61 harness scripts/markers are unchanged. Thirteen local pipeline safety tests pass; a full hosted benchmark is required before claiming a measured speedup. No gameplay version change and no restart of the existing 0.97.2 release. See [RELEASE_PIPELINE.md](RELEASE_PIPELINE.md).

# Current status — 0.97.2 release in progress

The opening chapter through the Thane homecoming is implemented. Current work is delivery of the completed visual polish and royal-axe correction, followed by owner playtesting. Marriage and district expansion remain deferred.

Source PR [#117](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/117) and [its five-job gate](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41760487374) passed; all five jobs succeeded. PR #117 merged as `83444ee7141417ce677c8592fb3a708c5e51df54`, whose tree exactly matches the tested source. The authorized [Windows release job](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41761990982) is running from `b305023db9889d46ce5fb244bb2b48f0f6b6bcf2`; it requires all 61 exact-export cases and the identical-source gate. The last confirmed download remains 0.97.0.

Final local native/exact-export checks passed 172/811 assertions, and all 3,893 PCK entries passed integrity checks. [Acceptance record](testing/polish135/acceptance.json) contains the preceding regression evidence and limitations. Native-size inventory/HUD and prior scene captures were reviewed. Human pacing, audio and Windows device performance remain playtest work.

Next: let the existing Windows release checks finish, verify published assets/digest and update this status. Avoid duplicate release jobs. Then test the first paid shift and earning a personal home before considering more features.

[Recovery handoff](SESSION_HANDOFF.md) contains exact refs and commands/workflow pointers. [Prior status history](https://github.com/tylerhamilton888/stellar-holds-first-fortune/blob/b305023db9889d46ce5fb244bb2b48f0f6b6bcf2/docs/CURRENT_STATUS.md) is preserved.
