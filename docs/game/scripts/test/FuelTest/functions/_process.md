# FuelTest::_process Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 105–114)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _process(delta: float) -> void
```

## Source

```gdscript
func _process(delta: float) -> void:
	if move_enabled:
		var base_mps: float = _kph_to_mps(RX_SPEED_KPH)
		var mult: float = fuel.speed_mult(rx.id)
		rx.position_m.x += base_mps * mult * delta

	fuel.tick(delta)
	_update_labels()
```
