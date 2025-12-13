# SubtitleTrack::deserialize Function Reference

*Defined at:* `scripts/data/SubtitleTrack.gd` (lines 40–45)</br>
*Belongs to:* [SubtitleTrack](../../SubtitleTrack.md)

**Signature**

```gdscript
func deserialize(data: Dictionary) -> void
```

## Description

Deserialize subtitle track from dictionary (for JSON import)

## Source

```gdscript
func deserialize(data: Dictionary) -> void:
	subtitles.clear()
	var subtitle_array: Array = data.get("subtitles", [])
	for subtitle_data in subtitle_array:
		if subtitle_data is Dictionary:
			subtitles.append(Subtitle.deserialize(subtitle_data))
```
