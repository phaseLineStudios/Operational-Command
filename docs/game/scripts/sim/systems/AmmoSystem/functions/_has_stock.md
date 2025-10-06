# AmmoSystem::_has_stock Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 175–181)</br>
*Belongs to:* [AmmoSystem](../AmmoSystem.md)

**Signature**

```gdscript
func _has_stock(u: UnitData) -> bool
```

## Description

True if unit has any stock left to transfer.

## Source

```gdscript
func _has_stock(u: UnitData) -> bool:
	for t in u.throughput.keys():
		if int(u.throughput[t]) > 0:
			return true
	return false
```
