# MoraleSystem::get_morale_state Function Reference

*Defined at:* `scripts/sim/MoraleSystem.gd` (lines 53–61)</br>
*Belongs to:* [MoraleSystem](../../MoraleSystem.md)

**Signature**

```gdscript
func get_morale_state(value: float = morale) -> int
```

## Description

returns moralestate based on morale value

## Source

```gdscript
func get_morale_state(value: float = morale) -> int:
	if value >= 0.6:
		return MoraleState.STEADY  #0
	elif value >= 0.3:
		return MoraleState.SHAKEN  #1
	else:
		return MoraleState.BROKEN  #2
```
