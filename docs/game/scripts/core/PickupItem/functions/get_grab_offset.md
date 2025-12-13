# PickupItem::get_grab_offset Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 70–76)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func get_grab_offset(hit_position: Vector3) -> Vector3
```

- **hit_position**: World position where the item was clicked.
- **Return Value**: Local offset for grabbing.

## Description

Get the grab offset for this item.
If use_fixed_anchor is true, returns anchor_offset.
Otherwise, returns the offset based on where the item was clicked.

## Source

```gdscript
func get_grab_offset(hit_position: Vector3) -> Vector3:
	if use_fixed_anchor:
		return anchor_offset
	else:
		return to_local(hit_position)
```
