# AmmoSystem::is_low Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 74–81)</br>
*Belongs to:* [AmmoSystem](../AmmoSystem.md)

**Signature**

```gdscript
func is_low(u: UnitData, t: String) -> bool
```

## Description

True if current/cap <= low threshold (and > 0).

## Source

```gdscript
func is_low(u: UnitData, t: String) -> bool:
	var cap := int(u.ammunition.get(t, 0))
	if cap <= 0:
		return false
	var cur := int(u.state_ammunition.get(t, 0))
	return cur > 0 and float(cur) / float(cap) <= u.ammunition_low_threshold
```
