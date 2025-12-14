# AudioManager::play_ui_sound Function Reference

*Defined at:* `scripts/core/AudioManager.gd` (lines 46–55)</br>
*Belongs to:* [AudioManager](../../AudioManager.md)

**Signature**

```gdscript
func play_ui_sound(sound: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void
```

- **sound**: The AudioStream to play
- **volume_db**: Volume adjustment in decibels (0 = default, negative = quieter)
- **pitch_scale**: Pitch multiplier (1.0 = normal, >1.0 = higher, <1.0 = lower)

## Description

Play a UI sound effect.

## Source

```gdscript
func play_ui_sound(sound: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if not sound:
		return
	if not _ui_playback:
		push_warning("AudioManager: UI playback not initialized")
		return

	_ui_playback.play_stream(sound, 0.0, volume_db, pitch_scale)
```
