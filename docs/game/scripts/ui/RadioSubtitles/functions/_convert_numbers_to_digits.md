# RadioSubtitles::_convert_numbers_to_digits Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 404–431)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _convert_numbers_to_digits(text: String) -> String
```

## Description

Convert number words to digits in text (e.g., "five hundred" -> "500")

## Source

```gdscript
func _convert_numbers_to_digits(text: String) -> String:
	var tokens := text.to_lower().split(" ", false)
	if tokens.is_empty():
		return text

	var number_words: Dictionary = _tables.get("number_words", {})
	var result_tokens: Array[String] = []
	var i := 0

	while i < tokens.size():
		var t := tokens[i]

		# Check if this token is a number word or already a digit
		if number_words.has(t) or _is_all_digits(t):
			# Try to read a complete number sequence
			var num_result := _read_number_sequence(tokens, i, number_words)
			if num_result.value > 0:
				result_tokens.append(str(num_result.value))
				i += num_result.consumed
				continue

		# Not a number, keep as-is
		result_tokens.append(t)
		i += 1

	return " ".join(result_tokens)
```
