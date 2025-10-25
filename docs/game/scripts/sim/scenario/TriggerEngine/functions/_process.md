# TriggerEngine::_process Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 28–32)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func _process(dt: float) -> void
```

## Description

Tick triggers independently.

## Source

```gdscript
func _process(dt: float) -> void:
	if run_in_process:
		tick(dt)
```
