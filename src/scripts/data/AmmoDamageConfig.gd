class_name AmmoDamageConfig
extends Resource
## Resource that maps ammo type identifiers to their base damage.

## Dictionary of ammo type -> damage value.
@export var damage_by_type: Dictionary = {}


## Returns the configured damage value for the provided ammo type.
func get_damage_for(ammo_type: String) -> float:
	return float(damage_by_type.get(ammo_type, 0.0))


## Returns the metadata profile for an ammo type (damage, tags, etc.).
func get_profile(ammo_type: String):
	pass


## Returns vehicle-specific damage for the provided ammo type.
func get_vehicle_damage_for(ammo_type: String):
	pass


## Returns true if the ammo type is considered anti-vehicle capable.
func is_anti_vehicle(ammo_type: String):
	pass
