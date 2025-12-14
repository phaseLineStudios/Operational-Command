# TimerController::_release_button Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 280–294)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _release_button(bone_idx: int) -> void
```

## Description

Release a button (animate back to rest position).

## Source

```gdscript
func _release_button(bone_idx: int) -> void:
	if _skeleton == null or bone_idx < 0:
		return

	var current_pose := _skeleton.get_bone_pose(bone_idx)
	var start_y := current_pose.origin.y
	var rest_y: float = _bone_rest_positions.get(bone_idx, 0.0)

	_animating_bones[bone_idx] = {
		"start_y": start_y, "target_y": rest_y, "duration": press_duration, "elapsed": 0.0
	}

	_play_button_release_sound()
```
