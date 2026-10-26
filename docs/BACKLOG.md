# Architectural collections — 0.77.0 candidate

Three compatible collections, independent finishes, matching interiors and visual construction menus are implemented. Native collection tests pass; release gates are pending. Review the actual mixed-material previews and room captures before accepting a new visual checkpoint.

Future scope: individually repositionable exterior windows/doors, arbitrary roof shapes, and assigning NPC households or businesses to new addresses. The current original frontage is a preserved architectural component; it is not advertised as per-window editing. Large empty rooms remain player-furnished. No unrelated progression or combat work is included.

# 0.76.0 — The Builders of Keldrath: published, verified and merged

All 22 prepared designs now share plans, exterior rendering, room geometry and player furnishing components. The Building Book offers furnished plans or empty shells, editable interiors, side/rear bays, five connected floors, rename/relocate/recover, private storage and real household/workshop services. Original painted fronts and household identities remain intact. Eastern building grounds have matching river/cliff boundaries. Existing construction and normal/test saves are preserved; older saves receive an exact pre-architecture backup.

Runtime source ff840c816d451e75babaf1fecdc3c776c8b8a1e2 and PR #43 merge 6ff9dc03b56624903d46debdd79990d8b1de97c9 share tree 2ae39e202456a24fab98af2df25f8d286a28fb72. Local native architecture verification passed 301 assertions; seven focused cases passed 343; the five-storey keyboard walkthrough passed 20. Original/player buildings, furnishings, menus and the eastern river boundary were visually reviewed. Source run 40249460487 passed all 30 gameplay cases plus people-preview.

Release run 40249459330 passed the package audit and all 20 exact-export cases (1,550 assertions), including all 301 architecture checks. Exported catalogue and royal-hall captures were reviewed. Downloaded build report and verification evidence match their GitHub digests; verified source, clean build report and uploaded ZIP metadata agree.

Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.76.0
Windows ZIP: 729,897,845 bytes; SHA256 1478b9f514d8e050de5e7160727fb368b110fdb5bd4b7e7a5fedc1610a588cf4. Extract the complete archive into a fresh folder. Windows device performance/audio remain hands-on testing. Painted façades remain reusable architectural styles; arbitrary per-window façade editing and NPC business/household assignment are not added here.

Try Title > Dev Testing > Construction & decorating. F9 offers the Building Book and eastern-grounds shortcuts. In normal play, O on the claim opens home improvements and the book; O inside a player building opens renovation. E uses stairs; Shift+E descends. Reopen F9 after a test-location shortcut.

Verified local architecture86-ground-verified.bundle and confirmed remote recovery/architecture86-ground-verified preserve the runtime source. The incremental bundle requires cf6fe48459d6c9a5c44707b57c1cb35c5c1ea25e and 217991b75e3878d047e643fba4097dcfcdc323a9, retained in the full dev-testing85-native-verified.bundle. Preserve all earlier backups/releases. Delivery documentation is separate from the verified runtime. See testing/architecture86.md.

# 0.75.0 — The Testing Grounds: delivered

Added four standalone title-screen testing presets with immediate locations, unlocks and supplies: combat, construction/decorating, mining/workstations and farming/fishing/cooking. F9 inside tests exposes reset/restock, enemy selection and hitboxes, building/work plans, and garden/river/kitchen shortcuts. Existing gameplay rules are reused. A dedicated marked test save preserves all normal slots; normal gameplay does not expose the test shortcut. One build flag hides the temporary entry points.

PR #41 merged after native visual review, 80 focused local assertions, all 29 source cases plus people-preview, and 19 exact-export cases / 1,249 assertions. Release 0.75.0 is published. See CURRENT_STATUS.md and testing/dev-testing85.md for source, evidence and hashes.

Next feedback: combat feel and enemy readability, build placement and collision, bench/hauling usability, and farming/fishing/cooking flow. Keep these presets temporary; disable HoldBuild.DEV_TESTING when preparing a build without test access. No new content milestone is included in this utility.

# Fantasy enemy roster — delivered in 0.74.0

