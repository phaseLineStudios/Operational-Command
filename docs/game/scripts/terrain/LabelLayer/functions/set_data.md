# LabelLayer::set_data Function Reference

*Defined at:* `scripts/terrain/LabelLayer.gd` (lines 26–45)</br>
*Belongs to:* [LabelLayer](../LabelLayer.md)

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
		and data.is_connected("labels_changed", Callable(self, "_on_labels_changed"))
	):
		data.disconnect("labels_changed", Callable(self, "_on_labels_changed"))
		_data_conn = false
	data = d
	_items.clear()
	_draw_items.clear()
	_draw_dirty = true
	if data:
		data.labels_changed.connect(
			_on_labels_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED
		)
		_data_conn = true
	queue_redraw()
```
