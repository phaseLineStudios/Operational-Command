# OCMenuTabContainer::_on_tab_bar_input Function Reference

*Defined at:* `scripts/ui/controls/OcMenuTabContainer.gd` (lines 27–34)</br>
*Belongs to:* [OCMenuTabContainer](../../OCMenuTabContainer.md)

**Signature**

```gdscript
func _on_tab_bar_input(event: InputEvent) -> void
```

## Source

```gdscript
func _on_tab_bar_input(event: InputEvent) -> void:
	if not _tab_bar:
		return

	if event is InputEventMouseMotion:
		_handle_hover(event.position)
```
