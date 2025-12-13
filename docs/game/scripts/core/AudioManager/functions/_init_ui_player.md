# AudioManager::_init_ui_player Function Reference

*Defined at:* `scripts/core/AudioManager.gd` (lines 30–41)</br>
*Belongs to:* [AudioManager](../../AudioManager.md)

**Signature**

```gdscript
func _init_ui_player() -> void
```

## Description

Initialize the UI sound player with polyphonic stream

## Source

```gdscript
func _init_ui_player() -> void:
	_ui_player = AudioStreamPlayer.new()
	add_child(_ui_player)

	var stream := AudioStreamPolyphonic.new()
	stream.polyphony = UI_POLYPHONY
	_ui_player.stream = stream
	_ui_player.bus = "UI"
	_ui_player.play()
	_ui_playback = _ui_player.get_stream_playback()
```
