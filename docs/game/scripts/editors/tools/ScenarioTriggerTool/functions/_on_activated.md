# ScenarioTriggerTool::_on_activated Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTriggerTool.gd` (lines 11–14)</br>
*Belongs to:* [ScenarioTriggerTool](../../ScenarioTriggerTool.md)

**Signature**

```gdscript
func _on_activated() -> void
```

## Source

```gdscript
func _on_activated() -> void:
	emit_signal("request_redraw_overlay")
```
