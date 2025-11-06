# RadioSubtitles::_normalize_and_tokenize Function Reference

*Defined at:* `scripts/ui/RadioSubtitles.gd` (lines 359–376)</br>
*Belongs to:* [RadioSubtitles](../../RadioSubtitles.md)

**Signature**

```gdscript
func _normalize_and_tokenize(text: String) -> PackedStringArray
```

## Description

Normalize and tokenize text (same as OrdersParser)

## Source

```gdscript
func _normalize_and_tokenize(text: String) -> PackedStringArray:
	var s := text.to_lower().strip_edges()
	s = s.replace("—", "-").replace("–", "-")
	var cleaned := ""
	for i in s.length():
		var cp := s.unicode_at(i)
		if _is_ascii_alpha_cp(cp) or _is_ascii_digit_cp(cp) or cp == 32 or cp == 45:
			cleaned += char(cp)

	cleaned = cleaned.strip_edges()
	var parts := cleaned.split(" ", false)
	var out := PackedStringArray()
	for p in parts:
		if p.length() > 0:
			out.append(p)
	return out
```
