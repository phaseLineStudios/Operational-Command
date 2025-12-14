# FuelSystem::_within_radius Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 357–362)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _within_radius(src: ScenarioUnit, dst: ScenarioUnit) -> bool
```

## Source

```gdscript
func _within_radius(src: ScenarioUnit, dst: ScenarioUnit) -> bool:
	## True if destination is within the source's supply transfer radius in meters.
	var r: float = max(0.0, src.unit.supply_transfer_radius_m)
	return src.position_m.distance_to(dst.position_m) <= r
```
