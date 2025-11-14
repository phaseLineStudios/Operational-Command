# AIController::apply_trigger_sync Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 465–494)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func apply_trigger_sync(per_unit: Dictionary, triggers: Array) -> void
```

- **per_unit**: Dictionary returned from build_per_unit_queues.
- **triggers**: Scenario triggers.

## Description

Register trigger/task sync so tasks stay blocked until trigger activates.

## Source

```gdscript
func apply_trigger_sync(per_unit: Dictionary, triggers: Array) -> void:
	_initial_blocks_by_unit.clear()
	_blocked_triggers.clear()
	if triggers == null:
		return
	var owner_by_task: Dictionary = {}
	for uid in per_unit.keys():
		var tasks: Array = per_unit[uid]
		for task in tasks:
			var idx := int(task.get("__src_index", -1))
			if idx < 0:
				continue
			owner_by_task[idx] = uid
	for trig in triggers:
		if trig == null:
			continue
		var tid := String(trig.id)
		for tidx in trig.synced_tasks:
			var idx := int(tidx)
			var uid := int(owner_by_task.get(idx, -1))
			if uid < 0:
				continue
			if not _initial_blocks_by_unit.has(uid):
				_initial_blocks_by_unit[uid] = []
			(_initial_blocks_by_unit[uid] as Array).append(idx)
			if not _blocked_triggers.has(tid):
				_blocked_triggers[tid] = []
			(_blocked_triggers[tid] as Array).append({"unit_id": uid, "task_index": idx})
```
