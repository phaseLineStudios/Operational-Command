# MovementAdapter::set_env_speed_multiplier Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 531–536)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func set_env_speed_multiplier(_su: ScenarioUnit, _mult: float) -> void
```

## Description

Set an external environment speed multiplier for a unit (placeholder).

## Source

```gdscript
func set_env_speed_multiplier(_su: ScenarioUnit, _mult: float) -> void:
	if _su == null:
		return
	_su.set_meta("env_speed_mult", float(_mult))
```
