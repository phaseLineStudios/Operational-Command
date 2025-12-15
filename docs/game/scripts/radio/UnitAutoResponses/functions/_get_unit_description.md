# UnitAutoResponses::_get_unit_description Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 818–854)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _get_unit_description(unit: ScenarioUnit) -> String
```

- **unit**: Unit data.
- **Return Value**: Description string.

## Description

Get descriptive text for a unit (e.g., "Enemy infantry platoon").

## Source

```gdscript
func _get_unit_description(unit: ScenarioUnit) -> String:
	var affiliation := "Enemy"
	if unit:
		match unit.affiliation:
			0:
				affiliation = "Friendly"
			1:
				affiliation = "Enemy"
			_:
				affiliation = "Unknown"

	var unit_type := "forces"
	if unit and unit.unit.type != -1:
		unit_type = MilSymbol.UnitType.keys()[unit.unit.type]
	elif unit and unit.unit.title != "":
		unit_type = unit.unit.title.to_lower().split(" ")[0]

	var size_str := ""
	if unit:
		match unit.unit.size:
			0:
				size_str = "team"
			1:
				size_str = "squad"
			2:
				size_str = "platoon"
			3:
				size_str = "company"
			4:
				size_str = "battalion"

	if size_str != "":
		return "%s %s %s" % [affiliation, unit_type, size_str]
	else:
		return "%s %s" % [affiliation, unit_type]
```
