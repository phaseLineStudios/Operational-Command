# TerrainData::set_line_style Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 241–248)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func set_line_style(id: int, width_px: float) -> void
```

## Description

Update line style.

## Source

```gdscript
func set_line_style(id: int, width_px: float) -> void:
	var i := _find_by_id(lines, id)
	if i < 0:
		return
	lines[i].width_px = width_px
	_queue_emit(_pend_lines, "style", PackedInt32Array([id]), "lines_changed")
```
