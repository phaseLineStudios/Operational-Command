# TriggerAPI::triggering_unit_friend Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 237–241)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func triggering_unit_friend() -> String
```

- **Return Value**: First friendly unit ID in trigger area, or empty string.

## Description

Get the first friendly unit ID that triggered this area (convenience method).
Returns empty string if no friendly units in area.

## Source

```gdscript
func triggering_unit_friend() -> String:
	var units := triggering_units_friend()
	return units[0] if units.size() > 0 else ""
```
