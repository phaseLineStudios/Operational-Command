# ScenarioEditor::_place_trigger_from_tool Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 323–337)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _place_trigger_from_tool(inst: ScenarioTrigger, pos_m: Vector2) -> void
```

## Description

Place a Trigger at world position (meters) and push to history

## Source

```gdscript
func _place_trigger_from_tool(inst: ScenarioTrigger, pos_m: Vector2) -> void:
	if ctx.data == null:
		push_warning("No active scenario")
		return
	inst.id = _generate_trigger_id()
	inst.area_center_m = pos_m
	if inst.title.strip_edges() == "":
		inst.title = inst.id
	if ctx.data.triggers == null:
		ctx.data.triggers = []
	history.push_res_insert(ctx.data, "triggers", "id", inst, "Place Trigger %s" % inst.title)
	_rebuild_scene_tree()
	ctx.request_overlay_redraw()
```
