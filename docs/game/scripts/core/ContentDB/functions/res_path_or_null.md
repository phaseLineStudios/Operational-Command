# ContentDB::res_path_or_null Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 416–425)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func res_path_or_null(res: Variant) -> Variant
```

## Description

serialize a resource

## Source

```gdscript
func res_path_or_null(res: Variant) -> Variant:
	if typeof(res) == TYPE_STRING:
		var s := String(res)
		@warning_ignore("incompatible_ternary")
		return s if s != "" else null
	if res is Resource and String(res.resource_path) != "":
		return res.resource_path
	return null
```
