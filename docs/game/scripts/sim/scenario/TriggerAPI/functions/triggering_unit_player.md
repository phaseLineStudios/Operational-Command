# TriggerAPI::triggering_unit_player Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 253–257)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func triggering_unit_player() -> String
```

- **Return Value**: First player unit ID in trigger area, or empty string.

## Description

Get the first player-controlled unit ID that triggered this area (convenience method).
Returns empty string if no player units in area.

## Source

```gdscript
func triggering_unit_player() -> String:
	var units := triggering_units_player()
	return units[0] if units.size() > 0 else ""
```
