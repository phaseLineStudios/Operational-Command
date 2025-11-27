# AmmoSystem::consume Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 104–126)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func consume(unit_id: String, t: String, amount: int = 1) -> bool
```

## Description

Decrease ammo for `unit_id` of type `t` by `amount`.
Returns true if ammo was consumed; false if blocked (missing type or empty).

## Source

```gdscript
func consume(unit_id: String, t: String, amount: int = 1) -> bool:
	var u: UnitData = _units.get(unit_id) as UnitData
	if u == null or not u.state_ammunition.has(t):
		return false

	var cur: int = int(u.state_ammunition.get(t, 0))
	if cur <= 0:
		u.state_ammunition[t] = 0
		emit_signal("ammo_empty", unit_id)
		return false

	var newv: int = max(0, cur - max(1, amount))
	u.state_ammunition[t] = newv

	if newv <= 0:
		emit_signal("ammo_empty", unit_id)
	elif is_critical(u, t):
		emit_signal("ammo_critical", unit_id)
	elif is_low(u, t):
		emit_signal("ammo_low", unit_id)
	return true
```
