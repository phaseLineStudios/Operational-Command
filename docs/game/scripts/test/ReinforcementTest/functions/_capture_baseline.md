# ReinforcementTest::_capture_baseline Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 137–143)</br>
*Belongs to:* [ReinforcementTest](../../ReinforcementTest.md)

**Signature**

```gdscript
func _capture_baseline() -> void
```

## Source

```gdscript
func _capture_baseline() -> void:
	_baseline_strengths.clear()
	for u: UnitData in _units:
		_baseline_strengths[u.id] = int(round(_unit_strength.get(u.id, 0.0)))
	_baseline_pool = _pool
```
