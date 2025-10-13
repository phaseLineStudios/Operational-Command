# TerrainPolygonTool::build_options_ui Function Reference

*Defined at:* `scripts/editors/tools/TerrainPolygonTool.gd` (lines 39–71)</br>
*Belongs to:* [TerrainPolygonTool](../../TerrainPolygonTool.md)

**Signature**

```gdscript
func build_options_ui(p: Control) -> void
```

## Source

```gdscript
func build_options_ui(p: Control) -> void:
	_load_brushes()

	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	p.add_child(vb)

	vb.add_child(_label("Feature Brush"))

	var list := ItemList.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	list.custom_minimum_size = Vector2(0, 160)

	var map_index := []
	for brush_idx in brushes.size():
		var brush = brushes[brush_idx]
		if brush.feature_type != TerrainBrush.FeatureType.AREA:
			continue
		list.add_item(brush.legend_title)
		map_index.append(brush_idx)

	list.item_selected.connect(
		func(i):
			if i >= 0 and i < map_index.size():
				active_brush = brushes[map_index[i]]
				_rebuild_info_ui()
	)

	vb.add_child(list)
```
