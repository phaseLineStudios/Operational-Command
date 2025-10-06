# TerrainData::add_line Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 224–230)</br>
*Belongs to:* [TerrainData](../TerrainData.md)

**Signature**

```gdscript
func add_line(l: Dictionary) -> int
```

## Description

Add a new line. Returns the assigned id.

## Source

```gdscript
func add_line(l: Dictionary) -> int:
	var id := _ensure_id_on_item(l, "_next_line_id")
	lines.append(l)
	_queue_emit(_pend_lines, "added", PackedInt32Array([id]), "lines_changed")
	return id
```
