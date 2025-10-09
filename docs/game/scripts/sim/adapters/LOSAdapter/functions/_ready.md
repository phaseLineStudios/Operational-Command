# LOSAdapter::_ready Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 24–31)</br>
*Belongs to:* [LOSAdapter](../../LOSAdapter.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Autowires LOS helper and terrain renderer from exported paths.

## Source

```gdscript
func _ready() -> void:
	if los_node_path != NodePath(""):
		_los = get_node(los_node_path)
	if terrain_renderer_path != NodePath(""):
		_renderer = get_node(terrain_renderer_path) as TerrainRender
		_terrain = _renderer.data
```
