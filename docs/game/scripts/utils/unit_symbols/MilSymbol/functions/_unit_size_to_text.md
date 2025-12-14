# MilSymbol::_unit_size_to_text Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbol.gd` (lines 353–382)</br>
*Belongs to:* [MilSymbol](../../MilSymbol.md)

**Signature**

```gdscript
func _unit_size_to_text(unit_size: UnitSize) -> String
```

## Description

Convert UnitSize enum to NATO size indicator text

## Source

```gdscript
func _unit_size_to_text(unit_size: UnitSize) -> String:
	match unit_size:
		UnitSize.NONE:
			return ""
		UnitSize.TEAM:
			return "ø"
		UnitSize.SQUAD:
			return "•"
		UnitSize.SECTION:
			return "••"
		UnitSize.PLATOON:
			return "•••"
		UnitSize.COMPANY:
			return "I"
		UnitSize.BATTALION:
			return "II"
		UnitSize.REGIMENT:
			return "III"
		UnitSize.BRIGADE:
			return "X"
		UnitSize.DIVISION:
			return "XX"
		UnitSize.CORPS:
			return "XXX"
		UnitSize.ARMY:
			return "XXXX"
		_:
			return ""
```
