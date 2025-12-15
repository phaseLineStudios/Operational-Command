# MovementAdapter::request_env_repath Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 576–581)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func request_env_repath(_su: ScenarioUnit) -> void
```

## Description

Request a repath due to environment state change (placeholder).
Flag a repath request; processed on the next tick group.

## Source

```gdscript
func request_env_repath(_su: ScenarioUnit) -> void:
	if _su == null:
		return
	_su.set_meta("env_repath_requested", true)
```
