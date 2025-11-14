# AIController::unregister_unit Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 74–86)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func unregister_unit(unit_id: int) -> void
```

## Description

Unregister and free the runner/agent for a unit id (idempotent).

## Source

```gdscript
func unregister_unit(unit_id: int) -> void:
	if _runners.has(unit_id):
		var r: ScenarioTaskRunner = _runners[unit_id]
		_runners.erase(unit_id)
		if is_instance_valid(r):
			r.queue_free()
	if _agents.has(unit_id):
		var a: AIAgent = _agents[unit_id]
		_agents.erase(unit_id)
		if is_instance_valid(a):
			a.queue_free()
```
