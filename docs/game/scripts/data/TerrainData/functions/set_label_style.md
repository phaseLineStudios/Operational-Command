# TerrainData::set_label_style Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 320–327)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func set_label_style(id: int, size: int) -> void
```

## Description

Update labelstyle or metadata by id

## Source

```gdscript
func set_label_style(id: int, size: int) -> void:
	var i := _find_by_id(labels, id)
	if i < 0:
		return
	labels[i].size = size
	_queue_emit(_pend_labels, "style", PackedInt32Array([id]), "labels_changed")
```
