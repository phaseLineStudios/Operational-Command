# UnitCounterController::_ready Function Reference

*Defined at:* `scripts/sim/UnitCounterController.gd` (lines 22–37)</br>
*Belongs to:* [UnitCounterController](../../UnitCounterController.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	## Ensure the drawer can receive ray-pick input, then wire its input signal.
	if drawer:
		# Required for 3D picking; also ensure the drawer is on some collision layer.
		drawer.input_ray_pickable = true
		# Connect the physics input signal emitted when this body is clicked/hovered.
		drawer.input_event.connect(_on_drawer_input_event)
	else:
		push_warning("unitCounterController: 'drawer' is not assigned.")

	if counter_dialog:
		counter_dialog.counter_create_requested.connect(_on_counter_create_requested)
	else:
		push_warning("unitCounterController: 'counter_dialog' is not assigned.")
```
