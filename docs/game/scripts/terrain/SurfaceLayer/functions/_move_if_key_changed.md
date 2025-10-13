# SurfaceLayer::_move_if_key_changed Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 292–309)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _move_if_key_changed(id: int) -> void
```

## Description

Moves a surface between groups if its brush (draw recipe) changed

## Source

```gdscript
func _move_if_key_changed(id: int) -> void:
	var item: Variant = _find_surface_by_id(id)
	if item == null:
		_remove_id(id)
		return
	var brush: TerrainBrush = item.get("brush", null)
	@warning_ignore("incompatible_ternary")
	var new_key: Variant = _brush_key(brush) if brush else null
	var old_key: Variant = _id_to_key.get(id, null)
	if new_key == null:
		_remove_id(id)
		return
	if old_key == new_key:
		_refresh_geometry_same_group(id)
	else:
		_upsert_from_data(id, true)
```
