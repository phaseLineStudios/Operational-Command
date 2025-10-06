# SurfaceLayer::set_data Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 35–59)</br>
*Belongs to:* [SurfaceLayer](../SurfaceLayer.md)

**Signature**

```gdscript
func set_data(d: TerrainData) -> void
```

## Description

Assigns TerrainData, resets caches, wires signals, and schedules redraw

## Source

```gdscript
func set_data(d: TerrainData) -> void:
	if (
		_data_conn
		and data
		and data.is_connected("surfaces_changed", Callable(self, "_on_surfaces_changed"))
	):
		data.disconnect("surfaces_changed", Callable(self, "_on_surfaces_changed"))
		_data_conn = false

	data = d
	_dirty_all = true
	_groups.clear()
	_id_to_key.clear()
	_tri_cache.clear()
	_cancel_all_threads()

	if data:
		data.surfaces_changed.connect(
			_on_surfaces_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED
		)
		_data_conn = true

	queue_redraw()
```
