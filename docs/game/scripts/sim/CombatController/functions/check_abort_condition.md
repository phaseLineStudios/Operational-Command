# CombatController::check_abort_condition Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 206–227)</br>
*Belongs to:* [CombatController](../CombatController.md)

**Signature**

```gdscript
func check_abort_condition(attacker: ScenarioUnit, defender: ScenarioUnit) -> void
```

## Description

Check the various conditions for if the combat is finished

## Source

```gdscript
func check_abort_condition(attacker: ScenarioUnit, defender: ScenarioUnit) -> void:
	if defender == null or defender.unit == null or attacker == null or attacker.unit == null:
		return

	if defender.unit.state_strength <= 0.5:
		LogService.info(defender.unit.id + " is [b]destroyed[/b]", "Combat.gd:62")
		if attacker.unit.morale <= 0.8:
			attacker.unit.morale += 0.2
		unit_destroyed.emit()
		abort_condition = true
		return
	elif defender.unit.morale <= 0.2:
		LogService.info(defender.unit.id + " is [b]surrendering[/b]", "Combat.gd:71")
		unit_surrendered.emit()
		abort_condition = true
		return
	if called_retreat:
		LogService.info(defender.unit.id + " is [b]retreating[/b]", "Combat.gd:78")
		unit_retreated.emit()
		abort_condition = true
```
