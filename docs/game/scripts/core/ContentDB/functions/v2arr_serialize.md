# ContentDB::v2arr_serialize Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 397–403)</br>
*Belongs to:* [ContentDB](../ContentDB.md)

**Signature**

```gdscript
func v2arr_serialize(a: PackedVector2Array) -> Array
```

## Description

Serialize PackedVector2Array

## Source

```gdscript
func v2arr_serialize(a: PackedVector2Array) -> Array:
	var out: Array = []
	for p in a:
		out.append(v2(p))
	return out
```
