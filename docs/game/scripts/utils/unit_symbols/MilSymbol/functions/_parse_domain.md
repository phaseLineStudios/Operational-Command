# MilSymbol::_parse_domain Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbol.gd` (lines 336–351)</br>
*Belongs to:* [MilSymbol](../../MilSymbol.md)

**Signature**

```gdscript
func _parse_domain(code: String) -> MilSymbolGeometry.Domain
```

## Description

Parse domain from string

## Source

```gdscript
func _parse_domain(code: String) -> MilSymbolGeometry.Domain:
	match code.to_upper():
		"G", "GROUND", "LAND":
			return MilSymbolGeometry.Domain.GROUND
		"A", "AIR":
			return MilSymbolGeometry.Domain.AIR
		"S", "SEA", "SURFACE":
			return MilSymbolGeometry.Domain.SEA
		"SP", "SPACE":
			return MilSymbolGeometry.Domain.SPACE
		"SS", "SUB", "SUBSURFACE":
			return MilSymbolGeometry.Domain.SUBSURFACE
		_:
			return MilSymbolGeometry.Domain.GROUND
```
