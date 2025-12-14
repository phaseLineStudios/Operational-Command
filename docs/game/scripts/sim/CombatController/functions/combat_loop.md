# CombatController::combat_loop Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 98–119)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func combat_loop(attacker: ScenarioUnit, defender: ScenarioUnit) -> void
```

## Description

Loop triggered every turn to simulate unit behavior in combat

## Source

```gdscript
func combat_loop(attacker: ScenarioUnit, defender: ScenarioUnit) -> void:
	var unit_switch: ScenarioUnit
	_cur_att = attacker
	_cur_def = defender
	notify_health.emit(attacker.unit, defender.unit)

	while not abort_condition:
		calculate_damage(attacker, defender)
		notify_health.emit(attacker.unit, defender.unit)
		check_abort_condition(attacker, defender)

		if debug_enabled:
			_emit_debug_snapshot(attacker, defender, true)

		await get_tree().create_timer(5.0, true, false, false).timeout
		unit_switch = attacker
		attacker = defender
		defender = unit_switch
		_cur_att = attacker
		_cur_def = defender
```
