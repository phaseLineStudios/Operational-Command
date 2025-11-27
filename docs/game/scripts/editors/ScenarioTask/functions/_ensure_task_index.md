# ScenarioTask::_ensure_task_index Function Reference

*Defined at:* `scripts/editors/ScenarioTask.gd` (lines 59–84)</br>
*Belongs to:* [ScenarioTask](../../ScenarioTask.md)

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

	var files := ResourceLoader.list_directory(TASKS_DIR)
	for file in files:
		var is_dir := file[file.length() - 1] == "/"
		var extension := file.split(".")[-1]
		if not is_dir and extension in ["gd"]:
			var path := "%s/%s" % [TASKS_DIR, file]
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
	_task_index_built = true
```
