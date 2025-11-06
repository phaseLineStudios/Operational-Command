# MilSymbolConfig::get_fill_color Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolConfig.gd` (lines 67–70)</br>
*Belongs to:* [MilSymbolConfig](../../MilSymbolConfig.md)

**Signature**

```gdscript
func get_fill_color(affiliation: MilSymbol.UnitAffiliation) -> Color
```

## Description

Get fill color for MilSymbol.UnitAffiliation

## Source

```gdscript
func get_fill_color(affiliation: MilSymbol.UnitAffiliation) -> Color:
	return fill_colors.get(affiliation, Color.WHITE)
```
