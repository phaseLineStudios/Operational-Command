class_name AmmoDamageConfig
extends Resource
## Resource that maps ammo type identifiers to their damage metadata.

const _DEFAULT_PROFILE := {"damage": 0.0, "vehicle_damage": 0.0, "anti_vehicle": false, "tags": []}
const _ANTI_VEHICLE_TAGS := [
	"anti_vehicle", "anti_tank", "antitank", "armor_piercing", "armour_piercing", "ap", "at"
]

## Dictionary of ammo type -> damage data (float or Dictionary).
@export var damage_by_type: Dictionary = {}


## Returns the configured damage value for the provided ammo type.
func get_damage_for(ammo_type: String) -> float:
	return float(get_profile(ammo_type).get("damage", 0.0))


## Returns the metadata profile for an ammo type (damage, tags, etc.).
func get_profile(ammo_type: String) -> Dictionary:
	return _resolve_profile(ammo_type, []).duplicate(true)


## Returns vehicle-specific damage for the provided ammo type.
func get_vehicle_damage_for(ammo_type: String) -> float:
	return float(get_profile(ammo_type).get("vehicle_damage", 0.0))


## Returns true if the ammo type is considered anti-vehicle capable.
func is_anti_vehicle(ammo_type: String) -> bool:
	return bool(get_profile(ammo_type).get("anti_vehicle", false))


## Resolve/normalize a profile, supporting aliases, dictionaries, and scalars.
func _resolve_profile(ammo_type: String, visited: Array) -> Dictionary:
	var key := String(ammo_type)
	if key == "" or visited.has(key):
		return _DEFAULT_PROFILE.duplicate(true)

	var entry: Variant = damage_by_type.get(key, null)
	if entry == null:
		return _DEFAULT_PROFILE.duplicate(true)

	match typeof(entry):
		TYPE_STRING:
			var alias := String(entry)
			var chain := visited.duplicate()
			chain.append(key)
			return _resolve_profile(alias, chain)
		_:
			return _normalize_entry(entry)


## Convert an arbitrary entry into the canonical profile dictionary.
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


## Copy tags into a normalized lowercase string array.
func _normalize_tags(raw_tags: Array) -> Array:
	var tags: Array[String] = []
	for tag in raw_tags:
		var txt := String(tag).to_lower()
		if txt == "":
			continue
		tags.append(txt)
	return tags


## Check if any known anti-vehicle tags were supplied.
func _tags_imply_anti_vehicle(tags: Array) -> bool:
	for t in tags:
		if _ANTI_VEHICLE_TAGS.has(String(t).to_lower()):
			return true
	return false
