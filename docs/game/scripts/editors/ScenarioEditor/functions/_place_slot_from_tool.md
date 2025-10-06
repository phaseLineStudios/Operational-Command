# ScenarioEditor::_place_slot_from_tool Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 300–315)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _place_slot_from_tool(slot_def: UnitSlotData, pos_m: Vector2) -> void
```

## Description

Place a player slot at world position (meters) and push to history

## Source

```gdscript
func _place_slot_from_tool(slot_def: UnitSlotData, pos_m: Vector2) -> void:
	if ctx.data == null:
		push_warning("No active scenario")
		return
	var inst := UnitSlotData.new()
	inst.key = _next_slot_key()
	inst.title = _generate_callsign(ScenarioUnit.Affiliation.FRIEND)
	inst.allowed_roles = slot_def.allowed_roles.duplicate()
	inst.start_position = pos_m
	if ctx.data.unit_slots == null:
		ctx.data.unit_slots = []
	history.push_res_insert(ctx.data, "unit_slots", "key", inst, "Place Slot %s" % inst.title)
	ctx.request_overlay_redraw()
	_rebuild_scene_tree()
```
