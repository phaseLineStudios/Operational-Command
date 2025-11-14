# CombatAdapter::can_fire Function Reference

*Defined at:* `scripts/sim/adapters/CombatAdapter.gd` (lines 175–183)</br>
*Belongs to:* [CombatAdapter](../../CombatAdapter.md)

**Signature**

```gdscript
func can_fire() -> bool
```

## Description

Query for fire permission based on current ROE.

## Source

```gdscript
func can_fire() -> bool:
	match _roe:
		ROE.HOLD_FIRE:
			return false
		ROE.RETURN_FIRE:
			return _saw_hostile_shot
		ROE.OPEN_FIRE:
			return true
	return false
```
