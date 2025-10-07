# UnitCard::_gui_input Function Reference

*Defined at:* `scripts/ui/helpers/UnitCard.gd` (lines 92–96)</br>
*Belongs to:* [UnitCard](../../UnitCard.md)

**Signature**

```gdscript
func _gui_input(e: InputEvent) -> void
```

## Description

Click to inspect the unit.

## Source

```gdscript
func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		emit_signal("unit_selected", unit)
```
