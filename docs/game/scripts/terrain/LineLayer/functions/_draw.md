# LineLayer::_draw Function Reference

*Defined at:* `scripts/terrain/LineLayer.gd` (lines 77–108)</br>
*Belongs to:* [LineLayer](../../LineLayer.md)

**Signature**

```gdscript
func _draw() -> void
```

## Source

```gdscript
func _draw() -> void:
	if data == null:
		return
	if _items.is_empty() and data.lines and not data.lines.is_empty():
		for s in data.lines:
			if s is Dictionary and s.get("type", "") != "polygon":
				var id := int(s.get("id", 0))
				if id > 0:
					_upsert_from_data(id, true)

	if _strokes_dirty:
		_rebuild_stroke_batches()

	for stroke in _strokes:
		if stroke.color.a <= 0.0:
			continue
		if stroke.width <= 0.0:
			continue
		for chain in stroke.chains:
			match stroke.mode:
				TerrainBrush.DrawMode.SOLID:
					_draw_polyline_solid(chain, stroke.color, stroke.width)
				TerrainBrush.DrawMode.DASHED:
					_draw_polyline_dashed(
						chain, stroke.color, stroke.width, stroke.dash, stroke.gap
					)
				TerrainBrush.DrawMode.DOTTED:
					_draw_polyline_dotted(chain, stroke.color, stroke.width, max(2.0, stroke.gap))
				_:
					_draw_polyline_solid(chain, stroke.color, stroke.width)
```
