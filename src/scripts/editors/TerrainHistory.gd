@tool
extends Node
class_name TerrainHistory

var _ur := UndoRedo.new()

func undo() -> void: _ur.undo()
func redo() -> void: _ur.redo()

func push_item_insert(data: TerrainData, array_name: String, item: Dictionary, desc: String, at_index: int = -1) -> void:
	assert(item.has("id"), "Inserted item must have an 'id'")
	var item_copy: Dictionary = _deep_copy(item)
	_ur.create_action(desc)
	_ur.add_do_method(Callable(self, "_insert_item_with_id").bind(data, array_name, item_copy, at_index))
	_ur.add_undo_method(Callable(self, "_erase_item_by_id").bind(data, array_name, item_copy.id))
	_ur.commit_action()

func push_item_edit_by_id(data: TerrainData, array_name: String, id_value, before: Dictionary, after: Dictionary, desc: String) -> void:
	var before_c: Dictionary = _deep_copy(before)
	var after_c: Dictionary = _deep_copy(after)
	_ur.create_action(desc)
	_ur.add_do_method(Callable(self, "_apply_item_by_id").bind(data, array_name, id_value, after_c))
	_ur.add_undo_method(Callable(self, "_apply_item_by_id").bind(data, array_name, id_value, before_c))
	_ur.commit_action()

func push_item_erase_by_id(data: TerrainData, array_name: String, id_value, item_copy: Dictionary, desc: String, original_index: int = -1) -> void:
	var item_c: Dictionary = _deep_copy(item_copy)

	if original_index < 0:
		original_index = _find_index_by_id(data.get(array_name), id_value)
	_ur.create_action(desc)
	_ur.add_do_method(Callable(self, "_erase_item_by_id").bind(data, array_name, id_value))
	_ur.add_undo_method(Callable(self, "_insert_item_with_id").bind(data, array_name, item_c, original_index))
	_ur.commit_action()

func push_array_replace(data: TerrainData, array_name: String, before: Array, after: Array, desc: String) -> void:
	_ur.create_action(desc)
	_ur.add_do_method(Callable(self, "_apply_array").bind(data, array_name, _deep_copy(after)))
	_ur.add_undo_method(Callable(self, "_apply_array").bind(data, array_name, _deep_copy(before)))
	_ur.commit_action()

func push_elevation_patch(data: TerrainData, rect: Rect2i, before_block: PackedFloat32Array, after_block: PackedFloat32Array, desc: String) -> void:
	_ur.create_action(desc)
	_ur.add_do_method(Callable(self, "_apply_elev_block").bind(data, rect, after_block))
	_ur.add_undo_method(Callable(self, "_apply_elev_block").bind(data, rect, before_block))
	_ur.commit_action()

func _apply_array(data: TerrainData, array_name: String, value: Array) -> void:
	data.set(array_name, value)
	_emit_changed(data)

func _apply_item_by_id(data: TerrainData, array_name: String, id_value, item: Dictionary) -> void:
	var arr: Array = data.get(array_name)
	var idx := _find_index_by_id(arr, id_value)
	if idx >= 0:
		arr[idx] = item
		data.set(array_name, arr)
		_emit_changed(data)

func _erase_item_by_id(data: TerrainData, array_name: String, id_value) -> void:
	var arr: Array = data.get(array_name)
	var idx := _find_index_by_id(arr, id_value)
	if idx >= 0:
		arr.remove_at(idx)
		data.set(array_name, arr)
		_emit_changed(data)

func _insert_item_with_id(data: TerrainData, array_name: String, item: Dictionary, at_index: int) -> void:
	var arr: Array = data.get(array_name)
	# prevent duplicate IDs on redo if item already exists (erase it first)
	var existing := _find_index_by_id(arr, item.id if item.has("id") else null)
	if existing >= 0:
		arr.remove_at(existing)
	# insert with order
	if at_index < 0:
		arr.append(item)
	else:
		arr.insert(clamp(at_index, 0, arr.size()), item)
	data.set(array_name, arr)
	_emit_changed(data)

static func _find_index_by_id(arr: Array, id_value) -> int:
	for i in arr.size():
		var it = arr[i]
		if typeof(it) == TYPE_DICTIONARY and it.has("id") and it.id == id_value:
			return i
	return -1

func _apply_elev_block(data: TerrainData, rect: Rect2i, block: PackedFloat32Array) -> void:
	if data and data.has_method("set_elevation_block"):
		data.set_elevation_block(rect, block)
	_emit_changed(data)

static func _deep_copy(x):
	match typeof(x):
		TYPE_DICTIONARY:
			var d := {}
			for k in x.keys(): d[k] = _deep_copy(x[k])
			return d
		TYPE_ARRAY:
			var a := []
			for v in x: a.append(_deep_copy(v))
			return a
		TYPE_PACKED_VECTOR2_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_COLOR_ARRAY:
			return x.duplicate()
		_:
			return x

static func _emit_changed(data):
	if data == null: return
	if data.has_method("emit_changed"): data.emit_changed()
	elif data.has_signal("changed"):    data.emit_signal("changed")
