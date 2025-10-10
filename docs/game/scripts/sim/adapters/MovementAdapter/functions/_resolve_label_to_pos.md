# MovementAdapter::_resolve_label_to_pos Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 107–127)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _resolve_label_to_pos(label_text: String, origin_m: Vector2 = Vector2.INF) -> Variant
```

- **label_text**: Label string to look up.
- **origin_m**: Optional origin (unit position) for tie-breaking.
- **Return Value**: Vector2 position if found, otherwise null.

## Description

Resolves a label phrase to a terrain position in meters.
When multiple labels share the same text, picks the closest to origin.

## Source

```gdscript
func _resolve_label_to_pos(label_text: String, origin_m: Vector2 = Vector2.INF) -> Variant:
	if not enable_label_destinations:
		return null
	var key := _norm_label(label_text)
	if not _labels.has(key):
		return null
	var arr: Array = _labels[key]
	if arr.is_empty():
		return null
	if origin_m.is_finite():
		var best: Vector2 = arr[0]
		var best_d := best.distance_to(origin_m)
		for p in arr:
			var d := (p as Vector2).distance_to(origin_m)
			if d < best_d:
				best = p
				best_d = d
		return best
	return arr[0]
```
