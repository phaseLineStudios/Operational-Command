# SlotItem::_gui_input Function Reference

*Defined at:* `scripts/ui/helpers/SlotItem.gd` (lines 147–152)</br>
*Belongs to:* [SlotItem](../../SlotItem.md)

**Signature**

```gdscript
func _gui_input(e: InputEvent) -> void
```

## Description

On click, emit inspect signal if a unit is assigned.

## Source

```gdscript
func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		if _assigned_unit != null:
			emit_signal("request_inspect_unit", _assigned_unit)
```
