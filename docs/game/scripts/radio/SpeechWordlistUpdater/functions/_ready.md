# SpeechWordlistUpdater::_ready Function Reference

*Defined at:* `scripts/radio/WordListUpdater.gd` (lines 23–29)</br>
*Belongs to:* [SpeechWordlistUpdater](../../SpeechWordlistUpdater.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Connects mission state change and performs an initial refresh.

## Source

```gdscript
func _ready() -> void:
	if sim and not sim.is_connected("mission_state_changed", Callable(self, "_on_state_changed")):
		sim.mission_state_changed.connect(_on_state_changed)

	_refresh_wordlist()
```
