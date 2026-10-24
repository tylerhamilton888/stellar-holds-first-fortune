# Royal Hall and grounded Keldrath verification

Published: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.71.0. PR #29 merged at 9d992e0f3abe38d49bf05ca72d4c250f9d76eb1c; verified release source 56260aa1d4b1204ec695b5dd171108e74799f8c3 and merged source share tree f280a3b4ceeca5282fd5e3bc099c1c1448771988.

## Recovery and behavior

Recovered the frozen session into an isolated worktree, preserving the original worktree, original PNGs, resource paths and published 0.70.0 baseline. Remote recovery/pre-royal79 retains baseline 92751bd7660a00eb688720e2c1145d978b00677f. The transfer workflow checked SHA256 for all 33 changed files and restored exact reviewed tree dc402093dee82e93dab3177a8c585f07a59e880f. Transfer chunks are absent from the runtime source. Owner approval resolved the initial upload rejection; GitHub now permits the authorized actions.

The continuation fixed advancing dialogue replaying the player's entrance and prepared the up-facing frames used by the actual top-down scene. The ambient export harness now inspects actual player/King movement rather than retired side-view fields. The first hosted source attempt caught an older world journey fixture using the retired gate coordinate; it now approaches the authoritative gate position and still exercises the real E interaction and onward mine entrance. Royal tests cover position continuity, skipping mid-entrance, idempotent completion, inventory/save preservation, return to Crownward, physical bases and complete royal silhouettes.

## Verification

- Fresh native royal case: 72 assertions, exit zero, no script errors or leak messages.
- Focused traversal suite: world journey, modular furnishing and ward/stair regressions passed 144 assertions, with no script errors or leak messages.
- Complete local exact-export gate: 15 cases, 693 assertions, no script errors or leak messages.
- Hosted source: https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/40038598002 — import and all 24 gameplay cases passed.
- Hosted release: https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/40038600939 — clean build, 3,263 PCK entries audited, identical-source gate and all 15 exact-export cases passed.
- Windows ZIP: 725,124,940 bytes; SHA256 540fe880913e2658f7c8f903b7e5034b5032a305d87813fe2542fb71e00447c4. Build report and release asset digest match.
- Native and local exported throne, seated king, actual audience, gate and ward visuals reviewed. Hosted exact-export evidence is retained as verification-evidence.tar.gz beside the ZIP and build.json.

The account's Actions artifact quota was full. Evidence upload to Actions is optional; no gameplay test or publication gate was made optional. The release stores its exported screenshots/logs/results in a separate release asset. Local build79 and qa79 evidence remain intact. Final source/docs are preserved on recovery/verified-royal79-delivery, with a verified local incremental bundle.

## Limits

Windows device performance and audible quality require player testing. Royal sitting/standing is complete; general lying-down animations are not included. Scenes remain individually loaded. Prior releases and recovery archives were not replaced or deleted.
