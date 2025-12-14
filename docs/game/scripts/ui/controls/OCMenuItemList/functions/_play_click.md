# OCMenuItemList::_play_click Function Reference

*Defined at:* `scripts/ui/controls/OcMenuItemList.gd` (lines 56–64)</br>
*Belongs to:* [OCMenuItemList](../../OCMenuItemList.md)

**Signature**

```gdscript
func _play_click(item_index: int) -> void
```

## Source

```gdscript
func _play_click(item_index: int) -> void:
	if not is_item_disabled(item_index):
		if click_sounds.size() > 0:
			AudioManager.play_random_ui_sound(click_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1))
	else:
		if click_disabled_sounds.size() > 0:
			AudioManager.play_random_ui_sound(
				click_disabled_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1)
			)
```
