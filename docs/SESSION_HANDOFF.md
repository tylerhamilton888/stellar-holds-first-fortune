# Current handoff — worker routes, in progress

Published baseline: **0.110.0**, source merged through PR #158 and delivery docs through #159. See [CURRENT_STATUS](CURRENT_STATUS.md). Latest verified master at recovery: `6963c58`.

Active branch: `feature/estate-worker-routes`. User requested the next blueprint piece: household-worker navigation. Implementation is in `scripts/estate_workers.gd`, integrated with the existing mine agent loop, surface renderer and Building Book. It connects recruited miners to actual household beds through built floors, upper stairs and cellar stairs, preserving mine assignments and saved positions. See [WORKERS160](WORKERS160.md).

New acceptance case `workers160` is registered for source and exact-package checks. Local checks are pending; the fresh workspace is importing assets using pinned Godot 4.4.1. Test evidence belongs in `test-results/workers160-*`. No release, merge or completed validation is claimed yet.

Remaining: finish focused native tests and visual review, tooling checks, review changes, prepare the source/version PR and verified release, then reconcile delivery docs. Preserve older releases and saves. Follow [release procedure](RELEASE_PIPELINE.md). Automated freight is the next separate blueprint piece; provisional-property story integration remains deferred.
