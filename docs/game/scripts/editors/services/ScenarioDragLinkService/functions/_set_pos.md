# ScenarioDragLinkService::_set_pos Function Reference

*Defined at:* `scripts/editors/services/ScenarioDragLinkService.gd` (lines 93–122)</br>
*Belongs to:* [ScenarioDragLinkService](../ScenarioDragLinkService.md)

**Signature**

```gdscript
func _set_pos(ctx: ScenarioEditorContext, pick: Dictionary, p: Vector2) -> void
```

## Source

```gdscript
func _set_pos(ctx: ScenarioEditorContext, pick: Dictionary, p: Vector2) -> void:
	match StringName(pick.get("type", "")):
		&"unit":
			var i := int(pick["index"])
			if ctx.data.units and i >= 0 and i < ctx.data.units.size() and ctx.data.units[i]:
				ctx.data.units[i].position_m = p
		&"slot":
			var s := int(pick["index"])
			if (
				ctx.data.unit_slots
				and s >= 0
				and s < ctx.data.unit_slots.size()
				and ctx.data.unit_slots[s]
			):
				ctx.data.unit_slots[s].start_position = p
		&"task":
			var t := int(pick["index"])
			if ctx.data.tasks and t >= 0 and t < ctx.data.tasks.size() and ctx.data.tasks[t]:
				ctx.data.tasks[t].position_m = p
		&"trigger":
			var g := int(pick["index"])
			if (
				ctx.data.triggers
				and g >= 0
				and g < ctx.data.triggers.size()
				and ctx.data.triggers[g]
			):
				ctx.data.triggers[g].area_center_m = p
```
