# Current Windows release procedure

Workflow authority: [.github/workflows/windows-release.yml](../.github/workflows/windows-release.yml). Coverage rules: [VALIDATION_POLICY.md](VALIDATION_POLICY.md). [CURRENT_STATUS.md](CURRENT_STATUS.md) identifies the verified published build; merged source alone is not a delivered Windows release.

## Prepare a requested release

1. Read current status, handoff and AGENTS.md. Confirm the requested changes, reviewed source commit and completed focused checks/visual review. Preserve existing releases and saves.
2. Set the new version in `scripts/build_info.gd`, the authoritative build metadata. Confirm that its release tag does not already exist. Update RELEASE_NOTES.md and CHANGELOG.md, preserving superseded notes in history. Open the source/version PR.
3. When publication is requested, create `release/<version>` at the exact reviewed commit. The branch suffix must match the build version. PR validation and release checks may overlap; merge the PR only after its required checks pass. Do not change an active release branch merely to update delivery documentation.
4. Monitor the release run through publication. Use bounded summaries; retain complete logs and evidence in files. A queued/running display alone is not a reason to restart a run.

## Triggers and gates

- A push to `release/<version>` starts the publishing pipeline.
- A manual **Verified Windows release** run is a full, non-publishing rehearsal, even when launched on a release branch.
- Ordinary PR validation selects affected cases with conservative full-source fallback. It does not automatically build a Windows package.
- Each release run builds one clean ZIP and independently runs all four native source groups against its own exact source. It does not borrow acceptance from an ancestor or another PR.
- Four package workers verify the same candidate bytes and test the exported PCK. The aggregate verifier requires every current exported case exactly once, passing results and matching source/package/archive identity.
- Publication requires build, source, package and verification success. It rechecks the candidate and refuses to replace an existing release.

Use the workflow's pinned engine/runtime installers and captured commands. A local export or focused test pass cannot replace complete release acceptance. Current suite membership comes from the manifests, not historical case counts in reports.

## Verify delivery and consolidate instructions

After publication, confirm the release is public and its named Windows ZIP, build.json, release-summary.json and verification-evidence.tar.gz are uploaded. Check version/source and matching PCK/ZIP hashes in the published metadata and receipt; confirm the ZIP size agrees with the release asset.

Record the release URL, exact source, run, results and limitations in CURRENT_STATUS.md. Update SESSION_HANDOFF.md and BACKLOG.md so completed delivery is not described as pending. Review README.md, PLAYTEST_GUIDE.md, RELEASE_NOTES.md and any affected feature audit for obsolete downloads, controls or installation instructions. Keep general download links on `releases/latest`; current status and the release's notes hold the specific version.

Put superseded procedures in clearly linked history files rather than appending them below current instructions. Keep the current playtest guide and this procedure concise. Record delivery documentation on a separate docs branch and merge after its checks pass. Documentation-only corrections do not need a new game version or Windows rebuild.

## Evidence and retry

Candidate and package-shard transfer artifacts last one day; aggregated evidence lasts seven days and is retained permanently as a release asset. Retry failed jobs only while their exact candidate remains available. If it has expired or the candidate changes, rebuild and rerun the complete source/package verification; do not reuse proof for different bytes. Missing artifact transfers block acceptance.

Native visual review and normal-speed Windows/input/audio playtesting retain their separate roles. Historical timing measurements and superseded ancestor-gate instructions are preserved in [pipeline history](history/RELEASE_PIPELINE-before-doc-consolidation-2026-11-10.md), not current procedure.
