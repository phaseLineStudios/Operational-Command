# RadioSubtitles::_read_number_sequence Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 433–508)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _read_number_sequence(tokens: Array, idx: int, number_words: Dictionary) -> Dictionary
```

## Description

Read a number sequence from tokens and return the value

## Source

```gdscript
func _read_number_sequence(tokens: Array, idx: int, number_words: Dictionary) -> Dictionary:
	var nil := {"value": 0, "consumed": 0}

	if idx >= tokens.size():
		return nil

	# Check if it's already a digit literal
	var j: int
	if _is_all_digits(tokens[idx]):
		j = idx
		var digits := ""
		while j < tokens.size() and _is_all_digits(tokens[j]):
			digits += tokens[j]
			j += 1
		return {"value": int(digits), "consumed": j - idx}

	# Collect consecutive number words
	var vals: Array = []
	j = idx
	while j < tokens.size():
		var t: String = tokens[j]
		if not number_words.has(t):
			break
		vals.append(int(number_words[t]))
		j += 1

	if vals.is_empty():
		return nil

	# Convert sequence to number
	var consumed := vals.size()

	# Check if all values are 0-9 (spoken digits)
	var all_under_ten := true
	for v in vals:
		if int(v) < 0 or int(v) > 9:
			all_under_ten = false
			break

	if all_under_ten and vals.size() >= 2:
		# Concatenate digits: "five four" -> 54
		var result := 0
		for d in vals:
			result = result * 10 + int(d)
		return {"value": result, "consumed": consumed}

	# Check for large numbers (hundred, thousand)
	var has_large := false
	for v in vals:
		if int(v) >= 100:
			has_large = true
			break

	if has_large:
		# Process compound numbers: "five hundred" -> 500, "two thousand" -> 2000
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
		return {"value": acc + current, "consumed": consumed}
	else:
		# Sum simple numbers: "twenty five" -> 25
		var sum := 0
		for v in vals:
			sum += int(v)
		return {"value": sum, "consumed": consumed}
```
