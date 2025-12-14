# OCMenuButton::_play_hover Function Reference

*Defined at:* `scripts/ui/controls/OcMenuButton.gd` (lines 73–83)</br>
*Belongs to:* [OCMenuButton](../../OCMenuButton.md)

**Signature**

```gdscript
func _play_hover() -> void
```

## Source

```gdscript
func _play_hover() -> void:
	if not disabled:
		if hover_sounds.size() > 0:
			AudioManager.play_random_ui_sound(hover_sounds, Vector2(1.0, 1.0), Vector2(0.98, 1.02))
	else:
		if hover_disabled_sounds.size() > 0:
			AudioManager.play_random_ui_sound(
				hover_disabled_sounds, Vector2(1.0, 1.0), Vector2(0.98, 1.02)
			)
```
