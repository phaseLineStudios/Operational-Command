extends Resource
class_name ScenarioTask
## A placed task for a unit with per-instance params and linking

## Unique Id within scenario
@export var id: String
## The task definition
@export var task: UnitBaseTask
## World position (meters)
@export var position_m: Vector2
## Overrides per exported property of `task`
@export var params: Dictionary = {}
## Owner unit index in ScenarioData.units
@export var unit_index: int = -1
## Link to next ScenarioTask in the chain
@export var next_index: int = -1
## Link to previous ScenarioTask in the chain
@export var prev_index: int = -1

## Where to find task scripts
const TASKS_DIR := "res://scripts/editors/tasks"

static var _task_by_typeid: Dictionary = {}
static var _task_index_built := false

## Convert this task into a JSON-safe dictionary
func serialize() -> Dictionary:
	return {
		"id": id,
		"task_type": String(task.type_id) if task else "",
		"position_m": ContentDB.v2(position_m),
		"params": params,
		"unit_index": unit_index,
		"next_index": next_index,
		"prev_index": prev_index,
	}

## Create/restore from a JSON dictionary
static func deserialize(d: Dictionary) -> ScenarioTask:
	var inst := ScenarioTask.new()
	inst.id = String(d.get("id", ""))

	var type_id := StringName(d.get("task_type", ""))
	inst.task = _make_task_from_type_id(type_id)

	inst.position_m = ContentDB.v2_from(d.get("position_m"))

	inst.params      = d.get("params", {})
	inst.unit_index  = int(d.get("unit_index", -1))
	inst.next_index  = int(d.get("next_index", -1))
	inst.prev_index  = int(d.get("prev_index", -1))

	return inst

## Build/refresh the type_id -> Script index
static func _ensure_task_index() -> void:
	if _task_index_built:
		return
	var dir := DirAccess.open(TASKS_DIR)
	if dir == null:
		push_warning("ScenarioTask: tasks dir not found: %s" % TASKS_DIR)
		_task_index_built = true
		return
	dir.list_dir_begin()
	while true:
		var f := dir.get_next()
		if f == "": break
		if dir.current_is_dir(): continue
		if not f.to_lower().ends_with(".gd"): continue
		var path := "%s/%s" % [TASKS_DIR, f]
		var scr := load(path)
		if scr == null: continue
		var obj: Variant = scr.new()
		var tid := ""
		if obj is Object and obj.has_method("get"):
			var v: Variant = obj.get("type_id")
			if typeof(v) in [TYPE_STRING, TYPE_STRING_NAME]:
				tid = String(v)
		if tid != "":
			_task_by_typeid[StringName(tid)] = scr
		if obj is RefCounted:
			obj = null
	dir.list_dir_end()
	_task_index_built = true

## Resolve and instance a UnitBaseTask by type_id (or null)
static func _make_task_from_type_id(type_id: StringName) -> UnitBaseTask:
	_ensure_task_index()
	var scr: Script = _task_by_typeid.get(type_id, null)
	if scr:
		var inst: Variant = scr.new()
		return inst as UnitBaseTask
	return null
