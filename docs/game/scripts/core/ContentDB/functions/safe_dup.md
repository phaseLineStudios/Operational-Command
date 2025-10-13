# ContentDB::safe_dup Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 477–484)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func safe_dup(v: Variant) -> Variant
```

## Description

Safely duplicate a dictionary or array

## Source

```gdscript
func safe_dup(v: Variant) -> Variant:
	match typeof(v):
		TYPE_DICTIONARY:
			return (v as Dictionary).duplicate(true)
		TYPE_ARRAY:
			return (v as Array).duplicate(true)
		_:
			return v
```
