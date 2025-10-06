# TerrainEditor Class Reference

*File:* `scripts/editors/TerrainEditor.gd`
*Class name:* `TerrainEditor`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name TerrainEditor
extends Control
```

## Brief

In-game terrain editor for custom terrains.

## Detailed Description

Lets creators create terrains to use in scenarios.

Action on exit

Order of editor tools

Initial Terrain Data

## Public Member Functions

- [`func _ready()`](TerrainEditor/functions/_ready.md)
- [`func _notification(what)`](TerrainEditor/functions/_notification.md) — Catch resize and close notifications
- [`func _on_filemenu_pressed(id: int)`](TerrainEditor/functions/_on_filemenu_pressed.md) — On file menu pressed event
- [`func _on_editmenu_pressed(id: int)`](TerrainEditor/functions/_on_editmenu_pressed.md) — On edit menu pressed event
- [`func _on_new_pressed()`](TerrainEditor/functions/_on_new_pressed.md) — On New Terrain Pressed event
- [`func _new_terrain(d: TerrainData)`](TerrainEditor/functions/_new_terrain.md) — Create new terrain data
- [`func _edit_terrain(_d: TerrainData)`](TerrainEditor/functions/_edit_terrain.md) — Create new terrain data
- [`func _request_exit(kind: String) -> void`](TerrainEditor/functions/_request_exit.md) — Request to exit the editor
- [`func _on_exit_save_confirmed() -> void`](TerrainEditor/functions/_on_exit_save_confirmed.md) — Save then exit
- [`func _perform_pending_exit() -> void`](TerrainEditor/functions/_perform_pending_exit.md) — Exit application
- [`func _build_tool_buttons()`](TerrainEditor/functions/_build_tool_buttons.md) — Build the tool panel
- [`func _select_tool(btn: TextureButton) -> void`](TerrainEditor/functions/_select_tool.md) — Select the active tool
- [`func _deselect_tool(_btn: TextureButton) -> void`](TerrainEditor/functions/_deselect_tool.md) — Deselect the active tool
- [`func _update_tool_button_tint(btn: TextureButton) -> void`](TerrainEditor/functions/_update_tool_button_tint.md) — Update tool button tint
- [`func _rebuild_options_panel() -> void`](TerrainEditor/functions/_rebuild_options_panel.md) — Rebuild the options panel for the selected tool
- [`func _rebuild_info_panel() -> void`](TerrainEditor/functions/_rebuild_info_panel.md) — Builds the tool info panel
- [`func _rebuild_tool_hint() -> void`](TerrainEditor/functions/_rebuild_tool_hint.md) — Builds the tool info panel
- [`func _build_exit_dialog() -> void`](TerrainEditor/functions/_build_exit_dialog.md) — Build exit dialog
- [`func _unhandled_key_input(event)`](TerrainEditor/functions/_unhandled_key_input.md) — Handle unhandled input
- [`func _on_brush_overlay_gui_input(event)`](TerrainEditor/functions/_on_brush_overlay_gui_input.md) — Input handler for terrainview Viewport
- [`func _on_brush_overlay_mouse_enter()`](TerrainEditor/functions/_on_brush_overlay_mouse_enter.md) — Triggers when mouse enters brush overlay
- [`func _on_brush_overlay_mouse_exit()`](TerrainEditor/functions/_on_brush_overlay_mouse_exit.md) — Triggers when mouse exits brush overlay
- [`func _save()`](TerrainEditor/functions/_save.md) — Save terrain
- [`func _save_as()`](TerrainEditor/functions/_save_as.md) — Save terrain as
- [`func _open()`](TerrainEditor/functions/_open.md) — Open terrain
- [`func _on_history_changed(past: Array, future: Array) -> void`](TerrainEditor/functions/_on_history_changed.md) — Show UndoRedo history
- [`func _queue_free_children(node: Control)`](TerrainEditor/functions/_queue_free_children.md) — Helper function to delete all children of a parent node
- [`func screen_to_world(pos: Vector2) -> Vector2`](TerrainEditor/functions/screen_to_world.md) — API to get screen position from world position
- [`func world_to_screen(pos: Vector2) -> Vector2`](TerrainEditor/functions/world_to_screen.md) — API to get world position from screen position
- [`func screen_to_map(pos: Vector2, keep_aspect: bool = true) -> Vector2`](TerrainEditor/functions/screen_to_map.md) — API to convert a screen-space point to terrain-local meters,
- [`func map_to_screen(local_m: Vector2, keep_aspect: bool = true) -> Vector2`](TerrainEditor/functions/map_to_screen.md) — API to convert terrain meters to a screen-space point
- [`func map_to_terrain(local_m: Vector2) -> Vector2`](TerrainEditor/functions/map_to_terrain.md) — Wrapper for map_to_terrain from terrain renderer
- [`func terrain_to_map(pos: Vector2) -> Vector2`](TerrainEditor/functions/terrain_to_map.md) — Wrapper for terrain_to_map from terrain renderer

## Public Attributes

- `TerrainData data`
- `Vector2 tool_icon_size` — Icon size for tool buttons
- `Array[TerrainBrush] brushes`
- `Array[Variant] features`
- `TerrainToolBase active_tool`
- `String _current_path`
- `bool _dirty`
- `int _current_history_index`
- `int _saved_history_index`
- `String _pending_exit_kind`
- `bool _pending_quit_after_save`
- `ConfirmationDialog _exit_dialog`
- `MenuButton file_menu`
- `MenuButton edit_menu`
- `GridContainer tools_grid`
- `TerrainRender terrain_render`
- `SubViewportContainer terrainview_container`
- `SubViewport terrainview`
- `Control brush_overlay`
- `NewTerrainDialog terrain_settings_dialog`
- `VBoxContainer tools_options`
- `VBoxContainer tools_info`
- `HBoxContainer tools_hint`
- `VBoxContainer history_container`
- `TerrainCamera camera`
- `Label mouse_position_l`
- `TabContainer tab_container_2`
- `TabContainer tab_container_3`

## Member Function Documentation

### _ready

```gdscript
func _ready()
```

### _notification

```gdscript
func _notification(what)
```

Catch resize and close notifications

### _on_filemenu_pressed

```gdscript
func _on_filemenu_pressed(id: int)
```

On file menu pressed event

### _on_editmenu_pressed

```gdscript
func _on_editmenu_pressed(id: int)
```

On edit menu pressed event

### _on_new_pressed

```gdscript
func _on_new_pressed()
```

On New Terrain Pressed event

### _new_terrain

```gdscript
func _new_terrain(d: TerrainData)
```

Create new terrain data

### _edit_terrain

```gdscript
func _edit_terrain(_d: TerrainData)
```

Create new terrain data

### _request_exit

```gdscript
func _request_exit(kind: String) -> void
```

Request to exit the editor

### _on_exit_save_confirmed

```gdscript
func _on_exit_save_confirmed() -> void
```

Save then exit

### _perform_pending_exit

```gdscript
func _perform_pending_exit() -> void
```

Exit application

### _build_tool_buttons

```gdscript
func _build_tool_buttons()
```

Build the tool panel

### _select_tool

```gdscript
func _select_tool(btn: TextureButton) -> void
```

Select the active tool

### _deselect_tool

```gdscript
func _deselect_tool(_btn: TextureButton) -> void
```

Deselect the active tool

### _update_tool_button_tint

```gdscript
func _update_tool_button_tint(btn: TextureButton) -> void
```

Update tool button tint

### _rebuild_options_panel

```gdscript
func _rebuild_options_panel() -> void
```

Rebuild the options panel for the selected tool

### _rebuild_info_panel

```gdscript
func _rebuild_info_panel() -> void
```

Builds the tool info panel

### _rebuild_tool_hint

```gdscript
func _rebuild_tool_hint() -> void
```

Builds the tool info panel

### _build_exit_dialog

```gdscript
func _build_exit_dialog() -> void
```

Build exit dialog

### _unhandled_key_input

```gdscript
func _unhandled_key_input(event)
```

Handle unhandled input

### _on_brush_overlay_gui_input

```gdscript
func _on_brush_overlay_gui_input(event)
```

Input handler for terrainview Viewport

### _on_brush_overlay_mouse_enter

```gdscript
func _on_brush_overlay_mouse_enter()
```

Triggers when mouse enters brush overlay

### _on_brush_overlay_mouse_exit

```gdscript
func _on_brush_overlay_mouse_exit()
```

Triggers when mouse exits brush overlay

### _save

```gdscript
func _save()
```

Save terrain

### _save_as

```gdscript
func _save_as()
```

Save terrain as

### _open

```gdscript
func _open()
```

Open terrain

### _on_history_changed

```gdscript
func _on_history_changed(past: Array, future: Array) -> void
```

Show UndoRedo history

### _queue_free_children

```gdscript
func _queue_free_children(node: Control)
```

Helper function to delete all children of a parent node

### screen_to_world

```gdscript
func screen_to_world(pos: Vector2) -> Vector2
```

API to get screen position from world position

### world_to_screen

```gdscript
func world_to_screen(pos: Vector2) -> Vector2
```

API to get world position from screen position

### screen_to_map

```gdscript
func screen_to_map(pos: Vector2, keep_aspect: bool = true) -> Vector2
```

API to convert a screen-space point to terrain-local meters,

### map_to_screen

```gdscript
func map_to_screen(local_m: Vector2, keep_aspect: bool = true) -> Vector2
```

API to convert terrain meters to a screen-space point

### map_to_terrain

```gdscript
func map_to_terrain(local_m: Vector2) -> Vector2
```

Wrapper for map_to_terrain from terrain renderer

### terrain_to_map

```gdscript
func terrain_to_map(pos: Vector2) -> Vector2
```

Wrapper for terrain_to_map from terrain renderer

## Member Data Documentation

### data

```gdscript
var data: TerrainData
```

### tool_icon_size

```gdscript
var tool_icon_size: Vector2
```

Icon size for tool buttons

### brushes

```gdscript
var brushes: Array[TerrainBrush]
```

### features

```gdscript
var features: Array[Variant]
```

### active_tool

```gdscript
var active_tool: TerrainToolBase
```

### _current_path

```gdscript
var _current_path: String
```

### _dirty

```gdscript
var _dirty: bool
```

### _current_history_index

```gdscript
var _current_history_index: int
```

### _saved_history_index

```gdscript
var _saved_history_index: int
```

### _pending_exit_kind

```gdscript
var _pending_exit_kind: String
```

### _pending_quit_after_save

```gdscript
var _pending_quit_after_save: bool
```

### _exit_dialog

```gdscript
var _exit_dialog: ConfirmationDialog
```

### file_menu

```gdscript
var file_menu: MenuButton
```

### edit_menu

```gdscript
var edit_menu: MenuButton
```

### tools_grid

```gdscript
var tools_grid: GridContainer
```

### terrain_render

```gdscript
var terrain_render: TerrainRender
```

### terrainview_container

```gdscript
var terrainview_container: SubViewportContainer
```

### terrainview

```gdscript
var terrainview: SubViewport
```

### brush_overlay

```gdscript
var brush_overlay: Control
```

### terrain_settings_dialog

```gdscript
var terrain_settings_dialog: NewTerrainDialog
```

### tools_options

```gdscript
var tools_options: VBoxContainer
```

### tools_info

```gdscript
var tools_info: VBoxContainer
```

### tools_hint

```gdscript
var tools_hint: HBoxContainer
```

### history_container

```gdscript
var history_container: VBoxContainer
```

### camera

```gdscript
var camera: TerrainCamera
```

### mouse_position_l

```gdscript
var mouse_position_l: Label
```

### tab_container_2

```gdscript
var tab_container_2: TabContainer
```

### tab_container_3

```gdscript
var tab_container_3: TabContainer
```
