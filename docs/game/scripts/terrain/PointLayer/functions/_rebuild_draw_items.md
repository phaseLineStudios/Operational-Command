# PointLayer::_rebuild_draw_items Function Reference

*Defined at:* `scripts/terrain/PointLayer.gd` (lines 193–212)</br>
*Belongs to:* [PointLayer](../../PointLayer.md)

**Signature**

```gdscript
func _rebuild_draw_items() -> void
```

## Description

Build/refresh array used by _draw(), sorted by z

## Source

```gdscript
func _rebuild_draw_items() -> void:
	_draw_dirty = false
	_draw_items.clear()
	if _items.is_empty():
		return

	var tmp := []
	for id in _items.keys():
		var it = _items[id]
		if it.visible and it.tex != null:
			tmp.append(it)

	tmp.sort_custom(
		func(a, b):
			return (str(a.tex) < str(b.tex)) if (int(a.z) == int(b.z)) else (int(a.z) < int(b.z))
	)

	_draw_items = tmp
```
