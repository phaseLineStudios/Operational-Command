# RadioFeedback::_on_parse_error Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 62–65)</br>
*Belongs to:* [RadioFeedback](../RadioFeedback.md)

**Signature**

```gdscript
func _on_parse_error(error: String) -> void
```

## Description

Order parser signaled an error (e.g., invalid command). Play a short error sound.

## Source

```gdscript
func _on_parse_error(error: String) -> void:
	LogService.error("error: %s, playing audio..." % error, "RadioFeedback.gd:11")
	if error_player:
		error_player.play()
```
