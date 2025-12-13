# EnvironmentController::_process Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 253–276)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func _process(dt: float) -> void
```

## Source

```gdscript
func _process(dt: float) -> void:
	if sun_moon_parent == null:
		return
	if sun_root == null:
		return
	if sun == null:
		return
	if moon_root == null:
		return
	if moon == null:
		return

	# Only update environment every UPDATE_INTERVAL seconds to avoid expensive per-frame updates
	_last_update_time += dt
	if _last_update_time >= UPDATE_INTERVAL:
		_update_rotation()
		_update_sky()
		_update_lights()
		_last_update_time = 0.0

	if not env_scene:
		_update_environment()
```
