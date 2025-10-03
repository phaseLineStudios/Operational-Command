@tool
class_name TerrainHistory
extends Node

## Wrapper around Godot's UndoRedo system
##
## Records actions, exposes helpers for inserting/editing/erasing items in TerrainData

## Emitted when the history stack changes
signal history_changed(past: Array, future: Array)

var _ur := UndoRedo.new()

var _past: Array[String] = []
var _future: Array[String] = []


## undo the last action
func undo() -> void:
	if _past.is_empty():
		return
	var last: String = _past.pop_back()
	_ur.undo()
	_future.append(last)
	emit_signal("history_changed", _past.duplicate(), _future.duplicate())


## Redo the last action
func redo() -> void:
	if _future.is_empty():
		return
	var next: String = _future.pop_back()
	_ur.redo()
	_past.append(next)
	emit_signal("history_changed", _past.duplicate(), _future.duplicate())


## Record a commit to history
func _record_commit(desc: String) -> void:
	_past.append(desc)
	_future.clear()
	emit_signal("history_changed", _past.duplicate(), _future.duplicate())


## Insert an item dictionary into `data[array_name]`
func push_item_insert(
	data: TerrainData, array_name: String, item: Dictionary, desc: String, at_index: int = -1
) -> void:
	assert(item.has("id"), "Inserted item must have an 'id'")
	var item_copy: Dictionary = _deep_copy(item)
	_ur.create_action(desc)
	_ur.add_do_method(
		Callable(self, "_insert_item_with_id").bind(data, array_name, item_copy, at_index)
	)
	_ur.add_undo_method(Callable(self, "_erase_item_by_id").bind(data, array_name, item_copy.id))
	_ur.commit_action()
	_record_commit(desc)


## Edit (replace) an item by its `id_value` in `data[array_name]`
func push_item_edit_by_id(
	data: TerrainData,
	array_name: String,
	id_value,
	before: Dictionary,
	after: Dictionary,
	desc: String
) -> void:
	var before_c: Dictionary = _deep_copy(before)
	var after_c: Dictionary = _deep_copy(after)
	_ur.create_action(desc)
	_ur.add_do_method(Callable(self, "_apply_item_by_id").bind(data, array_name, id_value, after_c))
	_ur.add_undo_method(
		Callable(self, "_apply_item_by_id").bind(data, array_name, id_value, before_c)
	)
	_ur.commit_action()
	_record_commit(desc)


## Erase an item by `id_value` from `data[array_name]`
func push_item_erase_by_id(
	data: TerrainData,
	array_name: String,
	id_value,
	item_copy: Dictionary,
	desc: String,
	original_index: int = -1
) -> void:
	var item_c: Dictionary = _deep_copy(item_copy)

	if original_index < 0:
		original_index = _find_index_by_id(data.get(array_name), id_value)
	_ur.create_action(desc)
	_ur.add_do_method(Callable(self, "_erase_item_by_id").bind(data, array_name, id_value))
	_ur.add_undo_method(
		Callable(self, "_insert_item_with_id").bind(data, array_name, item_c, original_index)
	)
	_ur.commit_action()
	_record_commit(desc)


## Replace the entire `data[array_name]` with `after`, undo to `before`
func push_array_replace(
	data: TerrainData, array_name: String, before: Array, after: Array, desc: String
) -> void:
	_ur.create_action(desc)
	_ur.add_do_method(Callable(self, "_apply_array").bind(data, array_name, _deep_copy(after)))
	_ur.add_undo_method(Callable(self, "_apply_array").bind(data, array_name, _deep_copy(before)))
	_ur.commit_action()
	_record_commit(desc)


## Push an elevation patch operation over a `rect`:
func push_elevation_patch(
	data: TerrainData,
	rect: Rect2i,
	before_block: PackedFloat32Array,
	after_block: PackedFloat32Array,
	desc: String
) -> void:
	_ur.create_action(desc)
	_ur.add_do_method(Callable(self, "_apply_elev_block").bind(data, rect, after_block))
	_ur.add_undo_method(Callable(self, "_apply_elev_block").bind(data, rect, before_block))
	_ur.commit_action()
	_record_commit(desc)


## Replace `data[array_name]` with `value` and emit change.
func _apply_array(data: TerrainData, array_name: String, value: Array) -> void:
	data.set(array_name, value)
	_emit_changed(data)


## Replace a single item (by id) in `data[array_name]` with `item`, then emit.
func _apply_item_by_id(data: TerrainData, array_name: String, id_value, item: Dictionary) -> void:
	var arr: Array = data.get(array_name)
	var idx := _find_index_by_id(arr, id_value)
	if idx >= 0:
		arr[idx] = item
		data.set(array_name, arr)
		_emit_changed(data)


## Remove a single item (by id) from `data[array_name]`, then emit.
func _erase_item_by_id(data: TerrainData, array_name: String, id_value) -> void:
	var arr: Array = data.get(array_name)
	var idx := _find_index_by_id(arr, id_value)
	if idx >= 0:
		arr.remove_at(idx)
		data.set(array_name, arr)
		_emit_changed(data)


## Insert `item` into `data[array_name]` at `at_index` (or append if < 0), then emit.
func _insert_item_with_id(
	data: TerrainData, array_name: String, item: Dictionary, at_index: int
) -> void:
	var arr: Array = data.get(array_name)
	var existing := _find_index_by_id(arr, item.id if item.has("id") else null)
	if existing >= 0:
		arr.remove_at(existing)
	if at_index < 0:
		arr.append(item)
	else:
		arr.insert(clamp(at_index, 0, arr.size()), item)
	data.set(array_name, arr)
	_emit_changed(data)


## Apply an elevation block via TerrainData API and emit change.
func _apply_elev_block(data: TerrainData, rect: Rect2i, block: PackedFloat32Array) -> void:
	if data and data.has_method("set_elevation_block"):
		data.set_elevation_block(rect, block)
	_emit_changed(data)


## Find the index of the dictionary in `arr` whose `"id"` equals `id_value`.
static func _find_index_by_id(arr: Array, id_value) -> int:
	for i in arr.size():
		var it = arr[i]
		if typeof(it) == TYPE_DICTIONARY and it.has("id") and it.id == id_value:
			return i
	return -1


## Deep copy for dictionaries, arrays, and common packed arrays used in TerrainData.
static func _deep_copy(x):
	match typeof(x):
		TYPE_DICTIONARY:
			var d := {}
			for k in x.keys():
				d[k] = _deep_copy(x[k])
			return d
		TYPE_ARRAY:
			var a := []
			for v in x:
				a.append(_deep_copy(v))
			return a
		TYPE_PACKED_VECTOR2_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_COLOR_ARRAY:
			return x.duplicate()
		_:
			return x


## Emit a generic change notification on TerrainData.
static func _emit_changed(data):
	if data == null:
		return
	if data.has_method("emit_changed"):
		data.emit_changed()
	elif data.has_signal("changed"):
		data.emit_signal("changed")
