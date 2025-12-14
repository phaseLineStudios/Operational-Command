# ViewportReadOverlay::_on_background_gui_input Function Reference

*Defined at:* `scripts/ui/ViewportReadOverlay.gd` (lines 102–109)</br>
*Belongs to:* [ViewportReadOverlay](../../ViewportReadOverlay.md)

**Signature**

```gdscript
func _on_background_gui_input(event: InputEvent) -> void
```

## Source

```gdscript
func _on_background_gui_input(event: InputEvent) -> void:
	if not close_on_background_click:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		close()
```
