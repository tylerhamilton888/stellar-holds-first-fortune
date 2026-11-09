# Living forges — implementation and maintenance

Keldrath keeps its 1020 × 650 established forge, resident work shifts, anvil, storage and three benches. New Stonebridge communal forges use an 820 × 520 plan with a cold coal hearth, bellows, Borin, two benches and shared stores. New player workshops start at 640 × 385 with a working hearth/anvil/bench cluster, fuel, quench barrel, tool rack and storage. Existing building extensions still expand their actual rooms.

Saved building `rooms`, furniture positions and chest contents remain authoritative. Never resize an existing workshop automatically. Legacy workshop records without a `rooms` field retain the original forge template. New templates apply only when a building is created.

Furnaces open smelting, anvils open tools/equipment, and benches open crafting. These use the existing recipes, production queue, resources, equipment and research. Automation research adds a bench-side Industry prompt and additional workpiece dressing; it does not award an automaton or bypass the industry requirements. Communal restoration still belongs to Cold Forge/ledger progression. Cold means no fire glow, bellows cycling or smith strikes; restored activity shares the existing clock. No decorative steam implies an actual quench event.

Each physical anvil is rendered by the furniture system. The surface smith draws his pose/workpiece/sparks, not another anvil. The older side-view renderer retains its own anvil. Never hide every furnishing of a type because an actor draws a similar prop.

Dynamic public fixtures derive their collisions from the same accepted prop list as rendering, reject overlaps with saved furniture/storage, and preserve the exit. Player furniture remains movable. Avoid adding blocking decorations dynamically to player rooms after a research unlock. Workstation prompts must match physical stations and remain reachable from the entrance; permissions must accept the furnace as well as the bench in a valid workshop.

Run `tools/check.py --suite living_forges148` with Godot 4.4.1 on a native display. The new scenario captures ordinary and collision views of the cold/restored communal forge, starter/industry player workshop and Keldrath. It verifies station access, real menu routing and old/new save persistence. `forge147` exercises actual restoration and smelting; integration cases cover the ledger, opening, equipment and architecture. Broader source validation follows the repository planner.

Keep screenshots and full logs as files. Never print base64, data URLs, archive bytes or complete historical logs into a chat. Show a small manifest, use the image viewer, and report observed tool errors by step. These controls reduce avoidable conversation payload growth; they do not repair ChatGPT server state or guarantee that its size limit cannot be reached.
