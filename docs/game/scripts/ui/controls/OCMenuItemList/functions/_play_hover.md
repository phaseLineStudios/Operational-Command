# OCMenuItemList::_play_hover Function Reference

*Defined at:* `scripts/ui/controls/OcMenuItemList.gd` (lines 45–55)</br>
*Belongs to:* [OCMenuItemList](../../OCMenuItemList.md)

**Signature**

```gdscript
func _play_hover(item_index: int) -> void
```

## Source

```gdscript
func _play_hover(item_index: int) -> void:
	if not is_item_disabled(item_index):
		if hover_sounds.size() > 0:
			AudioManager.play_random_ui_sound(hover_sounds, Vector2(1.0, 1.0), Vector2(0.98, 1.02))
	else:
		if hover_disabled_sounds.size() > 0:
			AudioManager.play_random_ui_sound(
				hover_disabled_sounds, Vector2(1.0, 1.0), Vector2(0.98, 1.02)
			)
```
