# AmmoDamageConfig::_normalize_entry Function Reference

*Defined at:* `scripts/data/AmmoDamageConfig.gd` (lines 55–95)</br>
*Belongs to:* [AmmoDamageConfig](../../AmmoDamageConfig.md)

**Signature**

```gdscript
func _normalize_entry(entry: Variant) -> Dictionary
```

## Description

Convert an arbitrary entry into the canonical profile dictionary.

## Source

```gdscript
func _normalize_entry(entry: Variant) -> Dictionary:
	var profile: Dictionary = _DEFAULT_PROFILE.duplicate(true)
	match typeof(entry):
		TYPE_DICTIONARY:
			profile["damage"] = float(entry.get("damage", profile.get("damage", 0.0)))
			profile["vehicle_damage"] = float(
				entry.get(
					"vehicle_damage", entry.get("armor_damage", profile.get("vehicle_damage", 0.0))
				)
			)
			profile["anti_vehicle"] = bool(
				entry.get(
					"anti_vehicle", entry.get("is_anti_vehicle", profile.get("anti_vehicle", false))
				)
			)
			var tags: Variant = entry.get("tags", null)
			if typeof(tags) == TYPE_ARRAY:
				profile["tags"] = _normalize_tags(tags)
			if (
				not bool(profile.get("anti_vehicle", false))
				and _tags_imply_anti_vehicle(profile.get("tags", []))
			):
				profile["anti_vehicle"] = true
		TYPE_FLOAT, TYPE_INT:
			var dmg := float(entry)
			profile["damage"] = dmg
			profile["vehicle_damage"] = dmg
		TYPE_ARRAY:
			var arr: Array = entry
			if arr.size() > 0:
				profile["damage"] = float(arr[0])
			if arr.size() > 1:
				profile["vehicle_damage"] = float(arr[1])
			if arr.size() > 2:
				profile["anti_vehicle"] = bool(arr[2])
		_:
			pass

	return profile
```
