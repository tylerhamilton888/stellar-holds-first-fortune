# Current status — 2026-11-12

## Published Windows build

**[0.107.0 — Surface room blueprints](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.107.0)** is published. [Source PR #152](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/152) merged after all required checks passed.

- Release source: `e20067f7d564b186ea3fce60a919f926b143c577`; source tree: `bf8e1e3fa0803df8a760ecb058eb9ddb600bae97`.
- Merge commit: `38112580276aa98c3a7b3cfd640f8e53b56b80aa`.
- [Successful release run](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43270053006): 82 native source cases, 72 exact-package cases, aggregate verification and publication passed.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/43269561230) passed all four gameplay groups and its aggregate gate.
- Published assets confirmed: Windows ZIP, build.json, release-summary.json, verification-evidence.tar.gz.
- Windows ZIP: 964,671,095 bytes; GitHub asset SHA-256 `6fea0bf3b1b0022d44943ba1c6911e8c47565c8837191dc7f5178c07cbb2763d`.

The publication gate revalidated the exact source, PCK and ZIP against the verification receipt before upload. Post-publication asset names, sizes and digests were checked through GitHub. Direct retrieval of the two JSON asset bodies was unavailable through the connected reader after the local execution environment disconnected; no independent post-upload metadata-body comparison is claimed.

## Delivered scope

Building Book (**O**) → **Plan Your Holding** supports saved ground-floor rooms/corridors, optional designation, shared materials, doorways, nearby construction, progress and research-gated finishes. Furnishings supply actual function. Removing a plan leaves structures and possessions intact. See [feature notes](BLUEPRINTS.md), [directive](BLUEPRINT_DIRECTIVE.md) and [playtest guide](PLAYTEST_GUIDE.md).

Local acceptance passed 566 native assertions: blueprints 61, furnished manor 47, architecture styles 60, architecture 347, LivingWorks 51. Tooling passed 42 tests. Native screenshots were reviewed; the furnished manor covers mixed-use rooms, stocked storage, renovation, manual stairs and save/reload.

## Next work and limits

Normal-speed Windows input, audio, performance and enjoyment still need player testing. Excavation planning (Stage B), unified multilevel estates (Stage C) and provisional property-story changes remain deferred. Existing manual stairs remain supported.

Preserve previous releases and saves. Use [release procedure](RELEASE_PIPELINE.md) for future delivery and bounded diagnostics. The local command environment disconnected after source acceptance; the committed source and published artifacts are authoritative. Earlier first-hour evidence remains in [history](history/CURRENT_STATUS-before-blueprints152.md).
