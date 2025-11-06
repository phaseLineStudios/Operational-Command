# MilSymbolConfig::get_frame_color Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolConfig.gd` (lines 72–75)</br>
*Belongs to:* [MilSymbolConfig](../../MilSymbolConfig.md)

**Signature**

```gdscript
func get_frame_color(affiliation: MilSymbol.UnitAffiliation) -> Color
```

## Description

Get frame color for MilSymbol.UnitAffiliation

## Source

```gdscript
func get_frame_color(affiliation: MilSymbol.UnitAffiliation) -> Color:
	return frame_colors.get(affiliation, Color.BLACK)
```
