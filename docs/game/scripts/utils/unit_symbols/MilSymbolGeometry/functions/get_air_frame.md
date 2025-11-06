# MilSymbolGeometry::get_air_frame Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolGeometry.gd` (lines 30–52)</br>
*Belongs to:* [MilSymbolGeometry](../../MilSymbolGeometry.md)

**Signature**

```gdscript
func get_air_frame(affiliation: MilSymbol.UnitAffiliation) -> Array[Vector2]
```

## Description

Get frame points for air units based on affiliation

## Source

```gdscript
static func get_air_frame(affiliation: MilSymbol.UnitAffiliation) -> Array[Vector2]:
	match affiliation:
		MilSymbol.UnitAffiliation.FRIEND:
			# Curved arc (approximated with segments)
			return _create_arc_points(Vector2(100, 100), 60.0, 180.0, 0.0, 32)
		MilSymbol.UnitAffiliation.ENEMY:
			# Chevron
			return [
				Vector2(45, 150),
				Vector2(45, 70),
				Vector2(100, 20),
				Vector2(155, 70),
				Vector2(155, 150)
			]
		MilSymbol.UnitAffiliation.NEUTRAL:
			# Flat top rectangle
			return [Vector2(45, 150), Vector2(45, 30), Vector2(155, 30), Vector2(155, 150)]
		MilSymbol.UnitAffiliation.UNKNOWN:
			# Rounded clover
			return []
	return []
```
