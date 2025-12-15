# OrdersParser::order_to_string Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 460–481)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func order_to_string(o: Dictionary) -> String
```

## Description

Human-friendly summary for a single order.

## Source

```gdscript
func order_to_string(o: Dictionary) -> String:
	if o.is_empty():
		return "<invalid>"
	var s := ""
	s += "%s: " % str(o.get("callsign", ""))
	s += _order_type_to_string(int(o.get("type", OrderType.UNKNOWN)))
	var dir := str(o.get("direction", ""))
	if dir != "":
		s += " " + dir
	var qty := int(o.get("quantity", 0))
	if qty > 0:
		var z := str(o.get("zone", ""))
		if z != "":
			s += " %d %s" % [qty, z]
		else:
			s += " %d" % qty
	var tgt := str(o.get("target_callsign", ""))
	if tgt != "":
		s += " -> %s" % tgt
	return s.strip_edges()
```