PR #39 is merged; full source, native visual/behavior and exact-export gates passed. Release 0.74.0 is published.

Combat now uses explicit ground-plane body circles (player 10 px; goblin 12, beetle 14, orc 17, troll 26), shared sector geometry for hits and telegraphs, and a 3 px carbine projectile radius. Damage lands on the authored contact key at 52% of the action, once per strike, with direction locked through recovery. Brief 25–70 ms combat-only hit-stop, bounded wall-safe recoil, sparks and existing impact audio distinguish hits, blocks and parries. Hammers recoil farther; trolls resist displacement and retain stagger protection. F8 toggles a live hitbox inspection overlay. No global slowdown or camera shake is added.

Goblins, armored orcs and cave trolls have distinct art, animations, combat roles and material rewards. Preserve old encounters and the peaceful first mine floor. Next player feedback: movement readability, troll warning/defense clarity and difficulty of mixed encounters. More species, ranged enemy roles and bosses are later work; equipment instances and schematics remain the next Steel & Spoils milestone.

# Steel & Spoils — combat foundation delivered in 0.73.0

PR #37 is merged; source, native visual and exact-export gates passed and 0.73.0 is published. Next milestone: save-compatible equipment instances, material/workmanship definitions, salvage/study choices, persistent schematics and one memorable expedition feeding a useful crafted item. Preserve peaceful acquisition alternatives and the low-pressure sandbox. New weapon styles follow proven combat roles; no class or stamina rewrite. Seek player feedback on paired-enemy pacing and the shield/brace distinction.

# Faces of the Hold — delivered in 0.72.0

PR #35 is merged and 0.72.0 is published. Full source, focused native/visual and exact-export verification passed. See CURRENT_STATUS.md and testing/people82.md for the delivery record.

Next: fresh-player feedback on mine approach clarity, discoverability of personal conversations, readable gift/favor menus and People notebook usefulness. Test Windows hardware performance and audible quality.

Romance remains future work: four authored adult/single candidates have dormant metadata. Implement explicit reciprocal courtship and separate saved relationship stages only in a later directed milestone. Preserve friendship, services and character identity. Continue developing authored scenes and carefully promote background residents without rerolling their histories.

The validation push trigger follows the current master default branch while retaining main compatibility. No runtime changes are included in that delivery follow-up.

# Workstation quest — delivered in 0.71.2

Optional Ivar introduction, one-time timber, saved checklist, pause/resume and objective markers are implemented and verified. Next: fresh-player feedback on discoverability and clarity. Worksite construction remains optional; coal commissions do not require the lesson.

# 0.71.1 — A Clearer Path: published and verified

Quest journal hierarchy, status-grouped lessons, correct introduction targets, ancestral contact markers, paused quest browsing and readable footer are implemented. Existing saves/rewards and original artwork are preserved. Local final focused verification passed 117 assertions; journal, pack and settings screenshots reviewed at 1280×720. Hosted source run 40046866977 passed all 25 gameplay cases; release run 40046874975 passed the 3,263-entry PCK audit and all 15 exact-export cases.

Published: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.71.1
PR #31 merged as d88ff6fb236d8817ccc59d70329366668bdac852. Its tree c9bd0fd80b0e0fbce51fe67fbb04a425caf852fa matches tested release source e610b426b81642f778094e10a037a13a97f9c162. Windows ZIP: 725,124,683 bytes; SHA256 794ef4d6ca5f1810319f2f40198b0041639bbf9990ace12cac01ca9ff4099a75, matching clean build report and uploaded digest. Release includes verification evidence. Local menu80-final.bundle preserves the runtime checkpoint; prior releases/backups remain intact. Windows device performance and audio remain player testing.

# Royal Hall continuation — 0.71.0

- Implemented: expanded hall, shared royal standing/walking/sitting poses, top-down audience, mounted signs, gate bedrock and proportional architectural crops.
- Fixed during recovery: advancing audience dialogue no longer restarts the player's entrance.
- Published and verified. Remaining: player review of hall composition, movement pacing, mounted signs and gate readability. General lying-down poses across the character roster remain future work.

