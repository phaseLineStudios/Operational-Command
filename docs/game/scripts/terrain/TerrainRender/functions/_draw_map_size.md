# TerrainRender::_draw_map_size Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 242–253)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func _draw_map_size() -> void
```

## Description

Resize the map to fit the terrain data

## Source

```gdscript
func _draw_map_size() -> void:
	if data == null:
		return
	if margin:
		var base_size := data.get_size()
		var margins := Vector2(margin_left_px + margin_right_px, margin_top_px + margin_bottom_px)
		var total := base_size + margins
		margin.size = total
		size = margin.size
	queue_redraw()
```
