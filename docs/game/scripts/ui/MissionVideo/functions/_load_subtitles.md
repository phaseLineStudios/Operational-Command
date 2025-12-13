# MissionVideo::_load_subtitles Function Reference

*Defined at:* `scripts/ui/MissionVideo.gd` (lines 100–104)</br>
*Belongs to:* [MissionVideo](../../MissionVideo.md)

**Signature**

```gdscript
func _load_subtitles() -> void
```

## Source

```gdscript
func _load_subtitles() -> void:
	if Game.current_scenario.video_subtitles:
		_subtitle_track = Game.current_scenario.video_subtitles
```
