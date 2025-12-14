# AmmoSystem::_has_stock Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 195–201)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func _has_stock(su: ScenarioUnit) -> bool
```

## Description

True if unit has any stock left to transfer.

## Source

```gdscript
func _has_stock(su: ScenarioUnit) -> bool:
	for t in su.unit.throughput.keys():
		if int(su.unit.throughput[t]) > 0:
			return true
	return false
```
