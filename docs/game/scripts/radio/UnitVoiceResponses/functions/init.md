# UnitVoiceResponses::init Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 85–90)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func init(id_index: Dictionary, world: Node, terrain_renderer: Node = null) -> void
```

- **id_index**: Dictionary String->ScenarioUnit (by unit id).
- **world**: Reference to SimWorld for contact data.
- **terrain_renderer**: Reference to TerrainRender for grid conversions.

## Description

Initialize with references to units and simulation world.

## Source

```gdscript
func init(id_index: Dictionary, world: Node, terrain_renderer: Node = null) -> void:
	units_by_id = id_index
	sim_world = world
	terrain_render = terrain_renderer
```
