# scenes/
Packed scenes that compose the game flow.

## Key Scenes
- `main_menu.tscn` — Entry point, options, quit.
- `campaign_select.tscn` — Choose campaign / difficulty.
- `mission_select.tscn` — Branching missions, score gates.
- `briefing.tscn` — Loads `data/briefs/` and presents objectives.
- `unit_select.tscn` — Deployment and roster adjustments.
- `hq_table.tscn` — 3D/2D hybrid command-post (radios, documents).
- `tactical_map.tscn` — Core mission map with tools & markers.
- `debrief.tscn` — Results, score, persistence write-back.
- `unit_mgmt.tscn` — Between-mission roster/logistics.

## System Scenes
- `system/<scene>.tscn` — Utility scenes

## Scene Contracts
- Scenes emit `request_transition(target: String, payload := {})` for `Game.gd`.
- `tactical_map.tscn` expects `SimWorld` autoload or injected node.
- UI scenes should not access disk directly; go through managers.
