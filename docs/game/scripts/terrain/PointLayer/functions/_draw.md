# PointLayer::_draw Function Reference

*Defined at:* `scripts/terrain/PointLayer.gd` (lines 77–104)</br>
*Belongs to:* [PointLayer](../PointLayer.md)

**Signature**

```gdscript
func _draw() -> void
```

## Source

```gdscript
func _draw() -> void:
	if data == null:
		return

	if _items.is_empty() and data.points and not data.points.is_empty():
		for s in data.points:
			if s is Dictionary:
				var id := int(s.get("id", 0))
				if id > 0:
					_upsert_from_data(id, true)

	if _draw_dirty:
		_rebuild_draw_items()

	for it in _draw_items:
		var pos_local: Vector2 = it.pos
		var tex: Texture2D = it.tex
		var sc: float = it.size
		var rot := deg_to_rad(float(it.rot))

		var half := Vector2(sc, sc) * 0.5
		var rect := Rect2(-half, Vector2(sc, sc))

		draw_set_transform(pos_local, rot, Vector2.ONE)
		draw_texture_rect(tex, rect, false)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
```
