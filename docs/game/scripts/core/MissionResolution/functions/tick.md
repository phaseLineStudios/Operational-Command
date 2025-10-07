# MissionResolution::tick Function Reference

*Defined at:* `scripts/core/MissionResolution.gd` (lines 51–56)</br>
*Belongs to:* [MissionResolution](../../MissionResolution.md)

**Signature**

```gdscript
func tick(dt: float) -> void
```

## Description

Advance internal timer. Call from mission loop.

## Source

```gdscript
func tick(dt: float) -> void:
	if _is_final:
		return
	_elapsed_s += dt
```
