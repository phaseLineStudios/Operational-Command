# TimerController::_setup_collision Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 124–144)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _setup_collision() -> void
```

## Description

Setup collision body for button click detection.

## Source

```gdscript
func _setup_collision() -> void:
	if timer == null:
		push_warning("TimerController: Timer reference not set")
		return

	var static_body := StaticBody3D.new()
	static_body.collision_layer = button_mask
	static_body.collision_mask = 0
	timer.add_child(static_body)

	var collision_shape := CollisionShape3D.new()
	var box_shape := BoxShape3D.new()
	box_shape.size = collision_box_size
	collision_shape.shape = box_shape
	collision_shape.position = collision_box_position
	static_body.add_child(collision_shape)

	if debug_draw_collision:
		_setup_debug_draw(static_body)
```
