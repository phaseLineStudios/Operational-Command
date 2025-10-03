class_name ScenarioTasksService
extends RefCounted

var defs: Array[UnitBaseTask] = []
var selected_def: UnitBaseTask


func setup(ctx: ScenarioEditorContext) -> void:
	_init_defs()
	_build_list(ctx)
	ctx.task_list.item_selected.connect(func(idx): _on_selected(ctx, idx))


func _init_defs() -> void:
	defs.clear()
	defs.append(UnitTask_Move.new())
	defs.append(UnitTask_Defend.new())
	defs.append(UnitTask_Wait.new())
	defs.append(UnitTask_Patrol.new())
	defs.append(UnitTask_SetBehaviour.new())
	defs.append(UnitTask_SetCombatMode.new())


func _build_list(ctx: ScenarioEditorContext) -> void:
	var list := ctx.task_list
	list.clear()
	for i in defs.size():
		var t: UnitBaseTask = defs[i]
		if t.icon:
			var img := t.icon.get_image()
			img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
			list.add_item(t.display_name, ImageTexture.create_from_image(img))
		else:
			list.add_item(t.display_name)
		list.set_item_metadata(i, t)


func _on_selected(ctx: ScenarioEditorContext, index: int) -> void:
	var meta: Variant = ctx.task_list.get_item_metadata(index)
	selected_def = meta if meta is UnitBaseTask else null
	if selected_def:
		ctx.selection_changed.emit({"type": &"task_palette", "task": selected_def})


# --- API used by editor/tool ---
func place_task_for_unit(
	ctx: ScenarioEditorContext,
	unit_index: int,
	task: UnitBaseTask,
	pos_m: Vector2,
	after_index := -1
) -> int:
	if ctx.data == null or task == null:
		return -1
	if ctx.data.tasks == null:
		ctx.data.tasks = []

	var before := _snap(ctx)
	var after := _snap(ctx)
	var tasks := after["tasks"] as Array

	var inst := ScenarioTask.new()
	inst.id = _gen_task_id(ctx, task.type_id)
	inst.task = task
	inst.unit_index = unit_index
	inst.position_m = pos_m
	inst.params = task.make_default_params()
	inst.prev_index = -1
	inst.next_index = -1

	if after_index >= 0 and after_index < tasks.size():
		var after_ref: ScenarioTask = tasks[after_index]
		inst.prev_index = after_index
		inst.next_index = after_ref.next_index
	else:
		var tail := _find_tail(after["tasks"], unit_index)
		inst.prev_index = tail

	var new_idx: int = tasks.size()
	tasks.append(inst)

	if inst.prev_index >= 0 and inst.prev_index < tasks.size():
		(tasks[inst.prev_index] as ScenarioTask).next_index = new_idx
	if inst.next_index >= 0 and inst.next_index < tasks.size():
		(tasks[inst.next_index] as ScenarioTask).prev_index = new_idx

	ctx.history.push_array_replace(ctx.data, "tasks", before["tasks"], after["tasks"], "Place Task")
	ctx.request_scene_tree_rebuild()
	ctx.request_overlay_redraw()
	return new_idx


func collect_unit_chain(data: ScenarioData, unit_index: int) -> Array[int]:
	var out: Array[int] = []
	if data == null or data.tasks == null:
		return out
	var visited := {}
	for i in data.tasks.size():
		var t: ScenarioTask = data.tasks[i]
		if t and t.unit_index == unit_index and t.prev_index == -1:
			var cur := i
			while cur >= 0 and cur < data.tasks.size() and not visited.has(cur):
				visited[cur] = true
				out.append(cur)
				var nxt := data.tasks[cur].next_index
				if nxt == cur:
					break
				cur = nxt
	for j in data.tasks.size():
		if data.tasks[j] and data.tasks[j].unit_index == unit_index and not visited.has(j):
			out.append(j)
	return out


func make_task_title(inst: ScenarioTask, idx_in_chain: int) -> String:
	var nm := inst.task.display_name if (inst.task and inst.task.display_name != "") else "Task"
	return "%d: %s" % [idx_in_chain + 1, nm]


func _gen_task_id(ctx: ScenarioEditorContext, type_id: StringName) -> String:
	var base := "task_%s" % String(type_id)
	var used := {}
	if ctx.data.tasks:
		for t in ctx.data.tasks:
			if t and t.id is String and (t.id as String).begins_with(base + "_"):
				var s := (t.id as String).substr(base.length() + 1)
				if s.is_valid_int():
					used[int(s)] = true
	var n := 1
	while used.has(n):
		n += 1
	return "%s_%d" % [base, n]


func _find_tail(tasks: Array, unit_index: int) -> int:
	var tail := -1
	for i in tasks.size():
		var ti: ScenarioTask = tasks[i]
		if ti and ti.unit_index == unit_index and ti.next_index == -1:
			tail = i
	return tail


func _snap(ctx: ScenarioEditorContext) -> Dictionary:
	return {
		"tasks":
		ScenarioHistory._deep_copy_array_res(ctx.data.tasks if ctx.data and ctx.data.tasks else [])
	}
