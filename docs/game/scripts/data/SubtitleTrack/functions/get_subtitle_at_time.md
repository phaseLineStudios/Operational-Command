# SubtitleTrack::get_subtitle_at_time Function Reference

*Defined at:* `scripts/data/SubtitleTrack.gd` (lines 18–25)</br>
*Belongs to:* [SubtitleTrack](../../SubtitleTrack.md)

**Signature**

```gdscript
func get_subtitle_at_time(time: float) -> String
```

## Description

Get subtitle at specific time position

## Source

```gdscript
func get_subtitle_at_time(time: float) -> String:
	for subtitle in subtitles:
		if time >= subtitle.start_time and time <= subtitle.end_time:
			return subtitle.text

	return ""
```
