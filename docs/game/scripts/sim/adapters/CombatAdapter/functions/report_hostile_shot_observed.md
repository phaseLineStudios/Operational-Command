# CombatAdapter::report_hostile_shot_observed Function Reference

*Defined at:* `scripts/sim/adapters/CombatAdapter.gd` (lines 169–173)</br>
*Belongs to:* [CombatAdapter](../../CombatAdapter.md)

**Signature**

```gdscript
func report_hostile_shot_observed() -> void
```

## Description

External systems call this when the unit observes an enemy firing event.

## Source

```gdscript
func report_hostile_shot_observed() -> void:
	_saw_hostile_shot = true
	_shot_timer = return_fire_window_sec
```
