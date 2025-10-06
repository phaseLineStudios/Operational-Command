# TerrainElevationTool::_smooth01 Function Reference

*Defined at:* `scripts/editors/tools/TerrainElevationTool.gd` (lines 221–225)</br>
*Belongs to:* [TerrainElevationTool](../TerrainElevationTool.md)

**Signature**

```gdscript
func _smooth01(x: float) -> float
```

## Description

Helper for smooth fade

## Source

```gdscript
func _smooth01(x: float) -> float:
	var t: float = clamp(x, 0.0, 1.0)
	return t * t * (3.0 - 2.0 * t)
```
