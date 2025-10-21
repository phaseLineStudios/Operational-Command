# TerrainData::_set_lines Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 170–175)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _set_lines(v) -> void
```

## Source

```gdscript
func _set_lines(v) -> void:
	lines = _ensure_ids(v, "_next_line_id")
	_queue_emit(_pend_lines, "reset", _collect_ids(lines), "lines_changed")
	emit_signal("changed")
```
