# Current status — 2026-11-10

## Living Forges source complete

PR #140 merged as `a009d0e363a318360b349620a06e226904bfe8ca`. All 80 native source scenarios and the final hosted gate passed (run 42730685187). Local acceptance also passed 9 scenarios / 858 assertions, with 42 tooling tests. Twelve captures were recorded; cold/restored communal, starter/industry player and Keldrath views were inspected with collision overlays.

New communal/player workshops have distinct practical layouts and physical smelting/anvil/bench services. Cold Forge restoration controls coal heat, bellows, smith activity and ambience. Existing saved room dimensions, placed objects and storage are preserved. Sten's patrol is clear and each visible anvil has one rendering owner.

## Windows delivery

The 0.104.0 candidate built successfully at commit `1b3d34ee4703834b5107998529013a8f04915b0a`. Release run 42731501280 is still checking all 80 native and 70 exported-package scenarios. It may publish only after verification succeeds. Live latest release remains v0.103.0 until confirmed otherwise.

## Conversation-size safeguards

PR #141/#142 are merged: bounded production output, file-only capture, safe diagnostics, CI evidence artifacts and automated output-policy tests. Active backlog and release notes now also have enforced budgets, with historical text preserved unchanged. Current recovery documents remain compact.

The reported HTTP 413 / conversation_too_large is established, but its exact triggering payload and platform threshold are unknown. These safeguards reduce known repository hazards; they cannot guarantee ChatGPT backend reliability. See CONVERSATION_OUTPUT.md.
