# TerrainData::end_batch Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 84–95)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func end_batch() -> void
```

## Description

End a batch - emits coalesced signals.

## Source

```gdscript
func end_batch() -> void:
	if _batch_depth <= 0:
		return
	_batch_depth -= 1
	if _batch_depth > 0:
		return
	_emit_coalesced(_pend_surfaces, surfaces_changed)
	_emit_coalesced(_pend_lines, lines_changed)
	_emit_coalesced(_pend_points, points_changed)
	_emit_coalesced(_pend_labels, labels_changed)
```
