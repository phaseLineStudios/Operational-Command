# UnitCreateDialog::_require_id Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 655–661)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _require_id(s: String) -> String
```

## Description

Require a unit id.

## Source

```gdscript
func _require_id(s: String) -> String:
	var idt := s.strip_edges()
	if idt != "":
		return idt
	return _slug(_title.text.strip_edges())
```
