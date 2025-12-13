# MissionVideo::_update_subtitles Function Reference

*Defined at:* `scripts/ui/MissionVideo.gd` (lines 105–123)</br>
*Belongs to:* [MissionVideo](../../MissionVideo.md)

**Signature**

```gdscript
func _update_subtitles() -> void
```

## Source

```gdscript
func _update_subtitles() -> void:
	if _subtitle_track == null:
		subtitles_lbl.text = ""
		return

	if not _video_started:
		if player.is_playing() and player.stream_position > 0.0:
			_video_started = true
		else:
			subtitles_lbl.text = ""
			return

	if not player.is_playing():
		subtitles_lbl.text = ""
		return

	var current_time := player.stream_position
	var subtitle_text := _subtitle_track.get_subtitle_at_time(current_time)
	subtitles_lbl.text = subtitle_text
```
