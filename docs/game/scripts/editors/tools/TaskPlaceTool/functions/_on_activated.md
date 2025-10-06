# TaskPlaceTool::_on_activated Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTaskTool.gd` (lines 20–23)</br>
*Belongs to:* [TaskPlaceTool](../TaskPlaceTool.md)

**Signature**

```gdscript
func _on_activated() -> void
```

## Source

```gdscript
func _on_activated() -> void:
	emit_signal("request_redraw_overlay")
```
