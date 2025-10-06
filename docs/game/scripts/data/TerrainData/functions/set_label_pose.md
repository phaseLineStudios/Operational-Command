# TerrainData::set_label_pose Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 304–312)</br>
*Belongs to:* [TerrainData](../TerrainData.md)

**Signature**

```gdscript
func set_label_pose(id: int, pos: Vector2, rot: float) -> void
```

## Description

Update labels transform by id

## Source

```gdscript
func set_label_pose(id: int, pos: Vector2, rot: float) -> void:
	var i := _find_by_id(labels, id)
	if i < 0:
		return
	labels[i].pos = pos
	labels[i].rot = rot
	_queue_emit(_pend_labels, "move", PackedInt32Array([id]), "labels_changed")
```
