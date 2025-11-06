# MilSymbolGeometry::is_circle_frame Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolGeometry.gd` (lines 104–111)</br>
*Belongs to:* [MilSymbolGeometry](../../MilSymbolGeometry.md)

**Signature**

```gdscript
func is_circle_frame(domain: Domain, affiliation: MilSymbol.UnitAffiliation) -> bool
```

## Description

Check if frame should use circle drawing

## Source

```gdscript
static func is_circle_frame(domain: Domain, affiliation: MilSymbol.UnitAffiliation) -> bool:
	if domain == Domain.SEA and affiliation == MilSymbol.UnitAffiliation.FRIEND:
		return true
	if affiliation == MilSymbol.UnitAffiliation.UNKNOWN:
		return true  # Simplified clover as circle
	return false
```
