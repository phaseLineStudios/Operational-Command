# MissionVideo::_process Function Reference

*Defined at:* `scripts/ui/MissionVideo.gd` (lines 43–48)</br>
*Belongs to:* [MissionVideo](../../MissionVideo.md)

**Signature**

```gdscript
func _process(delta: float) -> void
```

## Source

```gdscript
func _process(delta: float) -> void:
	_handle_space_hold(delta)
	_handle_mouse_hide(delta)
	_update_subtitles()
```
