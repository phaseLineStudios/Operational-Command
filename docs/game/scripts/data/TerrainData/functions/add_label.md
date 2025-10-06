# TerrainData::add_label Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 296–302)</br>
*Belongs to:* [TerrainData](../TerrainData.md)

**Signature**

```gdscript
func add_label(lab: Dictionary) -> int
```

## Description

Add a new label. Returns the assigned id

## Source

```gdscript
func add_label(lab: Dictionary) -> int:
	var id := _ensure_id_on_item(lab, "_next_label_id")
	labels.append(lab)
	_queue_emit(_pend_labels, "added", PackedInt32Array([id]), "labels_changed")
	return id
```
