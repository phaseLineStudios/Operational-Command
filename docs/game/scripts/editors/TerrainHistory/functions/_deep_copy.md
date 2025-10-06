# TerrainHistory::_deep_copy Function Reference

*Defined at:* `scripts/editors/TerrainHistory.gd` (lines 187–204)</br>
*Belongs to:* [TerrainHistory](../TerrainHistory.md)

**Signature**

```gdscript
func _deep_copy(x)
```

## Description

Deep copy for dictionaries, arrays, and common packed arrays used in TerrainData.

## Source

```gdscript
static func _deep_copy(x):
	match typeof(x):
		TYPE_DICTIONARY:
			var d := {}
			for k in x.keys():
				d[k] = _deep_copy(x[k])
			return d
		TYPE_ARRAY:
			var a := []
			for v in x:
				a.append(_deep_copy(v))
			return a
		TYPE_PACKED_VECTOR2_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_COLOR_ARRAY:
			return x.duplicate()
		_:
			return x
```
