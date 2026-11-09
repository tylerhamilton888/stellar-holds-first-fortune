# Forge147 — workshop update (0.104.0, in validation)

Stonebridge's communal forge now has a visible hearth, stocked workshop fittings, Borin at the anvil, and usable hearth, anvil and benches. The hearth's state follows the existing Cold Forge project; existing furnishings and chest contents remain authoritative. The hall shell is unchanged to protect established saves. Focused native and visual checks are in progress; hosted source and release gates remain required before delivery.

Windows 0.103.0 was published successfully in [release run 42633939330](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/42633939330). This supersedes the older in-progress opening and ledger notes below.

# Opening146 — source work in progress (0.103.0)

A new skippable, resumable Stonebridge arrival leads into the bunkhouse and first shift. Ivar, Rurik, Sigrid and Skarrin have revised dialogue; early journal, shift book and Ledger explain their purpose gradually while retaining access to the complete books. Existing saves do not replay the introduction. The opening146 suite and hosted validation must pass before integration. Windows 0.102.2 remains published; normal-speed pacing, writing and Windows audio/performance need human playtesting.

# Civic145 — authorized delivery in progress (0.102.2)

The monumental town ledger is implemented and visually reviewed, including the exported game. Five affected native cases passed **381 assertions**; the exported ledger and mine-entryway cases passed **35 assertions**. All 24 tooling tests and all 3,945 PCK entries passed. Tested runtime commit: `39398608d0627d9731d6b6c632fc971055168e88`; later delivery commits only update evidence/docs. The asset is the original approved painting, with no image alteration.

**Authorization recovered:** on November 8 the owner approved upload/merge/publication and asked to stop repeated routine confirmation; the current recovery was explicitly directed to pick up that work. AGENTS.md records this scope. The earlier automatic-review rejection is historical, not evidence that a new approval is missing. Do not bypass a new platform rejection. Source restored from the b20bcc09157981b224a9dd5747764e0df2085942 bundle with all 23 file hashes matching. Hosted validation and Windows publication remain pending; Windows **0.102.0** is still the public download.

Local branch: `feature/civic-ledger145`. Workspace: `/workspace/scratch/92dc7a5dfe57/stellar-holds-first-fortune`. Results: `test-results/ledger145-final`, `test-results/ledger145-pack`; acceptance receipt: `docs/testing/civic145/acceptance.json`. A clean Windows candidate was built at `/workspace/scratch/b4fa21c3a147/windows-candidate` from `3152e8c491a8becdb35bea0d6dc9a6a2cff6fa6f` using the verified official 4.4.1 template. ZIP size: 963,191,585 bytes; SHA-256: `8cf337af14108a81c0fc8f2f9f6e727fb1447719c60bde87cdea8934e48b00bd`. Its 3,907-entry PCK excludes local developer captures; both exact-candidate cases passed all 35 assertions. Place `.gdignore` in local build/test-results folders before future exports, or build from a clean checkout. Focused local package checks do not constitute full Windows release acceptance.

Do not rerun completed checks unless runtime changes. Next: push the branch, open the focused PR, require hosted source validation, merge, then run the normal verified release workflow. Preserve prior releases and original assets. The next product task is human playtest feedback on finding the book and the mine doorway.

# Entryways144 — source 0.102.1 merged

The mine's surface exit is a stone-framed doorway at the north wall, with lamps, a paved approach and solid jambs. The old freight-floor crossing no longer exits. Mineworks return doors also sit at their arrival-bay walls. Deliberate walking or E at the surface doorway works; held entry input cannot bounce back outside. Saved placement preserves terrain, furniture and freight handling. First annex creation after JSON loading now normalizes the saved numeric seed.

