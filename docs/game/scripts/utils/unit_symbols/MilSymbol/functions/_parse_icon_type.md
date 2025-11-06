# MilSymbol::_parse_icon_type Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbol.gd` (lines 245–248)</br>
*Belongs to:* [MilSymbol](../../MilSymbol.md)

**Signature**

```gdscript
func _parse_icon_type(code: String) -> UnitType
```

## Description

Parse icon type from string

## Source

```gdscript
func _parse_icon_type(code: String) -> UnitType:
	return MilSymbolIcons.parse_unit_type(code)
```
