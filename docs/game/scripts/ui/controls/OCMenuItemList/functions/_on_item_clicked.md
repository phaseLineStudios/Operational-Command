# OCMenuItemList::_on_item_clicked Function Reference

*Defined at:* `scripts/ui/controls/OcMenuItemList.gd` (lines 40–44)</br>
*Belongs to:* [OCMenuItemList](../../OCMenuItemList.md)

**Signature**

```gdscript
func _on_item_clicked(_idx: int, _pos: Vector2, mouse_button_index: int) -> void
```

## Source

```gdscript
func _on_item_clicked(_idx: int, _pos: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		_play_click(_idx)
```
