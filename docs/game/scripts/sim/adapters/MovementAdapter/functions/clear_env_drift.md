# MovementAdapter::clear_env_drift Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 565–573)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func clear_env_drift(_su: ScenarioUnit) -> void
```

## Description

Clear drift vector (placeholder).

## Source

```gdscript
func clear_env_drift(_su: ScenarioUnit) -> void:
	if _su == null:
		return
	if _su.has_meta("env_drift"):
		_su.remove_meta("env_drift")
	if _actor != null and _actor.has_meta("env_drift3"):
		_actor.remove_meta("env_drift3")
```
