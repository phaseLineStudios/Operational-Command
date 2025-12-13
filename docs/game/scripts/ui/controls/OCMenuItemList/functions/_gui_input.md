# OCMenuItemList::_gui_input Function Reference

*Defined at:* `scripts/ui/controls/OcMenuItemList.gd` (lines 22–26)</br>
*Belongs to:* [OCMenuItemList](../../OCMenuItemList.md)

**Signature**

```gdscript
func _gui_input(event: InputEvent) -> void
```

## Source

```gdscript
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_handle_hover(event.position)
```
