# ContentDB::ids_from_resources Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 454–463)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func ids_from_resources(arr: Array, id_prop: String = "id") -> Array
```

## Description

Serialize resources to IDs

## Source

```gdscript
func ids_from_resources(arr: Array, id_prop: String = "id") -> Array:
	var out: Array = []
	for r in arr:
		if r != null and r.has_method("get"):
			var rid = r.get(id_prop)
			if rid != null and String(rid) != "":
				out.append(String(rid))
	return out
```
