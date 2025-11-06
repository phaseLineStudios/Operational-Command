# EnvironmentController::_update_environment Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 141–147)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func _update_environment() -> void
```

## Source

```gdscript
func _update_environment() -> void:
	if env_anchor == null:
		return
	var env := environment_scene.instantiate() as SceneEnvironment
	env_anchor.add_child(env)
```
