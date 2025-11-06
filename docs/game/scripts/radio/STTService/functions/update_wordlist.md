# STTService::update_wordlist Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 193–199)</br>
*Belongs to:* [STTService](../../STTService.md)

**Signature**

```gdscript
func update_wordlist(callsigns: Array[String] = [], labels: Array[String] = []) -> void
```

- **callsigns**: Mission callsigns override.
- **labels**: Mission-specific label texts.

## Description

Update the recognizer's grammar word list at runtime.
Called by SimWorld after mission-specific custom commands are registered.

## Source

```gdscript
func update_wordlist(callsigns: Array[String] = [], labels: Array[String] = []) -> void:
	if _stt == null:
		push_warning("STTService: Cannot update wordlist, recognizer not initialized")
		return
	var wordlist := NARules.get_vosk_grammar_words(callsigns, labels)
	_stt.set_wordlist(wordlist)
	LogService.info("Updated STT grammar wordlist", "STTService.gd")
```
