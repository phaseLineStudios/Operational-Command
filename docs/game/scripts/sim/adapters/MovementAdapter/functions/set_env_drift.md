# MovementAdapter::set_env_drift Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 547–555)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func set_env_drift(_su: ScenarioUnit, _drift: Vector2) -> void
```

## Description

Apply an external drift vector while lost (placeholder).
Store drift for 2D pathing and mirror to actor for 3D motion.

## Source

```gdscript
func set_env_drift(_su: ScenarioUnit, _drift: Vector2) -> void:
	if _su == null:
		return
	_su.set_meta("env_drift", _drift)
	# Mirror drift into actor metadata for 3D movement if available
	if _actor != null:
		_actor.set_meta("env_drift3", Vector3(_drift.x, 0.0, _drift.y))
```
