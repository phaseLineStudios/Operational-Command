# SubtitleTrack::add_subtitle Function Reference

*Defined at:* `scripts/data/SubtitleTrack.gd` (lines 12–16)</br>
*Belongs to:* [SubtitleTrack](../../SubtitleTrack.md)

**Signature**

```gdscript
func add_subtitle(start: float, end: float, text: String) -> void
```

## Description

Add a subtitle entry

## Source

```gdscript
func add_subtitle(start: float, end: float, text: String) -> void:
	var subtitle := Subtitle.new(start, end, text)
	subtitles.append(subtitle)
```
