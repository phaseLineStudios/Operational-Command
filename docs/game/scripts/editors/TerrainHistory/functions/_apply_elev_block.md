# TerrainHistory::_apply_elev_block Function Reference

*Defined at:* `scripts/editors/TerrainHistory.gd` (lines 171–176)</br>
*Belongs to:* [TerrainHistory](../TerrainHistory.md)

**Signature**

```gdscript
func _apply_elev_block(data: TerrainData, rect: Rect2i, block: PackedFloat32Array) -> void
```

## Description

Apply an elevation block via TerrainData API and emit change.

## Source

```gdscript
func _apply_elev_block(data: TerrainData, rect: Rect2i, block: PackedFloat32Array) -> void:
	if data and data.has_method("set_elevation_block"):
		data.set_elevation_block(rect, block)
	_emit_changed(data)
```
