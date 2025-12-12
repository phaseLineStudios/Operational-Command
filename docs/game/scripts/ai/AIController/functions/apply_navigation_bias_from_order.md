# AIController::apply_navigation_bias_from_order Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 565–569)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func apply_navigation_bias_from_order(_unit_id: String, _bias: StringName) -> void
```

## Description

Apply navigation bias intent from orders (placeholder).

## Source

```gdscript
func apply_navigation_bias_from_order(_unit_id: String, _bias: StringName) -> void:
	if _env_behavior_system and _env_behavior_system.has_method("set_navigation_bias"):
		_env_behavior_system.set_navigation_bias(_unit_id, _bias)
```
