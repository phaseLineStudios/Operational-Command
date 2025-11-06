# UnitCounterController::init Function Reference

*Defined at:* `scripts/sim/UnitCounterController.gd` (lines 94–98)</br>
*Belongs to:* [UnitCounterController](../../UnitCounterController.md)

**Signature**

```gdscript
func init(map_mesh: MeshInstance3D, terrain_render: TerrainRender) -> void
```

- **map_mesh**: MeshInstance3D of the map plane
- **terrain_render**: TerrainRender for terrain data

## Description

Initialize references for coordinate conversion.

## Source

```gdscript
func init(map_mesh: MeshInstance3D, terrain_render: TerrainRender) -> void:
	_map_mesh = map_mesh
	_terrain_render = terrain_render
```
