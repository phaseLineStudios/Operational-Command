# DrawingController::_update_current_tool Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 92–111)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func _update_current_tool() -> void
```

## Source

```gdscript
func _update_current_tool() -> void:
	if not interaction or not interaction._held:
		_current_tool = Tool.NONE
		return

	var held_name := interaction._held.name

	match held_name:
		"PenBlack":
			_current_tool = Tool.PEN_BLACK
		"PenBlue":
			_current_tool = Tool.PEN_BLUE
		"PenRed":
			_current_tool = Tool.PEN_RED
		"Eraser":
			_current_tool = Tool.ERASER
		_:
			_current_tool = Tool.NONE
```
