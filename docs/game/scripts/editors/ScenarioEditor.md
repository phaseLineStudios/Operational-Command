# ScenarioEditor Class Reference

*File:* `scripts/editors/ScenarioEditor.gd`
*Class name:* `ScenarioEditor`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name ScenarioEditor
extends Control
```

## Public Member Functions

- [`func _ready()`](ScenarioEditor/functions/_ready.md) — Initialize context, services, signals, UI, and dialogs
- [`func _setup_scene_tree_signals() -> void`](ScenarioEditor/functions/_setup_scene_tree_signals.md) — Connect scene tree selection to selection service
- [`func _rebuild_scene_tree() -> void`](ScenarioEditor/functions/_rebuild_scene_tree.md) — Rebuild the left scene tree and restore selection
- [`func _on_ctx_selection_changed(payload: Dictionary) -> void`](ScenarioEditor/functions/_on_ctx_selection_changed.md) — Handle palette selections (units, tasks, triggers)
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
- [`func _on_edit_menu_pressed(id: int) -> void`](ScenarioEditor/functions/_on_edit_menu_pressed.md) — Handle Edit menu actions (Undo/Redo).
- [`func _on_update_scenario(_d: ScenarioData) -> void`](ScenarioEditor/functions/_on_update_scenario.md)
- [`func _on_briefing_update(new_brief: BriefData) -> void`](ScenarioEditor/functions/_on_briefing_update.md) — Apply briefing change via history (undoable).
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
- [`func _rebuild_command_list() -> void`](ScenarioEditor/functions/_rebuild_command_list.md) — Rebuild the custom commands list from scenario data
- [`func _on_new_command() -> void`](ScenarioEditor/functions/_on_new_command.md) — Create a new custom command
- [`func _on_edit_command() -> void`](ScenarioEditor/functions/_on_edit_command.md) — Edit the selected custom command
- [`func _on_delete_command() -> void`](ScenarioEditor/functions/_on_delete_command.md) — Delete the selected custom command
- [`func _on_playtest_pressed() -> void`](ScenarioEditor/functions/_on_playtest_pressed.md) — Handle PlayTest button press
- [`func _check_playtest_return() -> void`](ScenarioEditor/functions/_check_playtest_return.md) — Check if returning from playtest and restore state
- [`func success_notification(text: String, timeout: int = 2, sound: bool = true) -> void`](ScenarioEditor/functions/success_notification.md) — Show a success notification banner.
- [`func failed_notification(text: String, timeout: int = 2, sound: bool = true) -> void`](ScenarioEditor/functions/failed_notification.md) — Show a failure notification banner.
- [`func generic_notification(text: String, timeout: int = 2, sound: bool = true) -> void`](ScenarioEditor/functions/generic_notification.md) — Show a normal notification banner.

## Public Attributes

- `ScenarioData data` — Active scenario data resource bound to the editor UI
- `ScenarioHistory history` — Global undo/redo history stack for scenario edits
- `MenuButton file_menu`
- `MenuButton edit_menu`
- `MenuButton attribute_menu`
- `Label title_label`
- `TerrainRender terrain_render`
- `NewScenarioDialog new_scenario_dialog`
- `ScenarioWeatherDialog weather_dialog`
- `BriefingDialog brief_dialog`
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
- `Button units_add_btn`
- `UnitCreateDialog unit_create_dialog`
- `ItemList task_list`
- `ItemList trigger_list`
- `ItemList command_list`
- `Button new_command_btn`
- `Button edit_command_btn`
- `Button delete_command_btn`
- `Button draw_toolbar_freehand`
- `Button draw_toolbar_stamp`
- `Button draw_toolbar_eraser`
- `GridContainer fh_settings`
- `ColorPickerButton fh_color`
- `SpinBox fh_width`
- `HSlider fh_opacity`
- `GridContainer st_settings`
- `HSeparator st_seperator`
- `ColorPickerButton st_color`
- `SpinBox st_scale`
- `SpinBox st_rotation`
- `HSlider st_opacity`
- `LineEdit st_label_text`
- `Label st_label`
- `ItemList st_list`
- `Button st_load_btn`
- `SlotConfigDialog slot_cfg`
- `UnitConfigDialog unit_cfg`
- `TaskConfigDialog task_cfg`
- `TriggerConfigDialog trigger_cfg`
- `CustomCommandConfigDialog command_cfg`
- `TabContainer _tab_container1`
- `Button _playtest_btn`
- `NotificationBanner _notification_banner`

## Member Function Documentation

### _ready

```gdscript
func _ready()
```

Initialize context, services, signals, UI, and dialogs

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

### _on_edit_menu_pressed

```gdscript
func _on_edit_menu_pressed(id: int) -> void
```

Handle Edit menu actions (Undo/Redo).
`id` Menu item ID (0=Undo, 1=Redo).

### _on_update_scenario

```gdscript
func _on_update_scenario(_d: ScenarioData) -> void
```

### _on_briefing_update

```gdscript
func _on_briefing_update(new_brief: BriefData) -> void
```

Apply briefing change via history (undoable).

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

### _rebuild_command_list

```gdscript
func _rebuild_command_list() -> void
```

Rebuild the custom commands list from scenario data

### _on_new_command

```gdscript
func _on_new_command() -> void
```

Create a new custom command

### _on_edit_command

```gdscript
func _on_edit_command() -> void
```

Edit the selected custom command

### _on_delete_command

```gdscript
func _on_delete_command() -> void
```

Delete the selected custom command

### _on_playtest_pressed

```gdscript
func _on_playtest_pressed() -> void
```

Handle PlayTest button press

### _check_playtest_return

```gdscript
func _check_playtest_return() -> void
```

Check if returning from playtest and restore state

### success_notification

```gdscript
func success_notification(text: String, timeout: int = 2, sound: bool = true) -> void
```

Show a success notification banner.
`text` Notification text to display.
`timeout` Duration in seconds before auto-hiding (default 2).
`sound` Whether to play success sound (default true).

### failed_notification

```gdscript
func failed_notification(text: String, timeout: int = 2, sound: bool = true) -> void
```

Show a failure notification banner.
`text` Notification text to display.
`timeout` Duration in seconds before auto-hiding (default 2).
`sound` Whether to play failure sound (default true).

### generic_notification

```gdscript
func generic_notification(text: String, timeout: int = 2, sound: bool = true) -> void
```

Show a normal notification banner.
`text` Notification text to display.
`timeout` Duration in seconds before auto-hiding (default 2).
`sound` Whether to play notification sound (default true).

## Member Data Documentation

### data

```gdscript
var data: ScenarioData
```

Decorators: `@export`

Active scenario data resource bound to the editor UI

### history

```gdscript
var history: ScenarioHistory
```

Decorators: `@export`

Global undo/redo history stack for scenario edits

### file_menu

```gdscript
var file_menu: MenuButton
```

### edit_menu

```gdscript
var edit_menu: MenuButton
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

