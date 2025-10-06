# ScenarioEditor Class Reference

*File:* `scripts/editors/ScenarioEditor.gd`
*Class name:* `ScenarioEditor`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name ScenarioEditor
extends Control
```

## Brief

Path to return to main menu scene

## Detailed Description

Active scenario data resource bound to the editor UI

Global undo/redo history stack for scenario edits

## Public Member Functions

- [`func _ready()`](ScenarioEditor/functions/_ready.md) — Initialize context, services, signals, UI, and dialogs
- [`func _init_file_dialogs() -> void`](ScenarioEditor/functions/_init_file_dialogs.md) — Create and configure FileDialog instances
- [`func _setup_scene_tree_signals() -> void`](ScenarioEditor/functions/_setup_scene_tree_signals.md) — Connect scene tree selection to selection service
- [`func _rebuild_scene_tree() -> void`](ScenarioEditor/functions/_rebuild_scene_tree.md) — Rebuild the left scene tree and restore selection
- [`func _on_ctx_selection_changed(payload: Dictionary) -> void`](ScenarioEditor/functions/_on_ctx_selection_changed.md) — Handle palette selections (units, tasks, triggers)
- [`func _open_slot_config(index: int) -> void`](ScenarioEditor/functions/_open_slot_config.md) — Open slot configuration dialog for a slot index
- [`func _open_unit_config(index: int) -> void`](ScenarioEditor/functions/_open_unit_config.md) — Open unit configuration dialog for a unit index
- [`func _open_task_config(task_index: int) -> void`](ScenarioEditor/functions/_open_task_config.md) — Open task configuration dialog for a task index
- [`func _open_trigger_config(index: int) -> void`](ScenarioEditor/functions/_open_trigger_config.md) — Open trigger configuration dialog for a trigger index
- [`func _start_place_task_tool(task: UnitBaseTask) -> void`](ScenarioEditor/functions/_start_place_task_tool.md) — Begin Task placement tool with a given task prototype
- [`func _start_place_unit_tool(payload: Variant) -> void`](ScenarioEditor/functions/_start_place_unit_tool.md) — Begin Unit/Slot placement tool with a given payload
- [`func _start_place_trigger_tool(proto: ScenarioTrigger) -> void`](ScenarioEditor/functions/_start_place_trigger_tool.md) — Begin Trigger placement tool with a trigger prototype
- [`func _place_unit_from_tool(u: UnitData, pos_m: Vector2) -> void`](ScenarioEditor/functions/_place_unit_from_tool.md) — Place a Unit at world position (meters) and push to history
- [`func _place_slot_from_tool(slot_def: UnitSlotData, pos_m: Vector2) -> void`](ScenarioEditor/functions/_place_slot_from_tool.md) — Place a player slot at world position (meters) and push to history
- [`func _place_trigger_from_tool(inst: ScenarioTrigger, pos_m: Vector2) -> void`](ScenarioEditor/functions/_place_trigger_from_tool.md) — Place a Trigger at world position (meters) and push to history
- [`func _set_tool(tool: ScenarioToolBase) -> void`](ScenarioEditor/functions/_set_tool.md) — Set or clear current tool and wire its signals
- [`func _clear_tool() -> void`](ScenarioEditor/functions/_clear_tool.md) — Clear current tool
- [`func _clear_hint() -> void`](ScenarioEditor/functions/_clear_hint.md) — Remove all hint widgets from the hint bar
- [`func _on_overlay_gui_input(event: InputEvent) -> void`](ScenarioEditor/functions/_on_overlay_gui_input.md) — Handle overlay input: hover, drag, link, select, and tool input
- [`func _unhandled_key_input(event)`](ScenarioEditor/functions/_unhandled_key_input.md) — Global key handling: delete, undo/redo, and tool input
- [`func _delete_pick(pick: Dictionary) -> void`](ScenarioEditor/functions/_delete_pick.md) — Route deletion to the correct entity handler
- [`func _delete_unit(unit_index: int) -> void`](ScenarioEditor/functions/_delete_unit.md) — Delete a unit and all its tasks; reindex references; push history
- [`func _delete_slot(slot_index: int) -> void`](ScenarioEditor/functions/_delete_slot.md) — Delete a slot; push history and refresh
- [`func _delete_task(task_index: int) -> void`](ScenarioEditor/functions/_delete_task.md) — Delete a task; repair chain links and reindex; push history
- [`func _delete_trigger(trigger_index: int) -> void`](ScenarioEditor/functions/_delete_trigger.md) — Delete a trigger; push history and refresh
- [`func _on_filemenu_pressed(id: int)`](ScenarioEditor/functions/_on_filemenu_pressed.md) — File menu actions (New/Open/Save/Save As/Back)
- [`func _on_attributemenu_pressed(id: int)`](ScenarioEditor/functions/_on_attributemenu_pressed.md) — Attributes menu actions (Edit Scenario/Briefing/Weather)
- [`func _cmd_save() -> void`](ScenarioEditor/functions/_cmd_save.md) — Save to current path or fallback to Save As
- [`func _cmd_save_as() -> void`](ScenarioEditor/functions/_cmd_save_as.md) — Show Save As dialog with suggested filename
- [`func _cmd_open() -> void`](ScenarioEditor/functions/_cmd_open.md) — Show Open dialog (asks to discard if dirty)
- [`func _on_open_file_selected(path: String) -> void`](ScenarioEditor/functions/_on_open_file_selected.md) — Handle file selection to open a scenario
- [`func _on_save_file_selected(path: String) -> void`](ScenarioEditor/functions/_on_save_file_selected.md) — Handle file selection to save a scenario
- [`func _on_new_scenario(d: ScenarioData) -> void`](ScenarioEditor/functions/_on_new_scenario.md) — Apply brand-new scenario data from dialog
- [`func _on_update_scenario(_d: ScenarioData) -> void`](ScenarioEditor/functions/_on_update_scenario.md) — Apply edits to current scenario data from dialog
- [`func _on_data_changed() -> void`](ScenarioEditor/functions/_on_data_changed.md) — Refresh UI/overlay/tree after data changes
- [`func _update_title() -> void`](ScenarioEditor/functions/_update_title.md) — Update window title label from scenario title
- [`func _on_history_changed(past: Array, future: Array) -> void`](ScenarioEditor/functions/_on_history_changed.md) — Rebuild history side panel from UndoRedo stacks
- [`func _next_slot_key() -> String`](ScenarioEditor/functions/_next_slot_key.md) — Generate next unique slot key (SLOT_n)
- [`func _generate_trigger_id() -> String`](ScenarioEditor/functions/_generate_trigger_id.md) — Generate next unique trigger id (TRG_n)
- [`func _generate_callsign(affiliation: ScenarioUnit.Affiliation) -> String`](ScenarioEditor/functions/_generate_callsign.md) — Compute next available callsign for given affiliation
- [`func _get_callsign_pool(affiliation: ScenarioUnit.Affiliation) -> Array[String]`](ScenarioEditor/functions/_get_callsign_pool.md) — Get callsign pool for faction (uses defaults if scenario lacks overrides)
- [`func _collect_used_callsigns(affiliation: ScenarioUnit.Affiliation) -> Dictionary`](ScenarioEditor/functions/_collect_used_callsigns.md) — Build set of already-used callsigns for uniqueness checks
- [`func _generate_unit_instance_id_for(u: UnitData) -> String`](ScenarioEditor/functions/_generate_unit_instance_id_for.md) — Generate unique unit instance id based on UnitData.id
- [`func _confirm_discard() -> bool`](ScenarioEditor/functions/_confirm_discard.md) — Confirm discarding unsaved changes; returns true if accepted
- [`func _show_info(msg: String) -> void`](ScenarioEditor/functions/_show_info.md) — Show a non-blocking info toast/dialog with a message
- [`func _snapshot_arrays() -> Dictionary`](ScenarioEditor/functions/_snapshot_arrays.md) — Deep-copy key arrays for history operations
- [`func _queue_free_children(node: Control)`](ScenarioEditor/functions/_queue_free_children.md) — Utility: queue_free all children of a UI container

## Public Attributes

- `ScenarioData data`
- `ScenarioHistory history`
- `FileDialog _open_dlg`
- `FileDialog _save_dlg`
- `MenuButton file_menu`
- `MenuButton attribute_menu`
- `Label title_label`
- `TerrainRender terrain_render`
- `NewScenarioDialog new_scenario_dialog`
- `ScenarioWeatherDialog weather_dialog`
- `ScenarioEditorOverlay terrain_overlay`
- `HBoxContainer tool_hint`
- `Label mouse_position_label`
- `Tree scene_tree`
- `VBoxContainer history_list`
- `Button unit_faction_friend`
- `Button unit_faction_enemy`
- `OptionButton unit_category_opt`
- `LineEdit unit_search`
- `Tree unit_list`
- `ItemList task_list`
- `ItemList trigger_list`
- `SlotConfigDialog _slot_cfg`
- `UnitConfigDialog _unit_cfg`
- `TaskConfigDialog _task_cfg`
- `TriggerConfigDialog _trigger_cfg`
- `TabContainer _tab_container1`

## Public Constants

- `const DEFAULT_FRIENDLY_CALLSIGNS: Array[String]` — Default NATO-style callsigns used for friendly units when none provided
- `const DEFAULT_ENEMY_CALLSIGNS: Array[String]` — Default adversary callsigns used for enemy units when none provided

## Member Function Documentation

### _ready

```gdscript
func _ready()
```

Initialize context, services, signals, UI, and dialogs

### _init_file_dialogs

```gdscript
func _init_file_dialogs() -> void
```

Create and configure FileDialog instances

### _setup_scene_tree_signals

```gdscript
func _setup_scene_tree_signals() -> void
```

Connect scene tree selection to selection service

### _rebuild_scene_tree

```gdscript
func _rebuild_scene_tree() -> void
```

Rebuild the left scene tree and restore selection

### _on_ctx_selection_changed

```gdscript
func _on_ctx_selection_changed(payload: Dictionary) -> void
```

Handle palette selections (units, tasks, triggers)

### _open_slot_config

```gdscript
func _open_slot_config(index: int) -> void
```

Open slot configuration dialog for a slot index

### _open_unit_config

```gdscript
func _open_unit_config(index: int) -> void
```

Open unit configuration dialog for a unit index

### _open_task_config

```gdscript
func _open_task_config(task_index: int) -> void
```

Open task configuration dialog for a task index

### _open_trigger_config

```gdscript
func _open_trigger_config(index: int) -> void
```

Open trigger configuration dialog for a trigger index

### _start_place_task_tool

```gdscript
func _start_place_task_tool(task: UnitBaseTask) -> void
```

Begin Task placement tool with a given task prototype

### _start_place_unit_tool

```gdscript
func _start_place_unit_tool(payload: Variant) -> void
```

Begin Unit/Slot placement tool with a given payload

### _start_place_trigger_tool

```gdscript
func _start_place_trigger_tool(proto: ScenarioTrigger) -> void
```

Begin Trigger placement tool with a trigger prototype

### _place_unit_from_tool

```gdscript
func _place_unit_from_tool(u: UnitData, pos_m: Vector2) -> void
```

Place a Unit at world position (meters) and push to history

### _place_slot_from_tool

```gdscript
func _place_slot_from_tool(slot_def: UnitSlotData, pos_m: Vector2) -> void
```

Place a player slot at world position (meters) and push to history

### _place_trigger_from_tool

```gdscript
func _place_trigger_from_tool(inst: ScenarioTrigger, pos_m: Vector2) -> void
```

Place a Trigger at world position (meters) and push to history

### _set_tool

```gdscript
func _set_tool(tool: ScenarioToolBase) -> void
```

Set or clear current tool and wire its signals

### _clear_tool

```gdscript
func _clear_tool() -> void
```

Clear current tool

### _clear_hint

```gdscript
func _clear_hint() -> void
```

Remove all hint widgets from the hint bar

### _on_overlay_gui_input

```gdscript
func _on_overlay_gui_input(event: InputEvent) -> void
```

Handle overlay input: hover, drag, link, select, and tool input

### _unhandled_key_input

```gdscript
func _unhandled_key_input(event)
```

Global key handling: delete, undo/redo, and tool input

### _delete_pick

```gdscript
func _delete_pick(pick: Dictionary) -> void
```

Route deletion to the correct entity handler

### _delete_unit

```gdscript
func _delete_unit(unit_index: int) -> void
```

Delete a unit and all its tasks; reindex references; push history

### _delete_slot

```gdscript
func _delete_slot(slot_index: int) -> void
```

Delete a slot; push history and refresh

### _delete_task

```gdscript
func _delete_task(task_index: int) -> void
```

Delete a task; repair chain links and reindex; push history

### _delete_trigger

```gdscript
func _delete_trigger(trigger_index: int) -> void
```

Delete a trigger; push history and refresh

### _on_filemenu_pressed

```gdscript
func _on_filemenu_pressed(id: int)
```

File menu actions (New/Open/Save/Save As/Back)

### _on_attributemenu_pressed

```gdscript
func _on_attributemenu_pressed(id: int)
```

Attributes menu actions (Edit Scenario/Briefing/Weather)

### _cmd_save

```gdscript
func _cmd_save() -> void
```

Save to current path or fallback to Save As

### _cmd_save_as

```gdscript
func _cmd_save_as() -> void
```

Show Save As dialog with suggested filename

### _cmd_open

```gdscript
func _cmd_open() -> void
```

Show Open dialog (asks to discard if dirty)

### _on_open_file_selected

```gdscript
func _on_open_file_selected(path: String) -> void
```

Handle file selection to open a scenario

### _on_save_file_selected

```gdscript
func _on_save_file_selected(path: String) -> void
```

Handle file selection to save a scenario

### _on_new_scenario

```gdscript
func _on_new_scenario(d: ScenarioData) -> void
```

Apply brand-new scenario data from dialog

### _on_update_scenario

```gdscript
func _on_update_scenario(_d: ScenarioData) -> void
```

Apply edits to current scenario data from dialog

### _on_data_changed

```gdscript
func _on_data_changed() -> void
```

Refresh UI/overlay/tree after data changes

### _update_title

```gdscript
func _update_title() -> void
```

Update window title label from scenario title

### _on_history_changed

```gdscript
func _on_history_changed(past: Array, future: Array) -> void
```

Rebuild history side panel from UndoRedo stacks

### _next_slot_key

```gdscript
func _next_slot_key() -> String
```

Generate next unique slot key (SLOT_n)

### _generate_trigger_id

```gdscript
func _generate_trigger_id() -> String
```

Generate next unique trigger id (TRG_n)

### _generate_callsign

```gdscript
func _generate_callsign(affiliation: ScenarioUnit.Affiliation) -> String
```

Compute next available callsign for given affiliation

### _get_callsign_pool

```gdscript
func _get_callsign_pool(affiliation: ScenarioUnit.Affiliation) -> Array[String]
```

Get callsign pool for faction (uses defaults if scenario lacks overrides)

### _collect_used_callsigns

```gdscript
func _collect_used_callsigns(affiliation: ScenarioUnit.Affiliation) -> Dictionary
```

Build set of already-used callsigns for uniqueness checks

### _generate_unit_instance_id_for

```gdscript
func _generate_unit_instance_id_for(u: UnitData) -> String
```

Generate unique unit instance id based on UnitData.id

### _confirm_discard

```gdscript
func _confirm_discard() -> bool
```

Confirm discarding unsaved changes; returns true if accepted

### _show_info

```gdscript
func _show_info(msg: String) -> void
```

Show a non-blocking info toast/dialog with a message

### _snapshot_arrays

```gdscript
func _snapshot_arrays() -> Dictionary
```

Deep-copy key arrays for history operations

### _queue_free_children

```gdscript
func _queue_free_children(node: Control)
```

Utility: queue_free all children of a UI container

## Member Data Documentation

### data

```gdscript
var data: ScenarioData
```

### history

```gdscript
var history: ScenarioHistory
```

### _open_dlg

```gdscript
var _open_dlg: FileDialog
```

### _save_dlg

```gdscript
var _save_dlg: FileDialog
```

### file_menu

```gdscript
var file_menu: MenuButton
```

### attribute_menu

```gdscript
var attribute_menu: MenuButton
```

### title_label

```gdscript
var title_label: Label
```

### terrain_render

```gdscript
var terrain_render: TerrainRender
```

### new_scenario_dialog

```gdscript
var new_scenario_dialog: NewScenarioDialog
```

### weather_dialog

```gdscript
var weather_dialog: ScenarioWeatherDialog
```

### terrain_overlay

```gdscript
var terrain_overlay: ScenarioEditorOverlay
```

### tool_hint

```gdscript
var tool_hint: HBoxContainer
```

### mouse_position_label

```gdscript
var mouse_position_label: Label
```

### scene_tree

```gdscript
var scene_tree: Tree
```

### history_list

```gdscript
var history_list: VBoxContainer
```

### unit_faction_friend

```gdscript
var unit_faction_friend: Button
```

### unit_faction_enemy

```gdscript
var unit_faction_enemy: Button
```

### unit_category_opt

```gdscript
var unit_category_opt: OptionButton
```

### unit_search

```gdscript
var unit_search: LineEdit
```

### unit_list

```gdscript
var unit_list: Tree
```

### task_list

```gdscript
var task_list: ItemList
```

### trigger_list

```gdscript
var trigger_list: ItemList
```

### _slot_cfg

```gdscript
var _slot_cfg: SlotConfigDialog
```

### _unit_cfg

```gdscript
var _unit_cfg: UnitConfigDialog
```

### _task_cfg

```gdscript
var _task_cfg: TaskConfigDialog
```

### _trigger_cfg

```gdscript
var _trigger_cfg: TriggerConfigDialog
```

### _tab_container1

```gdscript
var _tab_container1: TabContainer
```

## Constant Documentation

### DEFAULT_FRIENDLY_CALLSIGNS

```gdscript
const DEFAULT_FRIENDLY_CALLSIGNS: Array[String]
```

Default NATO-style callsigns used for friendly units when none provided

### DEFAULT_ENEMY_CALLSIGNS

```gdscript
const DEFAULT_ENEMY_CALLSIGNS: Array[String]
```

Default adversary callsigns used for enemy units when none provided
