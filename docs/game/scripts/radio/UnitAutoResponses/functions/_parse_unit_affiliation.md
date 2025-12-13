# UnitAutoResponses::_parse_unit_affiliation Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 789–798)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _parse_unit_affiliation(aff: ScenarioUnit.Affiliation) -> MilSymbol.UnitAffiliation
```

- **aff**: `enum ScenarioUnit.Affiliation` to parse.
- **Return Value**: parsed `enum MilSymbol.UnitAffiliation`.

## Description

parses `enum ScenarioUnit.Affiliation` to `enum MilSymbol.UnitAffiliation`.

## Source

```gdscript
func _parse_unit_affiliation(aff: ScenarioUnit.Affiliation) -> MilSymbol.UnitAffiliation:
	match aff:
		0:
			return MilSymbol.UnitAffiliation.FRIEND
		1:
			return MilSymbol.UnitAffiliation.ENEMY
		_:
			return MilSymbol.UnitAffiliation.UNKNOWN
```

## References

- [`enum ScenarioUnit.Affiliation`](../../../editors/ScenarioUnit.md#affiliation)
- [`enum MilSymbol.UnitAffiliation`](../../../utils/unit_symbols/MilSymbol.md#unitaffiliation)
