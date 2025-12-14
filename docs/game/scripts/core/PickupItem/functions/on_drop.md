# PickupItem::on_drop Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 109–128)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func on_drop() -> void
```

## Description

Runs on drop

## Source

```gdscript
func on_drop() -> void:
	if snap_to_origin_position:
		global_transform.origin = origin_position
		if snap_to_origin_rotation:
			global_rotation = origin_rotation
		freeze = true

		var sound := collision_sounds[randi() % collision_sounds.size()]
		_collision_sound_player.stream = sound
		_collision_sound_player.play()
	elif snap_to_origin_rotation:
		global_rotation = origin_rotation
		freeze = false
	else:
		freeze = false

	if hide_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
```
