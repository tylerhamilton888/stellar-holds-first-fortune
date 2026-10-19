# Packaging and security verification — 0.53.1

The .53.0 Windows ZIP was detected as Trojan:Win32/MalUri.A!cl during download and reported Removed. No game execution was reported. The cause remains unknown; this report does not classify it as a false positive.

## Changes
- Fresh standard Windows release export from source checkpoint `playability-0.53.0`, with the title label updated to .53.1. No gameplay, art, save-format or save-directory changes.
- FirstFortune.exe and separate FirstFortune.pck. No bundled editor, batch launcher, installer, updater or native extension.
- Export preset keeps the official runtime bytes unmodified and disables the console wrapper. The official template is unsigned; no publisher signing certificate was added.
- Retained prior releases and added repeatable PCK inspection in tools/audit_release_pck.py. All old backups remain preserved.

## Provenance and content checks
Godot 4.4.1 Linux build tool and complete official export-template archive were fetched/checked against the SHA512-SUMS.txt published in the godotengine/godot-builds 4.4.1-stable release. See compiler-provenance.json and template-provenance.json. Exported FirstFortune.exe is byte-identical to the official windows_release_x86_64.exe:

`b493c1d53fb915f7805f360cfe42d1c3126e720dfc234a4b0f2feb99200f9a4b`

Clean import and export used an isolated copy of tracked source with no inherited .godot import cache. The resulting runtime source inputs were compared to the working project; only the version label differs from .53.0. Source review found no process execution, shell launching, network API calls, dynamic code creation or native-extension use. Review includes all FileAccess/DirAccess/OS calls: local resources, game saves/backups, capture paths and test arguments. This limited static review is not a formal security proof.

The 2,639 PCK entries were checked for relative paths, duplicate entries, in-bounds data and matching entry MD5, then SHA-256 inventoried and unpacked separately for scanning. No embedded executable, DLL, shell/PowerShell script or native extension. See pck-inventory.json. ZIP CRC and SHA-256 equality of every archived member against staging passed. FILE-HASHES.sha256 is included in the download.

## Malware scanning
ClamAV 1.5.3, official main v63, daily v28150 (2026-10-11 06:26 UTC), bytecode v339; 3,628,164 known signatures. All three database digital signatures verified successfully. The latest available daily database here is over seven days old. The updater cannot switch users in this environment, and the direct database endpoint refused access. Databases were instead obtained from the documented official clamav/clamav:stable distribution, image dated 2026-10-12; its manifest/layer digests were checked. See docker-provenance.json.

Component/source/old-ZIP scan: exit 0, 2,796 files, **0 infected files**, 2.99 GiB scanned. This covers new exported components, independently unpacked new PCK entries, all game scripts, and the .53.0 outer ZIP. The original PCK was not independently unpacked for that scan. Scan limits were raised to 600 MiB per file / 1,500 MiB per archive; limit-exceeded alerts were enabled, per-file time cutoff disabled, and no limit-exceeded/error result appeared. Full log: clamav-components.log.txt.

Final downloadable ZIP scan: exit 0, **0 infected files**, 1.24 GiB scanned, no errors or limit-exceeded alerts. The exact SHA-256 below identifies the scanned download. Full log: clamav-final-zip.log.txt.

A clean ClamAV result cannot establish a current Microsoft Defender verdict or guarantee absence of malware. Windows/Defender execution is unavailable here. No project was uploaded to an external malware-sharing service. Leave any newly flagged package blocked; do not bypass protection or add exclusions. Investigate any further detection using its exact affected item and Microsoft analysis.

## Packaged gameplay verification
The exact Windows-exported PCK was booted with the verified official Linux **release** runtime under Xvfb/llvmpipe with isolated save data. Passed title display, current character/weapon/combat rendering, rest, new game, mine entry, a matching-coordinate descent/ascent, and resource/depth save-reload. The persistence harness uses explicit failure branches rather than release-disabled assertions. Captures title/practice/strike/rest were reviewed. No content changes were required.

The title-only and first render harness emitted the pre-existing ObjectDB/five-resources-at-shutdown warning; the persistence harness exited cleanly. No gameplay load/parser/runtime errors were observed. This is native Linux release validation, not a claim that Windows was executed. Prior .53.0 gameplay regression results remain historical, not rerun counts for this packaging update.

## Package identity
ZIP: Stellar-Holds-First-Fortune-0.53.1-Windows.zip
Bytes: 354393303
SHA-256: eb05e75e2cac42fe64556a827eb4646d0a8935c0cedd12a99d6afd8571590dcd

Official references:
- https://github.com/godotengine/godot-builds/releases/tag/4.4.1-stable
- https://docs.godotengine.org/en/4.4/tutorials/export/exporting_for_windows.html
- https://docs.clamav.net/manual/Installing/Docker.html
