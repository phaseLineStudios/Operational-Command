# SubtitleEditor::_format_time Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 123–129)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _format_time(seconds: float) -> String
```

## Source

```gdscript
func _format_time(seconds: float) -> String:
	var mins := int(seconds) / 60
	var secs := int(seconds) % 60
	var millis := int((seconds - int(seconds)) * 1000)
	return "%02d:%02d.%03d" % [mins, secs, millis]
```
