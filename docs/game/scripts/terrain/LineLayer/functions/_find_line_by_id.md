# LineLayer::_find_line_by_id Function Reference

*Defined at:* `scripts/terrain/LineLayer.gd` (lines 341–347)</br>
*Belongs to:* [LineLayer](../../LineLayer.md)

**Signature**

```gdscript
func _find_line_by_id(id: int) -> Variant
```

## Description

Find a line dictionary in TerrainData by id

## Source

```gdscript
func _find_line_by_id(id: int) -> Variant:
	if data == null:
		return null
	for s in data.lines:
		if s is Dictionary and int(s.get("id", 0)) == id:
			return s
	return null
```
