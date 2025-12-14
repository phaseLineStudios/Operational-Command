# MapController::_bind_terrain_signals Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 329–376)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _bind_terrain_signals(d: TerrainData) -> void
```

## Description

Bind/unbind TerrainData signals so map refresh works in UPDATE_DISABLED mode.

## Source

```gdscript
func _bind_terrain_signals(d: TerrainData) -> void:
	if _terrain_data == d:
		return

	if _terrain_data:
		if _terrain_data.is_connected("changed", Callable(self, "_on_terrain_changed")):
			_terrain_data.disconnect("changed", Callable(self, "_on_terrain_changed"))
		if _terrain_data.is_connected(
			"elevation_changed", Callable(self, "_on_terrain_elevation_changed")
		):
			_terrain_data.disconnect(
				"elevation_changed", Callable(self, "_on_terrain_elevation_changed")
			)
		if _terrain_data.is_connected(
			"surfaces_changed", Callable(self, "_on_terrain_content_changed")
		):
			_terrain_data.disconnect(
				"surfaces_changed", Callable(self, "_on_terrain_content_changed")
			)
		if _terrain_data.is_connected(
			"lines_changed", Callable(self, "_on_terrain_content_changed")
		):
			_terrain_data.disconnect("lines_changed", Callable(self, "_on_terrain_content_changed"))
		if _terrain_data.is_connected(
			"points_changed", Callable(self, "_on_terrain_content_changed")
		):
			_terrain_data.disconnect(
				"points_changed", Callable(self, "_on_terrain_content_changed")
			)
		if _terrain_data.is_connected(
			"labels_changed", Callable(self, "_on_terrain_content_changed")
		):
			_terrain_data.disconnect(
				"labels_changed", Callable(self, "_on_terrain_content_changed")
			)

	_terrain_data = d
	if _terrain_data == null:
		return

	_terrain_data.changed.connect(_on_terrain_changed, CONNECT_DEFERRED)
	_terrain_data.elevation_changed.connect(_on_terrain_elevation_changed, CONNECT_DEFERRED)
	_terrain_data.surfaces_changed.connect(_on_terrain_content_changed, CONNECT_DEFERRED)
	_terrain_data.lines_changed.connect(_on_terrain_content_changed, CONNECT_DEFERRED)
	_terrain_data.points_changed.connect(_on_terrain_content_changed, CONNECT_DEFERRED)
	_terrain_data.labels_changed.connect(_on_terrain_content_changed, CONNECT_DEFERRED)
```
