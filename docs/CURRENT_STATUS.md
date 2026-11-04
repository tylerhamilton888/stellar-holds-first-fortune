# Current status — 0.97.2 release in progress

The opening chapter through the Thane homecoming is implemented. Current work is delivery of the completed visual polish and royal-axe correction, followed by owner playtesting. Marriage and district expansion remain deferred.

Source PR [#117](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/117) and [its five-job gate](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41760487374) are awaiting completion. The authorized [Windows release job](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41761990982) is running from `b305023db9889d46ce5fb244bb2b48f0f6b6bcf2`; it requires all 61 exact-export cases and the identical-source gate. The last confirmed download remains 0.97.0.

Final local native/exact-export checks passed 172/811 assertions, and all 3,893 PCK entries passed integrity checks. [Acceptance record](testing/polish135/acceptance.json) contains the preceding regression evidence and limitations. Native-size inventory/HUD and prior scene captures were reviewed. Human pacing, audio and Windows device performance remain playtest work.

Next: complete the existing checks, merge #117, verify published assets/digest and update this status. Avoid duplicate release jobs. Then test the first paid shift and earning a personal home before considering more features.

[Recovery handoff](SESSION_HANDOFF.md) contains exact refs and commands/workflow pointers. [Prior status history](https://github.com/tylerhamilton888/stellar-holds-first-fortune/blob/b305023db9889d46ce5fb244bb2b48f0f6b6bcf2/docs/CURRENT_STATUS.md) is preserved.
