# FuelTest::_now_s Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 312–313)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _now_s() -> float
```

## Source

```gdscript
func _now_s() -> float:
	return float(Time.get_ticks_msec()) / 1000.0
```
