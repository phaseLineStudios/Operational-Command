# UnitCard::_gui_input Function Reference

*Defined at:* `scripts/ui/helpers/UnitCard.gd` (lines 105–111)</br>
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
		if click_sounds.size() > 0:
			AudioManager.play_random_ui_sound(click_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1))
		emit_signal("unit_selected", unit)
```
