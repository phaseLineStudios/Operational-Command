# ScenarioTask::_ensure_task_index Function Reference

*Defined at:* `scripts/editors/ScenarioTask.gd` (lines 59–93)</br>
*Belongs to:* [ScenarioTask](../ScenarioTask.md)

**Signature**

```gdscript
func _ensure_task_index() -> void
```

## Description

Build/refresh the type_id -> Script index

## Source

```gdscript
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
		if f == "":
			break
		if dir.current_is_dir():
			continue
		if not f.to_lower().ends_with(".gd"):
			continue
		var path := "%s/%s" % [TASKS_DIR, f]
		var scr := load(path)
		if scr == null:
			continue
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
```
