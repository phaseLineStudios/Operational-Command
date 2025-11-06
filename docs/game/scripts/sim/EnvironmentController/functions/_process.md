# EnvironmentController::_process Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 162–175)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func _process(_dt: float) -> void
```

## Source

```gdscript
func _process(_dt: float) -> void:
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
	_update_rotation()
	_update_sky()
	_update_lights()
```
