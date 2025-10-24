# CombatController::print_unit_status Function Reference

*Defined at:* `scripts/sim/Combat.gd` (lines 235–246)</br>
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
	LogService.info(
		"[b]Attacker(%s)[/b]\n\t%s\n\t%s" % [attacker.id, attacker.morale, attacker.strength],
		"Combat.gd:85"
	)
	LogService.info(
		"[b]Defender(%s)[/b]\n\t%s\n\t%s" % [defender.id, defender.morale, defender.strength],
		"Combat.gd:86"
	)
	return
```
