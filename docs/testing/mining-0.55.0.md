# Working the Mountain — 0.55.0 verification
2026-10-19 UTC. Baseline: `reference-0.54.0`, preserved as `pre-mining-0.55.0`. New checkpoint: `mining-0.55.0`.

## Actual validation
Godot 4.4.1 on Linux, native Xvfb/OpenGL llvmpipe rendering, isolated save directories and Dummy audio. Tests instantiated the existing main scene. Source and exported-pack tests used actual input where identified below. The exported Windows PCK was run with the Linux Godot editor executable; this is not Windows execution or a native Linux release-template test.

| Check | Passed | Scope |
|---|---:|---|
| mining55.gd | 38 | Held contacts, interruption by movement, physical ore, field work, racks, stonebreaker, cart batch collection, mastery, lamp/support benefits, bounded two-face split, old-save copy and real passage inputs with a load on the landing |
| handworks55.gd | 32 | Craft/placement costs, single-owner raw transfers, interrupted bench work, output collection, house construction, timber processing, cart movement and independent Pinewood cuts/regrowth |
| test_deepworks55.gd | 45 | Headless model/integration: deterministic geology, five levels, discoveries, connected stairs, return/craft/sell, old saves, physical crew routes, automation assignments and slagcaster |
| site55.gd | 17 | Native input route on untouched seed 5755 terrain: recovered-stone construction, rack/breaker/cart loop, wall-adjacent working stance, cavern breakthrough, actual lode recovery on two depths, return and persistence |
| pack55.gd | 14 | Exported title/hold/trail entry, held fracture, physical load/field dressing, connected depths, cavern discovery, save/reload and return |

132 source checks plus 14 exported-pack checks passed. Shutdown still reports retained ObjectDB/resources (4–9 resources in the focused native runs); there were no script/gameplay errors in the successful final runs. These pre-existing teardown warnings are not counted as gameplay failures.

The natural route opened **51 faces**, travelled **5,640 world units**, established its equipment from delivered materials, found a cavern, recorded **four formations**, and left **47 persistent raw loads** for further hauling. It exercised about **182 seconds of scripted game time**, with direct prepared input and no human planning pauses. The fixture starts after the introductory commissions with 12 additional timber and 2 iron; it does not grant stone or alter terrain. This demonstrates the integrated loop, not proof that a human 10–15 minute session feels satisfying. Use PLAYTEST_GUIDE.md for that acceptance check.

## Visual review and fixes
Inspected native anticipation/contact/fracture stages; one and two-face openings; ore on the shoulder, rack, station and cart; field work; support pillars; survey and naturally developed galleries. The existing reference-led full-body drawings remain authoritative. Registered work positioning and foreground tool drawing keep hammer contact on the actual breaker load. A shared raw renderer preserves mineral markings at every ownership stage. No new image atlas or rotated-limb animation was introduced.

The route caught and resolved two concrete problems: nearby racks stealing the selected bench during approach/collection, and a bench beside a wall selecting a colliding stance. Working position now checks the entire Dwarf footprint along the approach and can use the other side. Moving manually releases station focus. Real stair interactions take priority over loose cargo on their exact landing.

Native evidence is in `testing/mining-0.55.0/`. The focused worksite screenshots use controlled fixtures; `site/` uses the original generated terrain and actual excavated paths. Original .54 screenshots and all original artwork remain intact.

## Package and recovery
The final source hashes match the fresh build input manifest. All **2,670 PCK entries** passed relative-path, bounds and per-file checksum validation; the audit rejects external executable scripts and native extensions. The ZIP passed CRC and member-hash checks.

ClamAV 1.5.3 scanned **2,828 component/source files** including the independently unpacked PCK, then the final ZIP separately (1.30 GiB scanned). Both final scans reported zero detections. Daily definitions are **October 11, 2026**, older than seven days. The former .53.0 Defender download detection remains unresolved. These checks do not establish a Windows Defender verdict or guarantee that a package is malware-free. No editor, installer or batch launcher is shipped.

The Windows executable remains byte-identical to the verified official Godot 4.4.1 release template:
`b493c1d53fb915f7805f360cfe42d1c3126e720dfc234a4b0f2feb99200f9a4b`

Final ZIP SHA-256:
`a81148daeda85062f9e17840bfa5998b87121c71b8ffa8ab9ad85da697a5c234`
Final PCK SHA-256:
`27e2c3c82d35bd58156e8d3f3928dc92720e9c98a2c53421b34d776f15af6f1b`

The new Git bundle and source update are incremental after .54. Recovery.txt records the exact commit/tree and independent restoration verification. Existing canonical archives and recovery bundles are preserved; only reproducible import/export/audit staging was cleared. Temporary runtime/tools and incomplete transfer fragments were relocated with their paths preserved; no remote was changed or pushed.

Windows execution, audible impact balance, subjective pacing and the human 10–15 minute development goal remain player acceptance checks. Raw-workstation NPC operation and full industrial hauling jobs remain deferred; existing mining/industry/crew automation is retained and tested.
