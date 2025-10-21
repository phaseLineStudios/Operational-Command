# TerrainData::remove_line Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 259–266)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func remove_line(id: int) -> void
```

## Description

Remove line by id.

## Source

```gdscript
func remove_line(id: int) -> void:
	var i := _find_by_id(lines, id)
	if i < 0:
		return
	lines.remove_at(i)
	_queue_emit(_pend_lines, "removed", PackedInt32Array([id]), "lines_changed")
```
