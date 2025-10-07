# TerrainData::_queue_emit Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 481–487)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _queue_emit(bucket: Array, kind: String, ids: PackedInt32Array, sig_name: String) -> void
```

## Description

Queue up signal emits

## Source

```gdscript
func _queue_emit(bucket: Array, kind: String, ids: PackedInt32Array, sig_name: String) -> void:
	if _batch_depth > 0:
		bucket.append([kind, ids])
	else:
		emit_signal(sig_name, kind, ids)
```
