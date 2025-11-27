# AmmoSystem::register_unit Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 42–54)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func register_unit(u: UnitData) -> void
```

## Description

Register a unit so AmmoSystem tracks it and applies defaults if missing.

## Source

```gdscript
func register_unit(u: UnitData) -> void:
	_units[u.id] = u

	# Initialize ammunition from equipment if available
	_init_ammunition_from_equipment(u)

	# Apply profile defaults for any missing values
	if ammo_profile:
		ammo_profile.apply_defaults_if_missing(u)

	_logi[u.id] = _is_logistics(u)
```
