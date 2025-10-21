# TerrainToolBase Class Reference

*File:* `scripts/editors/tools/TerrainToolBase.gd`
*Class name:* `TerrainToolBase`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name TerrainToolBase
extends RefCounted
```

## Public Member Functions

- [`func _init()`](TerrainToolBase/functions/_init.md) — Assign Metadata
- [`func handle_view_input(_event: InputEvent) -> bool`](TerrainToolBase/functions/handle_view_input.md) — Handle viewport input.
- [`func build_options_ui(_parent: Control) -> void`](TerrainToolBase/functions/build_options_ui.md) — Populate options UI.
- [`func build_info_ui(_parent: Control) -> void`](TerrainToolBase/functions/build_info_ui.md) — Populate info UI.
- [`func build_hint_ui(_parent: Control) -> void`](TerrainToolBase/functions/build_hint_ui.md) — Populate hint UI
- [`func build_preview(_parent: Control) -> Control`](TerrainToolBase/functions/build_preview.md) — Build tool preview
- [`func ensure_preview(parent: Control) -> void`](TerrainToolBase/functions/ensure_preview.md) — Ensure the preview exists
- [`func on_mouse_inside(inside: bool) -> void`](TerrainToolBase/functions/on_mouse_inside.md) — Editor tells the tool the mouse entered/exited the viewport
- [`func update_preview_at_screen(screen_pos: Vector2) -> void`](TerrainToolBase/functions/update_preview_at_screen.md) — Update preview position on screen
- [`func update_preview_at_overlay(overlay: Control, overlay_pos: Vector2) -> void`](TerrainToolBase/functions/update_preview_at_overlay.md) — Update preview location on viewport
- [`func _place_preview(local_px: Vector2) -> void`](TerrainToolBase/functions/_place_preview.md) — Where to place the preview and how to feed parameters
- [`func destroy_preview() -> void`](TerrainToolBase/functions/destroy_preview.md) — Destroy the preview

## Public Attributes

- `TerrainEditor editor`
- `TerrainRender render`
- `SubViewportContainer viewport_container`
- `SubViewport viewport`
- `TerrainData data`
- `Array[TerrainBrush] brushes`
- `Array[Variant] features`
- `Texture2D tool_icon`
- `Control _preview`

## Signals

- `signal on_options_changed` — Base class for terrain editor tools.
- `signal on_need_info`
- `signal on_hints_changed`

## Member Function Documentation

### _init

```gdscript
func _init()
```

Assign Metadata

### handle_view_input

```gdscript
func handle_view_input(_event: InputEvent) -> bool
```

Handle viewport input. Return true if consumed.

### build_options_ui

```gdscript
func build_options_ui(_parent: Control) -> void
```

Populate options UI.

### build_info_ui

```gdscript
func build_info_ui(_parent: Control) -> void
```

Populate info UI.

### build_hint_ui

```gdscript
func build_hint_ui(_parent: Control) -> void
```

Populate hint UI

### build_preview

```gdscript
func build_preview(_parent: Control) -> Control
```

Build tool preview

### ensure_preview

```gdscript
func ensure_preview(parent: Control) -> void
```

Ensure the preview exists

### on_mouse_inside

```gdscript
func on_mouse_inside(inside: bool) -> void
```

Editor tells the tool the mouse entered/exited the viewport

### update_preview_at_screen

```gdscript
func update_preview_at_screen(screen_pos: Vector2) -> void
```

Update preview position on screen

### update_preview_at_overlay

```gdscript
func update_preview_at_overlay(overlay: Control, overlay_pos: Vector2) -> void
```

Update preview location on viewport

### _place_preview

```gdscript
func _place_preview(local_px: Vector2) -> void
```

Where to place the preview and how to feed parameters

### destroy_preview

```gdscript
func destroy_preview() -> void
```

Destroy the preview

## Member Data Documentation

### editor

```gdscript
var editor: TerrainEditor
```

### render

```gdscript
var render: TerrainRender
```

### viewport_container

```gdscript
var viewport_container: SubViewportContainer
```

### viewport

```gdscript
var viewport: SubViewport
```

### data

```gdscript
var data: TerrainData
```

### brushes

```gdscript
var brushes: Array[TerrainBrush]
```

### features

```gdscript
var features: Array[Variant]
```

### tool_icon

```gdscript
var tool_icon: Texture2D
```

### _preview

```gdscript
var _preview: Control
```

## Signal Documentation

### on_options_changed

```gdscript
signal on_options_changed
```

Decorators: `@warning_ignore("unused_signal")`

Base class for terrain editor tools.

### on_need_info

```gdscript
signal on_need_info
```

### on_hints_changed

```gdscript
signal on_hints_changed
```
