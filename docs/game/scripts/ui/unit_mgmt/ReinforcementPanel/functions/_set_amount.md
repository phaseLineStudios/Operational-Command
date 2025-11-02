# ReinforcementPanel::_set_amount Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 257–274)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func _set_amount(uid: String, target: int) -> void
```

## Description

Set planned amount for a unit (clamped to capacity and pool).

## Source

```gdscript
func _set_amount(uid: String, target: int) -> void:
	var u: UnitData = _find_unit(uid)
	if u == null:
		return
	var cur: int = int(round(u.state_strength))
	var cap: int = int(max(0, u.strength))
	var missing: int = max(0, cap - cur)
	var already: int = int(_pending.get(uid, 0))
	var room_in_pool: int = _pool_remaining + already

	var clamped: int = clampi(target, 0, min(missing, room_in_pool))
	_pending[uid] = clamped
	_pool_remaining = _pool_total - _pending_sum()
	_emit_preview(uid, clamped)
	_update_all_rows_state()
	_update_commit_enabled()
```
