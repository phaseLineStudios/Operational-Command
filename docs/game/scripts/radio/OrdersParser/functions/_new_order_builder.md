# OrdersParser::_new_order_builder Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 298–314)</br>
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
		"direct": false,
		"report_type": "",  # For REPORT orders: status, position, contact
		"ammo_type": "",  # For FIRE orders: "ap", "smoke", "illum"
		"rounds": 1,  # For FIRE orders: number of rounds
		"engineer_task": "",  # For ENGINEER orders: "mine", "demo", "bridge"
		"raw": PackedStringArray()
	}
```
