# OrdersRouter::_resolve_target Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 240–247)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _resolve_target(order: Dictionary) -> ScenarioUnit
```

## Description

Resolve a unit from `target_callsign`.
[param order] Order dictionary.
[return] ScenarioUnit or `null`.

## Source

```gdscript
func _resolve_target(order: Dictionary) -> ScenarioUnit:
	var cs := str(order.get("target_callsign", ""))
	if cs == "":
		return null
	var other_uid: String = _units_by_callsign.get(cs, "")
	return _units_by_id.get(other_uid)
```
