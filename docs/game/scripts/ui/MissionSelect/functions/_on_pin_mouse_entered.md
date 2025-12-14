# MissionSelect::_on_pin_mouse_entered Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 222–230)</br>
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

	if pin_hover_sounds.size() > 0:
		AudioManager.play_random_ui_sound(pin_hover_sounds, Vector2(1.0, 1.0), Vector2(0.98, 1.02))
```
