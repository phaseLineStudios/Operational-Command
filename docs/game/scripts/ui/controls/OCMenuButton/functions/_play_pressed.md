# OCMenuButton::_play_pressed Function Reference

*Defined at:* `scripts/ui/controls/OcMenuButton.gd` (lines 84–94)</br>
*Belongs to:* [OCMenuButton](../../OCMenuButton.md)

**Signature**

```gdscript
func _play_pressed() -> void
```

## Source

```gdscript
func _play_pressed() -> void:
	if not disabled:
		if click_sounds.size() > 0:
			AudioManager.play_random_ui_sound(click_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1))
	else:
		if click_disabled_sounds.size() > 0:
			AudioManager.play_random_ui_sound(
				click_disabled_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1)
			)
```
