# UnitCreateDialog::_slug Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 699–706)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _slug(s: String) -> String
```

- **s**: string to create id from.
- **Return Value**: id string.

## Description

Create a id from string.

## Source

```gdscript
static func _slug(s: String) -> String:
	var out := ""
	for ch in s.to_lower():
		if ch.is_valid_identifier() or ch in ["-", "_"]:
			out += ch
		elif ch == " ":
			out += "_"
	return out
```
