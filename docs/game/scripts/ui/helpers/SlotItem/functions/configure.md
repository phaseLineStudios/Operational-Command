# SlotItem::configure Function Reference

*Defined at:* `scripts/ui/helpers/SlotItem.gd` (lines 84–94)</br>
*Belongs to:* [SlotItem](../../SlotItem.md)

**Signature**

```gdscript
func configure(id: String, slot_title: String, roles: Array, i: int, m: int) -> void
```

## Description

Initialize slot metadata (id/title/roles/index/total) and update UI.

## Source

```gdscript
func configure(id: String, slot_title: String, roles: Array, i: int, m: int) -> void:
	slot_id = id
	title = slot_title
	allowed_roles = roles.duplicate()
	index = i
	max_count = m
	_refresh_labels()
	_update_icon()
	_apply_style()
```
