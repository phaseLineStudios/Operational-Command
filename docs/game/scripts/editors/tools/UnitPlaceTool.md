# UnitPlaceTool Class Reference

*File:* `scripts/editors/tools/ScenarioUnitTool.gd`
*Class name:* `UnitPlaceTool`
*Inherits:* `ScenarioToolBase`

## Synopsis

```gdscript
class_name UnitPlaceTool
extends ScenarioToolBase
```

## Public Member Functions

- [`func _on_activated() -> void`](UnitPlaceTool/functions/_on_activated.md)
- [`func _on_deactivated()`](UnitPlaceTool/functions/_on_deactivated.md)
- [`func build_hint_ui(parent: Control) -> void`](UnitPlaceTool/functions/build_hint_ui.md)
- [`func _on_mouse_move(e: InputEventMouseMotion) -> bool`](UnitPlaceTool/functions/_on_mouse_move.md)
- [`func _on_mouse_button(e: InputEventMouseButton) -> bool`](UnitPlaceTool/functions/_on_mouse_button.md)
- [`func _on_key(e: InputEventKey) -> bool`](UnitPlaceTool/functions/_on_key.md)
- [`func draw_overlay(canvas: Control) -> void`](UnitPlaceTool/functions/draw_overlay.md)
- [`func _place() -> void`](UnitPlaceTool/functions/_place.md)
- [`func _snap(p: Vector2) -> Vector2`](UnitPlaceTool/functions/_snap.md)
- [`func _label(t: String) -> Label`](UnitPlaceTool/functions/_label.md)
- [`func _clear(node: Control) -> void`](UnitPlaceTool/functions/_clear.md)
- [`func _is_already_used(ctx: ScenarioEditorContext, u: UnitData) -> bool`](UnitPlaceTool/functions/_is_already_used.md)

## Public Attributes

- `payload`
- `Texture2D _icon_tex`

## Member Function Documentation

### _on_activated

```gdscript
func _on_activated() -> void
```

### _on_deactivated

```gdscript
func _on_deactivated()
```

### build_hint_ui

```gdscript
func build_hint_ui(parent: Control) -> void
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

### _is_already_used

```gdscript
func _is_already_used(ctx: ScenarioEditorContext, u: UnitData) -> bool
```

## Member Data Documentation

### payload

```gdscript
var payload
```

### _icon_tex

```gdscript
var _icon_tex: Texture2D
```
