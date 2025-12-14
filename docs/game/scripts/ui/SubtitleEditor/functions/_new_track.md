# SubtitleEditor::_new_track Function Reference

*Defined at:* `scripts/ui/SubtitleEditor.gd` (lines 88–93)</br>
*Belongs to:* [SubtitleEditor](../../SubtitleEditor.md)

**Signature**

```gdscript
func _new_track() -> void
```

## Source

```gdscript
func _new_track() -> void:
	_subtitle_track = SubtitleTrack.new()
	_refresh_subtitle_list()
	_clear_editor()
```
