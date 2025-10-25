# TriggerEngine::tick Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 41–46)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func tick(dt: float) -> void
```

- **dt**: delta time from last tick.

## Description

Deterministic evaluation entry point.

## Source

```gdscript
func tick(dt: float) -> void:
	_refresh_unit_indices()
	for t in _scenario.triggers:
		_evaluate_trigger(t, dt)
```
