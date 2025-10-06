# TerrainEffects::_brush_fields Function Reference

*Defined at:* `scripts/sim/TerrainEffects.gd` (lines 155–168)</br>
*Belongs to:* [TerrainEffects](../TerrainEffects.md)

**Signature**

```gdscript
func _brush_fields(renderer: TerrainRender, _terrain: TerrainData, p: Vector2) -> Dictionary
```

## Description

Brush field adapter for either TerrainRender or TerrainData (area features only).

## Source

```gdscript
static func _brush_fields(renderer: TerrainRender, _terrain: TerrainData, p: Vector2) -> Dictionary:
	if renderer != null and renderer.has_method("get_surface_at_terrain_position"):
		var s := renderer.get_surface_at_terrain_position(p)
		if typeof(s) == TYPE_DICTIONARY and s.has("brush"):
			var b: TerrainBrush = s.get("brush")
			if b != null:
				return {
					"cover_reduction": _try_field(b, "cover_reduction"),
					"concealment": _try_field(b, "concealment"),
					"los_attenuation_per_m": _try_field(b, "los_attenuation_per_m")
				}
	return {"cover_reduction": 0.0, "concealment": 0.0, "los_attenuation_per_m": 0.0}
```
