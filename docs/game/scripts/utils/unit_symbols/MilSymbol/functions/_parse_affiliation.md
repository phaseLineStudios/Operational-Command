# MilSymbol::_parse_affiliation Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbol.gd` (lines 316–329)</br>
*Belongs to:* [MilSymbol](../../MilSymbol.md)

**Signature**

```gdscript
func _parse_affiliation(code: String) -> UnitAffiliation
```

## Description

Parse affiliation from string

## Source

```gdscript
func _parse_affiliation(code: String) -> UnitAffiliation:
	match code.to_upper():
		"F", "FRIEND", "FRIENDLY", "BLUE":
			return UnitAffiliation.FRIEND
		"H", "HOSTILE", "ENEMY", "RED":
			return UnitAffiliation.ENEMY
		"N", "NEUTRAL", "GREEN":
			return UnitAffiliation.NEUTRAL
		"U", "UNKNOWN", "YELLOW":
			return UnitAffiliation.UNKNOWN
		_:
			return UnitAffiliation.FRIEND
```
