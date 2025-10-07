# LineLayer::set_data Function Reference

*Defined at:* `scripts/terrain/LineLayer.gd` (lines 20–37)</br>
*Belongs to:* [LineLayer](../../LineLayer.md)

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
		and data.is_connected("lines_changed", Callable(self, "_on_lines_changed"))
	):
		data.disconnect("lines_changed", Callable(self, "_on_lines_changed"))
		_data_conn = false
	data = d
	_items.clear()
	_strokes.clear()
	_strokes_dirty = true
	if data:
		data.lines_changed.connect(_on_lines_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		_data_conn = true
	queue_redraw()
```
