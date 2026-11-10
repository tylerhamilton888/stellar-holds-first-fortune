# Dialogue state audit — 2026-11-10

Scope: current opening and first-shift instructions, NPC conversation routing, daily favors and gifts, friendship errands, courtship gates, forge requirements, and civic project completion. Compare text with the authoritative transaction/state owners; do not change progression to match inaccurate text.

## Corrections

- Completed favors acknowledge help after leaving and reopening the conversation; they do not request another delivery or promise another payment.
- Every conversation response starts at the beginning, including same-topic replies and friendship errands.
- Ivar stops recommending cold-forge work after restoration. Older non-frontier lodges retain their north-door/High Trail directions and do not advertise a Stonebridge ledger.
- Completed civic projects keep their completion/reward record but hide obsolete delivery instructions.
- Steel research is only recommended while unlearned. Cold production explains the restoration requirement.
- Gifts and favors say "for now", not "today": their existing ten-minute play intervals are separate from calendar days and sleeping.
- Betrothal distinguishes the calendar delay from insufficient friendship. Personal replies use natural wording while costs and commitments remain explicit.

## Regression coverage

Extend existing people, menu92, lodge100, forge147, ledger137 and courtship101 cases rather than adding a duplicate suite. Check visible text after real transactions and reopening panels. Existing source/package coverage remains mandatory for a release.

Tooling: 42 passing tests; pinned Godot 4.4.1 import passed. Native interaction results, screenshot review and hosted checks are recorded in PR #146. Windows 0.105.0 is the published baseline and does not include this follow-up. This audit reduces known contradictions; it does not certify every possible story combination or replace human playtesting.