# Hearth & Homestead follow-up

0.70.0 implementation in progress. Player acceptance: crop readability, riverbank access, meal pacing, comfort clarity and household art alongside the approved Dwarfs. More crops, seasonal systems, brewing production and underground farming remain separate future work. Preserve the low-pressure sandbox: no penalties for leaving a hobby alone.

# Keldrath household and building identity

Implemented in Stone & Hearth: individual household identities/fronts/interiors, separate public façades, the Hall of Names and shared Copperkettle quarters with a double bed. Preserve the three wards, Great Stairs, real routes, services and saves. Player review should assess architectural weight and room composition. Broader city expansion and simulated household spouses/children remain future work; the existing nine residents and canonical couple are preserved.

# Workshop visual and interaction pass

Implemented upright fixed station art, removal of the redundant player bucket/rock overlay and automatic player bench output. Review the five props beside the approved Dwarf at gameplay scale and check the new output flow in an existing save. Deliberate storage withdrawal, field dressing and crew ownership remain unchanged. Broader work animations and transport redraws remain separate tasks.

# Roads & Hearths follow-up

Player review: physical crossing readability, countryside density, first-visit preparation time and recurring order prices. Broader regions, cross-region NPC work schedules, autonomous farm/forestry production, seasons and a streamed planet remain future work. Current local residents are ambient, and eastern farm crops are protected scenery. Retain the approved whole-character art and existing player-built sites. At 1280×720, work-board panels can extend the bottom keyboard-help footer below the viewport; delivery, lease, guide and close controls remain visible. Bound the shared shell in a focused UI follow-up.

# First-hour player feedback

Test planted axe/pick work, supplied station approaches, lesson clarity and furnishing the starter room. Measure Windows transitions with an existing 0.66 cache and a fresh character. No promise of zero cold-load time: whole painted frames still need initial preparation. Full brewing, new animation redraws and additional progression systems remain separate tasks.

# Hearth & Stone follow-up

Player acceptance of gait cadence and architecture remains important. This pass reuses whole painted action frames; it is not a full new animation set. Roofs depict existing solid building mass; no roof-access gameplay is added. Rugs currently dress authored interiors; a textile economy and player rug crafting remain future scope.

# Discipline follow-ups

- Brewing: dedicated production loop before earnable mastery and unlocks.
- Extend the first-tier discipline definitions with real craft-quality options, apprenticeships and research discoveries as those systems are implemented.
- Tune work thresholds with player sessions; preserve existing earned capabilities.

## After ancestral recognition
- Discuss and implement a readable personal development screen. Preserve existing productive-work counters; separate mastery, researched knowledge and civic standing. See PROGRESSION_NEXT.md.
- Expand the two-stage tablet investigation with bespoke narrative art or further field evidence only when it improves play. Current investigation and investiture use normal conversations, not new cinematics.
- Rescue workers are a bounded saved walking objective, not a general disaster simulation. No timed deaths or terrain resets.
- Player acceptance of the Thane development threshold: completed camp works, two crew, and provisions. Full governance, laws, taxation and communal-reserve authority are not implemented.

## After the Three Hearths refinement
- Player acceptance of ward identity, scenic depth and reduced captions; Windows hardware performance/audio still require device testing.
- Distant Works Below are scenery, not a playable fourth ward. New pressure machinery and training racks are decorations, not new production/combat systems.
- Preserve clear circulation when adding any future decor; escort routes and resident paths are release checks.

## After 0.63.0
Published and verified; remaining items below are follow-ups, not incomplete release gates.
- Player acceptance of Great Stair travel, hold scale, forge contact and nine household schedules. Target Windows performance/audio remain unverified locally.
- Expand other interiors and architectural variation after this playable forge/terrace milestone; distinct interior spaces remain intentional.
- Ordinary street rovers and story hosts do not have the new household schedule. New resident work is ambient, not economic production or an NPC hauling rewrite.
- Arbitrary overlapping floor occlusion, a full lighting/day simulation and seamless interiors remain future work. The implemented approach bounds rendering to active/visible adjacent wards.
- Cold preparation still does real work. Compiled navigation grids are discarded; further imported-asset caching should be measured independently.

