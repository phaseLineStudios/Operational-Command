# SurfaceLayer::_sorted_groups Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 327–334)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _sorted_groups() -> Array
```

## Description

Returns groups sorted by z-index

## Source

```gdscript
func _sorted_groups() -> Array:
	var arr: Array = []
	for key in _groups.keys():
		arr.append(_groups[key])
	arr.sort_custom(func(a, b): return int(a.z) < int(b.z))
	return arr
```
