# PointLayer::_find_point_by_id Function Reference

*Defined at:* `scripts/terrain/PointLayer.gd` (lines 221–227)</br>
*Belongs to:* [PointLayer](../PointLayer.md)

**Signature**

```gdscript
func _find_point_by_id(id: int) -> Variant
```

## Description

Find a point dictionary in TerrainData by id

## Source

```gdscript
func _find_point_by_id(id: int) -> Variant:
	if data == null:
		return null
	for s in data.points:
		if s is Dictionary and int(s.get("id", 0)) == id:
			return s
	return null
```
