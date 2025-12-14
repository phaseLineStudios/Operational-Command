# OCMenuItemList::_handle_hover Function Reference

*Defined at:* `scripts/ui/controls/OcMenuItemList.gd` (lines 27–35)</br>
*Belongs to:* [OCMenuItemList](../../OCMenuItemList.md)

**Signature**

```gdscript
func _handle_hover(mouse_pos: Vector2) -> void
```

## Source

```gdscript
func _handle_hover(mouse_pos: Vector2) -> void:
	var item_index := get_item_at_position(mouse_pos, true)

	if item_index != _last_hovered_item:
		if item_index >= 0:
			_play_hover(item_index)
		_last_hovered_item = item_index
```
