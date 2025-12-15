# ForestTerrain::check_rain Function Reference

*Defined at:* `scripts/terrain/environments/ForestTerrain.gd` (lines 30–53)</br>
*Belongs to:* [ForestTerrain](../../ForestTerrain.md)

**Signature**

```gdscript
func check_rain() -> void
```

## Source

```gdscript
func check_rain() -> void:
	if not terrain_mesh or not _scenario:
		LogService.warning("No Terrain Mesh or missing scenario.", "forest_terrain.gd:27")
		return

	var mat = terrain_mesh.get_surface_override_material(0)
	if not mat:
		LogService.warning("No material found on terrain mesh.", "forest_terrain.gd:34")
		return

	if not mat is ShaderMaterial:
		LogService.warning(
			"Material is not a ShaderMaterial: %s" % mat.get_class(), "forest_terrain.gd:40"
		)
		return

	var shader_mat := mat as ShaderMaterial

	if _scenario.rain > 0.0:
		shader_mat.set_shader_parameter("roughness_scale", 0.1)
		print("Set terrain roughness to 0.0 (wet)")
	else:
		shader_mat.set_shader_parameter("roughness_scale", 1.0)
		print("Set terrain roughness to 1.0 (dry)")
```
