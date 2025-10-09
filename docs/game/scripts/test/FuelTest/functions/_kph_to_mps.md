# FuelTest::_kph_to_mps Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 308–311)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _kph_to_mps(kph: float) -> float
```

## Source

```gdscript
func _kph_to_mps(kph: float) -> float:
	return max(0.0, kph) * (1000.0 / 3600.0)
```
