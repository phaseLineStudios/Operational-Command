# OrdersRouter::apply Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 51–82)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func apply(order: Dictionary) -> bool
```

- **order**: Normalized order dictionary from OrdersParser.
- **Return Value**: `true` if applied, otherwise `false`.

## Description

Apply a single validated order.

## Source

```gdscript
func apply(order: Dictionary) -> bool:
	var t := _normalize_type(order.get("type", "UNKNOWN"))
	var uid := str(order.get("unit_id", ""))
	var unit: ScenarioUnit = _units_by_id.get(uid)
	if unit == null:
		emit_signal("order_failed", order, "unknown_unit")
		return false

	if unit.is_dead():
		emit_signal("order_failed", order, "dead_unit")
		return false

	match t:
		"MOVE":
			return _apply_move(unit, order)
		"HOLD", "CANCEL":
			return _apply_hold(unit, order)
		"ATTACK":
			return _apply_attack(unit, order)
		"DEFEND":
			return _apply_defend(unit, order)
		"RECON":
			return _apply_recon(unit, order)
		"FIRE":
			return _apply_fire(unit, order)
		"REPORT":
			return _apply_report(unit, order)
		_:
			emit_signal("order_failed", order, "unsupported_type")
			return false
```
