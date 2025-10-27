# MoraleSystem::morale_effectiveness_mul Function Reference

*Defined at:* `scripts/sim/MoraleSystem.gd` (lines 103–112)</br>
*Belongs to:* [MoraleSystem](../../MoraleSystem.md)

**Signature**

```gdscript
func morale_effectiveness_mul() -> float
```

## Description

returns morale multiplier based on moralestate

## Source

```gdscript
func morale_effectiveness_mul() -> float:
	var state = get_morale_state()
	if state == MoraleState.SHAKEN:
		return 0.9
	elif state == MoraleState.BROKEN:
		return 0.7
	else:
		return 1
```
