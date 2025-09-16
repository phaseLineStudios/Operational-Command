extends RefCounted
class_name ScenarioDragLinkService

var dragging := false
var drag_pick: Dictionary = {}
var drag_offset_m := Vector2.ZERO
var drag_origin_m := Vector2.ZERO
var linking := false
var link_src_pick: Dictionary = {}

func begin_drag(ctx: ScenarioEditorContext, pick: Dictionary, overlay_pos: Vector2) -> void:
	if pick.is_empty(): return
	dragging = true
	drag_pick = pick
	drag_origin_m = _get_pos(ctx, pick)
	var mp := ctx.terrain_render.map_to_terrain(overlay_pos)
	drag_offset_m = drag_origin_m - mp

func update_drag(ctx: ScenarioEditorContext, overlay_pos: Vector2) -> void:
	if not dragging: return
	var mp := ctx.terrain_render.map_to_terrain(overlay_pos)
	var target := mp + drag_offset_m
	if ctx.terrain_render.is_inside_map(target):
		_set_pos(ctx, drag_pick, target)
		ctx.request_overlay_redraw()

func end_drag(ctx: ScenarioEditorContext, commit := true) -> void:
	if not dragging: return
	if not commit:
		_set_pos(ctx, drag_pick, drag_origin_m)
	else:
		_commit_move(ctx, drag_pick, drag_origin_m, _get_pos(ctx, drag_pick))
	dragging = false
	drag_pick = {}

func begin_link(ctx: ScenarioEditorContext, src: Dictionary, cursor_pos: Vector2) -> void:
	linking = true
	link_src_pick = src
	ctx.terrain_overlay.begin_link_preview(src)
	ctx.terrain_overlay.update_link_preview(cursor_pos)

func update_link(ctx: ScenarioEditorContext, cursor_pos: Vector2) -> void:
	if linking: ctx.terrain_overlay.update_link_preview(cursor_pos)

func end_link(ctx: ScenarioEditorContext) -> void:
	if linking:
		ctx.terrain_overlay.end_link_preview()
	linking = false
	link_src_pick = {}

func _get_pos(ctx: ScenarioEditorContext, pick: Dictionary) -> Vector2:
	match StringName(pick.get("type","")):
		&"unit":
			var i := int(pick["index"]); if ctx.data.units and i>=0 and i<ctx.data.units.size() and ctx.data.units[i]: return ctx.data.units[i].position_m
		&"slot":
			var s := int(pick["index"]); if ctx.data.unit_slots and s>=0 and s<ctx.data.unit_slots.size() and ctx.data.unit_slots[s]: return ctx.data.unit_slots[s].start_position
		&"task":
			var t := int(pick["index"]); if ctx.data.tasks and t>=0 and t<ctx.data.tasks.size() and ctx.data.tasks[t]: return ctx.data.tasks[t].position_m
		&"trigger":
			var g := int(pick["index"]); if ctx.data.triggers and g>=0 and g<ctx.data.triggers.size() and ctx.data.triggers[g]: return ctx.data.triggers[g].area_center_m
	return Vector2.ZERO

func _set_pos(ctx: ScenarioEditorContext, pick: Dictionary, p: Vector2) -> void:
	match StringName(pick.get("type","")):
		&"unit":
			var i := int(pick["index"]); if ctx.data.units and i>=0 and i<ctx.data.units.size() and ctx.data.units[i]: ctx.data.units[i].position_m = p
		&"slot":
			var s := int(pick["index"]); if ctx.data.unit_slots and s>=0 and s<ctx.data.unit_slots.size() and ctx.data.unit_slots[s]: ctx.data.unit_slots[s].start_position = p
		&"task":
			var t := int(pick["index"]); if ctx.data.tasks and t>=0 and t<ctx.data.tasks.size() and ctx.data.tasks[t]: ctx.data.tasks[t].position_m = p
		&"trigger":
			var g := int(pick["index"]); if ctx.data.triggers and g>=0 and g<ctx.data.triggers.size() and ctx.data.triggers[g]: ctx.data.triggers[g].area_center_m = p

func _commit_move(ctx: ScenarioEditorContext, pick: Dictionary, before: Vector2, after: Vector2) -> void:
	if before.distance_squared_to(after) <= 0.001:
		return

	var t := StringName(pick.get("type",""))
	var idx := int(pick.get("index",-1))

	if t == &"unit":
		var su: ScenarioUnit = ctx.data.units[idx]
		ctx.history.push_entity_move(ctx.data, &"unit", su.id, before, after, "Move Unit %s" % su.callsign)
	elif t == &"slot":
		var sl: UnitSlotData = ctx.data.unit_slots[idx]
		ctx.history.push_entity_move(ctx.data, &"slot", sl.key, before, after, "Move Slot %s" % sl.title, "key")
	elif t == &"task":
		var ti: ScenarioTask = ctx.data.tasks[idx]
		var tname := (ti.task.display_name if ti.task else "Task")
		ctx.history.push_entity_move(ctx.data, &"task", ti.id, before, after, "Move %s" % tname)
	elif t == &"trigger":
		var before_snap := ScenarioHistory._deep_copy_array_res(ctx.data.triggers if ctx.data and ctx.data.triggers else [])
		var after_snap  := ScenarioHistory._deep_copy_array_res(ctx.data.triggers if ctx.data and ctx.data.triggers else [])

		if idx >= 0 and before_snap and idx < before_snap.size() and before_snap[idx]:
			(before_snap[idx] as ScenarioTrigger).area_center_m = before
		if idx >= 0 and after_snap and idx < after_snap.size() and after_snap[idx]:
			(after_snap[idx] as ScenarioTrigger).area_center_m = after

		ctx.history.push_array_replace(
			ctx.data, "triggers",
			before_snap, after_snap,
			"Move Trigger %s" % String(ctx.data.triggers[idx].id)
		)
