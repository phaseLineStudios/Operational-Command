# TerrainData::_set_labels Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 200–205)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _set_labels(v) -> void
```

## Source

```gdscript
func _set_labels(v) -> void:
	labels = _ensure_ids(v, "_next_label_id")
	_queue_emit(_pend_labels, "reset", _collect_ids(labels), "labels_changed")
	emit_signal("changed")
```
