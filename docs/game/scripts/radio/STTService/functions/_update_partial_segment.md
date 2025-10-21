# STTService::_update_partial_segment Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 122–141)</br>
*Belongs to:* [STTService](../../STTService.md)

**Signature**

```gdscript
func _update_partial_segment(partial_text: String) -> void
```

## Description

Update the current segment with a new partial.

## Source

```gdscript
func _update_partial_segment(partial_text: String) -> void:
	partial_text = partial_text.strip_edges()
	if partial_text == _last_partial:
		return

	# Grow by suffix when possible; otherwise replace the segment (Vosk rewrites).
	if _last_partial != "" and partial_text.begins_with(_last_partial):
		var suffix := partial_text.substr(_last_partial.length()).strip_edges()
		if suffix.length() > 0:
			if _segment.length() == 0:
				_segment = suffix
			else:
				_segment += (" " if not _segment.ends_with(" ") else "") + suffix
	else:
		# Rewrite: drop previous segment and use the new partial as the entire segment.
		_segment = partial_text

	_last_partial = partial_text
```
