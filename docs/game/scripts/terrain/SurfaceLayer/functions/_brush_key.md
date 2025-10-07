# SurfaceLayer::_brush_key Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 488–493)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _brush_key(brush: TerrainBrush) -> String
```

## Description

Builds a stable key string for grouping surfaces by brush/recipe

## Source

```gdscript
func _brush_key(brush: TerrainBrush) -> String:
	if brush == null:
		return ""
	return brush.resource_path if brush.resource_path != "" else "id:%s" % brush.get_instance_id()
```
