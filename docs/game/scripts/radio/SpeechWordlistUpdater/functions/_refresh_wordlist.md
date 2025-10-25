# SpeechWordlistUpdater::_refresh_wordlist Function Reference

*Defined at:* `scripts/radio/WordListUpdater.gd` (lines 48–59)</br>
*Belongs to:* [SpeechWordlistUpdater](../../SpeechWordlistUpdater.md)

**Signature**

```gdscript
func _refresh_wordlist() -> void
```

## Description

Rebuilds the word list from mission callsigns and map labels,
serializes it to JSON, and applies it to the recognizer.

## Source

```gdscript
func _refresh_wordlist() -> void:
	var callsigns := _collect_mission_callsigns()
	var labels := _collect_terrain_labels()

	var words := NARules.build_vosk_word_array(callsigns, labels)
	var json := JSON.stringify(words)

	if recognizer and recognizer.has_method("set_wordlist"):
		recognizer.set_wordlist(json)
		emit_signal("wordlist_updated", words.size())
```
