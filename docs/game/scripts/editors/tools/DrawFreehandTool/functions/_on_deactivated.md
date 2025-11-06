# DrawFreehandTool::_on_deactivated Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawFreehandTool.gd` (lines 26–31)</br>
*Belongs to:* [DrawFreehandTool](../../DrawFreehandTool.md)

**Signature**

```gdscript
func _on_deactivated() -> void
```

## Description

Deactivate tool.

## Source

```gdscript
func _on_deactivated() -> void:
	_dragging = false
	_points_m.clear()
	request_redraw_overlay.emit()
```
