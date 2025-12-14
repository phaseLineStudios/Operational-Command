# UnitCard::_on_mouse_entered Function Reference

*Defined at:* `scripts/ui/helpers/UnitCard.gd` (lines 121–127)</br>
*Belongs to:* [UnitCard](../../UnitCard.md)

**Signature**

```gdscript
func _on_mouse_entered() -> void
```

## Description

Hover-in visual feedback.

## Source

```gdscript
func _on_mouse_entered() -> void:
	_is_hovered = true
	_update_style()
	if hover_sounds.size() > 0:
		AudioManager.play_random_ui_sound(hover_sounds, Vector2(1.0, 1.0), Vector2(0.98, 1.02))
```
