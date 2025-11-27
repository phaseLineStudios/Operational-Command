# ScenarioEditorContext Class Reference

*File:* `scripts/editors/services/ScenarioEditorContext.gd`
*Class name:* `ScenarioEditorContext`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name ScenarioEditorContext
extends RefCounted
```

## Public Member Functions

- [`func request_overlay_redraw() -> void`](ScenarioEditorContext/functions/request_overlay_redraw.md)
- [`func request_scene_tree_rebuild() -> void`](ScenarioEditorContext/functions/request_scene_tree_rebuild.md)
- [`func toast(msg: String) -> void`](ScenarioEditorContext/functions/toast.md)

## Public Attributes

- `ScenarioData data`
- `ScenarioHistory history`
- `TerrainRender terrain_render`
- `ScenarioEditorOverlay terrain_overlay`
- `Tree scene_tree`
- `HBoxContainer tool_hint`
- `Label mouse_position_label`
- `Tree unit_list`
- `OptionButton unit_category_opt`
- `LineEdit unit_search`
- `Button unit_faction_friend`
- `Button unit_faction_enemy`
- `Button unit_create_btn`
- `UnitCreateDialog unit_create_dlg`
- `ItemList task_list`
- `ItemList trigger_list`
- `Dictionary selected_pick`
- `ScenarioToolBase current_tool`

## Signals

- `signal overlay_redraw_requested`
- `signal selection_changed(pick: Dictionary)`
- `signal scene_tree_rebuild_requested`
- `signal toast_requested(text: String)`

## Member Function Documentation

### request_overlay_redraw

```gdscript
func request_overlay_redraw() -> void
```

### request_scene_tree_rebuild

```gdscript
func request_scene_tree_rebuild() -> void
```

### toast

```gdscript
func toast(msg: String) -> void
```

## Member Data Documentation

### data

```gdscript
var data: ScenarioData
```

### history

```gdscript
var history: ScenarioHistory
```

### terrain_render

```gdscript
var terrain_render: TerrainRender
```

### terrain_overlay

```gdscript
var terrain_overlay: ScenarioEditorOverlay
```

### scene_tree

```gdscript
var scene_tree: Tree
```

### tool_hint

```gdscript
var tool_hint: HBoxContainer
```

### mouse_position_label

```gdscript
var mouse_position_label: Label
```

### unit_list

```gdscript
var unit_list: Tree
```

### unit_category_opt

```gdscript
var unit_category_opt: OptionButton
```

### unit_search

```gdscript
var unit_search: LineEdit
```

### unit_faction_friend

```gdscript
var unit_faction_friend: Button
```

### unit_faction_enemy

```gdscript
var unit_faction_enemy: Button
```

### unit_create_btn

```gdscript
var unit_create_btn: Button
```

### unit_create_dlg

```gdscript
var unit_create_dlg: UnitCreateDialog
```

### task_list

```gdscript
var task_list: ItemList
```

### trigger_list

```gdscript
var trigger_list: ItemList
```

### selected_pick

```gdscript
var selected_pick: Dictionary
```

### current_tool

```gdscript
var current_tool: ScenarioToolBase
```

## Signal Documentation

### overlay_redraw_requested

```gdscript
signal overlay_redraw_requested
```

### selection_changed

```gdscript
signal selection_changed(pick: Dictionary)
```

### scene_tree_rebuild_requested

```gdscript
signal scene_tree_rebuild_requested
```

### toast_requested

```gdscript
signal toast_requested(text: String)
```
