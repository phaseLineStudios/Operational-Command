# RadioFeedback::_on_parse_error Function Reference

*Defined at:* `scripts/radio/RadioFeedback.gd` (lines 129–132)</br>
*Belongs to:* [RadioFeedback](../../RadioFeedback.md)

**Signature**

```gdscript
func _on_parse_error(error: String) -> void
```

## Description

Order parser signaled an error (e.g., invalid command). Plays a short error sound.

## Source

```gdscript
func _on_parse_error(error: String) -> void:
	LogService.error("error: %s, playing audio..." % error, "RadioFeedback")
	if error_player:
		error_player.play()
```
