# STTService::_ready Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 29–48)</br>
*Belongs to:* [STTService](../../STTService.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	var bus := AudioServer.get_bus_index(CAPTURE_BUS)
	if bus < 0:
		emit_signal("error", "Audio bus '%s' not found." % CAPTURE_BUS)
		return

	for i in AudioServer.get_bus_effect_count(bus):
		var eff := AudioServer.get_bus_effect(bus, i)
		if eff is AudioEffectCapture:
			_effect = eff
			break
	if _effect == null:
		emit_signal("error", "No AudioEffectCapture on bus '%s'." % CAPTURE_BUS)
		return

	_stt = Vosk.new()
	var wordlist = NARules.get_vosk_grammar_words()
	_stt.init_wordlist(ProjectSettings.globalize_path(LANG_MODEL), wordlist)
```
