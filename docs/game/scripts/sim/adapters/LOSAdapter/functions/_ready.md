# LOSAdapter::_ready Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 40–58)</br>
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
	var sim: SimWorld
	if simworld_path.is_empty():
		sim = null
	else:
		sim = get_node_or_null(simworld_path)
	if sim:
		sim.contact_reported.connect(_on_contact)
	if los_node_path != NodePath(""):
		_los = get_node(los_node_path)
	if terrain_renderer_path != NodePath(""):
		_renderer = get_node(terrain_renderer_path) as TerrainRender
		_terrain = _renderer.data
	if actor_path.is_empty():
		_actor = get_parent() as Node3D
	else:
		_actor = get_node_or_null(actor_path) as Node3D
```
