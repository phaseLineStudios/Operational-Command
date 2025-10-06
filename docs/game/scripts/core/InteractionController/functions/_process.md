# InteractionController::_process Function Reference

*Defined at:* `scripts/core/PlayerInteraction.gd` (lines 63–85)</br>
*Belongs to:* [InteractionController](../InteractionController.md)

**Signature**

```gdscript
func _process(delta: float) -> void
```

## Source

```gdscript
func _process(delta: float) -> void:
	if _held == null:
		return

	if _held.is_inspecting():
		return

	var pos: Variant = _project_mouse_to_finite_plane(get_viewport().get_mouse_position())
	if pos != null:
		_last_valid_plane_point = pos
		_have_valid_plane_point = true

	if _have_valid_plane_point:
		var world_offset := _held.global_transform.basis * _grab_offset_local
		var target := _last_valid_plane_point - world_offset
		if follow_smooth > 0.0:
			_held.global_transform.origin = _held.global_transform.origin.lerp(
				target, clamp(follow_smooth * delta, 0.0, 1.0)
			)
		else:
			_held.global_transform.origin = target
```
