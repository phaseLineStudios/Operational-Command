# TimerController::_ready Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 78–113)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	# Setup collision body for button clicks
	_setup_collision()

	# Setup LCD display
	_setup_lcd_display()

	# Find skeleton in children
	_skeleton = _find_skeleton(timer)
	if _skeleton == null:
		push_warning("TimerController: No Skeleton3D found in Timer model")
		return

	# Get bone indices
	_pause_bone_idx = _skeleton.find_bone(pause_button_bone)
	_speed_1x_bone_idx = _skeleton.find_bone(speed_1x_button_bone)
	_speed_2x_bone_idx = _skeleton.find_bone(speed_2x_button_bone)

	if _pause_bone_idx == -1:
		push_warning("TimerController: Bone '%s' not found" % pause_button_bone)
	if _speed_1x_bone_idx == -1:
		push_warning("TimerController: Bone '%s' not found" % speed_1x_button_bone)
	if _speed_2x_bone_idx == -1:
		push_warning("TimerController: Bone '%s' not found" % speed_2x_button_bone)

	# Store rest positions for all buttons
	for bone_idx in [_pause_bone_idx, _speed_1x_bone_idx, _speed_2x_bone_idx]:
		if bone_idx >= 0:
			var pose := _skeleton.get_bone_pose(bone_idx)
			_bone_rest_positions[bone_idx] = pose.origin.y

	# Set initial time scale and button state
	_apply_time_state(_current_state)
	_set_button_pressed(_get_bone_for_state(_current_state))
```
