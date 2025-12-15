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

Start playtest mode from the scenario editor

## Public Member Functions

- [`func ready() -> void`](Game/functions/ready.md)
- [`func _ready() -> void`](Game/functions/_ready.md)
- [`func goto_scene(path: String) -> void`](Game/functions/goto_scene.md) — Change to scene at `path`; logs error if missing.
- [`func _on_window_size_changed() -> void`](Game/functions/_on_window_size_changed.md)
- [`func _apply_video_perf_settings() -> void`](Game/functions/_apply_video_perf_settings.md)
- [`func _compute_content_scale_size(window_size: Vector2i, target_size: Vector2i) -> Vector2i`](Game/functions/_compute_content_scale_size.md)
- [`func select_campaign(campaign: CampaignData) -> void`](Game/functions/select_campaign.md) — Set current campaign and emit `signal campaign_selected`.
- [`func select_save(save_id: StringName) -> void`](Game/functions/select_save.md) — Set current save and emit `signal save_selected`.
- [`func delete_save(save_id: StringName) -> void`](Game/functions/delete_save.md)
- [`func select_scenario(scenario: ScenarioData) -> void`](Game/functions/select_scenario.md) — Set current mission and emit `signal mission_selected`.
- [`func set_scenario_loadout(loadout: Dictionary) -> void`](Game/functions/set_scenario_loadout.md) — Set current mission loadout and emit `signal mission_loadout_selected`
- [`func start_scenario(prim: Array[String]) -> void`](Game/functions/start_scenario.md) — Start mission
- [`func update_loop(dt: float) -> void`](Game/functions/update_loop.md) — Call from mission tick.
- [`func complete_objective(id: StringName) -> void`](Game/functions/complete_objective.md) — Complete objective
- [`func set_objective_state(id: StringName, state: MissionResolution.ObjectiveState) -> void`](Game/functions/set_objective_state.md) — Set objective state wrapper
- [`func fail_objective(id: StringName) -> void`](Game/functions/fail_objective.md) — Fail objective
- [`func record_casualties(fr: int, en: int) -> void`](Game/functions/record_casualties.md) — Record casualties
- [`func record_unit_lost(count: int = 1) -> void`](Game/functions/record_unit_lost.md) — record lost units
- [`func end_scenario_and_go_to_debrief() -> void`](Game/functions/end_scenario_and_go_to_debrief.md) — End mission and navigate to debrief
- [`func on_debrief_continue(_payload: Dictionary) -> void`](Game/functions/on_debrief_continue.md) — Handle continue from debrief scene
- [`func on_debrief_retry(_payload: Dictionary) -> void`](Game/functions/on_debrief_retry.md) — Handle retry from debrief scene
- [`func on_medal_assigned(medal: String, recipient_name: String) -> void`](Game/functions/on_medal_assigned.md) — Handle medal assignment in debrief
- [`func get_current_units() -> Array`](Game/functions/get_current_units.md) — Return current units in context for screens that need them.
- [`func _award_experience_to_units() -> void`](Game/functions/_award_experience_to_units.md) — Award experience to playable units after mission completion.
- [`func _snapshot_mission_start_states(scenario: ScenarioData) -> void`](Game/functions/_snapshot_mission_start_states.md) — Snapshot unit states at mission start (for replay support).
- [`func restore_unit_states_from_save(scenario: ScenarioData) -> void`](Game/functions/restore_unit_states_from_save.md) — Restore unit states from the current campaign save.
- [`func save_campaign_state() -> void`](Game/functions/save_campaign_state.md)
- [`func end_playtest() -> void`](Game/functions/end_playtest.md) — End playtest mode and return to editor

## Public Attributes

- `PackedScene debug_display_scene`
- `CanvasLayer debug_display`
- `CampaignData current_campaign`
- `StringName current_save_id`
- `CampaignSave current_save`
- `ScenarioData current_scenario`
- `Dictionary current_scenario_loadout`
- `Dictionary current_scenario_summary`
- `PlayMode play_mode`
- `String playtest_return_scene`
- `Dictionary playtest_history_state`
- `String playtest_file_path`
- `int _base_msaa_3d`
- `SceneTreeTimer _video_perf_timer`
- `MissionResolution resolution`

