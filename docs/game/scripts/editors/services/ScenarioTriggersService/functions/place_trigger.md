# ScenarioTriggersService::place_trigger Function Reference

*Defined at:* `scripts/editors/services/ScenarioTriggersService.gd` (lines 25–36)</br>
*Belongs to:* [ScenarioTriggersService](../ScenarioTriggersService.md)

**Signature**

```gdscript
func place_trigger(ctx: ScenarioEditorContext, inst: ScenarioTrigger, pos_m: Vector2) -> void
```

## Source

```gdscript
func place_trigger(ctx: ScenarioEditorContext, inst: ScenarioTrigger, pos_m: Vector2) -> void:
	inst.id = _next_id(ctx.data)
	inst.area_center_m = pos_m
	if inst.title.strip_edges() == "":
		inst.title = inst.id
	if ctx.data.triggers == null:
		ctx.data.triggers = []
	ctx.history.push_res_insert(ctx.data, "triggers", "id", inst, "Place Trigger %s" % inst.title)
	ctx.request_scene_tree_rebuild()
	ctx.request_overlay_redraw()
```
