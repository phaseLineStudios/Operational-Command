# OrdersParser::_new_order_builder Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 155–166)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func _new_order_builder() -> Dictionary
```

## Description

Builder for a fresh order dictionary.

## Source

```gdscript
func _new_order_builder() -> Dictionary:
	return {
		"callsign": "",
		"type": OrderType.UNKNOWN,
		"direction": "",
		"quantity": 0,
		"zone": "",
		"target_callsign": "",
		"raw": PackedStringArray()
	}
```
