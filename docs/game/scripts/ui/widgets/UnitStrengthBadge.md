# UnitStrengthBadge Class Reference

*File:* `scripts/ui/widgets/UnitStrengthBadge.gd`
*Class name:* `UnitStrengthBadge`
*Inherits:* `HBoxContainer`

## Synopsis

```gdscript
class_name UnitStrengthBadge
extends HBoxContainer
```

## Public Member Functions

- [`func _ensure_ui() -> void`](UnitStrengthBadge/functions/_ensure_ui.md) — Create child UI nodes if needed.
- [`func _ready() -> void`](UnitStrengthBadge/functions/_ready.md) — Called when the node enters the scene tree.
- [`func set_unit(u: UnitData, threshold: float = -1.0) -> void`](UnitStrengthBadge/functions/set_unit.md) — Update the badge from a UnitData.

## Public Attributes

- `float understrength_threshold` — Compact badge that shows unit strength percent and status color.
- `Label _percent_lbl`
- `ColorRect _status_rect`

## Member Function Documentation

### _ensure_ui

```gdscript
func _ensure_ui() -> void
```

Create child UI nodes if needed. Safe to call before _ready().

### _ready

```gdscript
func _ready() -> void
```

Called when the node enters the scene tree.

### set_unit

```gdscript
func set_unit(u: UnitData, threshold: float = -1.0) -> void
```

Update the badge from a UnitData. Creates UI if called before _ready().

## Member Data Documentation

### understrength_threshold

```gdscript
var understrength_threshold: float
```

Decorators: `@export`

Compact badge that shows unit strength percent and status color.

### _percent_lbl

```gdscript
var _percent_lbl: Label
```

### _status_rect

```gdscript
var _status_rect: ColorRect
```
