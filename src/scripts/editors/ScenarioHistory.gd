class_name ScenarioHistory
extends Node
## Wrapper around Godot's UndoRedo for ScenarioData edits.
##
## Records actions, supports inserting/removing/replacing resource items in arrays.
## moving entities by id, and multi-array atomic changes.

## Emitted when the history stack changes
signal history_changed(past: Array, future: Array)

var _ur := UndoRedo.new()
var _past: Array[String] = []
var _future: Array[String] = []


## Undo last action
func undo() -> void:
	if _past.is_empty():
		return
	var last: String = _past.pop_back()
	_ur.undo()
	_future.append(last)
	emit_signal("history_changed", _past.duplicate(), _future.duplicate())


## Redo next action
func redo() -> void:
	if _future.is_empty():
		return
	var next: String = _future.pop_back()
	_ur.redo()
	_past.append(next)
	emit_signal("history_changed", _past.duplicate(), _future.duplicate())


func _record_commit(desc: String) -> void:
	_past.append(desc)
	_future.clear()
	emit_signal("history_changed", _past.duplicate(), _future.duplicate())


## Insert/replace a Resource in data[array_name] by unique id field (e.g. "id" or "key")
func push_res_insert(
	data: Resource,
	array_name: String,
	id_prop: String,
	res: Resource,
	desc: String,
	at_index: int = -1
) -> void:
	var res_copy: Resource = _dup_res(res)
	_ur.create_action(desc)
	_ur.add_do_method(
		Callable(self, "_insert_res_with_id").bind(data, array_name, id_prop, res_copy, at_index)
	)
	_ur.add_undo_method(
		Callable(self, "_erase_res_by_id").bind(data, array_name, id_prop, _get_id(res_copy))
	)
	_ur.commit_action()
	_record_commit(desc)


## Replace item by id with 'after' Resource (undo to 'before')
func push_res_edit_by_id(
	data: Resource,
	array_name: String,
	id_prop: String,
	id_value: String,
	before_res: Resource,
	after_res: Resource,
	desc: String
) -> void:
	var b: Variant = _dup_res(before_res)
	var a: Variant = _dup_res(after_res)
	_ur.create_action(desc)
	_ur.add_do_method(
		Callable(self, "_apply_res_by_id").bind(data, array_name, id_prop, id_value, a)
	)
	_ur.add_undo_method(
		Callable(self, "_apply_res_by_id").bind(data, array_name, id_prop, id_value, b)
	)
	_ur.commit_action()
	_record_commit(desc)


## Erase item by id (undo reinserts the provided backup at original_index, or auto)
func push_res_erase_by_id(
	data: Resource,
	array_name: String,
	id_prop: String,
	id_value: String,
	backup_res: Resource,
	desc: String,
	original_index: int = -1
) -> void:
	var b: Variant = _dup_res(backup_res)
	_ur.create_action(desc)
	_ur.add_do_method(Callable(self, "_erase_res_by_id").bind(data, array_name, id_prop, id_value))
	_ur.add_undo_method(
		Callable(self, "_insert_res_with_id").bind(data, array_name, id_prop, b, original_index)
	)
	_ur.commit_action()
	_record_commit(desc)


## Replace entire array (atomic). Provide deep copies of before/after
func push_array_replace(
	data: Resource, array_name: String, before: Array, after: Array, desc: String
) -> void:
	_ur.create_action(desc)
	_ur.add_do_method(
		Callable(self, "_apply_array").bind(data, array_name, _deep_copy_array_res(after))
	)
	_ur.add_undo_method(
		Callable(self, "_apply_array").bind(data, array_name, _deep_copy_array_res(before))
	)
	_ur.commit_action()
	_record_commit(desc)


## Replace multiple arrays atomically. changes = [{prop:String, before:Array, after:Array}, ...]
func push_multi_replace(data: Resource, changes: Array, desc: String) -> void:
	_ur.create_action(desc)

	for c in changes:
		if typeof(c) == TYPE_DICTIONARY and c.has("prop") and c.has("after"):
			var prop := String(c["prop"])
			var after_arr: Array = _deep_copy_array_res(c["after"])
			_ur.add_do_method(Callable(self, "_apply_array").bind(data, prop, after_arr))

	for c in changes:
		if typeof(c) == TYPE_DICTIONARY and c.has("prop") and c.has("before"):
			var prop := String(c["prop"])
			var before_arr: Array = _deep_copy_array_res(c["before"])
			_ur.add_undo_method(Callable(self, "_apply_array").bind(data, prop, before_arr))
	_ur.commit_action()
	_record_commit(desc)


## Move entity (unit/slot/task/trigger) by id. 'ent_type' is "unit"/"slot"/"task"/"trigger"
func push_entity_move(
	data: Resource,
	ent_type: StringName,
	id_value: String,
	before_pos: Vector2,
	after_pos: Vector2,
	desc: String,
	id_prop_override: String = ""
) -> void:
	_ur.create_action(desc)
	_ur.add_do_method(
		Callable(self, "_set_entity_pos_by_id").bind(
			data, ent_type, id_value, after_pos, id_prop_override
		)
	)
	_ur.add_undo_method(
		Callable(self, "_set_entity_pos_by_id").bind(
			data, ent_type, id_value, before_pos, id_prop_override
		)
	)
	_ur.commit_action()
	_record_commit(desc)


