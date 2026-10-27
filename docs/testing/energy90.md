# Supper & Slumber verification

Runtime source: `0802f021a441309058ec2efafa14960864caf350` (PR #51).
Release source: `44fd344ba41779bd5197804254886f231095f09b`; only release notes differ.

Native local verification passed 163 relevant assertions: energy 24, homestead 69, combat 44 and work 26. Final energy captures are in `test-results/energy90-approved/energy`; reviewed the tired meal panel, accessible bedside sleep/nap buttons and compact HUD meter. Earlier layout captures are superseded. The three final energy captures are byte-identical to the downloaded hosted source evidence (artifact 12760865180, SHA256 994b1654f5c5f2e6abff13d8e8eadd121c8075b02c4636748429955b922f041e). New tankard artwork is an SVG inventory icon, not a new character animation.

Energy checks cover legacy initialization, four food recovery levels and matching consumption, fullness and drink cooldowns without inventory loss, capped work slowdown, sleep/nap recovery, paused-menu time, real bedside completion, real mining expenditure, unrestricted combat movement/dodge and save/reload persistence. The same standalone case is included in exact-export acceptance.

The complete 33-case source manifest is partitioned into three disjoint suites, with every case represented once. The release requires the entire source workflow to succeed, followed by its own exact-package suite. Source workflow: 40557642059. Release workflow: 40558582380. Both workflows passed. All 23 exported cases passed 1,780 assertions. The downloaded export artifact (12761574776) matches SHA256 b37da8d1e90d133af3e1c7a48a2f93b29b5895b4ac2bcad5b0ea38daa4b6fd46. All three exported energy captures are byte-identical to their reviewed local and hosted-source counterparts. Published files and tag agree with the clean build report. See energy90/delivery.json for the final hashes and merge identity.

Balance defaults: active-time tiredness at 60/90/120 minutes reduces food recovery to 75/50/25%; energy never disables movement or combat. Zero reserve reduces demanding work speed 20%. Full sleep restores the reserve; a nap restores 35 and reduces awake time 30 minutes. Meals have a two-minute fullness interval. Ale gives five minutes of 5% reduced work expenditure; full sleep gives ten minutes of the same benefit, without stacking.

Limits: no calendar, daylight simulation, holidays, offline fatigue or elapsed-world-time sleep. Windows hardware performance, audible quality and subjective pacing remain hands-on playtests.
