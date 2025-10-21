# PointLayer::set_data Function Reference

*Defined at:* `scripts/terrain/PointLayer.gd` (lines 18–37)</br>
*Belongs to:* [PointLayer](../../PointLayer.md)

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
		and data.is_connected("points_changed", Callable(self, "_on_points_changed"))
	):
		data.disconnect("points_changed", Callable(self, "_on_points_changed"))
		_data_conn = false
	data = d
	_items.clear()
	_draw_items.clear()
	_draw_dirty = true
	if data:
		data.points_changed.connect(
			_on_points_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED
		)
		_data_conn = true
	queue_redraw()
```
