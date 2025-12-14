# PickupItem::_enter_tree Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 77–82)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func _enter_tree() -> void
```

## Source

```gdscript
func _enter_tree() -> void:
	if not collision_sounds.is_empty():
		max_contacts_reported = 4
		contact_monitor = true
```
