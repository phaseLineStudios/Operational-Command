# LOSAdapter::_ready Function Reference

*Defined at:* `scripts/sim/adapters/LOSAdapter.gd` (lines 43–65)</br>
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
	var sim: SimWorld = null
	if not simworld_path.is_empty():
		sim = get_node_or_null(simworld_path) as SimWorld
	if sim == null:
		sim = _find_simworld()
	if sim and not sim.is_connected("contact_reported", Callable(self, "_on_contact")):
		sim.contact_reported.connect(_on_contact)
	if los_node_path != NodePath(""):
		_los = get_node(los_node_path)
	if terrain_renderer_path != NodePath(""):
		_renderer = get_node(terrain_renderer_path) as TerrainRender
		_terrain = _renderer.data

	var scan_enabled: bool = (
		sim == null and not actor_path.is_empty() and String(hostiles_group_name) != ""
	)
	set_process(scan_enabled)
	if scan_enabled:
		_actor = get_node_or_null(actor_path) as Node3D
		_scan_accum = proximity_scan_interval_sec
```
