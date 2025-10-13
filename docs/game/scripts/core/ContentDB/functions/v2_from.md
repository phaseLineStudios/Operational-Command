# ContentDB::v2_from Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 388–395)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func v2_from(d: Variant) -> Vector2
```

## Description

Deserialize Vector2

## Source

```gdscript
func v2_from(d: Variant) -> Vector2:
	if typeof(d) == TYPE_DICTIONARY and d.has("x") and d.has("y"):
		return Vector2(float(d["x"]), float(d["y"]))
	if typeof(d) == TYPE_ARRAY and d.size() >= 2:
		return Vector2(float(d[0]), float(d[1]))
	return Vector2.ZERO
```
