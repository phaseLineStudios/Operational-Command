class_name AmmoDamageConfig
extends Resource
## Resource that maps ammo type identifiers to their base damage.

## Dictionary of ammo type -> damage value.
@export var damage_by_type: Dictionary = {}


## Returns the configured damage value for the provided ammo type.
func get_damage_for(ammo_type: String) -> float:
	return float(damage_by_type.get(ammo_type, 0.0))
