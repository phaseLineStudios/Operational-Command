# EnvBehaviorSystem::_apply_drift Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 369–380)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _apply_drift(unit_id: String, drift: Vector2) -> void
```

## Description

Apply or clear drift metadata on the movement adapter.

## Source

```gdscript
func _apply_drift(unit_id: String, drift: Vector2) -> void:
	if movement_adapter == null:
		return
	var su := _find_unit_by_id(unit_id)
	if su == null:
		return
	if drift == Vector2.ZERO:
		if movement_adapter.has_method("clear_env_drift"):
			movement_adapter.clear_env_drift(su)
	else:
		if movement_adapter.has_method("set_env_drift"):
			movement_adapter.set_env_drift(su, drift)
```