[PR #135](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/135) merged as `7d095b884d99edf846116bb2694b9d4fb62e8869`. Its tree `52d4c0c1a457222a18b64353d20182b5c40cdae2` matches tested source `79aa40ca35a345588665c858df3e2bf7d30265a7`. [Source run 42403208851](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/42403208851) passed all **76 native scenarios** and the final gate. Five focused native cases passed **209 assertions**, four focused exported cases passed **124**, all **3,905** package entries passed audit and all **24** tooling tests passed. Overhead, return, side-heading and optional perspective visuals were reviewed. [Acceptance receipt](testing/entryways144/acceptance.json); [entryway ownership](ENTRYWAYS144.md).

The public Windows download remains **0.102.0**. This is merged source for the next requested build; focused exported checks are not full Windows release acceptance. Next: address the owner's next reported playtest issue, then bundle fixes when a build is requested. Do not repeat completed checks after chat recovery.

# Windows 0.102.0 — published

[Download the complete Windows ZIP](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/download/v0.102.0/Stellar-Holds-First-Fortune-0.102.0-Windows.zip). Extract all files into a new folder and run `FirstFortune.exe`. **New Game** starts the standard opening; **Load Game** continues existing progress.

[Release run 42245441301](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/42245441301) passed all **75 native source scenarios** and **66 exact-package scenarios / 14,043 assertions**. The clean release source is `f1fc5b41a60130ab90b087dccd36ad4a1c7a1f38`, tree `b5d2b8af5f695c020a39e97d7e8ce807d8565b9c`. The published tag targets that exact source. The uploaded ZIP is **961,221,648 bytes**; its SHA-256 `18f3d0dc6803e2aa2386e1765ecd5f79993620ab10d2ab0301ba7f28bd8249e1` matches the build and package-verification reports. Publication completed 2026-11-06T16:16:07Z.

Release-package bridge, district board and long-name HUD captures were reviewed; no new visual blocker was found. [Acceptance receipt](testing/mineworks143/acceptance.json). Publication is complete: do not rerun the release or completed acceptance after chat recovery. Continue from GitHub master and the [playtest route](PLAYTEST_GUIDE.md). Next: human feedback on excavation scale, district layout and bridge/tool pacing; further mine biomes and engineering gates remain future extensions.

# Mineworks143 — source 0.102.0 merged

Source **0.102.0** adds three permanent 80 × 64 lateral mineworks: Stonewright Delve, Blackvein Reach and Farbank Works. Players reserve named districts and develop them with existing rooms and equipment. A physically mined tempered-steel seal and a Stoneworking bridge project gate expansion. Carts and hired workers follow open connections; original five-depth terrain and property remain intact. [Design and ownership](MINEWORKS143.md).

[PR #132](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/132) merged as `f74fbe39ce1a95e624155d371a8fce1093305341`. Its tree `a7c737fde385f78feba0f1d14fe234bfc812696a` exactly matches tested source `77547ef4c0775cb6ae514ef22cffa6b127de9fb9` and the tested PR merge. [Source validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/42060576334) passed **all 75 scenarios and the final gate**. On November 6, cancelled group 3 was retried alone as job `127964865871`; all 18 cases passed, retaining the other 57. No runtime changes or full-suite restart were needed during recovery.

Corrected local opening/mineworks checks passed **210 assertions**; focused exported mineworks and wage/polish checks passed **111 assertions**. All **3,905** PCK entries and all **24** tooling checks passed. Native/exported bridge, district board, workshop, long-name HUD and entrance visuals were reviewed; hosted captures were rechecked during recovery. [Acceptance receipt](testing/mineworks143/acceptance.json). Do not rerun completed acceptance after chat recovery.

The source checkpoint below was subsequently packaged and published as Windows 0.102.0; see the release receipt above.

# 0.101.1 — New Game / Load Game · published

[Download Windows 0.101.1](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.101.1). The title menu now says **New Game** and **Load Game**, and the new-game slot banner matches. New Game starts the standard bunkhouse opening in an empty fortune slot; Load Game resumes existing progress. This patch contains only the three wording changes and version metadata; gameplay and saves are unchanged.

All 74 native source scenarios and all 65 exported scenarios passed. The package verifier recorded 14,000 assertions against identical PCK/ZIP hashes. [Release workflow](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41925565984) succeeded. The published tag targets `85e45668224f28c0e7dbca910fdf546cf4037c05`, tree `416128b9ac40f12461d72b3875224fec6067b3df`. The uploaded ZIP is 961,201,218 bytes and its SHA-256 matches the build report. [Acceptance receipt](testing/title-labels142/acceptance.json).

The earlier focused menu/startup checks passed 102 assertions and title/slot visuals were reviewed. Publication is complete; do not restart these checks after recovery. Final delivery changes are documentation only; release verification is authoritative for this exact runtime. Earlier releases are preserved.

Next: use **New Game** in a fresh slot and follow the [playtest guide](PLAYTEST_GUIDE.md). Collect pacing, clarity, Windows performance and audio feedback before adding systems. Continue from GitHub master; preserve remote ancestry because this recovered local checkout has different history.

# 0.101.0 — Collections of the hold · published and merged

[Download Windows 0.101.0](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.101.0). Three optional Ledger collections save partial deliveries and award a reusable masonry recipe, Borin’s tempered hammer, or a functional supper-table plan/materials. Hearthkeepers choose farming or fishing. Collections consume shared production credit, remain available after the contest, and grant no campaign marks, seals or research. This release also delivers the previously merged Cold Forge, practical campaign milestones, Winter Stores and North Crossing. Existing saves and later story owners remain authoritative.

[PR #128](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/128) merged as `2fcbfe89032a65423e3064008330202b9ecb6e79`; its tree `84684c27b22ff5f4482d03b477c35098da173dca` exactly matches the tested release source `5239351c37f738227f107cae679c87bc08aafd18`. All 74 native source cases and all 65 exported cases passed; the package verifier recorded 14,000 assertions against one identical PCK/ZIP. Seven affected local cases passed 502 assertions, all 24 tooling tests passed, and the collection/reward/recipe/furnishing interfaces were visually reviewed. [Acceptance receipt](testing/collections141/acceptance.json).

[Source validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41910396704) and [Windows publication](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41910383093) completed successfully. The public tag targets the release source; the uploaded ZIP’s size and GitHub SHA-256 match the build report: 961,203,100 bytes, `447142f11a8d223edf00aaa23595b016581931ce2ac7dc922d7663b7eada8f03`. Earlier releases remain preserved. Do not rerun completed validation after chat recovery.

Next: follow the updated [playtest guide](PLAYTEST_GUIDE.md) in a fresh First visit fortune. Try one collection alongside the main milestones and report unclear objectives, resource bottlenecks and active play time. Pause further system expansion for pacing feedback. Normal-speed balance, Windows performance and audio remain human checks; marriage and district expansion remain deferred. [Collection design and ownership](great-claim/COLLECTIONS141.md).

Continue from GitHub master. The recovered local checkout’s history differs from the remote; never overwrite remote ancestry from it. Runtime/test baseline bytes and all 28 changed source files were checked against GitHub; the release tag preserves the complete source and original assets.

# Validation140 — focused development checks

PR #126 implements conservative affected-test selection, removes duplicate people
validation and the automatic post-merge rerun, and makes Windows rehearsals
explicit. Actual releases retain the full native suite and all 64 exported cases.
Read [VALIDATION_POLICY.md](VALIDATION_POLICY.md) for the current workflow.

All 24 Python safety tests passed. Native startup/save checks passed 42 assertions
locally and both selected hosted cases passed. Hosted run 41897781913 passed its
planner, gameplay worker and final validation gate. Its tested source files match
620ffe3b7d733192d91e32564874a792fe6a88ce exactly. See
[acceptance receipt](testing/validation140/acceptance.json). No gameplay, artwork,
saves, version or public release changes accompany this tooling work.

North Crossing delivery notes below are preserved from merged PR #127. Continue
from GitHub master; do not reset the older dirty worktrees. The complete campaign
overhaul and normal-speed pacing playtest remain outstanding.

# Source 0.100.0 — The North Crossing

The next authored Act IV milestone restores a northern river crossing between Old Workings and the survey hall. Inspect the west abutment after the rescue and Winter Stores, deliver 12 dressed stone / 24 timber / 4 iron through the Ledger, and supply three crew shifts. Smiths supply forged parts, builders processed timber or stone, and provisioners cooked bread, hotpot or chowder. Repeat one route or mix them. Research and unspent production evidence are checked on every deposit; partial deliveries persist.

Return to fit the span, then gather Ivar and Skarrin for a short saved scene. The crossing changes real collision and uses the existing bridge art. Fresh fortunes need the witnessed restoration before final ancestral authentication; saves already at archive research or beyond retain eligibility. Closed contest scores, homes, courtships and the existing trial/Thane sequence remain authoritative. No deadlines or simulated rival economy.

Nine affected source cases pass 1,755 assertions; four focused exported cases pass 907. All 3,901 package entries and 13 pipeline unit tests pass. Native and exported visuals were reviewed. All five hosted source jobs and all 64 exported cases (13,917 assertions) passed, including the final identical-build verifier. [Acceptance receipt](testing/restoration139/acceptance.json).

Merged in [PR #125](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/125) as `279ac1648762b18b9f35b622b2a18b6701315edf`. Its tree `48458e516ce5184b160f937478e364e2fe8dcf19` matches the tested source. Head `cd6e68389e34bf3a8361b00197f2c4a356e4cb53`; tested PR merge `f2a1347b8ce6a99afff85deba1fc8feabe86bae6`. [Native run](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41893233736) and [complete package rehearsal](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41893233723) succeeded. Windows 0.97.2 remains published; this work did not publish a new release.

See [design and acceptance scope](great-claim/RESTORATION139.md). Next: advanced transport/production adventures, optional collections, and human pacing/specialty-cost playtesting.

# Source 0.99.0 — Hands of the hold

The next campaign batch replaces the 180-mark rescue gate with seven practical milestones: a registered home; ore/smelting/steel; timber and loaded hauling; field tools, fishing OR farming and cooking; a survey, descent/return and Stoneworking; the Winter Stores; and three civic projects or trade seals. Marks remain narrative recognition. Existing earned invitations and accepted story stages are preserved.

The Winter Stores now use saved partial deliveries, an on-site investigation and reconstruction, and a final provisioning stage. The original public building, trading services and reward owner remain in use. Opening it adds permanent supplies inside. The Ledger and journal expose the authored campaign acts and requirements. See [scope and state](great-claim/CAMPAIGN138.md) and the [owner’s full directive](great-claim/OPENING_CAMPAIGN_DIRECTIVE.md).

Implementation merged in [PR #123](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/123), source `8f1d974424c80bdb8e48cc419d4a7e6175fbae3f`. All eight native regressions pass 1,029 assertions; the final focused native case passes 59; three exported cases pass 334. All 3,897 package entries and 13 pipeline tests pass. All five hosted source jobs and all 63 exported cases (13,808 assertions) passed, including the final identical-build verifier. Merge `c6a026c3589d81531eda749e59a7a39cdf271506` has the exact tested tree. See [acceptance](testing/campaign138/acceptance.json). No new Windows release was published. [Recovery handoff](SESSION_HANDOFF.md) records the merged source and completed runs.

## Previous batch and published download

[PR #121](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/121) contains Ledger137’s partial contributions, staged Cold Forge, home checklist and welcoming Skarrin. It merged as `bcd0bad5ef77f86a91783ad5f95b5b954683be08` after all five source jobs and all 62 exported cases passed in runs `41867138581` and `41867138211`; its tree matches the validated source. The earlier obsolete civic UI test expectation was corrected and verified.

[Windows 0.97.2](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.97.2) remains published. The four-runner release process is preserved; the export catalogue now includes 64 cases. PR rehearsals do not publish. See [release process](RELEASE_PIPELINE.md).

Next after this batch: more substantial restoration and optional collections, advanced transport/production adventures, and stronger late-act specialization. Existing rescue, ancestry, invasion, trial and Thane homecoming remain. Marriage/district expansion remain deferred. Campaign duration and normal-speed pacing need human playtesting.
