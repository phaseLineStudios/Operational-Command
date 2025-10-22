# MoraleSystem::is_broken Function Reference

*Defined at:* `scripts/sim/MoraleSystem.gd` (lines 62–68)</br>
*Belongs to:* [MoraleSystem](../../MoraleSystem.md)

**Signature**

```gdscript
func is_broken() -> bool
```

## Description

bool to see if morealstate is broken

## Source

```gdscript
func is_broken() -> bool:
	if get_morale_state() == MoraleState.BROKEN:
		return true
	else:
		return false
```
