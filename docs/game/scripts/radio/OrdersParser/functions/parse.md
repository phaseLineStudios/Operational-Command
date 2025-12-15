# OrdersParser::parse Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 73–98)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

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

	var normalized_text := text.to_lower().strip_edges()
	for keyword in _custom_commands.keys():
		if normalized_text.contains(keyword):
			var custom_order := _build_custom_order(keyword, normalized_text, tokens)
			emit_signal("parsed", [custom_order])
			LogService.info("Custom Order: %s" % keyword, "OrdersParser.gd")
			return [custom_order]

	# Fall back to standard order parsing
	var orders := apply_navigation_bias_metadata(_extract_orders(tokens))
	if orders.is_empty():
		emit_signal("parse_error", "No orders found.")
	else:
		emit_signal("parsed", orders)

		for order in orders:
			LogService.info("Order: %s" % order_to_string(order), "OrdersParser.gd:41")
	return orders
```
