# ReinforcementTest::_on_committed Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 92–129)</br>
*Belongs to:* [ReinforcementTest](../../ReinforcementTest.md)

**Signature**

```gdscript
func _on_committed(plan: Dictionary) -> void
```

## Description

Apply plan and keep Game + panel pools synchronized

## Source

```gdscript
func _on_committed(plan: Dictionary) -> void:
	var remaining: int = _pool
	for uid in plan.keys():
		var u: UnitData = _find(uid)
		if u == null:
			continue
		# Business rule: don't reinforce wiped-out
		if u.state_strength <= 0.0:
			continue

		var give: int = int(plan[uid])
		var cur: int = int(round(u.state_strength))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - cur)
		var applied: int = min(give, missing, remaining)
		if applied <= 0:
			continue
		u.state_strength = float(cur + applied)
		remaining -= applied

	# Persist remaining to Game (if present) and mirror to panel
	var g: Node = get_tree().get_root().get_node_or_null("/root/Game")
	if g:
		if g.has_method("set_replacement_pool"):
			g.set_replacement_pool(remaining)
		elif g.has_variable("campaign_replacement_pool"):
			g.campaign_replacement_pool = remaining

	_pool = remaining
	_panel.set_units(_units)  # refresh rows/badges/missing caps
	_panel.set_pool(_pool)
	_panel.reset_pending()

	print("Remaining pool:", _pool)
	for u: UnitData in _units:
		print(u.id, ": ", int(round(u.state_strength)), "/", int(u.strength))
```
