# CombatController::print_unit_status Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 241–258)</br>
*Belongs to:* [CombatController](../../CombatController.md)

**Signature**

```gdscript
func print_unit_status(attacker: UnitData, defender: UnitData) -> void
```

## Description

check unit mid combat status for testing of combat status

## Source

```gdscript
func print_unit_status(attacker: UnitData, defender: UnitData) -> void:
	LogService.trace(
		(
			"Attacker(%s) • morale %s • strength %s"
			% [attacker.id, attacker.morale, attacker.strength]
		),
		"Combat.gd:85"
	)
	LogService.trace(
		(
			"Defender(%s) • morale %s • strength %s"
			% [defender.id, defender.morale, defender.strength]
		),
		"Combat.gd:86"
	)
	return
```
