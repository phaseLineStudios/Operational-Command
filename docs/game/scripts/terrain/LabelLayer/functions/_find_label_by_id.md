# LabelLayer::_find_label_by_id Function Reference

*Defined at:* `scripts/terrain/LabelLayer.gd` (lines 255–261)</br>
*Belongs to:* [LabelLayer](../LabelLayer.md)

**Signature**

```gdscript
func _find_label_by_id(id: int) -> Variant
```

## Description

Find a label dictionary in TerrainData by id

## Source

```gdscript
func _find_label_by_id(id: int) -> Variant:
	if data == null:
		return null
	for s in data.labels:
		if s is Dictionary and int(s.get("id", 0)) == id:
			return s
	return null
```
