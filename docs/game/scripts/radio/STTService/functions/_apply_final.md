# STTService::_apply_final Function Reference

*Defined at:* `scripts/radio/STTService.gd` (lines 143–149)</br>
*Belongs to:* [STTService](../../STTService.md)

**Signature**

```gdscript
func _apply_final(final_text: String) -> void
```

## Description

Apply a Vosk final by replacing the current partial segment with final text.

## Source

```gdscript
func _apply_final(final_text: String) -> void:
	final_text = final_text.strip_edges()
	_committed = _join_non_empty(_committed, final_text)
	_segment = ""
	_last_partial = ""
```
