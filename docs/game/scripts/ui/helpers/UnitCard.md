# UnitCard Class Reference

*File:* `scripts/ui/helpers/UnitCard.gd`
*Class name:* `UnitCard`
*Inherits:* `PanelContainer`

## Synopsis

```gdscript
class_name UnitCard
extends PanelContainer
```

## Brief

Recruitable unit card.

## Public Member Functions

- [`func _ready() -> void`](UnitCard/functions/_ready.md)
- [`func setup(u: UnitData) -> void`](UnitCard/functions/setup.md) — Initialize card visual with a unit dictionary.
- [`func set_selected(v: bool) -> void`](UnitCard/functions/set_selected.md) — Mark card as selected by the controller.
- [`func _update_style() -> void`](UnitCard/functions/_update_style.md) — Apply hover/selected panel styling.
- [`func _gui_input(e: InputEvent) -> void`](UnitCard/functions/_gui_input.md) — Click to inspect the unit.
- [`func _notification(what: int) -> void`](UnitCard/functions/_notification.md) — Cache laid-out size for drag preview.
- [`func _on_mouse_entered() -> void`](UnitCard/functions/_on_mouse_entered.md) — Hover-in visual feedback.
- [`func _on_mouse_exited() -> void`](UnitCard/functions/_on_mouse_exited.md) — Hover-out visual feedback.
- [`func _get_drag_data(_pos: Vector2) -> Variant`](UnitCard/functions/_get_drag_data.md) — Provide drag payload.
- [`func _make_drag_preview() -> Control`](UnitCard/functions/_make_drag_preview.md) — Build a fixed-size preview that matches the pool layout.

## Public Attributes

- `Texture2D fallback_default_icon` — Fallback icon if unit["icon"] is missing/empty.
- `StyleBox hover_style` — Hover style
- `StyleBox selected_style` — Selected Style
- `UnitData unit`
- `String unit_id`
- `Texture2D default_icon`
- `StyleBox _base_style`
- `HBoxContainer _row`
- `TextureRect _icon`
- `Label _name`
- `Label _role`
- `Label _cost`

## Signals

- `signal unit_selected(unit: Dictionary)` — Emitted when user clicks the card.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### setup

```gdscript
func setup(u: UnitData) -> void
```

Initialize card visual with a unit dictionary.

### set_selected

```gdscript
func set_selected(v: bool) -> void
```

Mark card as selected by the controller.

### _update_style

```gdscript
func _update_style() -> void
```

Apply hover/selected panel styling.

### _gui_input

```gdscript
func _gui_input(e: InputEvent) -> void
```

Click to inspect the unit.

### _notification

```gdscript
func _notification(what: int) -> void
```

Cache laid-out size for drag preview.

### _on_mouse_entered

```gdscript
func _on_mouse_entered() -> void
```

Hover-in visual feedback.

### _on_mouse_exited

```gdscript
func _on_mouse_exited() -> void
```

Hover-out visual feedback.

### _get_drag_data

```gdscript
func _get_drag_data(_pos: Vector2) -> Variant
```

Provide drag payload.

### _make_drag_preview

```gdscript
func _make_drag_preview() -> Control
```

Build a fixed-size preview that matches the pool layout.

## Member Data Documentation

### fallback_default_icon

```gdscript
var fallback_default_icon: Texture2D
```

Decorators: `@export`

Fallback icon if unit["icon"] is missing/empty.

### hover_style

```gdscript
var hover_style: StyleBox
```

Decorators: `@export`

Hover style

### selected_style

```gdscript
var selected_style: StyleBox
```

Decorators: `@export`

Selected Style

### unit

```gdscript
var unit: UnitData
```

### unit_id

```gdscript
var unit_id: String
```

### default_icon

```gdscript
var default_icon: Texture2D
```

### _base_style

```gdscript
var _base_style: StyleBox
```

### _row

```gdscript
var _row: HBoxContainer
```

### _icon

```gdscript
var _icon: TextureRect
```

### _name

```gdscript
var _name: Label
```

### _role

```gdscript
var _role: Label
```

### _cost

```gdscript
var _cost: Label
```

## Signal Documentation

### unit_selected

```gdscript
signal unit_selected(unit: Dictionary)
```

Emitted when user clicks the card.