## Set a property on a Resource with undo/redo (emits changed).
func push_prop_set(
	target: Object, prop: String, before: Variant, after: Variant, desc: String
) -> void:
	_ur.create_action(desc)
	_ur.add_do_property(target, prop, after)
	_ur.add_undo_property(target, prop, before)
	_ur.add_do_method(Callable(self, "_emit_changed").bind(target))
	_ur.add_undo_method(Callable(self, "_emit_changed").bind(target))
	_ur.commit_action()
	_record_commit(desc)


func _apply_array(data: Resource, array_name: String, value: Array) -> void:
	var current: Array = data.get(array_name)

	if typeof(current) == TYPE_ARRAY:
		var cur := current as Array
		cur.clear()
		for v in value:
			cur.append(_dup_res(v))

		data.set(array_name, cur)
	else:
		data.set(array_name, _deep_copy_array_res(value))

	_emit_changed(data)


func _apply_res_by_id(
	data: Resource, array_name: String, id_prop: String, id_value: String, res: Resource
) -> void:
	var arr: Array = data.get(array_name)
	var idx := _find_index_by_id_res(arr, id_prop, id_value)
	if idx >= 0:
		arr[idx] = _dup_res(res)
		data.set(array_name, arr)
		_emit_changed(data)


func _erase_res_by_id(
	data: Resource, array_name: String, id_prop: String, id_value: String
) -> void:
	var arr: Array = data.get(array_name)
	var idx := _find_index_by_id_res(arr, id_prop, id_value)
	if idx >= 0:
		arr.remove_at(idx)
		data.set(array_name, arr)
		_emit_changed(data)


func _insert_res_with_id(
	data: Resource, array_name: String, id_prop: String, res: Resource, at_index: int
) -> void:
	var arr: Array = data.get(array_name)
	var rid := _get_id(res)
	var existing := _find_index_by_id_res(arr, id_prop, rid)
	if existing >= 0:
		arr.remove_at(existing)
	if at_index < 0:
		arr.append(_dup_res(res))
	else:
		arr.insert(clamp(at_index, 0, arr.size()), _dup_res(res))
	data.set(array_name, arr)
	_emit_changed(data)


## Get id/key from a Resource
func _get_id(res: Resource) -> String:
	if res == null:
		return ""
	if _has_prop(res, "id"):
		return String(res.get("id"))
	if _has_prop(res, "key"):
		return String(res.get("key"))
	return ""


static func _find_index_by_id_res(arr: Array, id_prop: String, id_value: String) -> int:
	for i in arr.size():
		var it = arr[i]
		if it is Resource and _has_prop(it, id_prop) and String(it.get(id_prop)) == id_value:
			return i
	return -1


## Set entity world position by id
func _set_entity_pos_by_id(
	data: Resource,
	ent_type: StringName,
	id_value: String,
	p: Vector2,
	id_prop_override: String = ""
) -> void:
	var t := ent_type
	if t == &"unit":
		var idx := _find_index_by_id_res(
			data.units, id_prop_override if id_prop_override != "" else "id", id_value
		)
		if idx >= 0:
			data.units[idx].position_m = p
	elif t == &"slot":
		var idx := _find_index_by_id_res(
			data.unit_slots, id_prop_override if id_prop_override != "" else "key", id_value
		)
		if idx >= 0:
			data.unit_slots[idx].start_position = p
	elif t == &"task":
		var idx := _find_index_by_id_res(
			data.tasks, id_prop_override if id_prop_override != "" else "id", id_value
		)
		if idx >= 0:
			data.tasks[idx].position_m = p
	elif t == &"trigger":
		var idx := _find_index_by_id_res(
			data.triggers, id_prop_override if id_prop_override != "" else "id", id_value
		)
		if idx >= 0:
			if _has_prop(data.triggers[idx], "area_center_m"):
				data.triggers[idx].area_center_m = p
			elif _has_prop(data.triggers[idx], "position_m"):
				data.triggers[idx].position_m = p
	_emit_changed(data)


static func _dup_res(r):
	if r is Resource:
		return (r as Resource).duplicate(true)
	return r


static func _deep_copy_array_res(arr: Array) -> Array:
	var out := []
	for v in arr:
		out.append(_dup_res(v))
	return out


## Does an Object expose a property with this name
static func _has_prop(o: Object, p_name: String) -> bool:
	if o == null:
		return false
	for pd in o.get_property_list():
		if String(pd["name"]) == p_name:
			return true
	return false


static func _emit_changed(data):
	if data == null:
		return
	if data.has_method("emit_changed"):
		data.emit_changed()
	elif data.has_signal("changed"):
		data.emit_signal("changed")
