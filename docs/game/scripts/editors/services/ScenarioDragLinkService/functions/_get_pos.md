# ScenarioDragLinkService::_get_pos Function Reference

*Defined at:* `scripts/editors/services/ScenarioDragLinkService.gd` (lines 62–92)</br>
*Belongs to:* [ScenarioDragLinkService](../../ScenarioDragLinkService.md)

**Signature**

```gdscript
func _get_pos(ctx: ScenarioEditorContext, pick: Dictionary) -> Vector2
```

## Source

```gdscript
func _get_pos(ctx: ScenarioEditorContext, pick: Dictionary) -> Vector2:
	match StringName(pick.get("type", "")):
		&"unit":
			var i := int(pick["index"])
			if ctx.data.units and i >= 0 and i < ctx.data.units.size() and ctx.data.units[i]:
				return ctx.data.units[i].position_m
		&"slot":
			var s := int(pick["index"])
			if (
				ctx.data.unit_slots
				and s >= 0
				and s < ctx.data.unit_slots.size()
				and ctx.data.unit_slots[s]
			):
				return ctx.data.unit_slots[s].start_position
		&"task":
			var t := int(pick["index"])
			if ctx.data.tasks and t >= 0 and t < ctx.data.tasks.size() and ctx.data.tasks[t]:
				return ctx.data.tasks[t].position_m
		&"trigger":
			var g := int(pick["index"])
			if (
				ctx.data.triggers
				and g >= 0
				and g < ctx.data.triggers.size()
				and ctx.data.triggers[g]
			):
				return ctx.data.triggers[g].area_center_m
	return Vector2.ZERO
```
