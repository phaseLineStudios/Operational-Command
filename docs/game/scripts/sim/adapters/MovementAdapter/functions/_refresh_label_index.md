# MovementAdapter::_refresh_label_index Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 46–63)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _refresh_label_index() -> void
```

## Description

Rebuilds the label lookup from TerrainData.labels.
Stores: normalized_text -> Array[Vector2] (terrain meters).

## Source

```gdscript
func _refresh_label_index() -> void:
	_labels.clear()
	if not enable_label_destinations:
		return
	if renderer == null or renderer.data == null:
		return
	var labels := renderer.data.labels
	for label in labels:
		var txt := str(label.get("text", "")).strip_edges()
		var pos: Vector2 = label.get("pos", null)
		if txt == "" or typeof(pos) != TYPE_VECTOR2:
			continue
		var key := _norm_label(txt)
		if not _labels.has(key):
			_labels[key] = []
		_labels[key].append(pos)
```
