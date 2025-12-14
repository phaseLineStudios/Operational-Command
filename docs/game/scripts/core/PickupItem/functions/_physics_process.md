# PickupItem::_physics_process Function Reference

*Defined at:* `scripts/core/PickupItem.gd` (lines 261–283)</br>
*Belongs to:* [PickupItem](../../PickupItem.md)

**Signature**

```gdscript
func _physics_process(_delta: float) -> void
```

## Description

Physics process for collision detection

## Source

```gdscript
func _physics_process(_delta: float) -> void:
	if collision_sounds.is_empty() or not _collision_sound_player or not _collision_sounds_enabled:
		return

	if _last_impact_impulse > collision_sound_min_impulse:
		var current_time := Time.get_ticks_msec() / 1000.0
		if current_time - _last_collision_time >= collision_sound_cooldown:
			var volume_db := clampf(
				remap(_last_impact_impulse, collision_sound_min_impulse, 1.0, -10.0, 0.0),
				-10.0,
				0.0
			)

			var sound := collision_sounds[randi() % collision_sounds.size()]
			_collision_sound_player.stream = sound
			_collision_sound_player.volume_db = volume_db
			_collision_sound_player.play()

			_last_collision_time = current_time

		_last_impact_impulse = 0.0
```
