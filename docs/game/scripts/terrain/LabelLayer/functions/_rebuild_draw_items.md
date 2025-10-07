# LabelLayer::_rebuild_draw_items Function Reference

*Defined at:* `scripts/terrain/LabelLayer.gd` (lines 185–198)</br>
*Belongs to:* [LabelLayer](../../LabelLayer.md)

**Signature**

```gdscript
func _rebuild_draw_items() -> void
```

## Description

Build sorted list from cache

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
		if it.visible and it.text != "":
			tmp.append(it)
	tmp.sort_custom(func(a, b): return int(a.z) < int(b.z))
	_draw_items = tmp
```
