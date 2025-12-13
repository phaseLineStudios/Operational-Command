# OrdersParser::_normalize_and_tokenize Function Reference

*Defined at:* `scripts/radio/OrdersParser.gd` (lines 333–357)</br>
*Belongs to:* [OrdersParser](../../OrdersParser.md)

**Signature**

```gdscript
func _normalize_and_tokenize(text: String) -> PackedStringArray
```

## Description

Lowercase, strip, keep letters/digits/space/hyphen/brackets, and split.

## Source

```gdscript
func _normalize_and_tokenize(text: String) -> PackedStringArray:
	var s := text.to_lower().strip_edges()
	s = s.replace("—", "-").replace("–", "-")
	var cleaned := ""
	for i in s.length():
		var cp := s.unicode_at(i)
		if (
			_is_ascii_alpha_cp(cp)
			or _is_ascii_digit_cp(cp)
			or cp == 32
			or cp == 45
			or cp == 91
			or cp == 93
		):
			cleaned += char(cp)

	cleaned = cleaned.strip_edges()
	var parts := cleaned.split(" ", false)
	var out := PackedStringArray()
	for p in parts:
		if p.length() > 0:
			out.append(p)
	return out
```
