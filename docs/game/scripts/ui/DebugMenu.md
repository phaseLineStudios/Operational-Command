# DebugMenu Class Reference

*File:* `scripts/ui/DebugMenu.gd`
*Class name:* `DebugMenu`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name DebugMenu
extends Window
```

## Public Member Functions

- [`func _ready()`](DebugMenu/functions/_ready.md)
- [`func _set_metrics_visibility(visibility: int)`](DebugMenu/functions/_set_metrics_visibility.md) — Set visibility for metrics display
- [`func _on_load_pressed() -> void`](DebugMenu/functions/_on_load_pressed.md) — Load scene
- [`func _populate_scene_list() -> void`](DebugMenu/functions/_populate_scene_list.md) — populate optionbutton with scenes
- [`func _collect_scenes(root: String) -> Array`](DebugMenu/functions/_collect_scenes.md) — Collect all scenes
- [`func _recursive_collect_scenes(path: String, out: Array) -> void`](DebugMenu/functions/_recursive_collect_scenes.md) — recursivly collect all scenes in project
- [`func _pretty_scene_name(p: String) -> String`](DebugMenu/functions/_pretty_scene_name.md) — Prettify scene name
- [`func _log_msg(msg: String, lvl: LogService.LogLevel) -> void`](DebugMenu/functions/_log_msg.md) — Capture and store log message
- [`func _refresh_log()`](DebugMenu/functions/_refresh_log.md) — refresh log display
- [`func _clear_log()`](DebugMenu/functions/_clear_log.md)
- [`func _refresh_scene_options() -> void`](DebugMenu/functions/_refresh_scene_options.md) — Refresh scene options by scanning all nodes
- [`func _clear_scene_options_ui() -> void`](DebugMenu/functions/_clear_scene_options_ui.md) — Clear all scene option UI elements
- [`func _scan_scene_for_options() -> void`](DebugMenu/functions/_scan_scene_for_options.md) — Async scan all nodes in the scene tree for debug options
- [`func _should_skip_node(node: Node) -> bool`](DebugMenu/functions/_should_skip_node.md) — Check if we should skip scanning this node
- [`func _should_skip_property(prop_name: String) -> bool`](DebugMenu/functions/_should_skip_property.md) — Check if we should skip this property
- [`func _extract_debug_exports(node: Node) -> Array`](DebugMenu/functions/_extract_debug_exports.md) — Extract debug-related @export variables from a node
- [`func _get_property_doc_comment(node: Node, prop_name: String) -> String`](DebugMenu/functions/_get_property_doc_comment.md) — Extract doc comment for a property from the script source
- [`func _property_to_option(node: Node, prop: Dictionary) -> Dictionary`](DebugMenu/functions/_property_to_option.md) — Convert a property dictionary to a debug option dictionary
- [`func _collect_nodes_recursive(node: Node, out: Array[Node]) -> void`](DebugMenu/functions/_collect_nodes_recursive.md) — Recursively collect all nodes in the tree
- [`func _build_scene_options_ui() -> void`](DebugMenu/functions/_build_scene_options_ui.md) — Build UI for all discovered scene options
- [`func _add_debug_option(node: Node, option: Dictionary) -> void`](DebugMenu/functions/_add_debug_option.md) — Add a single debug option to the UI
- [`func _process(_dt: float) -> void`](DebugMenu/functions/_process.md)
- [`func _close()`](DebugMenu/functions/_close.md)
- [`func _update_mission_tab_visibility() -> void`](DebugMenu/functions/_update_mission_tab_visibility.md) — Update Mission tab visibility based on whether HQ Table scene is active

## Public Attributes

- `Array _log_lines` — Debug menu window that provides scene-wide debugging options
- `Array _scene_options_discovered`
- `bool _is_scanning`
- `DebugMenuSaveEditor _save_editor`
- `DebugMenuMission _mission_editor`
- `DebugMetricsDisplay metrics_display`
- `OptionButton metrics_visibility`
- `OptionButton scene_loader_scene`
- `Button scene_loader_button`
- `RichTextLabel event_log_content`
- `Button event_log_clear`
- `Button event_log_filter_log`
- `Button event_log_filter_info`
- `Button event_log_filter_warning`
- `Button event_log_filter_error`
- `Button event_log_filter_debug`
- `Button event_log_filter_trace`
- `GridContainer scene_options_container`
- `Button scene_options_refresh`
- `Label scene_options_status`
- `Label save_editor_save_name`
- `Button save_editor_refresh`
- `GridContainer save_editor_content`
- `VBoxContainer save_editor_tab`
- `Label mission_status`
- `Button mission_refresh`
- `GridContainer mission_content`
- `VBoxContainer mission_tab`

## Member Function Documentation

### _ready

```gdscript
func _ready()
```

### _set_metrics_visibility

```gdscript
func _set_metrics_visibility(visibility: int)
```

Set visibility for metrics display

### _on_load_pressed

```gdscript
func _on_load_pressed() -> void
```

Load scene

### _populate_scene_list

```gdscript
func _populate_scene_list() -> void
```

populate optionbutton with scenes

### _collect_scenes

```gdscript
func _collect_scenes(root: String) -> Array
```

Collect all scenes

### _recursive_collect_scenes

```gdscript
func _recursive_collect_scenes(path: String, out: Array) -> void
```

recursivly collect all scenes in project

### _pretty_scene_name

```gdscript
func _pretty_scene_name(p: String) -> String
```

Prettify scene name

### _log_msg

```gdscript
func _log_msg(msg: String, lvl: LogService.LogLevel) -> void
```

Capture and store log message

### _refresh_log

```gdscript
func _refresh_log()
```

refresh log display

### _clear_log

```gdscript
func _clear_log()
```

### _refresh_scene_options

```gdscript
func _refresh_scene_options() -> void
```

Refresh scene options by scanning all nodes

### _clear_scene_options_ui

```gdscript
func _clear_scene_options_ui() -> void
```

Clear all scene option UI elements

### _scan_scene_for_options

```gdscript
func _scan_scene_for_options() -> void
```

Async scan all nodes in the scene tree for debug options

### _should_skip_node

```gdscript
func _should_skip_node(node: Node) -> bool
```

Check if we should skip scanning this node

### _should_skip_property

```gdscript
func _should_skip_property(prop_name: String) -> bool
```

Check if we should skip this property

### _extract_debug_exports

```gdscript
func _extract_debug_exports(node: Node) -> Array
```

Extract debug-related @export variables from a node

### _get_property_doc_comment

```gdscript
func _get_property_doc_comment(node: Node, prop_name: String) -> String
```

Extract doc comment for a property from the script source

### _property_to_option

```gdscript
func _property_to_option(node: Node, prop: Dictionary) -> Dictionary
```

Convert a property dictionary to a debug option dictionary

### _collect_nodes_recursive

```gdscript
func _collect_nodes_recursive(node: Node, out: Array[Node]) -> void
```

Recursively collect all nodes in the tree

### _build_scene_options_ui

```gdscript
func _build_scene_options_ui() -> void
```

Build UI for all discovered scene options

### _add_debug_option

```gdscript
func _add_debug_option(node: Node, option: Dictionary) -> void
```

Add a single debug option to the UI

### _process

```gdscript
func _process(_dt: float) -> void
```

### _close

```gdscript
func _close()
```

### _update_mission_tab_visibility

```gdscript
func _update_mission_tab_visibility() -> void
```

Update Mission tab visibility based on whether HQ Table scene is active

## Member Data Documentation

### _log_lines

```gdscript
var _log_lines: Array
```

Debug menu window that provides scene-wide debugging options

This window contains multiple tabs:
- Log: Shows filtered log messages from LogService
- General: General debug options and scene loader
- Scene Options: Auto-discovered debug options from nodes in the active scene
- Save Editor: Edit currently selected save

### _scene_options_discovered

```gdscript
var _scene_options_discovered: Array
```

### _is_scanning

```gdscript
var _is_scanning: bool
```

### _save_editor

```gdscript
var _save_editor: DebugMenuSaveEditor
```

### _mission_editor

```gdscript
var _mission_editor: DebugMenuMission
```

### metrics_display

```gdscript
var metrics_display: DebugMetricsDisplay
```

### metrics_visibility

```gdscript
var metrics_visibility: OptionButton
```

### scene_loader_scene

```gdscript
var scene_loader_scene: OptionButton
```

### scene_loader_button

```gdscript
var scene_loader_button: Button
```

### event_log_content

```gdscript
var event_log_content: RichTextLabel
```

### event_log_clear

```gdscript
var event_log_clear: Button
```

### event_log_filter_log

```gdscript
var event_log_filter_log: Button
```

### event_log_filter_info

```gdscript
var event_log_filter_info: Button
```

### event_log_filter_warning

```gdscript
var event_log_filter_warning: Button
```

### event_log_filter_error

```gdscript
var event_log_filter_error: Button
```

### event_log_filter_debug

```gdscript
var event_log_filter_debug: Button
```

### event_log_filter_trace

```gdscript
var event_log_filter_trace: Button
```

### scene_options_container

```gdscript
var scene_options_container: GridContainer
```

### scene_options_refresh

```gdscript
var scene_options_refresh: Button
```

### scene_options_status

```gdscript
var scene_options_status: Label
```

### save_editor_save_name

```gdscript
var save_editor_save_name: Label
```

### save_editor_refresh

```gdscript
var save_editor_refresh: Button
```

### save_editor_content

```gdscript
var save_editor_content: GridContainer
```

### save_editor_tab

```gdscript
var save_editor_tab: VBoxContainer
```

### mission_status

```gdscript
var mission_status: Label
```

### mission_refresh

```gdscript
var mission_refresh: Button
```

### mission_content

```gdscript
var mission_content: GridContainer
```

### mission_tab

```gdscript
var mission_tab: VBoxContainer
```
