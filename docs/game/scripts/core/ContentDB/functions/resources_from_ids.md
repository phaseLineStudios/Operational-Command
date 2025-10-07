# ContentDB::resources_from_ids Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 464–475)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func resources_from_ids(ids: Array, loader: Callable) -> Array
```

## Description

Deserialize resources from IDs

## Source

```gdscript
func resources_from_ids(ids: Array, loader: Callable) -> Array:
	var out: Array = []
	if typeof(ids) != TYPE_ARRAY:
		return out
	for raw in ids:
		var id_str := String(raw)
		var res: Variant = loader.call(id_str)
		if res != null:
			out.append(res)
	return out
```
