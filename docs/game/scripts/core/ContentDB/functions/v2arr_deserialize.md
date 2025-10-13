# ContentDB::v2arr_deserialize Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 405–414)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func v2arr_deserialize(a: Variant) -> PackedVector2Array
```

## Description

deserialize PackedVector2Array

## Source

```gdscript
func v2arr_deserialize(a: Variant) -> PackedVector2Array:
	var out := PackedVector2Array()
	if typeof(a) != TYPE_ARRAY:
		return out
	out.resize(a.size())
	for i in a.size():
		out[i] = v2_from(a[i])
	return out
```
