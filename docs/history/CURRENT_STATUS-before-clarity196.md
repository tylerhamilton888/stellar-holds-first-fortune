# Current status — 0.124.0 Under your own roof

**[0.124.0 — Under your own roof](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.124.0)** is public. [PR #189](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/189) merged after required checks and native visual review.

## Verified delivery

- Release source: `db5ab368fec1c9cc14768273a9fec6a099d53d18`; source merge: `5d46caa9e82b827f92e499ff66c921beefcf9aef`. Their trees match.
- [Release validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/44001746261): all 11 jobs passed, including all four native source groups, 78 exact-package cases / 14868 assertions, aggregate verification and publication.
- [PR validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/44001751339): all 6 jobs passed.
- Public assets: Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz.
- Windows ZIP: 964,846,727 bytes; SHA-256 `8dea90fbdcfb30cdcec4d4f07d40724245d1ec6f076b93cd33ad5ea755399f9d`.
- PCK SHA-256: `9fcc3b70e4e1505eb59666f4d54cb069f20a1e1d8cccdd05b4f4954ecf032bba`.

Downloaded both public JSON documents, verified their GitHub asset digests and matched version, clean source, PCK/ZIP hashes and ZIP size. The ZIP digest matches GitHub's asset digest. The release pipeline verified the full archive; it was not independently downloaded again.

## Delivered scope and review

Editable cottages now use continuous pitched slate, masonry gables and restrained timber framing from the existing architectural art. E at an exterior door enters or leaves a dedicated view of the actual connected rooms. Exterior roofs stay solid. Internal doors, paid finishes, room edits, possessions, stairs and worker/freight owners remain intact. No duplicate house or free furnishings are created.

Native review covered starter, expanded and two-storey exteriors/interiors beside the player. Cottage acceptance passed 17 assertions; revised frontier integration passed 338. Opening, room blueprints, upper floors, cellar, workers and freight passed, alongside 42 tooling tests. See [review](COTTAGE189.md).

The first broad gate caught the older frontier assertion expecting a walk-through doorway. It now checks collision and real E exit/re-entry. The successful run rebuilt and revalidated the complete corrected candidate; no failed candidate was published.

## Next work and limits

Playtest the new house presentation and E controls in a fresh fortune and an older save. Check expansions, interior doors, upstairs access and visible belongings. Normal Windows input/audio/performance and aesthetic preference still need human feedback. Preserve dwarven craft standards and the existing progression scope.

[Previous delivery](history/CURRENT_STATUS-before-cottage189.md).
