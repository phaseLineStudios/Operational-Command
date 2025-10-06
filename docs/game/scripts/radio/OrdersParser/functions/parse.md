# OrdersParser::parse Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 35–51)</br>
*Belongs to:* [OrdersParser](../OrdersParser.md)

**Signature**

```gdscript
func parse(text: String) -> Array
```

## Description

Parse a full STT sentence into one or more structured orders.

## Source

```gdscript
func parse(text: String) -> Array:
	var tokens := _normalize_and_tokenize(text)
	if tokens.is_empty():
		emit_signal("parse_error", "No tokens.")
		return []
	var orders := _extract_orders(tokens)
	if orders.is_empty():
		emit_signal("parse_error", "No orders found.")
	else:
		emit_signal("parsed", orders)

		# Print hr orders for debugging
		for order in orders:
			LogService.info("Order: %s" % order_to_string(order), "OrdersParser.gd:41")
	return orders
```