## After 0.62.1
- Build efficiency: cold editor asset import took about 8–11 minutes on GitHub. Consider a versioned imported-asset cache; never cache saves. Identical-source gate reuse is now implemented, so release jobs need not duplicate full gameplay validation.
- Player acceptance of town side-walk cycles and stair continuity. Female identity 5 repeats its accepted passing pose on both passing beats; all figures remain whole painted frames. Do not redraw the accepted player gait.
- The lower-ward view is a clipped architectural cutaway. Fully continuous multi-floor occlusion, richer inhabited galleries and all-level population schedules are not complete.
- Bedside rest uses a short fade, not a new lying-down animation. A first letter home is implemented; recurring correspondence is not.
- Windows device performance/audio and remaining art acceptance require player feedback. Current changes do not rebalance Deepworks or timber work.

0.62.0: Residential galleries, nine enterable two-floor hearths, connected neighborhood stairs and continuous interior/ward floors implemented. Legacy private houses remain closed. Neighbor schedules are simple street/hearth cycles; full occupational simulation, broader architectural variety and a Windows export remain follow-ups. User visual acceptance remains required; do not describe the entire hold art backlog as complete.

0.61.3: Shared placement grid/validity, fine furniture placement and safe repositioning implemented. Broader animation coverage, environment scale/art acceptance and Windows packaging remain separate follow-ups. Test placement around doors, on upper storeys and beside storage in player sessions.

0.61.2: Title sprite parity and illustrated loading feedback implemented. First-time palette preparation and synchronous world generation remain performance follow-ups; repeat preparation now reuses disk-cached frames.

# Foundation follow-up

Completed source import and independent fresh-checkout validation. Use small reviewed changes for remaining main.gd responsibilities, confirmed dead renderer dependencies, and measured geometry/animation duplication. Preserve older art and tests; do not confuse historic suites with current gates.

# 0.61.0 follow-up

Completed: escort preparation gate, town cadence, shared animated hearths, fountain motion/outline removal, married cast surname. User playtest remains the art/pace acceptance check. Illustrated prologue plates and static idle dialogue poses are unchanged. Other existing backlog entries below remain separate.

# 0.60.0 follow-up
Completed: dedicated portraits for all fourteen identities and the Lord, source-pigment/fringe controls, native creator/dialogue/story/roster review, audience actor parity and a new Windows package. Do not restore the magnified idle sprite or old Lord portrait in active portrait controls.

Player acceptance of appearance and feel remains. Existing world/animation/material backlog below is retained, including log lift/put-down, cart pushing, more directional work/combat, tattoos and strict mirrored cargo handedness. Windows/audio/hardware performance needs the user's machine.

# Whole-motion59 follow-up

Completed: four-key equipped passing poses and continuous one-/two-shoulder cargo cycles for all fourteen identities, stop/walk source parity, reviewed hair/load continuity and supported tray contents. These supersede the matching older carry/gait/tray blockers below.

Remaining: dedicated log lift/put-down and cart-pushing art; directional work/combat contacts; ore-specific carried markings and broader prop/material parity; tattoos; strict anatomical cargo handedness across mirrored turns. Broader world architecture and Windows/audio/hardware validation are separate. Keep complete male beards and rerun palette coverage after new art. See testing/motion59.md.

# Folk-quality58 follow-up

Completed full-beard coverage for the former moustache-only male, proper male axe strokes, male3 equipped topknot, male4 cropped nape and female2 axe waves. Those specific entries in older notes are superseded. Completed targeted extraction repairs do not certify every old source edge.

Next animation gates remain: stable carry shoulders and mixed/double loads; equipped passing poses; broader material parity, tray occlusion, tattoos, lift-log and directional work contacts. Preserve full male beards and run the colour audit after new art. Read testing/quality58.md. No new Windows release or full visual acceptance.

# Animation-refinement58 follow-up

