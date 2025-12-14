# PickupItem::on_pickup Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 100–107)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func on_pickup() -> void
```

## Description

Runs on pickup

## Source

```gdscript
func on_pickup() -> void:
	_pre_pick_freeze = freeze
	freeze = true
	global_rotation_degrees = held_rotation
	if hide_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
```
