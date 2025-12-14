# AudioManager::is_music_playing Function Reference

*Defined at:* `scripts/core/AudioManager.gd` (lines 201–204)</br>
*Belongs to:* [AudioManager](../../AudioManager.md)

**Signature**

```gdscript
func is_music_playing() -> bool
```

## Description

Check if music is currently playing

## Source

```gdscript
func is_music_playing() -> bool:
	return _current_music_player != null and _current_music_player.playing
```
