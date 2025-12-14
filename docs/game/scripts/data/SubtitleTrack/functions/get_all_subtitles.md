# SubtitleTrack::get_all_subtitles Function Reference

*Defined at:* `scripts/data/SubtitleTrack.gd` (lines 27–30)</br>
*Belongs to:* [SubtitleTrack](../../SubtitleTrack.md)

**Signature**

```gdscript
func get_all_subtitles() -> Array[Subtitle]
```

## Description

Get all subtitles as Subtitle objects

## Source

```gdscript
func get_all_subtitles() -> Array[Subtitle]:
	return subtitles.duplicate()
```
