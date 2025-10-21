# TerrainData::remove_label Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 323–330)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func remove_label(id: int) -> void
```

## Description

Remove label by id

## Source

```gdscript
func remove_label(id: int) -> void:
	var i := _find_by_id(labels, id)
	if i < 0:
		return
	labels.remove_at(i)
	_queue_emit(_pend_labels, "removed", PackedInt32Array([id]), "labels_changed")
```
