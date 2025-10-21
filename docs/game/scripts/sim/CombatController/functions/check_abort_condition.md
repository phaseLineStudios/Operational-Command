# CombatController::check_abort_condition Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 206–233)</br>
*Belongs to:* [CombatController](../../CombatController.md)

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
			attacker._morale_sys.apply_morale_delta(0.2, "enemy surrendered")
			attacker._morale_sys.nearby_ally_morale_change(0.05)
		unit_destroyed.emit()
		abort_condition = true
		return
	elif defender.unit.morale <= 0.2:
		LogService.info(defender.unit.id + " is [b]surrendering[/b]", "Combat.gd:71")
		defender._morale_sys.set_morale(0.0, "surrendered")
		attacker._morale_sys.apply_morale_delta(0.2, "enemy surrendered")
		attacker._morale_sys.nearby_ally_morale_change(0.05)
		unit_surrendered.emit()
		abort_condition = true
		return
	if called_retreat:
		LogService.info(defender.unit.id + " is [b]retreating[/b]", "Combat.gd:78")
		attacker._morale_sys.apply_morale_delta(0.1, "enemy retreating")
		attacker.attacker._morale_sys.nearby_ally_morale_change(0.05)
		unit_retreated.emit()
		abort_condition = true
```
