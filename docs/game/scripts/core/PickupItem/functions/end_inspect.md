# PickupItem::end_inspect Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 78–85)</br>
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
	global_rotation_degrees = held_rotation
```
