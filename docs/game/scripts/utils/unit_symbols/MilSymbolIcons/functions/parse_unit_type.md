# MilSymbolIcons::parse_unit_type Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolIcons.gd` (lines 48–77)</br>
*Belongs to:* [MilSymbolIcons](../../MilSymbolIcons.md)

**Signature**

```gdscript
func parse_unit_type(unit_type: String) -> MilSymbol.UnitType
```

## Description

Parse a simple unit type string to MilSymbol.UnitType

## Source

```gdscript
static func parse_unit_type(unit_type: String) -> MilSymbol.UnitType:
	var lower_type := unit_type.to_lower()

	# Check compound types first (anti-tank, anti-air) before simple types (tank, air)
	if "anti-tank" in lower_type or "anti_tank" in lower_type or "at" == lower_type:
		return MilSymbol.UnitType.ANTI_TANK
	elif "anti-air" in lower_type or "anti_air" in lower_type or "aa" in lower_type:
		return MilSymbol.UnitType.ANTI_AIR
	elif "infantry" in lower_type or "inf" in lower_type:
		return MilSymbol.UnitType.INFANTRY
	elif "armor" in lower_type or "tank" in lower_type:
		return MilSymbol.UnitType.ARMOR
	elif "mech" in lower_type:
		return MilSymbol.UnitType.MECHANIZED
	elif "motor" in lower_type:
		return MilSymbol.UnitType.MOTORIZED
	elif "artillery" in lower_type or "arty" in lower_type:
		return MilSymbol.UnitType.ARTILLERY
	elif "recon" in lower_type or "scout" in lower_type:
		return MilSymbol.UnitType.RECON
	elif "engineer" in lower_type or "eng" in lower_type:
		return MilSymbol.UnitType.ENGINEER
	elif "sup" in lower_type or "supply" in lower_type:
		return MilSymbol.UnitType.SUPPLY
	elif "med" in lower_type or "medical" in lower_type:
		return MilSymbol.UnitType.MEDICAL
	elif "hq" in lower_type or "headquarters" in lower_type:
		return MilSymbol.UnitType.HQ

	return MilSymbol.UnitType.NONE
```
