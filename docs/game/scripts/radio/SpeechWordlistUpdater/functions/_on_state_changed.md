# SpeechWordlistUpdater::_on_state_changed Function Reference

*Defined at:* `scripts/radio/WordListUpdater.gd` (lines 41–45)</br>
*Belongs to:* [SpeechWordlistUpdater](../../SpeechWordlistUpdater.md)

**Signature**

```gdscript
func _on_state_changed(_prev, next) -> void
```

- **_prev**: Previous state (unused).
- **next**: New state token or enum string.

## Description

Handles mission state transitions.
Refreshes the word list when the new state string contains "RUN".

## Source

```gdscript
func _on_state_changed(_prev, next) -> void:
	if str(next).findn("RUN") != -1:
		_refresh_wordlist()
```
