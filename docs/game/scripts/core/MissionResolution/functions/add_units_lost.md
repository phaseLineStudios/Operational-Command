# MissionResolution::add_units_lost Function Reference

*Defined at:* `scripts/core/MissionResolution.gd` (lines 85–92)</br>
*Belongs to:* [MissionResolution](../../MissionResolution.md)

**Signature**

```gdscript
func add_units_lost(count: int = 1) -> void
```

## Description

Record fully destroyed friendly unit(s) (e.g., wiped marker).

## Source

```gdscript
func add_units_lost(count: int = 1) -> void:
	if _is_final:
		return
	_units_lost += max(count, 0)
	_recompute_score()
	LogService.trace("Updated lost units", "MissionResolution.gd:84")
```
