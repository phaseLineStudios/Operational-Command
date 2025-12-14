# FuelSystem::_has_stock Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 349–356)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _has_stock(su: ScenarioUnit) -> bool
```

## Source

```gdscript
func _has_stock(su: ScenarioUnit) -> bool:
	## True if the source unit still has fuel stock to transfer.
	var u: UnitData = su.unit
	if u == null or not (u.throughput is Dictionary):
		return false
	return int(u.throughput.get("fuel", 0)) > 0
```
