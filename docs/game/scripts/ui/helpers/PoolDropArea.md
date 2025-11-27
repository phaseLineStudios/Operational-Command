# PoolDropArea Class Reference

*File:* `scripts/ui/helpers/PoolDropArea.gd`
*Class name:* `PoolDropArea`
*Inherits:* `VBoxContainer`

## Synopsis

```gdscript
class_name PoolDropArea
extends VBoxContainer
```

## Public Member Functions

- [`func _ready() -> void`](PoolDropArea/functions/_ready.md)
- [`func _can_drop_data(_at_position: Vector2, data: Variant) -> bool`](PoolDropArea/functions/_can_drop_data.md)
- [`func _drop_data(_at_position: Vector2, data: Variant) -> void`](PoolDropArea/functions/_drop_data.md)

## Signals

- `signal request_return_to_pool(slot_id: String, unit: UnitData)` — Vertical list that can live directly in a ScrollContainer.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _can_drop_data

```gdscript
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool
```

### _drop_data

```gdscript
func _drop_data(_at_position: Vector2, data: Variant) -> void
```

## Signal Documentation

### request_return_to_pool

```gdscript
signal request_return_to_pool(slot_id: String, unit: UnitData)
```

Vertical list that can live directly in a ScrollContainer.
