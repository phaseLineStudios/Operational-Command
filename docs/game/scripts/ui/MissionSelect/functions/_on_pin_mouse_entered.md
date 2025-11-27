# MissionSelect::_on_pin_mouse_entered Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 205–210)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _on_pin_mouse_entered(pin: Control) -> void
```

## Description

Temporarily restore full alpha while hovering a pin.

## Source

```gdscript
func _on_pin_mouse_entered(pin: Control) -> void:
	var c := pin.modulate
	c.a = 1.0
	pin.modulate = c
```
