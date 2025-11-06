# UnitCreateDialog::_val_to_text Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 646–653)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _val_to_text(v: Variant) -> String
```

## Description

Convert any value to string.

## Source

```gdscript
func _val_to_text(v: Variant) -> String:
	match typeof(v):
		TYPE_DICTIONARY, TYPE_ARRAY:
			return JSON.stringify(v)
		_:
			return str(v)
```
