# HQTable::_init_enemy_ai Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 504–543)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _init_enemy_ai() -> void
```

## Source

```gdscript
func _init_enemy_ai() -> void:
	if ai_controller == null:
		push_error("_init_enemy_ai(): AIController node is missing from the scene.")
		return

	var scenario := Game.current_scenario
	if scenario == null:
		return

	if trigger_engine:
		ai_controller.bind_trigger_engine(trigger_engine)

	ai_controller.unregister_all_units()
	ai_controller.refresh_unit_index_cache()

	var flat_tasks: Array = []
	if scenario.tasks is Array:
		flat_tasks = scenario.tasks
	var normalized: Array = ai_controller.normalize_tasks(flat_tasks)
	var per_unit: Dictionary = ai_controller.build_per_unit_queues(normalized)
	ai_controller.apply_trigger_sync(per_unit, scenario.triggers)

	for i in scenario.units.size():
		var u: ScenarioUnit = scenario.units[i]
		if u == null or u.affiliation != ScenarioUnit.Affiliation.ENEMY:
			continue
		var agent := ai_controller.create_agent(i)
		if agent == null:
			continue

		agent.set_behaviour(int(u.behaviour))
		agent.set_combat_mode(int(u.combat_mode))

		var ordered: Array[Dictionary] = per_unit.get(i, [] as Array[Dictionary])
		if ordered.is_empty():
			agent.set_behaviour(ScenarioUnit.Behaviour.AWARE)
			u.behaviour = ScenarioUnit.Behaviour.AWARE
			agent.set_combat_mode(ScenarioUnit.CombatMode.DO_NOT_FIRE_UNLESS_FIRED_UPON)
			u.combat_mode = ScenarioUnit.CombatMode.DO_NOT_FIRE_UNLESS_FIRED_UPON
		ai_controller.register_unit(i, agent, ordered)
```
