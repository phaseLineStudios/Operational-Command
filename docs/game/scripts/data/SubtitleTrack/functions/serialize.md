# SubtitleTrack::serialize Function Reference

*Defined at:* `scripts/data/SubtitleTrack.gd` (lines 32–38)</br>
*Belongs to:* [SubtitleTrack](../../SubtitleTrack.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serialize subtitle track to dictionary (for JSON export)

## Source

```gdscript
func serialize() -> Dictionary:
	var subtitle_dicts: Array = []
	for subtitle in subtitles:
		subtitle_dicts.append(subtitle.serialize())
	return {"subtitles": subtitle_dicts}
```
