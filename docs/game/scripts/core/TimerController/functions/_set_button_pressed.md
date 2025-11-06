# TimerController::_set_button_pressed Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 261–279)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _set_button_pressed(bone_idx: int) -> void
```

## Description

Set a button to pressed state (depressed and stays down).

## Source

```gdscript
func _set_button_pressed(bone_idx: int) -> void:
	if _skeleton == null or bone_idx < 0:
		return

	var current_pose := _skeleton.get_bone_pose(bone_idx)
	var start_y := current_pose.origin.y
	var rest_y: float = _bone_rest_positions.get(bone_idx, 0.0)

	# Animate to pressed position
	_animating_bones[bone_idx] = {
		"start_y": start_y,
		"target_y": rest_y - press_depth,
		"duration": press_duration,
		"elapsed": 0.0
	}

	_current_pressed_bone = bone_idx
```
