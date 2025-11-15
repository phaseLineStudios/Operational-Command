# AIController::_on_trigger_activated Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 369–381)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _on_trigger_activated(trigger_id: String) -> void
```

## Source

```gdscript
func _on_trigger_activated(trigger_id: String) -> void:
	var entries: Array = _blocked_triggers.get(trigger_id, [])
	if entries.is_empty():
		return
	for entry in entries:
		var uid := int(entry.get("unit_id", -1))
		var tidx := int(entry.get("task_index", -1))
		var runner: ScenarioTaskRunner = _runners.get(uid, null)
		if runner:
			runner.block_task_index(tidx, false)
	_blocked_triggers.erase(trigger_id)
```
