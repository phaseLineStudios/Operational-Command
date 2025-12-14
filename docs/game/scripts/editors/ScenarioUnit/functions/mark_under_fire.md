# ScenarioUnit::mark_under_fire Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 358–361)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func mark_under_fire() -> void
```

## Description

Mark this unit as being fired upon (called by Combat system)

## Source

```gdscript
func mark_under_fire() -> void:
	last_fired_upon_time = Time.get_ticks_msec() / 1000.0
```