Rear equipped faces, bun/bob axe hair, the bob spade/rifle clipping and female reeling props have targeted corrections. Carry shoulders, double/mixed loads, passing gaits, older male4 rear plaits, male3 topknot, loose-wave axe hair, material parity, tray occlusion, tattoos and full work contacts remain. Rejected image generations must not be revived as accepted work. Read testing/refinement58.md.

# Highest priority — finish whole-character visual acceptance

Palette follow-up `palette-fix58`: residual source purple corrected and audited across all active sheets. Keep its output-color and protected-material tests for future asset changes. Do not use the former palette preview as acceptance evidence.

The complete-figure backend is active in **whole-integration-wip-58**; it is not release-ready. Correct the observed per-key shoulder swaps, hairstyle/facing drift, wrong work props and clipped source drawings listed in `art/whole-integration-58.md`. Finish material parity, tray occlusion, tattoos, directional contacts and passing poses. Preserve all saved sculpts/palettes; no old-head fallback. Review native moving sequences before packaging. Mechanical verification currently passes 98/98; artistic acceptance remains failed.

## After 0.57.0
- Replaced floating equipped tools with complete drawn grips and shortened/broadened Folk bodies. Await user judgement of silhouette, held/work transition and side steps.
- Equipped upper poses remain steady while the four drawn foot keys cycle. More per-step shoulder/arm variation and additional work/combat directions are future art refinements; do not claim a full animation redraw.
- Shared cargo sprites/carry poses remain. Broader Keldrath architecture, older mine/exterior props, industrial NPC jobs and prior world backlog are unchanged.
- Windows/audio/hardware performance remain player checks. Do not treat passing mechanical tests as visual acceptance.

## After 0.56.0
- Repaired reported detached heads, weak side-step footwork, clipping mugs/hands, jumping tool hand and major oversized room furniture. Shared furniture sprites now support player construction and actual bases.
- User acceptance of the repaired native motion/reference likeness is still needed. Some rear-quarter/pushing directions share drawings; further direction-specific work/combat art remains.
- Remaining old mine furniture primitives, exterior ornaments and broader Keldrath architecture/interior atmosphere have not all been converted. Do not call every world asset modernized.
- Windows/audio and performance on the user's machine remain unverified. Existing NPC raw-workstation/industrial hauling and larger-world backlog remains; no new industry systems in this repair.

## After 0.55.1
- Resolved cave landmark reload identity, missing base collision and actor depth sorting.
- For unusually dense legacy sites where no nearby landmark relocation fits, inspect the preserved pre-551 save rather than regenerating terrain.
- Retain existing .55 backlog below. Windows/audio and Defender acceptance remain unverified.

## After 0.55.0
- Player acceptance of the 10–15 minute site-development goal: excavation weight, mineral value, field-versus-bench convenience, hauling and sound. Tune from actual feedback; preserve 150-unit/s unladen travel and one-owner material records.
- Existing miners/automation remain functional. Raw-workstation NPC operation and dedicated industrial hauling jobs are still deferred; do not claim those are implemented.
- Retain .54 reference art, previous world/interior scope and the unresolved Defender follow-up. Current scans use October 11 definitions and cannot establish a Windows Defender verdict.

## After 0.54.0
- Player acceptance of the October 19 reference interpretation, walk/carry/work contact, smaller world scale, slower planted mining and Windows Keldrath performance. Keep native evidence and compare new work at gameplay size.
- Expand the connected world and give Keldrath richer districts/interiors and daily activity. The new facades/vault do not finish this larger request. Replace remaining older props/interior treatments to match the new Folk.
- Add further directional pushing/station/combat drawings, wardrobe/armor silhouettes and richer NPC production/transport jobs without changing save ownership or quest continuity.
- Follow up with a current Windows Defender result for the exact .54 ZIP; the prior .53 detection is unresolved. Local scans do not establish Microsoft's verdict.

