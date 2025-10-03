class_name ScenarioTriggersService
extends RefCounted


func build_palette(ctx: ScenarioEditorContext) -> void:
	var list := ctx.trigger_list
	list.clear()
	var i := list.add_item("Trigger")
	var proto := ScenarioTrigger.new()
	proto.title = "Trigger"
	proto.area_size_m = Vector2(100.0, 100.0)
	list.set_item_metadata(i, proto)
	var img := proto.icon.get_image()
	img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
	list.set_item_icon(i, ImageTexture.create_from_image(img))
	list.item_selected.connect(func(idx): _on_selected(ctx, idx))


func _on_selected(ctx: ScenarioEditorContext, idx: int) -> void:
	var meta: Variant = ctx.trigger_list.get_item_metadata(idx)
	if meta is ScenarioTrigger:
		ctx.selection_changed.emit({"type": &"trigger_palette", "prototype": meta})


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


static func _next_id(data: ScenarioData) -> String:
	var used := {}
	if data and data.triggers:
		for t in data.triggers:
			if t and t.id is String and (t.id as String).begins_with("TRG_"):
				var s := (t.id as String).substr(4)
				if s.is_valid_int():
					used[int(s)] = true
	var n := 1
	while used.has(n):
		n += 1
	return "TRG_%d" % n


func try_sync_link(ctx: ScenarioEditorContext, a: Dictionary, b: Dictionary) -> void:
	if a.is_empty() or b.is_empty():
		return
	var ta := StringName(a.get("type", ""))
	var tb := StringName(b.get("type", ""))
	if ta == tb and ta != &"trigger":
		return
	if ta != &"trigger" and tb != &"trigger":
		return
	var trig_idx := int(a["index"]) if ta == &"trigger" else int(b["index"])
	var unit_idx := int(b["index"]) if tb == &"unit" else (int(a["index"]) if ta == &"unit" else -1)
	var task_idx := int(b["index"]) if tb == &"task" else (int(a["index"]) if ta == &"task" else -1)
	if ctx.data == null or ctx.data.triggers == null:
		return
	if trig_idx < 0 or trig_idx >= ctx.data.triggers.size():
		return
	var trig: ScenarioTrigger = ctx.data.triggers[trig_idx]
	if trig == null:
		return
	if unit_idx >= 0:
		if trig.synced_units == null:
			trig.synced_units = []
		if not trig.synced_units.has(unit_idx):
			trig.synced_units.append(unit_idx)
	if task_idx >= 0:
		if trig.synced_tasks == null:
			trig.synced_tasks = []
		if not trig.synced_tasks.has(task_idx):
			trig.synced_tasks.append(task_idx)
	ctx.request_overlay_redraw()
	ctx.request_scene_tree_rebuild()
