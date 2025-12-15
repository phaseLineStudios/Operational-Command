# OrdersParser::_extract_orders Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 100–294)</br>
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

		if t == "[unk]" or stopwords.has(t):
			i += 1
			continue

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

		if t == "direct":
			cur.direct = true
			i += 1
			continue

		if actions.has(t):
			var ot := int(actions[t])
			if cur.type != OrderType.UNKNOWN and cur.callsign != "":
				out.append(_finalize(cur))
				var prev_subject: String = cur.callsign
				cur = _new_order_builder()
				cur.callsign = prev_subject
			cur.type = ot

			if ot == OrderType.REPORT:
				cur.report_type = "status"
				if i + 1 < tokens.size():
					var next := tokens[i + 1]
					if next in ["status"]:
						cur.report_type = "status"
						i += 1
					elif next == "position":
						cur.report_type = "position"
						i += 1
					elif next in ["contact", "contacts"]:
						cur.report_type = "contact"
						i += 1
					elif next in ["supply", "supplies", "ammo", "fuel"]:
						cur.report_type = "supply"
						i += 1

			if ot == OrderType.FIRE:
				cur.ammo_type = "ap"
				cur.rounds = 1
				LogService.debug(
					"Parsing FIRE order, scanning from token %d: %s" % [i, tokens.slice(i)],
					"OrdersParser"
				)
				var j := i + 1
				while j < tokens.size():
					var next := tokens[j]

					if next in ["round", "rounds"]:
						if j > i + 1:
							var prev := tokens[j - 1]
							LogService.debug(
								"Found 'rounds' at %d, prev token: '%s'" % [j, prev], "OrdersParser"
							)
							if _is_int_literal(prev):
								cur.rounds = int(prev)
								LogService.debug(
									"Parsed rounds as int literal: %d" % cur.rounds, "OrdersParser"
								)
							elif number_words.has(prev):
								cur.rounds = int(number_words[prev])
								LogService.debug(
									"Parsed rounds from word: %d" % cur.rounds, "OrdersParser"
								)
							else:
								LogService.debug(
									"Prev token not recognized as number", "OrdersParser"
								)
						else:
							LogService.debug("Found 'rounds' but j <= i+1", "OrdersParser")
						j += 1
						continue

					if next in ["ap", "he", "frag", "antipersonnel"]:
						cur.ammo_type = "ap"
						j += 1
						continue
					elif next in ["smoke"]:
						cur.ammo_type = "smoke"
						j += 1
						continue
					elif next in ["illum", "illumination", "flare", "flares"]:
						cur.ammo_type = "illum"
						j += 1
						continue

					if qty_labels.has(next) or directions.has(next):
						break

					if callsigns.has(next) or actions.has(next):
						break

					j += 1
			if ot == OrderType.ENGINEER:
				cur.engineer_task = "mine"
				var j := i + 1
				while j < tokens.size():
					var next := tokens[j]
					if qty_labels.has(next) or directions.has(next):
						break
					if next in ["mine", "mines", "minefield"]:
						cur.engineer_task = "mine"
						j += 1
						continue
					elif next in ["demo", "demolition", "demolitions", "charge", "charges"]:
						cur.engineer_task = "demo"
						j += 1
						continue
					elif next in ["bridge", "bridges"]:
						cur.engineer_task = "bridge"
						j += 1
						continue
					elif callsigns.has(next) or actions.has(next):
						break
					j += 1

			i += 1
			continue

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

		if prepositions.has(t):
			i += 1
			continue

		cur.raw.append(t)
		i += 1

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