## After 0.53.1
- SEC-01: Obtain a current Windows Defender result for the exact .53.1 ZIP. The original .53.0 MalUri detection remains unexplained; local ClamAV and source inspection cannot settle Microsoft's verdict. Leave any flagged build blocked. Do not prescribe antivirus exclusions.
- Packaging now uses the official release runtime and separate PCK. Preserve the previous versions for recovery, not as a recommendation to run a flagged package. Existing .53 gameplay limitations remain.

## After 0.53.0
Player-test loaded travel, practice pacing, aimed strikes and the short rest on Windows with sound. Add further authored directional combat/guard/pushing poses, richer enemy navigation and vehicle footprint/turning clearance only after this playable baseline. House-stair transport, convoy/NPC cart jobs and raw-station/farm automation remain deferred. Preserve one-owner cargo and permanent encounter outcomes. Dedicated practice and outdoor/mine cart passage integration are now implemented; historical entries below describe earlier states.

## After 0.52.0
Player-test the new arrival escort, bed/chest objectives, gait, hand grips and directional cargo at normal speed. Windows launcher and audible balance remain acceptance checks. Further authored directional work/pushing poses and dedicated top-down sparring remain follow-up. Retain the now-tested introductory quest/save continuity and collision-checked route. Do not reopen the world layout or labor systems merely to refine a pose. Cross-zone wagon travel and raw-station/farm automation remain deferred.

## After 0.51.0
Player acceptance of work contacts, carry silhouettes, Windows launch and audio. Refine the short gait cycles, additional directional work/haul poses and remaining older prop styles beside the gold-standard Dwarfs. Implement general cart/wagon portal and Z navigation with cargo conservation before claiming cross-zone logistics. Raw-workstation/farm NPC operation, more crop/fish species and broader schedules remain future work. Preserve the existing verified mining and industry automation.

## After 0.50.0
Player acceptance of Windows build, audio, wayfinding and collision. Extend ambient routes into richer schedules only without removing reliable quest/service access. Dedicated sparring remains the existing combat mode behind the new top-down practice hall. Retain labeled private homes; expansion into additional enterable residences is future work. Existing Hands of the Dwarf deferred work below remains open.

0.49.2 follow-up: corrected tavern sip pose/mug facing and stray empty bucket; new original tankard/bucket. Full hand-drawn action atlases remain outside this targeted polish pass.

0.49.2 completed: mine/workshop art continuity, corrected sprite bounds, shared old haulage artwork and illustrated catalog. Full mastery and new-station automation remain deferred.

0.49.1 completed: irregular mine faces and saved-damage-driven chips/fractures. Deeper physical simulation is not introduced; existing Hands deferred work remains.

## After 0.49.0 — continue the attached Hands of the Dwarf brief
Complete D/E: forgiving optional skilled smithing, output quality and full personal mastery paths distinct from technology. Complete F for new raw-resource facilities: shared NPC input reservations/hauling/processing, forge blueprints, cart transfer through legitimate portals/stairs, deterministic geological specimens. Retain the now-working A–C loops, one-owner resource invariant and shared raw material visuals. Existing automation is retained, not replaced.

## After 0.48.0
Player-test the unified directional rig, shoulder seams, work timing and adaptive 1–0 hotbar. Further animation refinements should keep this one gameplay rig; do not restore legacy side/contact silhouettes. Separate practice-bay combat remains a future task. Food/water remain existing production supplies; no new eating/stamina system was added.

## After 0.47.0
Playtest house scale, material costs, multilevel building ergonomics and directional movement. Buildings support five storeys plus their roof deck, with construction access protected during recovery. Further work: fully authored directional work/combat cycles, freeform city modification, surface worker building jobs and unified house/mine excavation coordinates. Practice bay remains legacy combat. No implied completion of these systems.

## After 0.46.0
Playtest the walkable hold/trail/claim loop and local chest ownership on Windows. Expand directional sprites and homestead building variety after feedback. Retained practice bay remains a future top-down combat task. Do not introduce compulsory processing chains or stamina grind.

