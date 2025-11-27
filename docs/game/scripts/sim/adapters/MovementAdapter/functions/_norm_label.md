# MovementAdapter::_norm_label Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 130–163)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _norm_label(s: String) -> String
```

- **s**: Original label text.
- **Return Value**: Normalized key.

## Description

Normalizes label text for tolerant matching.
Removes punctuation, collapses spaces, and lowercases.

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
