# AIAgent::set_patrol_dwell Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 203–207)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func set_patrol_dwell(seconds: float) -> void
```

## Description

Optional: set patrol dwell time (seconds) if adapter supports it

## Source

```gdscript
func set_patrol_dwell(seconds: float) -> void:
	if _movement != null and _movement.has_method("set_patrol_dwell"):
		_movement.set_patrol_dwell(max(0.0, seconds))
```
