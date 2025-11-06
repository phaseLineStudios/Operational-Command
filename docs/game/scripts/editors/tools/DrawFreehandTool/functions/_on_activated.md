# DrawFreehandTool::_on_activated Function Reference

*Defined at:* `scripts/editors/tools/ScenarioDrawFreehandTool.gd` (lines 21–24)</br>
*Belongs to:* [DrawFreehandTool](../../DrawFreehandTool.md)

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
