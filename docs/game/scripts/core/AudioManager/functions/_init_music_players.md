# AudioManager::_init_music_players Function Reference

*Defined at:* `scripts/core/AudioManager.gd` (lines 72–87)</br>
*Belongs to:* [AudioManager](../../AudioManager.md)

**Signature**

```gdscript
func _init_music_players() -> void
```

## Description

Initialize the music players for crossfading

## Source

```gdscript
func _init_music_players() -> void:
	_music_player_a = AudioStreamPlayer.new()
	_music_player_a.name = "MusicPlayerA"
	_music_player_a.bus = "Music"
	_music_player_a.volume_db = -80.0
	add_child(_music_player_a)

	_music_player_b = AudioStreamPlayer.new()
	_music_player_b.name = "MusicPlayerB"
	_music_player_b.bus = "Music"
	_music_player_b.volume_db = -80.0
	add_child(_music_player_b)

	_current_music_player = _music_player_a
```
