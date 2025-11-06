# MilSymbolGeometry::get_circle_params Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolGeometry.gd` (lines 113–120)</br>
*Belongs to:* [MilSymbolGeometry](../../MilSymbolGeometry.md)

**Signature**

```gdscript
func get_circle_params(domain: Domain, affiliation: MilSymbol.UnitAffiliation) -> Array
```

## Description

Get circle parameters [center_x, center_y, radius]

## Source

```gdscript
static func get_circle_params(domain: Domain, affiliation: MilSymbol.UnitAffiliation) -> Array:
	if domain == Domain.SEA and affiliation == MilSymbol.UnitAffiliation.FRIEND:
		return [Vector2(100, 100), 60.0]
	if affiliation == MilSymbol.UnitAffiliation.UNKNOWN:
		return [Vector2(100, 100), 70.0]
	return [Vector2(100, 100), 50.0]
```
