# AudioManager::stop_music Function Reference

*Defined at:* `scripts/core/AudioManager.gd` (lines 124–144)</br>
*Belongs to:* [AudioManager](../../AudioManager.md)

**Signature**

```gdscript
func stop_music(fade_out_duration: float = DEFAULT_FADE_DURATION) -> void
```

- **fade_out_duration**: Duration of fade out effect in seconds

## Description

Stop the currently playing music with fade out.

## Source

```gdscript
func stop_music(fade_out_duration: float = DEFAULT_FADE_DURATION) -> void:
	if not is_music_playing():
		return

	if fade_out_duration <= 0.0:
		# Immediate stop
		_current_music_player.stop()
		_current_music_player.volume_db = -80.0
		_current_music_stream = null
	else:
		# Fade out then stop
		_fade_music_player(
			_current_music_player, _current_music_player.volume_db, -80.0, fade_out_duration
		)
		# Stop playback after fade completes
		await get_tree().create_timer(fade_out_duration).timeout
		if _current_music_player:
			_current_music_player.stop()
			_current_music_stream = null
```
