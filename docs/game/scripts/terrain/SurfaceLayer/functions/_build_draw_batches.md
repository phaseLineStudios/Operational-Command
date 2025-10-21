# SurfaceLayer::_build_draw_batches Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 568–588)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _build_draw_batches(sorted_groups: Array) -> Array
```

## Description

Builds draw batches by merging consecutive groups with identical recipes

## Source

```gdscript
func _build_draw_batches(sorted_groups: Array) -> Array:
	var out := []
	var current: Dictionary = {}
	var current_key := ""
	var has_current := false
	for g in sorted_groups:
		var rec: Dictionary = g.rec
		var key := _rec_key(rec)
		if (not has_current) or key != current_key:
			if has_current:
				out.append(current)
			current = {"key": key, "rec": rec, "polys": []}
			current_key = key
			has_current = true
		for p in g.merged:
			current.polys.append(p)
	if has_current:
		out.append(current)
	return out
```
