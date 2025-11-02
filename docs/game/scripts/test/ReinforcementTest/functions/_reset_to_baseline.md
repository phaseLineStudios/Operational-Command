# ReinforcementTest::_reset_to_baseline Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 141–161)</br>
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
		var base: int = int(_baseline_strengths.get(u.id, int(round(u.state_strength))))
		u.state_strength = float(base)

	# Restore pool (Game + panel)
	_pool = _baseline_pool
	var g: Node = get_tree().get_root().get_node_or_null("/root/Game")
	if g:
		if g.has_method("set_replacement_pool"):
			g.set_replacement_pool(_pool)
		elif g.has_variable("campaign_replacement_pool"):
			g.campaign_replacement_pool = _pool

	_panel.set_units(_units)
	_panel.set_pool(_pool)
	_panel.reset_pending()
	print("Reset to initial baseline — Pool:", _pool)
```
