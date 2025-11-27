# SimDebugOverlay::_enum_name Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 357–381)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _enum_name(_enum: Variant, value: int) -> String
```

- **_enum**: Enum type marker.
- **value**: Enum value.
- **Return Value**: Short label string.

## Description

Convert enum value to a short human label.

## Source

```gdscript
func _enum_name(_enum: Variant, value: int) -> String:
	match _enum:
		ScenarioUnit.Behaviour:
			match value:
				ScenarioUnit.Behaviour.CARELESS:
					return "Careless"
				ScenarioUnit.Behaviour.SAFE:
					return "Safe"
				ScenarioUnit.Behaviour.AWARE:
					return "Aware"
				ScenarioUnit.Behaviour.COMBAT:
					return "Combat"
				ScenarioUnit.Behaviour.STEALTH:
					return "Stealth"
		ScenarioUnit.CombatMode:
			match value:
				ScenarioUnit.CombatMode.FORCED_HOLD_FIRE:
					return "Hold"
				ScenarioUnit.CombatMode.DO_NOT_FIRE_UNLESS_FIRED_UPON:
					return "Return"
				ScenarioUnit.CombatMode.OPEN_FIRE:
					return "Open"
	return str(value)
```
