# MissionSelect::_on_pin_mouse_exited Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 212–220)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _on_pin_mouse_exited(pin: Control) -> void
```

## Description

Restore highlight alpha when mouse leaves.

## Source

```gdscript
func _on_pin_mouse_exited(pin: Control) -> void:
	var state := str(pin.get_meta("highlight_state", "dim"))

	if state == "current":
		pin.modulate = Color(1.0, 1.0, 1.0, 0.5)
	else:
		pin.modulate = Color(1.0, 1.0, 1.0, 1.0)
```
