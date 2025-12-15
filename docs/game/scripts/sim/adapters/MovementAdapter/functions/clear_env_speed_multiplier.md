# MovementAdapter::clear_env_speed_multiplier Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 546–552)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func clear_env_speed_multiplier(_su: ScenarioUnit) -> void
```

## Description

Clear environment speed multiplier (placeholder).

## Source

```gdscript
func clear_env_speed_multiplier(_su: ScenarioUnit) -> void:
	if _su == null:
		return
	if _su.has_meta("env_speed_mult"):
		_su.remove_meta("env_speed_mult")
```
