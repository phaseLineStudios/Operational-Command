# ScenarioSelectionService::_build_hint Function Reference

*Defined at:* `scripts/editors/services/ScenarioSelectionService.gd` (lines 24–36)</br>
*Belongs to:* [ScenarioSelectionService](../ScenarioSelectionService.md)

**Signature**

```gdscript
func _build_hint(ctx: ScenarioEditorContext, pick: Dictionary) -> void
```

## Source

```gdscript
func _build_hint(ctx: ScenarioEditorContext, pick: Dictionary) -> void:
	_queue_free_children(ctx.tool_hint)
	var t := StringName(pick.get("type", ""))
	if t in [&"unit", &"task"]:
		var l := Label.new()
		l.text = "CTRL+DRAG - synchronize with trigger"
		ctx.tool_hint.add_child(l)
	elif t == &"trigger":
		var l2 := Label.new()
		l2.text = "CTRL+DRAG - synchronize with Unit/Task"
		ctx.tool_hint.add_child(l2)
```
