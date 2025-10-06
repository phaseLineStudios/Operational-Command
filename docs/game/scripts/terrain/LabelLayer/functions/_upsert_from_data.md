# LabelLayer::_upsert_from_data Function Reference

*Defined at:* `scripts/terrain/LabelLayer.gd` (lines 122–159)</br>
*Belongs to:* [LabelLayer](../LabelLayer.md)

**Signature**

```gdscript
func _upsert_from_data(id: int) -> void
```

## Description

Insert/update a label from TerrainData

## Source

```gdscript
func _upsert_from_data(id: int) -> void:
	var l: Variant = _find_label_by_id(id)
	if l == null:
		_items.erase(id)
		_draw_dirty = true
		return

	var pos: Vector2 = l.get("pos", Vector2.INF)
	if not pos.is_finite():
		_items.erase(id)
		_draw_dirty = true
		return

	var txt: String = String(l.get("text", ""))
	if txt == "":
		_items.erase(id)
		_draw_dirty = true
		return

	var l_size: int = int(l.get("size", 16))
	var z: int = int(l.get("z", 0))
	var rot: float = float(l.get("rot", 0.0))
	var l_visible := _is_terrain_pos_visible(pos)

	var it: Variant = _items.get(
		id, {"pos": pos, "text": txt, "size": l_size, "rot": rot, "z": z, "visible": l_visible}
	)
	it.pos = pos
	it.text = txt
	it.size = l_size
	it.rot = rot
	it.z = z
	it.visible = l_visible

	_items[id] = it
	_draw_dirty = true
```
