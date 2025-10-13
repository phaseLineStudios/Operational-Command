# FuelSystem::speed_mult Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 117–125)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func speed_mult(unit_id: String) -> float
```

## Source

```gdscript
func speed_mult(unit_id: String) -> float:
	## Movement uses this multiplier: 1.0 normal, critical_speed_mult at CRITICAL, 0.0 at EMPTY.
	if is_empty(unit_id):
		return 0.0
	if is_critical(unit_id):
		return critical_speed_mult
	return 1.0
```
