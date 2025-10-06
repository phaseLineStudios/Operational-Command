# SlotItem Class Reference

*File:* `scripts/ui/helpers/SlotItem.gd`
*Class name:* `SlotItem`
*Inherits:* `PanelContainer`
> **Experimental**

## Synopsis

```gdscript
class_name SlotItem
extends PanelContainer
```

## Brief

Unit slot.

## Detailed Description

Accepts drops and shows current assigned unit.

Hover style when the slot is empty.

Style when the slot is filled

Hover style when the slot is filled.

Style to show while hovering with an invalid payload (deny-hover).

## Public Member Functions

- [`func _ready() -> void`](SlotItem/functions/_ready.md) — Cache base style, wire hover, set mouse filters, and refresh visuals.
- [`func configure(id: String, slot_title: String, roles: Array, i: int, m: int) -> void`](SlotItem/functions/configure.md) — Initialize slot metadata (id/title/roles/index/total) and update UI.
- [`func set_assignment(unit: UnitData) -> void`](SlotItem/functions/set_assignment.md) — Assign a unit to this slot and refresh visuals.
- [`func clear_assignment() -> void`](SlotItem/functions/clear_assignment.md) — Clear the assigned unit and refresh visuals.
- [`func _refresh_labels() -> void`](SlotItem/functions/_refresh_labels.md) — Update Title, and Type.
- [`func _update_icon() -> void`](SlotItem/functions/_update_icon.md) — Set icon to assigned unit's icon or fall back to exported default.
- [`func _apply_style() -> void`](SlotItem/functions/_apply_style.md) — Apply style
- [`func _gui_input(e: InputEvent) -> void`](SlotItem/functions/_gui_input.md) — On click, emit inspect signal if a unit is assigned.
- [`func _can_drop_data(_pos: Vector2, data: Variant) -> bool`](SlotItem/functions/_can_drop_data.md) — Validate payload type and role compatibility for dropping onto this slot.
- [`func _drop_data(_pos: Vector2, data: Variant) -> void`](SlotItem/functions/_drop_data.md) — Emit assignment request for valid drops, else briefly flash deny.
- [`func _get_drag_data(_pos: Vector2) -> Variant`](SlotItem/functions/_get_drag_data.md) — When filled, allow dragging the assigned unit out to pool or another slot.
- [`func _notification(what: int) -> void`](SlotItem/functions/_notification.md) — Clear deny-hover at drag end to restore normal styling.

## Public Attributes

- `StyleBox hover_style_empty`
- `StyleBox filled_style`
- `StyleBox hover_style_filled`
- `StyleBox deny_hover_style`
- `String slot_id` — Icon used when slot is empty or unit lacks icon.
- `String title`
- `Array allowed_roles`
- `UnitData _assigned_unit`
- `StyleBox _base_style`
- `HBoxContainer _row`
- `TextureRect _icon`
- `VBoxContainer _vb`
- `Label _lbl_title`
- `Label _lbl_slot`

## Signals

- `signal request_assign_drop(slot_id: String, unit: Dictionary, source_slot_id: String)` — Emitted when a drop is accepted and controller should assign a unit to this slot
- `signal request_inspect_unit(unit: Dictionary)` — Emitted when the user clicks a filled slot to inspect the assigned unit

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Cache base style, wire hover, set mouse filters, and refresh visuals.

### configure

```gdscript
func configure(id: String, slot_title: String, roles: Array, i: int, m: int) -> void
```

Initialize slot metadata (id/title/roles/index/total) and update UI.

### set_assignment

```gdscript
func set_assignment(unit: UnitData) -> void
```

Assign a unit to this slot and refresh visuals.

### clear_assignment

```gdscript
func clear_assignment() -> void
```

Clear the assigned unit and refresh visuals.

### _refresh_labels

```gdscript
func _refresh_labels() -> void
```

Update Title, and Type.

### _update_icon

```gdscript
func _update_icon() -> void
```

Set icon to assigned unit's icon or fall back to exported default.

### _apply_style

```gdscript
func _apply_style() -> void
```

Apply style

### _gui_input

```gdscript
func _gui_input(e: InputEvent) -> void
```

On click, emit inspect signal if a unit is assigned.

### _can_drop_data

```gdscript
func _can_drop_data(_pos: Vector2, data: Variant) -> bool
```

Validate payload type and role compatibility for dropping onto this slot.

### _drop_data

```gdscript
func _drop_data(_pos: Vector2, data: Variant) -> void
```

Emit assignment request for valid drops, else briefly flash deny.

### _get_drag_data

```gdscript
func _get_drag_data(_pos: Vector2) -> Variant
```

When filled, allow dragging the assigned unit out to pool or another slot.

### _notification

```gdscript
func _notification(what: int) -> void
```

Clear deny-hover at drag end to restore normal styling.

## Member Data Documentation

### hover_style_empty

```gdscript
var hover_style_empty: StyleBox
```

### filled_style

```gdscript
var filled_style: StyleBox
```

### hover_style_filled

```gdscript
var hover_style_filled: StyleBox
```

### deny_hover_style

```gdscript
var deny_hover_style: StyleBox
```

### slot_id

```gdscript
var slot_id: String
```

Decorators: `@export var default_icon: Texture2D`

Icon used when slot is empty or unit lacks icon.

### title

```gdscript
var title: String
```

### allowed_roles

```gdscript
var allowed_roles: Array
```

### _assigned_unit

```gdscript
var _assigned_unit: UnitData
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

### _vb

```gdscript
var _vb: VBoxContainer
```

### _lbl_title

```gdscript
var _lbl_title: Label
```

### _lbl_slot

```gdscript
var _lbl_slot: Label
```

## Signal Documentation

### request_assign_drop

```gdscript
signal request_assign_drop(slot_id: String, unit: Dictionary, source_slot_id: String)
```

Emitted when a drop is accepted and controller should assign a unit to this slot

### request_inspect_unit

```gdscript
signal request_inspect_unit(unit: Dictionary)
```

Emitted when the user clicks a filled slot to inspect the assigned unit
