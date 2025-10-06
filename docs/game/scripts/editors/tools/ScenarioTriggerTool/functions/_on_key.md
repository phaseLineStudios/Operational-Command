# ScenarioTriggerTool::_on_key Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTriggerTool.gd` (lines 64–71)</br>
*Belongs to:* [ScenarioTriggerTool](../ScenarioTriggerTool.md)

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
