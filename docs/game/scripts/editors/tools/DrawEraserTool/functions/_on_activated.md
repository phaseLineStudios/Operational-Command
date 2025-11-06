# DrawEraserTool::_on_activated Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawEraserTool.gd` (lines 15–18)</br>
*Belongs to:* [DrawEraserTool](../../DrawEraserTool.md)

**Signature**

```gdscript
func _on_activated() -> void
```

## Description

Activate tool.

## Source

```gdscript
func _on_activated() -> void:
	request_redraw_overlay.emit()
```
