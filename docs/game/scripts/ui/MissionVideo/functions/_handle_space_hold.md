# MissionVideo::_handle_space_hold Function Reference

*Defined at:* `scripts/ui/MissionVideo.gd` (lines 49–62)</br>
*Belongs to:* [MissionVideo](../../MissionVideo.md)

**Signature**

```gdscript
func _handle_space_hold(delta: float) -> void
```

## Source

```gdscript
func _handle_space_hold(delta: float) -> void:
	if Input.is_action_pressed("ptt"):
		_space_hold_time += delta
		hold_progress.value = _space_hold_time
		hold_progress.visible = true

		if _space_hold_time >= HOLD_TO_SKIP_DURATION:
			_on_skip_pressed()
	else:
		_space_hold_time = 0.0
		hold_progress.value = 0.0
		hold_progress.visible = false
```
