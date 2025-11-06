# DrawEraserTool::_on_deactivated Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawEraserTool.gd` (lines 20–23)</br>
*Belongs to:* [DrawEraserTool](../../DrawEraserTool.md)

**Signature**

```gdscript
func _on_deactivated() -> void
```

## Description

Deactivate tool.

## Source

```gdscript
func _on_deactivated() -> void:
	request_redraw_overlay.emit()
```
