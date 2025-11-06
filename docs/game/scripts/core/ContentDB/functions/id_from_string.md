# ContentDB::id_from_string Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 542–546)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func id_from_string(string: String) -> String
```

- **string**: String to generate ID from.

## Description

Generate ID from string

## Source

```gdscript
func id_from_string(string: String) -> String:
	var cleaned := string.to_lower().replace(" ", "_")
	return cleaned
```
