# UnitMgmt::_on_committed Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 112–143)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _on_committed(plan: Dictionary) -> void
```

## Description

Apply a committed plan:
clamp to capacity and pool, then signal status changes.

## Source

```gdscript
func _on_committed(plan: Dictionary) -> void:
	var remaining: int = _get_pool()

	for uid in plan.keys():
		var add := int(plan[uid])
		var u: UnitData = _find_unit(uid)
		if u == null:
			continue

		# Authoritative gate: skip wiped-out units here
		if not _can_reinforce(uid):
			continue

		var cur: int = int(round(_unit_strength.get(uid, 0.0)))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - cur)
		var give: int = min(add, missing, remaining)
		if give <= 0:
			continue

		_unit_strength[uid] = float(cur + give)
		remaining -= give
		emit_signal(
			"unit_strength_changed", uid, int(round(_unit_strength[uid])), _status_string(uid)
		)

	# Persist pool and refresh UI
	_set_pool(remaining)
	_panel.set_pool(remaining)
	_refresh_from_game()
```
