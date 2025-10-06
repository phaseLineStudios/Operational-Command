# SlotsList Class Reference

*File:* `scripts/ui/helpers/SlotsList.gd`
*Class name:* `SlotsList`
*Inherits:* `VBoxContainer`
> **Experimental**

## Synopsis

```gdscript
class_name SlotsList
extends VBoxContainer
```

## Brief

Container for SlotItem panels.

## Detailed Description

Builds one SlotItem per mission slot instance and relays signals upward.

Duration (seconds) for the denied flash fallback effect.

## Public Member Functions

- [`func build_from_slots(slots: Dictionary) -> void`](SlotsList/functions/build_from_slots.md) — Rebuild child SlotItems from the provided slot metadata map.
- [`func set_assignment(slot_id: String, unit: UnitData) -> void`](SlotsList/functions/set_assignment.md) — Apply an assigned unit to a specific SlotItem by slot_id.
- [`func clear_assignment(slot_id: String) -> void`](SlotsList/functions/clear_assignment.md) — Clear the assigned unit from a specific SlotItem by slot_id.
- [`func flash_denied(slot_id: String) -> void`](SlotsList/functions/flash_denied.md) — Briefly tint a SlotItem to indicate a denied action.

## Public Attributes

- `Dictionary _items_by_slot` — Slot Scene

## Signals

- `signal request_assign_drop(slot_id: String, unit: Dictionary, source_slot_id: String)` — Emitted when a SlotItem requests to assign a unit after a valid drop.
- `signal request_inspect_unit(unit: Dictionary)` — Emitted when a SlotItem requests to inspect its assigned unit.

## Member Function Documentation

### build_from_slots

```gdscript
func build_from_slots(slots: Dictionary) -> void
```

Rebuild child SlotItems from the provided slot metadata map.

### set_assignment

```gdscript
func set_assignment(slot_id: String, unit: UnitData) -> void
```

Apply an assigned unit to a specific SlotItem by slot_id.

### clear_assignment

```gdscript
func clear_assignment(slot_id: String) -> void
```

Clear the assigned unit from a specific SlotItem by slot_id.

### flash_denied

```gdscript
func flash_denied(slot_id: String) -> void
```

Briefly tint a SlotItem to indicate a denied action.

## Member Data Documentation

### _items_by_slot

```gdscript
var _items_by_slot: Dictionary
```

Decorators: `@export var slot_item_scene: PackedScene`

Slot Scene

## Signal Documentation

### request_assign_drop

```gdscript
signal request_assign_drop(slot_id: String, unit: Dictionary, source_slot_id: String)
```

Emitted when a SlotItem requests to assign a unit after a valid drop.

### request_inspect_unit

```gdscript
signal request_inspect_unit(unit: Dictionary)
```

Emitted when a SlotItem requests to inspect its assigned unit.
