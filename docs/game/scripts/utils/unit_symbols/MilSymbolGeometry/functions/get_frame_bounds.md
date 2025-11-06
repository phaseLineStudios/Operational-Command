# MilSymbolGeometry::get_frame_bounds Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolGeometry.gd` (lines 72–102)</br>
*Belongs to:* [MilSymbolGeometry](../../MilSymbolGeometry.md)

**Signature**

```gdscript
func get_frame_bounds(domain: Domain, affiliation: MilSymbol.UnitAffiliation) -> Rect2
```

## Description

Get bounding box for a frame (in 200x200 coordinate space)

## Source

```gdscript
static func get_frame_bounds(domain: Domain, affiliation: MilSymbol.UnitAffiliation) -> Rect2:
	match domain:
		Domain.GROUND:
			match affiliation:
				MilSymbol.UnitAffiliation.FRIEND:
					return Rect2(25, 50, 150, 100)
				MilSymbol.UnitAffiliation.ENEMY:
					return Rect2(28, 28, 144, 144)
				MilSymbol.UnitAffiliation.NEUTRAL:
					return Rect2(45, 45, 110, 110)
				MilSymbol.UnitAffiliation.UNKNOWN:
					return Rect2(30, 30, 140, 140)
		Domain.AIR:
			match affiliation:
				MilSymbol.UnitAffiliation.FRIEND:
					return Rect2(45, 30, 110, 120)
				MilSymbol.UnitAffiliation.ENEMY:
					return Rect2(45, 20, 110, 130)
				_:
					return Rect2(45, 30, 110, 120)
		Domain.SEA:
			match affiliation:
				MilSymbol.UnitAffiliation.FRIEND:
					return Rect2(40, 40, 120, 120)
				_:
					return Rect2(45, 45, 110, 110)
		_:
			return Rect2(25, 25, 150, 150)
	return Rect2(25, 25, 150, 150)
```
