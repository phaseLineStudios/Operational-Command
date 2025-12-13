# OCMenuTabContainer::_handle_hover Function Reference

*Defined at:* `scripts/ui/controls/OcMenuTabContainer.gd` (lines 35–53)</br>
*Belongs to:* [OCMenuTabContainer](../../OCMenuTabContainer.md)

**Signature**

```gdscript
func _handle_hover(mouse_pos: Vector2) -> void
```

## Source

```gdscript
func _handle_hover(mouse_pos: Vector2) -> void:
	if not _tab_bar:
		return

	var tab_index := -1
	var tab_count := get_tab_count()

	for i in range(tab_count):
		var tab_rect := _tab_bar.get_tab_rect(i)
		if tab_rect.has_point(mouse_pos):
			tab_index = i
			break

	if tab_index != _last_hovered_tab:
		if tab_index >= 0:
			_play_hover(tab_index)
		_last_hovered_tab = tab_index
```
