# Cross-profession components — 0.117.0

## Scope

**0.118.0 extension:** [Borin’s commissions](COMMISSIONS175.md) provide a paid alternative without player research. Requirements below describe self-manufacture and self-assembly.

The existing reinforced pick is the first combined-craft product. No additional tool tier or duplicate production system is introduced. A shaped haft costs 2 timber; a forged pickhead costs 6 iron and 3 coal; fittings cost 2 iron and 2 copper. Assembly costs one of each and retains the existing steel-pick, Reinforced tools, lit-forge and locality requirements. Previously owned picks retain their additive ownership flag and full mining capability.

All three recipes use the existing State queue, completion, inventory and save systems. The communal workshop exposes a Tool components page with exact inputs, output and profession. Hafts have no research requirement; head and fittings use Reinforced tools. No ingredient depends on basalt or the reinforced pick. Ordinary steel crafting stays at 5 iron and 2 timber.

HoldDisciplines credits completed haft batches to Woodworking and completed head/fittings batches to Smithing. Queueing, buying and assembly grant no manufacturing credit. Existing market transactions sell all components, including before research; assembly still checks its knowledge. A player can manufacture all parts, buy all parts or mix both routes. Existing item artwork is reused for timber, metal and fittings.

## Verification

Extended frontier103 covers cold/remote/unknown-tech rejection, unchanged raw cost, queued save/reload, exact outputs and craft credit, missing-part atomicity, partial and full purchasing routes, remote/duplicate assembly, owned-tool reload and basalt use. menu92 selects every component with a full pack to check the character summary remains visible. These cases also run against the exact exported package through the existing harness.

Five focused native cases passed 483 assertions; 42 tooling tests passed. Reviewed the component page, assembly and full-pack selection; all three recipes fit without scrolling, while the inventory grid scrolls independently to preserve the character summary. All 11 release jobs passed, including 77 exact-package cases / 14631 assertions. CURRENT_STATUS.md records publication evidence. Ordinary Windows playtesting is separate from automated validation. Specialist commissions are implemented in 0.118.0; broader advanced equipment remains a later extension.
