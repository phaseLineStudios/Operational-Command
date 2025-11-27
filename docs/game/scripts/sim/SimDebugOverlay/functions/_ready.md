# SimDebugOverlay::_ready Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 94–122)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Auto-wire references, build caches, connect signals, and set processing.

## Source

```gdscript
func _ready() -> void:
	# Ensure this overlay never blocks mouse/keyboard interaction with the scene
	mouse_filter = MOUSE_FILTER_IGNORE
	# Keep visibility aligned with the master toggle to avoid intercepting events
	visible = debug_enabled
	_terrain_base = terrain_renderer.get_node_or_null("MapMargin/TerrainBase") as Control

	_rebuild_id_index()
	_compute_map_transform()

	if _sim:
		if not _sim.is_connected("unit_updated", Callable(self, "_on_unit_updated")):
			_sim.unit_updated.connect(_on_unit_updated)
		if not _sim.is_connected("engagement_reported", Callable(self, "_on_contact")):
			_sim.engagement_reported.connect(_on_contact)
		if not _sim.is_connected("mission_state_changed", Callable(self, "_on_state")):
			_sim.mission_state_changed.connect(_on_state)
	if _orders:
		_orders.order_applied.connect(_on_order_applied)
		_orders.order_failed.connect(_on_order_failed)
	if terrain_renderer:
		terrain_renderer.connect("resized", Callable(self, "_on_resized"))
		terrain_renderer.connect("map_resize", Callable(self, "_on_resized"))
	if _terrain_base:
		_terrain_base.connect("resized", Callable(self, "_on_resized"))

	set_process(debug_enabled)
```
