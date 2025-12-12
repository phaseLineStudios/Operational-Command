# EnvBehaviorSystem::set_navigation_bias Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 77–88)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func set_navigation_bias(unit_id: String, bias: StringName) -> void
```

## Description

Apply navigation bias change request (roads/cover/shortest).

## Source

```gdscript
func set_navigation_bias(unit_id: String, bias: StringName) -> void:
	var nav: UnitNavigationState = _nav_state_by_id.get(unit_id, null)
	if nav == null:
		return
	if nav.navigation_bias == bias:
		return
	nav.set_navigation_bias(bias)
	if movement_adapter and movement_adapter.has_method("set_navigation_bias"):
		movement_adapter.set_navigation_bias(_find_unit_by_id(unit_id), bias)
	emit_signal("navigation_bias_changed", unit_id, bias)
```
