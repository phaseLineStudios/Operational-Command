# TimerController::_process Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 145–174)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _process(delta: float) -> void
```

## Source

```gdscript
func _process(delta: float) -> void:
	if _current_state == TimeState.PAUSED:
		pass
	elif _current_state == TimeState.SPEED_1X:
		_sim_elapsed_time += delta
	elif _current_state == TimeState.SPEED_2X:
		_sim_elapsed_time += delta * 2.0

	_update_lcd_display()

	if _skeleton == null:
		return

	for bone_idx in _animating_bones.keys():
		var anim: Dictionary = _animating_bones[bone_idx]
		anim.elapsed += delta

		var t := clampf(anim.elapsed / anim.duration, 0.0, 1.0)
		var eased := 1.0 - pow(1.0 - t, 3.0)

		var current_pose := _skeleton.get_bone_pose(bone_idx)
		var start_y: float = anim.get("start_y", 0.0)
		var target_y: float = anim.target_y
		current_pose.origin.y = lerpf(start_y, target_y, eased)
		_skeleton.set_bone_pose(bone_idx, current_pose)

		if t >= 1.0:
			_animating_bones.erase(bone_idx)
```
