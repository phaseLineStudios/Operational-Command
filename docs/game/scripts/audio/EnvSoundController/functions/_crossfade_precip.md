# EnvSoundController::_crossfade_precip Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 278–299)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _crossfade_precip(new_stream: AudioStream) -> void
```

## Description

Crossfade to a new precipitation loop.

## Source

```gdscript
func _crossfade_precip(new_stream: AudioStream) -> void:
	if new_stream == null:
		return

	var from_player: AudioStreamPlayer = _precip_a if _precip_using_a else _precip_b
	var to_player: AudioStreamPlayer = _precip_b if _precip_using_a else _precip_a

	if from_player.stream == new_stream and from_player.playing:
		return

	to_player.stream = new_stream
	to_player.volume_db = -80.0
	to_player.play()

	var tween := create_tween()
	tween.tween_property(to_player, "volume_db", 0.0, crossfade_time)
	tween.parallel().tween_property(from_player, "volume_db", -80.0, crossfade_time)
	tween.finished.connect(func() -> void: from_player.stop())

	_precip_using_a = not _precip_using_a
```
