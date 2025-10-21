# TaskPlaceTool Class Reference

*File:* `scripts/editors/tools/ScenarioTaskTool.gd`
*Class name:* `TaskPlaceTool`
*Inherits:* `ScenarioToolBase`

## Synopsis

```gdscript
class_name TaskPlaceTool
extends ScenarioToolBase
```

## Public Member Functions

- [`func build_hint_ui(parent: Control) -> void`](TaskPlaceTool/functions/build_hint_ui.md)
- [`func _on_activated() -> void`](TaskPlaceTool/functions/_on_activated.md)
- [`func _on_deactivated()`](TaskPlaceTool/functions/_on_deactivated.md)
- [`func _on_mouse_move(e: InputEventMouseMotion) -> bool`](TaskPlaceTool/functions/_on_mouse_move.md)
- [`func _on_mouse_button(e: InputEventMouseButton) -> bool`](TaskPlaceTool/functions/_on_mouse_button.md)
- [`func _on_key(e: InputEventKey) -> bool`](TaskPlaceTool/functions/_on_key.md)
- [`func draw_overlay(canvas: Control) -> void`](TaskPlaceTool/functions/draw_overlay.md)
- [`func _place() -> void`](TaskPlaceTool/functions/_place.md)
- [`func _snap(p: Vector2) -> Vector2`](TaskPlaceTool/functions/_snap.md)
- [`func _label(t: String) -> Label`](TaskPlaceTool/functions/_label.md)
- [`func _clear(node: Control) -> void`](TaskPlaceTool/functions/_clear.md)

## Public Attributes

- `UnitBaseTask task`

## Member Function Documentation

### build_hint_ui

```gdscript
func build_hint_ui(parent: Control) -> void
```

### _on_activated

```gdscript
func _on_activated() -> void
```

### _on_deactivated

```gdscript
func _on_deactivated()
```

### _on_mouse_move

```gdscript
func _on_mouse_move(e: InputEventMouseMotion) -> bool
```

### _on_mouse_button

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool
```

### _on_key

```gdscript
func _on_key(e: InputEventKey) -> bool
```

### draw_overlay

```gdscript
func draw_overlay(canvas: Control) -> void
```

### _place

```gdscript
func _place() -> void
```

### _snap

```gdscript
func _snap(p: Vector2) -> Vector2
```

### _label

```gdscript
func _label(t: String) -> Label
```

### _clear

```gdscript
func _clear(node: Control) -> void
```

## Member Data Documentation

### task

```gdscript
var task: UnitBaseTask
```
