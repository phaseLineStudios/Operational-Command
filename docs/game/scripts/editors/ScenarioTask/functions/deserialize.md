# ScenarioTask::deserialize Function Reference

*Defined at:* `scripts/editors/ScenarioTask.gd` (lines 41–57)</br>
*Belongs to:* [ScenarioTask](../ScenarioTask.md)

**Signature**

```gdscript
func deserialize(d: Dictionary) -> ScenarioTask
```

## Description

Create/restore from a JSON dictionary

## Source

```gdscript
static func deserialize(d: Dictionary) -> ScenarioTask:
	var inst := ScenarioTask.new()
	inst.id = String(d.get("id", ""))

	var type_id := StringName(d.get("task_type", ""))
	inst.task = _make_task_from_type_id(type_id)

	inst.position_m = ContentDB.v2_from(d.get("position_m"))

	inst.params = d.get("params", {})
	inst.unit_index = int(d.get("unit_index", -1))
	inst.next_index = int(d.get("next_index", -1))
	inst.prev_index = int(d.get("prev_index", -1))

	return inst
```
