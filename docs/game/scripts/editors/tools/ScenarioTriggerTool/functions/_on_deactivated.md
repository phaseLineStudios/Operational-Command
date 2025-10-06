# ScenarioTriggerTool::_on_deactivated Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTriggerTool.gd` (lines 15–20)</br>
*Belongs to:* [ScenarioTriggerTool](../ScenarioTriggerTool.md)

**Signature**

```gdscript
func _on_deactivated()
```

## Source

```gdscript
func _on_deactivated():
	if editor and editor.trigger_list:
		editor.trigger_list.deselect_all()
	emit_signal("request_redraw_overlay")
```
