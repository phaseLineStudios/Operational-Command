# TimerController::_get_closest_button_bone Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 212–237)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _get_closest_button_bone(local_pos: Vector3) -> int
```

## Description

Find which button bone is closest to the click position.

## Source

```gdscript
func _get_closest_button_bone(local_pos: Vector3) -> int:
	if _skeleton == null:
		return -1

	var closest_bone := -1
	var closest_dist := INF

	for bone_idx in [_pause_bone_idx, _speed_1x_bone_idx, _speed_2x_bone_idx]:
		if bone_idx < 0:
			continue

		var bone_pose := _skeleton.get_bone_global_pose(bone_idx)
		var bone_world_pos := _skeleton.global_transform * bone_pose.origin
		var bone_local_pos := timer.to_local(bone_world_pos)

		var dist := local_pos.distance_to(bone_local_pos)
		if dist < closest_dist:
			closest_dist = dist
			closest_bone = bone_idx

	if closest_dist > 0.05:
		return -1

	return closest_bone
```
