# UnitPlaceTool::_on_deactivated Function Reference

*Defined at:* `scripts/editors/tools/ScenarioUnitTool.gd` (lines 36–41)</br>
*Belongs to:* [UnitPlaceTool](../UnitPlaceTool.md)

**Signature**

```gdscript
func _on_deactivated()
```

## Source

```gdscript
func _on_deactivated():
	if editor and editor.unit_list:
		editor.unit_list.deselect_all()
	emit_signal("request_redraw_overlay")
```
