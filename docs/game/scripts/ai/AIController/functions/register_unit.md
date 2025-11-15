# AIController::register_unit Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 62–72)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func register_unit(unit_id: int, agent: AIAgent, ordered_tasks: Array[Dictionary]) -> void
```

- **unit_id**: Index in ScenarioData.units.
- **agent**: AIAgent that will execute intents.
- **ordered_tasks**: Runner-ready task dictionaries for this unit.

## Description

Register a unit's agent and its prebuilt ordered task list.

## Source

```gdscript
func register_unit(unit_id: int, agent: AIAgent, ordered_tasks: Array[Dictionary]) -> void:
	if _runners.has(unit_id):
		unregister_unit(unit_id)
	var runner := ScenarioTaskRunner.new()
	add_child(runner)
	runner.setup(unit_id, ordered_tasks)
	_runners[unit_id] = runner
	_agents[unit_id] = agent
	_apply_initial_blocks_for_unit(unit_id)
```
