# AmmoDamageConfig::_normalize_tags Function Reference

*Defined at:* `scripts/data/AmmoDamageConfig.gd` (lines 97–106)</br>
*Belongs to:* [AmmoDamageConfig](../../AmmoDamageConfig.md)

**Signature**

```gdscript
func _normalize_tags(raw_tags: Array) -> Array
```

## Description

Copy tags into a normalized lowercase string array.

## Source

```gdscript
func _normalize_tags(raw_tags: Array) -> Array:
	var tags: Array[String] = []
	for tag in raw_tags:
		var txt := String(tag).to_lower()
		if txt == "":
			continue
		tags.append(txt)
	return tags
```
