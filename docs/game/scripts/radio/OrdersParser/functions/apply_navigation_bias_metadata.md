# OrdersParser::apply_navigation_bias_metadata Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 545–559)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func apply_navigation_bias_metadata(_orders: Array) -> Array
```

## Description

Annotate parsed orders with navigation bias metadata (placeholder).

## Source

```gdscript
func apply_navigation_bias_metadata(_orders: Array) -> Array:
	if _orders.is_empty() or _nav_bias_phrases.is_empty():
		return _orders
	for i in _orders.size():
		var order: Dictionary = _orders[i]
		var raw_tokens: PackedStringArray = order.get("raw", PackedStringArray())
		var combined := " ".join(raw_tokens)
		for phrase in _nav_bias_phrases.keys():
			if combined.find(phrase) != -1:
				order["navigation_bias"] = _nav_bias_phrases[phrase]
				_orders[i] = order
				break
	return _orders
```
