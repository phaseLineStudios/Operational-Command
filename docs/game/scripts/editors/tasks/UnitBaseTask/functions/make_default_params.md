# UnitBaseTask::make_default_params Function Reference

*Defined at:* `scripts/editors/tasks/UnitBaseTask.gd` (lines 44–51)</br>
*Belongs to:* [UnitBaseTask](../../UnitBaseTask.md)

**Signature**

```gdscript
func make_default_params() -> Dictionary
```

## Description

Default parameter dictionary from exported properties.

## Source

```gdscript
func make_default_params() -> Dictionary:
	var d := {}
	for p in get_configurable_props():
		var n := String(p.name)
		d[n] = get(n)
	return d
```