### brief_dialog

```gdscript
var brief_dialog: BriefingDialog
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

### units_add_btn

```gdscript
var units_add_btn: Button
```

### unit_create_dialog

```gdscript
var unit_create_dialog: UnitCreateDialog
```

### task_list

```gdscript
var task_list: ItemList
```

### trigger_list

```gdscript
var trigger_list: ItemList
```

### command_list

```gdscript
var command_list: ItemList
```

### new_command_btn

```gdscript
var new_command_btn: Button
```

### edit_command_btn

```gdscript
var edit_command_btn: Button
```

### delete_command_btn

```gdscript
var delete_command_btn: Button
```

### draw_toolbar_freehand

```gdscript
var draw_toolbar_freehand: Button
```

### draw_toolbar_stamp

```gdscript
var draw_toolbar_stamp: Button
```

### draw_toolbar_eraser

```gdscript
var draw_toolbar_eraser: Button
```

### fh_settings

```gdscript
var fh_settings: GridContainer
```

### fh_color

```gdscript
var fh_color: ColorPickerButton
```

### fh_width

```gdscript
var fh_width: SpinBox
```

### fh_opacity

```gdscript
var fh_opacity: HSlider
```

### st_settings

```gdscript
var st_settings: GridContainer
```

### st_seperator

```gdscript
var st_seperator: HSeparator
```

### st_color

```gdscript
var st_color: ColorPickerButton
```

### st_scale

```gdscript
var st_scale: SpinBox
```

### st_rotation

```gdscript
var st_rotation: SpinBox
```

### st_opacity

```gdscript
var st_opacity: HSlider
```

### st_label_text

```gdscript
var st_label_text: LineEdit
```

### st_label

```gdscript
var st_label: Label
```

### st_list

```gdscript
var st_list: ItemList
```

### st_load_btn

```gdscript
var st_load_btn: Button
```

### slot_cfg

```gdscript
var slot_cfg: SlotConfigDialog
```

### unit_cfg

```gdscript
var unit_cfg: UnitConfigDialog
```

### task_cfg

```gdscript
var task_cfg: TaskConfigDialog
```

### trigger_cfg

```gdscript
var trigger_cfg: TriggerConfigDialog
```

### command_cfg

```gdscript
var command_cfg: CustomCommandConfigDialog
```

### _tab_container1

```gdscript
var _tab_container1: TabContainer
```

### _playtest_btn

```gdscript
var _playtest_btn: Button
```

### _notification_banner

```gdscript
var _notification_banner: NotificationBanner
```
