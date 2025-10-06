# SlotItem::_refresh_labels Function Reference

*Defined at:* `scripts/ui/helpers/SlotItem.gd` (lines 97–109)</br>
*Belongs to:* [SlotItem](../SlotItem.md)

**Signature**

```gdscript
func _refresh_labels() -> void
```

## Description

Update Title, and Type.

## Source

```gdscript
func _refresh_labels() -> void:
	var roles_str := ", ".join(allowed_roles)
	if not _assigned_unit:
		_lbl_title.text = "[Empty] • %s" % title
		_lbl_slot.text = "Slot %d/%d • %s" % [index, max_count, roles_str]
	else:
		var unit_title: String = _assigned_unit.title
		_lbl_title.text = "%s • %s" % [unit_title, title]

		var unit_role: String = _assigned_unit.role
		_lbl_slot.text = "Slot %d/%d • %s" % [index, max_count, unit_role]
```