## After 0.45.1
Compact original mason’s mallet replaces the full mining hammer at the bench. Its raised pose stays beside the face, the striking face meets the chisel cap at the material-contact phase, and worker sound/chips follow the saved job clock. Duplicate worker chisel rendering is removed. The bench has a bevelled slab, braced timber legs and iron fixings; partial dressing now reads the correct bench cell before the drawing offset. Existing menus remain bounded with fixed tabs and scrolling.
Human checks remaining: Windows launcher, audible impact balance and subjective animation feel.

## After 0.45.0
Stone block → stockpile → mason's bench → dressed floor, teaching quest and NPC handover now ship. Player-test contact/carrying animation, supply-range clarity and blocked-route recovery. Extend to more dressed furnishings only after acceptance. Broader brewing and profession skills remain deferred.

## After 0.44.0
Completed in 0.45.0: rough stone blocks → existing stockpile → mason’s bench → dressed building stone, with manual work then NPC delegation. Basic rubble construction preserved.
Player-test passages/quest wording, new anniversary pacing and room improvement feedback. Apply LIVING_WORKS_DESIGN.md to future specialist work: useful outcomes and earned delegation, no trivial XP loops. Brewing, NPC craft skill and optional precision/masterwork interactions are not yet implemented.

## After 0.43.1
Visual/menu pass completed. Next: human player feedback on feel/readability, Windows execution and larger worker/room populations.

## After 0.43.0
Player acceptance/Windows validation; room-board usability; optional tavern/storage types and brewing; richer schedules and habitat conditions. Rails/powered freight, surface habitats and larger society remain deferred. Do not describe flavor drink preferences as a brewing system.

# Backlog
## Critical bugs
- BUG-01: No new release-blocking gameplay defect established during organization; classify incoming reports by reproducible steps before changing code.
- BUG-02: Investigate ObjectDB/resource warnings at test shutdown. Done when the cause is documented and relevant shutdowns are clean, or a bounded test-only lifetime is demonstrated.
## Current milestone: reliable first season and mining
- MINE-01: Player-test Deepworks 0.41.0 held mining, directional contact and five-depth return routes on Windows.
- MINE-02: Tune geology/yields, survey readability and long-running multi-depth crew; add ramps/hoists and dedicated directional character art after acceptance.
- OPEN-01: Complete a fresh opening through first commission and royal audience. Done when every quest/host/route is understandable and no scene/menu blocks progress.
- WOOD-01: Player-test Pinewood 0.40.0. Fell a fir, recover its logs, reload, build with the timber and return by map. Confirm aiming, sound level and resource balance feel good.
## Weight of the Mountain follow-up
- HAUL-01: Player-test bucket64/cart320 capacity, contact rhythm, low/rich yields and return cadence on Windows. Preserve the no-loss/no-slowdown contract.
- RAIL-01: Next logistics milestone: short physical rail routes and cargo carts using DeepHaul transfers. Save track/vehicle XY and depth; test blocked track, station loading and reload conservation. No rail gameplay ships in 0.42.
- HAUL-02: Powered freight/elevators and explicit worker haul tasks after rail acceptance. Existing crews already deliver directly; do not remove that advantage without a replacement.
- GOAL-01: Reservations and broader construction goals only after the current ledger is player-tested.
## Near-term priorities
- SAVE-01: Test a copy of a real older player save. Done when identity, inventory, excavation and quests survive documented migrations.
- QA-01: Run the Windows launcher on Windows. Done when launch, audio, save/reload and mining are checked on the target platform.
- QA-02: Triage older tests against current behavior. Done when selected test purposes and obsolete assumptions are documented, without weakening valid gates.
- UX-01: Audit only reported menu/appearance issues. Done when the reproduced issue is fixed and its affected view is visually verified.
## Future systems
- FAMILY-01: Marriage, descendants and succession. Define a small playable milestone before implementation.
- SPACE-01: First playable ship and interstellar travel; current construction/launch scaffolding does not satisfy this.
- SKILL-01: Personal skill progression and richer equipment discoveries, separate from hold research.
## Long-term ambitions
Procedural civilizations, diplomacy, acquisitions, galactic markets, corporate/national empire management, immortal Greatbeard, and Dwarven Worldforging. These are vision items, not current commitments or finished systems.

