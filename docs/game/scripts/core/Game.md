# Game Class Reference

*File:* `scripts/core/Game.gd`
*Inherits:* `Node`

## Synopsis

```gdscript
extends Node
```

## Brief

Game flow and globals.

## Detailed Description

Central coordinator that manages scene transitions, difficulty, and access
to global services. Orchestrates the campaign loop: menus → briefing →
tactical map → debrief → unit management.

## Public Member Functions

- [`func ready() -> void`](Game/functions/ready.md)
- [`func _ready() -> void`](Game/functions/_ready.md)
- [`func goto_scene(path: String) -> void`](Game/functions/goto_scene.md) — Change to scene at `path`; logs error if missing.
- [`func select_campaign(campaign: CampaignData) -> void`](Game/functions/select_campaign.md) — Set current campaign and emit `signal campaign_selected`.
- [`func select_save(save_id: StringName) -> void`](Game/functions/select_save.md) — Set current save and emit `signal save_selected`.
- [`func select_scenario(scenario: ScenarioData) -> void`](Game/functions/select_scenario.md) — Set current mission and emit `signal mission_selected`.
- [`func set_scenario_loadout(loadout: Dictionary) -> void`](Game/functions/set_scenario_loadout.md) — Set current mission loadout and emit `signal mission_loadout_selected`
- [`func start_scenario(prim: Array[String]) -> void`](Game/functions/start_scenario.md) — Start mission
- [`func update_loop(dt: float) -> void`](Game/functions/update_loop.md) — Call from mission tick.
- [`func complete_objective(id: StringName) -> void`](Game/functions/complete_objective.md) — Complete objective
- [`func fail_objective(id: StringName) -> void`](Game/functions/fail_objective.md) — Fail objective
- [`func record_casualties(fr: int, en: int) -> void`](Game/functions/record_casualties.md) — Record casualties
- [`func record_unit_lost(count: int = 1) -> void`](Game/functions/record_unit_lost.md) — record lost units
- [`func end_scenario_and_go_to_debrief() -> void`](Game/functions/end_scenario_and_go_to_debrief.md) — End mission and navigate to debrief
- [`func get_replacement_pool() -> int`](Game/functions/get_replacement_pool.md) — Return available replacements pool
- [`func set_replacement_pool(v: int) -> void`](Game/functions/set_replacement_pool.md) — Set replacement pool (non-persistent placeholder)
- [`func get_current_units() -> Array`](Game/functions/get_current_units.md) — Return current units in context for screens that need them.
- [`func save_campaign_state() -> void`](Game/functions/save_campaign_state.md)

## Public Attributes

- `PackedScene debug_display_scene`
- `int campaign_replacement_pool` — Personnel replacements available for pre-mission reinforcement
- `CanvasLayer debug_display`
- `CampaignData current_campaign`
- `StringName current_save_id`
- `ScenarioData current_scenario`
- `Dictionary current_scenario_loadout`
- `Dictionary current_scenario_summary`
- `MissionResolution resolution`

## Signals

- `signal campaign_selected(campaign_id: StringName)` — Emitted when a campaign is selected.
- `signal save_selected(save_id: StringName)` — Emitted when a save is selected.
- `signal scenario_selected(mission_id: StringName)` — Emitted when a mission is selected.
- `signal scenario_loadout_selected(loadout: Dictionary)` — Emitted when a mission loadout is selected

## Member Function Documentation

### ready

```gdscript
func ready() -> void
```

### _ready

```gdscript
func _ready() -> void
```

### goto_scene

```gdscript
func goto_scene(path: String) -> void
```

Change to scene at `path`; logs error if missing.

### select_campaign

```gdscript
func select_campaign(campaign: CampaignData) -> void
```

Set current campaign and emit `signal campaign_selected`.

### select_save

```gdscript
func select_save(save_id: StringName) -> void
```

Set current save and emit `signal save_selected`.

### select_scenario

```gdscript
func select_scenario(scenario: ScenarioData) -> void
```

Set current mission and emit `signal mission_selected`.

### set_scenario_loadout

```gdscript
func set_scenario_loadout(loadout: Dictionary) -> void
```

Set current mission loadout and emit `signal mission_loadout_selected`

### start_scenario

```gdscript
func start_scenario(prim: Array[String]) -> void
```

Start mission

### update_loop

```gdscript
func update_loop(dt: float) -> void
```

Call from mission tick.

### complete_objective

```gdscript
func complete_objective(id: StringName) -> void
```

Complete objective

### fail_objective

```gdscript
func fail_objective(id: StringName) -> void
```

Fail objective

### record_casualties

```gdscript
func record_casualties(fr: int, en: int) -> void
```

Record casualties

### record_unit_lost

```gdscript
func record_unit_lost(count: int = 1) -> void
```

record lost units

### end_scenario_and_go_to_debrief

```gdscript
func end_scenario_and_go_to_debrief() -> void
```

End mission and navigate to debrief

### get_replacement_pool

```gdscript
func get_replacement_pool() -> int
```

Return available replacements pool

### set_replacement_pool

```gdscript
func set_replacement_pool(v: int) -> void
```

Set replacement pool (non-persistent placeholder)

### get_current_units

```gdscript
func get_current_units() -> Array
```

Return current units in context for screens that need them.
Prefer Scenario.units entries, but fall back to unit_recruits.

### save_campaign_state

```gdscript
func save_campaign_state() -> void
```

## Member Data Documentation

### debug_display_scene

```gdscript
var debug_display_scene: PackedScene
```

### campaign_replacement_pool

```gdscript
var campaign_replacement_pool: int
```

Decorators: `@export`

Personnel replacements available for pre-mission reinforcement

### debug_display

```gdscript
var debug_display: CanvasLayer
```

### current_campaign

```gdscript
var current_campaign: CampaignData
```

### current_save_id

```gdscript
var current_save_id: StringName
```

### current_scenario

```gdscript
var current_scenario: ScenarioData
```

### current_scenario_loadout

```gdscript
var current_scenario_loadout: Dictionary
```

### current_scenario_summary

```gdscript
var current_scenario_summary: Dictionary
```

### resolution

```gdscript
var resolution: MissionResolution
```

## Signal Documentation

### campaign_selected

```gdscript
signal campaign_selected(campaign_id: StringName)
```

Emitted when a campaign is selected.

### save_selected

```gdscript
signal save_selected(save_id: StringName)
```

Emitted when a save is selected.

### scenario_selected

```gdscript
signal scenario_selected(mission_id: StringName)
```

Emitted when a mission is selected.

### scenario_loadout_selected

```gdscript
signal scenario_loadout_selected(loadout: Dictionary)
```

Emitted when a mission loadout is selected
