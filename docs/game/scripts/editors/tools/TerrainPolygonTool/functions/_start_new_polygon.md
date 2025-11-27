# TerrainPolygonTool::_start_new_polygon Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 306–327)</br>
*Belongs to:* [TerrainPolygonTool](../../TerrainPolygonTool.md)

**Signature**

```gdscript
func _start_new_polygon() -> void
```

## Description

Start creating a new polygon

## Source

```gdscript
func _start_new_polygon() -> void:
	if data == null:
		return
	if active_brush == null or active_brush.feature_type != TerrainBrush.FeatureType.AREA:
		return
	var pid := _next_id
	_next_id += 1

	var poly := {
		"id": pid,
		"brush": active_brush,
		"type": "polygon",
		"points": PackedVector2Array(),
		"closed": true
	}
	data.add_surface(poly)
	editor.history.push_item_insert(data, "surfaces", poly, "Add polygon", data.surfaces.size())
	_edit_id = pid
	_edit_idx = data.surfaces.size() - 1
	_queue_preview_redraw()
```
