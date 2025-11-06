# DrawTextureTool::_on_activated Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawTextureTool.gd` (lines 25–28)</br>
*Belongs to:* [DrawTextureTool](../../DrawTextureTool.md)

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
