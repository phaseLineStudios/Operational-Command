# AmmoDamageConfig::_tags_imply_anti_vehicle Function Reference

*Defined at:* `scripts/data/AmmoDamageConfig.gd` (lines 108–112)</br>
*Belongs to:* [AmmoDamageConfig](../../AmmoDamageConfig.md)

**Signature**

```gdscript
func _tags_imply_anti_vehicle(tags: Array) -> bool
```

## Description

Check if any known anti-vehicle tags were supplied.

## Source

```gdscript
func _tags_imply_anti_vehicle(tags: Array) -> bool:
	for t in tags:
		if _ANTI_VEHICLE_TAGS.has(String(t).to_lower()):
			return true
	return false
```
