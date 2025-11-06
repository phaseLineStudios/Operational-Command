# MilSymbolGeometry::get_ground_frame Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolGeometry.gd` (lines 12–28)</br>
*Belongs to:* [MilSymbolGeometry](../../MilSymbolGeometry.md)

**Signature**

```gdscript
func get_ground_frame(affiliation: MilSymbol.UnitAffiliation) -> Array[Vector2]
```

## Description

Get frame points for ground units based on affiliation
Returns an array of Vector2 points in 200x200 coordinate space

## Source

```gdscript
static func get_ground_frame(affiliation: MilSymbol.UnitAffiliation) -> Array[Vector2]:
	match affiliation:
		MilSymbol.UnitAffiliation.FRIEND:
			# Rectangle
			return [Vector2(25, 50), Vector2(175, 50), Vector2(175, 150), Vector2(25, 150)]
		MilSymbol.UnitAffiliation.ENEMY:
			# Diamond
			return [Vector2(100, 28), Vector2(172, 100), Vector2(100, 172), Vector2(28, 100)]
		MilSymbol.UnitAffiliation.NEUTRAL:
			# Square
			return [Vector2(45, 45), Vector2(155, 45), Vector2(155, 155), Vector2(45, 155)]
		MilSymbol.UnitAffiliation.UNKNOWN:
			# Clover (approximated with circle for simplicity)
			return []  # Will use draw_circle instead
	return []
```
