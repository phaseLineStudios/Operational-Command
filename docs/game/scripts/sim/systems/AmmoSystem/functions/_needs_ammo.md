# AmmoSystem::_needs_ammo Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 167–173)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func _needs_ammo(u: UnitData) -> bool
```

## Description

True if any ammo type is below its cap.

## Source

```gdscript
func _needs_ammo(u: UnitData) -> bool:
	for t in u.ammunition.keys():
		if int(u.state_ammunition.get(t, 0)) < int(u.ammunition[t]):
			return true
	return false
```
