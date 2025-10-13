# UnitPlaceTool::_on_mouse_button Function Reference

*Defined at:* `scripts/editors/tools/ScenarioUnitTool.gd` (lines 64–76)</br>
*Belongs to:* [UnitPlaceTool](../../UnitPlaceTool.md)

**Signature**

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool
```

## Source

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool:
	if e.pressed:
		match e.button_index:
			MOUSE_BUTTON_LEFT:
				if _hover_valid:
					_place()
					return true
			MOUSE_BUTTON_RIGHT:
				emit_signal("canceled")
				return true
	return false
```
