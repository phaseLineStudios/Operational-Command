# MilSymbolGeometry::get_sea_frame Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolGeometry.gd` (lines 54–70)</br>
*Belongs to:* [MilSymbolGeometry](../../MilSymbolGeometry.md)

**Signature**

```gdscript
func get_sea_frame(affiliation: MilSymbol.UnitAffiliation) -> Array[Vector2]
```

## Description

Get frame points for sea units based on affiliation

## Source

```gdscript
static func get_sea_frame(affiliation: MilSymbol.UnitAffiliation) -> Array[Vector2]:
	match affiliation:
		MilSymbol.UnitAffiliation.FRIEND:
			# Circle (will use draw_circle)
			return []
		MilSymbol.UnitAffiliation.ENEMY:
			# Diamond
			return get_ground_frame(MilSymbol.UnitAffiliation.ENEMY)
		MilSymbol.UnitAffiliation.NEUTRAL:
			# Square
			return get_ground_frame(MilSymbol.UnitAffiliation.NEUTRAL)
		MilSymbol.UnitAffiliation.UNKNOWN:
			# Clover
			return []
	return []
```
