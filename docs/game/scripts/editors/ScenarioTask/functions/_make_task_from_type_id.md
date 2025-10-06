# ScenarioTask::_make_task_from_type_id Function Reference

*Defined at:* `scripts/editors/ScenarioTask.gd` (lines 95–101)</br>
*Belongs to:* [ScenarioTask](../ScenarioTask.md)

**Signature**

```gdscript
func _make_task_from_type_id(type_id: StringName) -> UnitBaseTask
```

## Description

Resolve and instance a UnitBaseTask by type_id (or null)

## Source

```gdscript
static func _make_task_from_type_id(type_id: StringName) -> UnitBaseTask:
	_ensure_task_index()
	var scr: Script = _task_by_typeid.get(type_id, null)
	if scr:
		var inst: Variant = scr.new()
		return inst as UnitBaseTask
	return null
```
