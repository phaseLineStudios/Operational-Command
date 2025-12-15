# OrdersParser::_finalize Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 314–334)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func _finalize(cur: Dictionary) -> Dictionary
```

## Description

Finalize a builder into an immutable order dictionary.

## Source

```gdscript
func _finalize(cur: Dictionary) -> Dictionary:
	if cur.type == OrderType.UNKNOWN and cur.direction != "":
		cur.type = OrderType.MOVE
	if cur.type == OrderType.CANCEL and cur.callsign == "":
		return {}
	return {
		"callsign": str(cur.callsign),
		"type": int(cur.type),
		"direction": str(cur.direction),
		"quantity": int(cur.quantity),
		"zone": str(cur.zone),
		"target_callsign": str(cur.target_callsign),
		"direct": bool(cur.get("direct", false)),
		"report_type": str(cur.report_type),
		"ammo_type": str(cur.ammo_type),
		"rounds": int(cur.rounds),
		"engineer_task": str(cur.engineer_task),
		"raw": (cur.raw as PackedStringArray).duplicate()
	}
```
