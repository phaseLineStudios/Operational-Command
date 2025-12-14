# ScenarioEditor::_place_unit_from_tool Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 230–248)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _place_unit_from_tool(u: UnitData, pos_m: Vector2) -> void
```

## Description

Place a Unit at world position (meters) and push to history

## Source

```gdscript
func _place_unit_from_tool(u: UnitData, pos_m: Vector2) -> void:
	if ctx.data == null:
		push_warning("No active scenario")
		return
	var su := ScenarioUnit.new()
	su.unit = u
	su.position_m = pos_m
	su.affiliation = ctx.selected_unit_affiliation
	su.callsign = id_gen.generate_callsign(ctx.selected_unit_affiliation)
	su.id = id_gen.generate_unit_instance_id_for(u)
	if ctx.data.units == null:
		ctx.data.units = []
	history.push_res_insert(ctx.data, "units", "id", su, "Place Unit %s" % su.callsign)
	ctx.selected_pick = {"type": &"unit", "index": ctx.data.units.size() - 1}
	ctx.request_overlay_redraw()
	_rebuild_scene_tree()
	units._refresh(ctx)
```
