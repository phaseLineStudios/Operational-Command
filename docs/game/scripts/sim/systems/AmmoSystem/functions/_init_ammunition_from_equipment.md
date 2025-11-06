# AmmoSystem::_init_ammunition_from_equipment Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 270–334)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func _init_ammunition_from_equipment(u: UnitData) -> void
```

- **u**: UnitData to initialize

## Description

Initialize ammunition capacities from equipment.
Scans equipment.weapons and calculates ammo capacity for each AmmoTypes.

## Source

```gdscript
func _init_ammunition_from_equipment(u: UnitData) -> void:
	if not u.equipment or not u.equipment.has("weapons"):
		return

	var weapons: Dictionary = u.equipment.get("weapons", {})
	if weapons.is_empty():
		return

	# Map AmmoTypes enum to ammo type string keys
	const AMMO_TYPE_KEYS := [
		"SMALL_ARMS",  # 0
		"HEAVY_WEAPONS",  # 1
		"AUTOCANNON",  # 2
		"TANK_GUN",  # 3
		"AT_ROCKET",  # 4
		"ATGM",  # 5
		"MORTAR_AP",  # 6
		"MORTAR_SMOKE",  # 7
		"MORTAR_ILLUM",  # 8
		"ARTILLERY_AP",  # 9
		"ARTILLERY_SMOKE",  # 10
		"ARTILLERY_ILLUM",  # 11
		"ENGINEER_MUN"  # 12
	]

	# Calculate ammo capacity for each type based on equipment
	var ammo_caps: Dictionary = {}
	for weapon_name in weapons.keys():
		var weapon_data: Dictionary = weapons[weapon_name]
		var ammo_type_index: int = int(weapon_data.get("ammo", -1))
		var quantity: int = int(weapon_data.get("type", 0))

		# Skip if no ammo type or quantity
		if ammo_type_index < 0 or ammo_type_index >= AMMO_TYPE_KEYS.size():
			continue
		if quantity <= 0:
			continue

		var ammo_key: String = AMMO_TYPE_KEYS[ammo_type_index]

		# Sum up quantities for this ammo type
		if not ammo_caps.has(ammo_key):
			ammo_caps[ammo_key] = 0
		ammo_caps[ammo_key] += quantity

	# Only update ammunition if we found any weapon equipment
	if not ammo_caps.is_empty():
		# Initialize ammunition dict if empty
		if u.ammunition.is_empty():
			u.ammunition = {}

		# Initialize state_ammunition dict if empty
		if u.state_ammunition.is_empty():
			u.state_ammunition = {}

		# Set capacities from equipment
		for ammo_key in ammo_caps.keys():
			u.ammunition[ammo_key] = ammo_caps[ammo_key]
			# Set current state to full capacity if not already set
			if not u.state_ammunition.has(ammo_key):
				u.state_ammunition[ammo_key] = ammo_caps[ammo_key]

		LogService.debug(
			"Initialized ammo from equipment for %s: %s" % [u.id, str(ammo_caps)], "AmmoSystem.gd"
		)
```
