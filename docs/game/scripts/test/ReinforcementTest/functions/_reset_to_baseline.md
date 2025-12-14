# ReinforcementTest::_reset_to_baseline Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 145–164)</br>
*Belongs to:* [ReinforcementTest](../../ReinforcementTest.md)

**Signature**

```gdscript
func _reset_to_baseline() -> void
```

## Description

Restore baseline strengths and pool (test-only behavior for the Reset button)

## Source

```gdscript
func _reset_to_baseline() -> void:
	# Restore unit strengths
	for u: UnitData in _units:
		var base: int = int(
			_baseline_strengths.get(u.id, int(round(_unit_strength.get(u.id, 0.0))))
		)
		_unit_strength[u.id] = float(base)

	# Restore pool (Game scenario + panel)
	_pool = _baseline_pool
	var g: Node = get_tree().get_root().get_node_or_null("/root/Game")
	if g and g.current_scenario:
		g.current_scenario.replacement_pool = _pool

	_panel.set_units(_units, _unit_strength)
	_panel.set_pool(_pool)
	_panel.reset_pending()
	print("Reset to initial baseline — Pool:", _pool)
```
