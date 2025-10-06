# ContentDB::load_res Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 426–433)</br>
*Belongs to:* [ContentDB](../ContentDB.md)

**Signature**

```gdscript
func load_res(path: Variant) -> Variant
```

## Description

Deserialize a resource

## Source

```gdscript
func load_res(path: Variant) -> Variant:
	if typeof(path) == TYPE_STRING:
		var s := String(path)
		if s != "":
			return load(s)
	return null
```
