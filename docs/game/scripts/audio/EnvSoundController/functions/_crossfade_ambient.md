# EnvSoundController::_crossfade_ambient Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 255–276)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _crossfade_ambient(new_stream: AudioStream) -> void
```

## Description

Crossfade to a new ambient loop.

## Source

```gdscript
func _crossfade_ambient(new_stream: AudioStream) -> void:
	if new_stream == null:
		return

	var from_player: AudioStreamPlayer = _ambient_a if _ambient_using_a else _ambient_b
	var to_player: AudioStreamPlayer = _ambient_b if _ambient_using_a else _ambient_a

	if from_player.stream == new_stream and from_player.playing:
		return

	to_player.stream = new_stream
	to_player.volume_db = -80.0
	to_player.play()

	var tween := create_tween()
	tween.tween_property(to_player, "volume_db", 0.0, crossfade_time)
	tween.parallel().tween_property(from_player, "volume_db", -80.0, crossfade_time)
	tween.finished.connect(func() -> void: from_player.stop())

	_ambient_using_a = not _ambient_using_a
```