## Public Constants

- `const _DEFAULT_RESOLUTIONS: Array[Vector2i]`

## Signals

- `signal campaign_selected(campaign_id: StringName)` — Emitted when a campaign is selected.
- `signal save_selected(save_id: StringName)` — Emitted when a save is selected.
- `signal save_deleted(save_id: StringName)` — Emitted when a save is deleted.
- `signal scenario_selected(mission_id: StringName)` — Emitted when a mission is selected.
- `signal scenario_loadout_selected(loadout: Dictionary)` — Emitted when a mission loadout is selected

## Enumerations

- `enum PlayMode` — Play mode determines navigation flow and UI behavior

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

### _on_window_size_changed

```gdscript
func _on_window_size_changed() -> void
```

### _apply_video_perf_settings

```gdscript
func _apply_video_perf_settings() -> void
```

### _compute_content_scale_size

```gdscript
func _compute_content_scale_size(window_size: Vector2i, target_size: Vector2i) -> Vector2i
```

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

### delete_save

```gdscript
func delete_save(save_id: StringName) -> void
```

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

### set_objective_state

```gdscript
func set_objective_state(id: StringName, state: MissionResolution.ObjectiveState) -> void
```

Set objective state wrapper

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

### on_debrief_continue

```gdscript
func on_debrief_continue(_payload: Dictionary) -> void
```

Handle continue from debrief scene

### on_debrief_retry

```gdscript
func on_debrief_retry(_payload: Dictionary) -> void
```

Handle retry from debrief scene

### on_medal_assigned

```gdscript
func on_medal_assigned(medal: String, recipient_name: String) -> void
```

Handle medal assignment in debrief
Awards bonus experience to the recipient unit

### get_current_units

```gdscript
func get_current_units() -> Array
```

Return current units in context for screens that need them.
Prefer Scenario.playable_units entries, but fall back to unit_recruits.

### _award_experience_to_units

```gdscript
func _award_experience_to_units() -> void
```

Award experience to playable units after mission completion.
Base XP for survival, bonus for success.

### _snapshot_mission_start_states

```gdscript
func _snapshot_mission_start_states(scenario: ScenarioData) -> void
```

Snapshot unit states at mission start (for replay support).
This captures the unit state BEFORE the mission begins, so replays start fresh.

### restore_unit_states_from_save

```gdscript
func restore_unit_states_from_save(scenario: ScenarioData) -> void
```

Restore unit states from the current campaign save.
Called when a scenario is selected to apply persistent state across missions.
If replaying a mission, restores from the snapshot taken BEFORE that mission.

### save_campaign_state

```gdscript
func save_campaign_state() -> void
```

### end_playtest

```gdscript
func end_playtest() -> void
```

End playtest mode and return to editor

## Member Data Documentation

### debug_display_scene

```gdscript
var debug_display_scene: PackedScene
```

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

### current_save

```gdscript
var current_save: CampaignSave
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

### play_mode

```gdscript
var play_mode: PlayMode
```

### playtest_return_scene

```gdscript
var playtest_return_scene: String
```

### playtest_history_state

```gdscript
var playtest_history_state: Dictionary
```

### playtest_file_path

```gdscript
var playtest_file_path: String
```

### _base_msaa_3d

```gdscript
var _base_msaa_3d: int
```

### _video_perf_timer

```gdscript
var _video_perf_timer: SceneTreeTimer
```

### resolution

```gdscript
var resolution: MissionResolution
```

## Constant Documentation

### _DEFAULT_RESOLUTIONS

```gdscript
const _DEFAULT_RESOLUTIONS: Array[Vector2i]
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

### save_deleted

```gdscript
signal save_deleted(save_id: StringName)
```

Emitted when a save is deleted.

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

## Enumeration Type Documentation

### PlayMode

```gdscript
enum PlayMode
```

Play mode determines navigation flow and UI behavior
