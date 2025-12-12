# EnvBehaviorSystem::_request_repath Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 350–360)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _request_repath(unit_id: String) -> void
```

## Description

Ask movement adapter to rebuild the path for a unit.

## Source

```gdscript
func _request_repath(unit_id: String) -> void:
	if movement_adapter == null:
		return
	if not movement_adapter.has_method("request_env_repath"):
		return
	var su := _find_unit_by_id(unit_id)
	if su == null:
		return
	movement_adapter.request_env_repath(su)
```
