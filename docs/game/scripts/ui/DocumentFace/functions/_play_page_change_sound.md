# DocumentFace::_play_page_change_sound Function Reference

*Defined at:* `scripts/ui/DocumentFace.gd` (lines 103–109)</br>
*Belongs to:* [DocumentFace](../../DocumentFace.md)

**Signature**

```gdscript
func _play_page_change_sound() -> void
```

## Description

Play a random page change sound

## Source

```gdscript
func _play_page_change_sound() -> void:
	if page_change_sounds.is_empty() or not _page_sound_player:
		return

	var sound := page_change_sounds[randi() % page_change_sounds.size()]
	_page_sound_player.stream = sound
	_page_sound_player.play()
```
