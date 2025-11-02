# UnitMgmt::_on_committed Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 109–138)</br>
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
		if not _can_reinforce(u):
			continue

		var cur: int = int(round(u.state_strength))
		var cap: int = int(max(0, u.strength))
		var missing: int = max(0, cap - cur)
		var give: int = min(add, missing, remaining)
		if give <= 0:
			continue

		u.state_strength = float(cur + give)
		remaining -= give
		emit_signal("unit_strength_changed", uid, int(round(u.state_strength)), _status_string(u))

	# Persist pool and refresh UI
	_set_pool(remaining)
	_panel.set_pool(remaining)
	_refresh_from_game()
```
