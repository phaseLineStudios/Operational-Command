# OrdersParser::_read_number Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 359–425)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func _read_number(tokens: PackedStringArray, idx: int, number_words: Dictionary) -> Dictionary
```

## Description

Read a verbal or digit number from tokens[idx..]; sets 'consumed'.

## Source

```gdscript
func _read_number(tokens: PackedStringArray, idx: int, number_words: Dictionary) -> Dictionary:
	var nil := {"value": 0, "consumed": 0}

	if idx >= tokens.size():
		return nil

	if _is_int_literal(tokens[idx]):
		@warning_ignore("confusable_local_declaration")
		var j := idx
		var digits := ""
		while j < tokens.size() and _is_int_literal(tokens[j]):
			digits += tokens[j]  # concat tokens
			j += 1
		return {"value": int(digits), "consumed": j - idx}

	var vals: Array = []
	var j := idx
	while j < tokens.size():
		var t := tokens[j]
		if not number_words.has(t):
			break
		vals.append(int(number_words[t]))
		j += 1

	if vals.is_empty():
		return nil

	var all_under_ten := true
	for v in vals:
		var iv := int(v)
		if iv < 0 or iv > 9:
			all_under_ten = false
			break

	if all_under_ten and vals.size() >= 2:
		var v := 0
		for d in vals:
			v = v * 10 + int(d)
		return {"value": v, "consumed": vals.size()}

	var has_large := false
	for v in vals:
		if int(v) >= 100:
			has_large = true
			break

	if has_large:
		var acc := 0
		var current := 0
		for v in vals:
			var iv := int(v)
			if iv == 100 or iv == 1000:
				if current == 0:
					current = 1
				current *= iv
				acc += current
				current = 0
			else:
				current += iv
		return {"value": acc + current, "consumed": vals.size()}
	else:
		var sum := 0
		for v in vals:
			sum += int(v)
		return {"value": sum, "consumed": vals.size()}
```
