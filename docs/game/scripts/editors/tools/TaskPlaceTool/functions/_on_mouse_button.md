# TaskPlaceTool::_on_mouse_button Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTaskTool.gd` (lines 43–57)</br>
*Belongs to:* [TaskPlaceTool](../TaskPlaceTool.md)

**Signature**

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool
```

## Source

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool:
	if not e.pressed:
		return false
	match e.button_index:
		MOUSE_BUTTON_LEFT:
			if _hover_valid:
				_place()
				return true
		MOUSE_BUTTON_RIGHT:
			editor._clear_tool()
			emit_signal("canceled")
			return true
	return false
```
