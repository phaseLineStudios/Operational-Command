# CombatAdapter::request_fire Function Reference

*Defined at:* `scripts/sim/CombatAdapter.gd` (lines 25–38)</br>
*Belongs to:* [CombatAdapter](../../CombatAdapter.md)

**Signature**

```gdscript
func request_fire(unit_id: String, ammo_type: String, rounds: int = 1) -> bool
```

## Description

Request to fire: returns true if ammo was consumed; false if blocked.
Fails open (true) when there is no ammo system or unit is unknown.

## Source

```gdscript
func request_fire(unit_id: String, ammo_type: String, rounds: int = 1) -> bool:
	if _ammo == null:
		return true
	var u := _ammo.get_unit(unit_id)
	if u == null:
		return true
	if not u.state_ammunition.has(ammo_type):
		return true
	if _ammo.is_empty(u, ammo_type):
		emit_signal("fire_blocked_empty", unit_id, ammo_type)
		return false
	return _ammo.consume(unit_id, ammo_type, max(1, rounds))
```
