# OrdersQueue::validate Function Reference

*Defined at:* `scripts/sim/OrdersQueue.gd` (lines 72–94)</br>
*Belongs to:* [OrdersQueue](../../OrdersQueue.md)

**Signature**

```gdscript
func validate(order: Dictionary, units_by_callsign: Dictionary = {}) -> Dictionary
```

- **order**: Order dictionary to validate.
- **units_by_callsign**: Callsign → unit_id map used to resolve targets.
- **Return Value**: Dictionary `{ "valid": bool, "reason": String, "order": Dictionary }`.

## Description

Validate and lightly normalize an order.
Ensures the structure is a Dictionary, resolves `"callsign"` to `"unit_id"`
when possible, and checks minimal fields per type.

## Source

```gdscript
func validate(order: Dictionary, units_by_callsign: Dictionary = {}) -> Dictionary:
	if typeof(order) != TYPE_DICTIONARY:
		return {"valid": false, "reason": "not_dictionary"}

	var o := order.duplicate(true)
	o["type"] = o.get("type", "UNKNOWN")
	if not o.has("callsign") and not o.has("unit_id"):
		return {"valid": false, "reason": "no_target"}

	if o.has("callsign") and not o.has("unit_id"):
		var cs: String = str(o.get("callsign"))
		if cs in units_by_callsign:
			o["unit_id"] = units_by_callsign[cs]

	match str(o["type"]).to_upper():
		"MOVE":
			if not o.has("pos_m") and not o.has("target_callsign"):
				return {"valid": false, "reason": "move_missing_destination"}
		"CANCEL", "HOLD":
			pass
		_:
			pass
	return {"valid": true, "order": o}
```
