# UnitDDItemList Class Reference

*File:* `scripts/editors/helpers/UnitDDItemList.gd`
*Class name:* `UnitDDItemList`
*Inherits:* `ItemList`

## Synopsis

```gdscript
class_name UnitDDItemList
extends ItemList
```

## Brief

Drag & drop enabled ItemList for moving UnitData between pool and selected.

## Detailed Description

Expects the parent dialog to implement
`_on_unit_dropped(from_kind:int, to_kind:int, unit_id:String)`.

## Public Member Functions

- [`func _ready() -> void`](UnitDDItemList/functions/_ready.md)
- [`func _get_drag_data(_at_position: Vector2) -> Variant`](UnitDDItemList/functions/_get_drag_data.md) — Return drag payload when user drags a selected row.
- [`func _can_drop_data(_pos: Vector2, data: Variant) -> bool`](UnitDDItemList/functions/_can_drop_data.md) — Accept drops that are unit payloads.
- [`func _drop_data(_pos: Vector2, data: Variant) -> void`](UnitDDItemList/functions/_drop_data.md) — Notify dialog to move the unit.

## Public Attributes

- `Kind kind` — This list’s role (POOL or SELECTED).
- `NodePath dialog_path` — Path to NewScenarioDialog so we can call back on drop.
- `Node _dlg`

## Enumerations

- `enum Kind` — List kind.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _get_drag_data

```gdscript
func _get_drag_data(_at_position: Vector2) -> Variant
```

Return drag payload when user drags a selected row.

### _can_drop_data

```gdscript
func _can_drop_data(_pos: Vector2, data: Variant) -> bool
```

Accept drops that are unit payloads.

### _drop_data

```gdscript
func _drop_data(_pos: Vector2, data: Variant) -> void
```

Notify dialog to move the unit.

## Member Data Documentation

### kind

```gdscript
var kind: Kind
```

Decorators: `@export`

This list’s role (POOL or SELECTED).

### dialog_path

```gdscript
var dialog_path: NodePath
```

Decorators: `@export`

Path to NewScenarioDialog so we can call back on drop.

### _dlg

```gdscript
var _dlg: Node
```

## Enumeration Type Documentation

### Kind

```gdscript
enum Kind
```

List kind.
