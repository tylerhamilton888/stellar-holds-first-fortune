# Recovery and checkpoint workflow
Persistent folder: `The Stellar Holds - Development`. PROJECT_INDEX.md is the entry point; filenames are versioned. No remote is configured, and nothing was pushed.

## Restore the organized project
Download/materialize `Stellar-Holds-0.40.0.bundle` and run:
```sh
git clone Stellar-Holds-0.40.0.bundle stellar-holds
git -C stellar-holds switch -c work pinewood-0.40.0
```
The bundle is self-contained: source, original assets, UIDs and all baseline/checkpoint commits/tags. A clone may set `origin` to the local bundle file; this is not a hosted remote. Do not push to it. Git configuration/credentials and Godot caches are not bundled. Open `project.godot` in Godot 4.4.1 and let imports rebuild.

Fallback: `Stellar-Holds-0.40.0-Source.zip` contains the same tracked files. Earlier unchanged `Stellar-Holds-0.39.1-Source.zip`, Library ID `libfile_663631733a748191afb26b65f5486949`, version 8. This lacks continuity documentation; pair it with the documentation ZIP. Original Windows release ID: `libfile_b2bd6ec7b5a88191af8e5138564dacbe`, version 55. It is unchanged by this task. No user saves or external engine executable are needed to restore source; install Godot separately.

## Before/after meaningful work
Check `git status`; preserve unrelated work. Create a local commit/tag before risky changes. Never delete old backups. After focused verification, update status/changelog and commit, then `git bundle create <new-version>.bundle --all`. Verify the bundle, clone to a fresh directory, compare tracked-file hashes, and save it persistently. Update the index only after storage succeeds. Keep working and stable checkpoints distinct when tests fail.

Temporary workspace files alone are not backups. Persistent Library saves must be confirmed by successful per-file results. Use current Library tools/skills; never rely on expired download URLs. Remote configuration/push requires user authorization.
