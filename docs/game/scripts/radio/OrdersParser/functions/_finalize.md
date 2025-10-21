# OrdersParser::_finalize Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 168–183)</br>
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
		"callsign": String(cur.callsign),
		"type": int(cur.type),
		"direction": String(cur.direction),
		"quantity": int(cur.quantity),
		"zone": String(cur.zone),
		"target_callsign": String(cur.target_callsign),
		"raw": (cur.raw as PackedStringArray).duplicate()
	}
```
