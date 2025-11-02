# TTSTest::_on_stream_ready Function Reference

*Defined at:* `scripts/test/TTSTest.gd` (lines 36–39)</br>
*Belongs to:* [TTSTest](../../TTSTest.md)

**Signature**

```gdscript
func _on_stream_ready(stream: AudioStreamGenerator) -> void
```

## Source

```gdscript
func _on_stream_ready(stream: AudioStreamGenerator) -> void:
	radio_player.stream = stream
	radio_player.play()
	TTSService.register_playback(radio_player.get_stream_playback() as AudioStreamGeneratorPlayback)
```
