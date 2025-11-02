# TTSTest::_on_submit Function Reference

*Defined at:* `scripts/test/TTSTest.gd` (lines 26–35)</br>
*Belongs to:* [TTSTest](../../TTSTest.md)

**Signature**

```gdscript
func _on_submit() -> void
```

## Source

```gdscript
func _on_submit() -> void:
	if not TTSService.is_ready():
		LogService.warning("TTS Service not ready.", "TTSTest.gd:18")
		return

	var ok := TTSService.say(text_input.text.strip_edges())
	if not ok:
		LogService.warning("Failed to send TTS")
```
