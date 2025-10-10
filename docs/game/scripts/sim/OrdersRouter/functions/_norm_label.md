# OrdersRouter::_norm_label Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 267–300)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _norm_label(s: String) -> String
```

- **s**: Input text.
- **Return Value**: Normalized key string.

## Description

Normalize label text for matching (lowercase, strip punctuation, collapse spaces).

## Source

```gdscript
func _norm_label(s: String) -> String:
	var t := s.strip_edges().to_lower()
	for bad in [
		",",
		".",
		":",
		";",
		"(",
		")",
		"[",
		"]",
		"'",
		'"',
		"?",
		"!",
		"@",
		"#",
		"$",
		"%",
		"^",
		"&",
		"*",
		"+",
		"=",
		"|",
		"\\"
	]:
		t = t.replace(bad, "")
	t = t.replace("-", " ").replace("_", " ").replace("/", " ")
	while t.find("  ") != -1:
		t = t.replace("  ", " ")
	return t
```
