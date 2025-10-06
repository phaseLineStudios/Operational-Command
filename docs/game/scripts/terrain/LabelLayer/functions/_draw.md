# LabelLayer::_draw Function Reference

*Defined at:* `scripts/terrain/LabelLayer.gd` (lines 103–120)</br>
*Belongs to:* [LabelLayer](../LabelLayer.md)

**Signature**

```gdscript
func _draw() -> void
```

## Source

```gdscript
func _draw() -> void:
	if data == null or font == null:
		return

	if _items.is_empty() and data.labels and not data.labels.is_empty():
		for s in data.labels:
			if s is Dictionary:
				var id := int(s.get("id", 0))
				if id > 0:
					_upsert_from_data(id)

	if _draw_dirty:
		_rebuild_draw_items()

	for it in _draw_items:
		_draw_label_centered(it.pos, it.text, it.size, it.rot)
```
