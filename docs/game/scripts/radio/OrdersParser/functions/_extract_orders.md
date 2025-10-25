# OrdersParser::_extract_orders Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 54–154)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func _extract_orders(tokens: PackedStringArray) -> Array
```

## Description

Scan tokens left→right and extract orders.

## Source

```gdscript
func _extract_orders(tokens: PackedStringArray) -> Array:
	var callsigns: Dictionary = _tables.get("callsigns", {})
	var actions: Dictionary = _tables.get("action_synonyms", {})
	var directions: Dictionary = _tables.get("directions", {})
	var stopwords: Dictionary = _tables.get("stopwords", {})
	var number_words: Dictionary = _tables.get("number_words", {})
	var prepositions: Dictionary = _tables.get("prepositions", {})
	var qty_labels: Dictionary = _tables.get("quantity_labels", {})

	var out: Array = []
	var cur := _new_order_builder()
	var i := 0

	while i < tokens.size():
		var t := tokens[i]

		# Skip artifacts/stopwords.
		if t == "[unk]" or stopwords.has(t):
			i += 1
			continue

		# Callsign.
		if callsigns.has(t):
			var cs := str(callsigns[t])
			if cur.callsign == "":
				cur.callsign = cs
			else:
				if cur.type != OrderType.UNKNOWN and cur.target_callsign == "":
					cur.target_callsign = cs
				else:
					if cur.callsign != "" and cur.type != OrderType.UNKNOWN:
						out.append(_finalize(cur))
					cur = _new_order_builder()
					cur.callsign = cs
			i += 1
			continue

		# Action keyword.
		if actions.has(t):
			var ot := int(actions[t])
			if cur.type != OrderType.UNKNOWN and cur.callsign != "":
				out.append(_finalize(cur))
				var prev_subject: String = cur.callsign
				cur = _new_order_builder()
				cur.callsign = prev_subject
			cur.type = ot
			i += 1
			continue

		# Direction.
		if directions.has(t):
			cur.direction = str(directions[t])
			i += 1
			continue

		if qty_labels.has(t):
			var num_after := _read_number(tokens, i + 1, number_words)
			if num_after.consumed > 0:
				cur.zone = str(qty_labels[t])
				cur.quantity = num_after.value
				i += 1 + num_after.consumed
				continue
			# If no number after label, treat label as hint and continue scanning.
			i += 1
			continue

		var num_here := _read_number(tokens, i, number_words)
		if num_here.consumed > 0:
			i += num_here.consumed
			if i < tokens.size():
				var lbl := tokens[i]
				if qty_labels.has(lbl):
					cur.zone = str(qty_labels[lbl])
					i += 1
			cur.quantity = num_here.value
			continue

		# Prepositions are hints; skip.
		if prepositions.has(t):
			i += 1
			continue

		# Unknowns kept for debugging.
		cur.raw.append(t)
		i += 1

	# Flush tail if meaningful.
	if (
		cur.callsign != ""
		and (
			cur.type != OrderType.UNKNOWN
			or cur.direction != ""
			or cur.quantity != 0
			or cur.target_callsign != ""
		)
	):
		out.append(_finalize(cur))

	return out
```
