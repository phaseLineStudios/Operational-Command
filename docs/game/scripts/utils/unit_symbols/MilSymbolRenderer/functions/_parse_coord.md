# MilSymbolRenderer::_parse_coord Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 262–268)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _parse_coord(coord_str: String) -> Vector2
```

## Description

Parse coordinate from string "x,y"

## Source

```gdscript
func _parse_coord(coord_str: String) -> Vector2:
	var parts := coord_str.split(",")
	if parts.size() >= 2:
		return Vector2(float(parts[0]), float(parts[1]))
	return Vector2.ZERO
```
