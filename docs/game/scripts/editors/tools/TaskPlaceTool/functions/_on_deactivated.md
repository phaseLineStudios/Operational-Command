# TaskPlaceTool::_on_deactivated Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTaskTool.gd` (lines 24–29)</br>
*Belongs to:* [TaskPlaceTool](../../TaskPlaceTool.md)

**Signature**

```gdscript
func _on_deactivated()
```

## Source

```gdscript
func _on_deactivated():
	if editor and editor.task_list:
		editor.task_list.deselect_all()
	emit_signal("request_redraw_overlay")
```
