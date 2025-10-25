# BriefingDialog::_slug Function Reference

*Defined at:* `scripts/editors/BriefingDialog.gd` (lines 186–193)</br>
*Belongs to:* [BriefingDialog](../../BriefingDialog.md)

**Signature**

```gdscript
func _slug(s: String) -> String
```

## Description

Make a lightweight slug from title.

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
