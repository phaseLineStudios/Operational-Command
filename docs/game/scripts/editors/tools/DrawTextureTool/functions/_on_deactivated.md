# DrawTextureTool::_on_deactivated Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawTextureTool.gd` (lines 30–34)</br>
*Belongs to:* [DrawTextureTool](../../DrawTextureTool.md)

**Signature**

```gdscript
func _on_deactivated() -> void
```

## Description

Deactivate tool.

## Source

```gdscript
func _on_deactivated() -> void:
	_has_hover = false
	request_redraw_overlay.emit()
```
