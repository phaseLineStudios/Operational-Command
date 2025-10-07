# TaskPlaceTool::_on_key Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTaskTool.gd` (lines 58–65)</br>
*Belongs to:* [TaskPlaceTool](../../TaskPlaceTool.md)

**Signature**

```gdscript
func _on_key(e: InputEventKey) -> bool
```

## Source

```gdscript
func _on_key(e: InputEventKey) -> bool:
	if e.pressed and e.keycode == KEY_ESCAPE:
		editor._clear_tool()
		emit_signal("canceled")
		return true
	return false
```
