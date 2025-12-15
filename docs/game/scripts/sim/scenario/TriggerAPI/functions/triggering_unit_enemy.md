# TriggerAPI::triggering_unit_enemy Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 245–249)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func triggering_unit_enemy() -> String
```

- **Return Value**: First enemy unit ID in trigger area, or empty string.

## Description

Get the first enemy unit ID that triggered this area (convenience method).
Returns empty string if no enemy units in area.

## Source

```gdscript
func triggering_unit_enemy() -> String:
	var units := triggering_units_enemy()
	return units[0] if units.size() > 0 else ""
```
