# SubtitleEditor::_refresh_subtitle_list Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 130–144)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _refresh_subtitle_list() -> void
```

## Source

```gdscript
func _refresh_subtitle_list() -> void:
	subtitle_list.clear()
	if not _subtitle_track:
		return

	var subs := _subtitle_track.get_all_subtitles()
	for i in range(subs.size()):
		var sub: Subtitle = subs[i]
		var display := (
			"[%s - %s] %s"
			% [_format_time(sub.start_time), _format_time(sub.end_time), sub.text.substr(0, 50)]
		)
		subtitle_list.add_item(display)
```
