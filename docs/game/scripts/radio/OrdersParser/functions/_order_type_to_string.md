# OrdersParser::_order_type_to_string Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 505–528)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func _order_type_to_string(t: int) -> String
```

## Description

String name for OrderType.

## Source

```gdscript
func _order_type_to_string(t: int) -> String:
	match t:
		OrderType.MOVE:
			return "MOVE"
		OrderType.HOLD:
			return "HOLD"
		OrderType.DEFEND:
			return "DEFEND"
		OrderType.ATTACK:
			return "ATTACK"
		OrderType.RECON:
			return "RECON"
		OrderType.FIRE:
			return "FIRE"
		OrderType.REPORT:
			return "REPORT"
		OrderType.CANCEL:
			return "CANCEL"
		OrderType.ENGINEER:
			return "ENGINEER"
		OrderType.CUSTOM:
			return "CUSTOM"
		_:
			return "UNKNOWN"
```
