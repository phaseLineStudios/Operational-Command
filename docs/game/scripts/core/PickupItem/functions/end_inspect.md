# PickupItem::end_inspect Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 150–158)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func end_inspect() -> void
```

## Description

Runs on inspect close

## Source

```gdscript
func end_inspect() -> void:
	if not _inspecting:
		return
	_inspecting = false
	_inspect_camera = null
	global_transform = _pre_inspect_transform
	global_rotation_degrees = held_rotation
```
