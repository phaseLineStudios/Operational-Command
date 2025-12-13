# AmmoSystem::register_unit Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 44–56)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func register_unit(su: ScenarioUnit) -> void
```

## Description

Register a unit so AmmoSystem tracks it and applies defaults if missing.

## Source

```gdscript
func register_unit(su: ScenarioUnit) -> void:
	_units[su.id] = su

	# Initialize ammunition from equipment if available
	_init_ammunition_from_equipment(su)

	# Apply profile defaults for any missing values
	if ammo_profile:
		ammo_profile.apply_defaults_if_missing(su)

	_logi[su.id] = _is_logistics(su)
```
