# TerrainRender::_debounce_relayout_and_push Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 228–240)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func _debounce_relayout_and_push() -> void
```

## Description

Debounce the relayout and push styles

## Source

```gdscript
func _debounce_relayout_and_push() -> void:
	if _debounce_timer:
		return
	_debounce_timer = get_tree().create_timer(0.03)
	_debounce_timer.timeout.connect(
		func():
			_debounce_timer = null
			_draw_map_size()
			_push_data_to_layers()
			_rebuild_surface_spatial_index()
	)
```
