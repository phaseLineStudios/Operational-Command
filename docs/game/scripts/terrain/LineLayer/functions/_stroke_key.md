# LineLayer::_stroke_key Function Reference

*Defined at:* `scripts/terrain/LineLayer.gd` (lines 336–339)</br>
*Belongs to:* [LineLayer](../LineLayer.md)

**Signature**

```gdscript
func _stroke_key(mode: int, color: Color, width: float, z: int, dash: float, gap: float) -> String
```

## Description

Stable key for batching strokes that share draw state

## Source

```gdscript
func _stroke_key(mode: int, color: Color, width: float, z: int, dash: float, gap: float) -> String:
	return "%d|%s|%.3f|%d|%.3f|%.3f" % [mode, color.to_html(), width, z, dash, gap]
```
