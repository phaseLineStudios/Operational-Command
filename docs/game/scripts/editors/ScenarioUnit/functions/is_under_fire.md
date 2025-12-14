# ScenarioUnit::is_under_fire Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 364–370)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func is_under_fire() -> bool
```

- **Return Value**: True if recently fired upon, false otherwise

## Description

Check if this unit is currently under fire

## Source

```gdscript
func is_under_fire() -> bool:
	if last_fired_upon_time < 0.0:
		return false
	var now := Time.get_ticks_msec() / 1000.0
	return (now - last_fired_upon_time) <= under_fire_timeout
```
