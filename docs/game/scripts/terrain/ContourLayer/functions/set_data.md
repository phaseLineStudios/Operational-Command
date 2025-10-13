# ContourLayer::set_data Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 49–77)</br>
*Belongs to:* [ContourLayer](../../ContourLayer.md)

**Signature**

```gdscript
func set_data(d: TerrainData) -> void
```

## Description

API to set Terrain Data

## Source

```gdscript
func set_data(d: TerrainData) -> void:
	if _data_conn and data and data.is_connected("changed", Callable(self, "_on_data_changed")):
		data.disconnect("changed", Callable(self, "_on_data_changed"))
	if (
		_data_conn_elev
		and data
		and data.has_signal("elevation_changed")
		and data.is_connected("elevation_changed", Callable(self, "_on_elevation_changed"))
	):
		data.disconnect("elevation_changed", Callable(self, "_on_elevation_changed"))
	_data_conn = false
	_data_conn_elev = false

	data = d
	_dirty = true

	if data:
		data.changed.connect(_on_data_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		_data_conn = true
		if data.has_signal("elevation_changed"):
			data.elevation_changed.connect(
				_on_elevation_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED
			)
			_data_conn_elev = true

	_schedule_rebuild()
	queue_redraw()
```
