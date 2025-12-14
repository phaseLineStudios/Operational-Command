# UnitCreateDialog::_validate Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 328–341)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _validate() -> String
```

## Description

Validate fields

## Source

```gdscript
func _validate() -> String:
	if _id.text.strip_edges() == "":
		return _error("Unit ID is required.")
	if _title.text.strip_edges() == "":
		return _error("Title is required.")
	if _role.text.strip_edges() == "":
		return _error("Role is required.")
	if _slots.is_empty():
		return _error("At least one Allowed Slot is required.")
	if _category_ob.get_selected() < 0:
		return _error("Select a Category.")
	return ""
```
