# PickupItem::_ready Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 83–98)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
func _ready():
	collision_layer = 2
	origin_position = global_transform.origin
	origin_rotation = global_rotation

	if document_viewport:
		set_process_unhandled_input(true)

	if not collision_sounds.is_empty():
		_collision_sound_player = AudioStreamPlayer3D.new()
		_collision_sound_player.bus = "SFX"
		add_child(_collision_sound_player)

		set_physics_process(true)
```
