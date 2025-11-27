# AmmoDamageConfig Class Reference

*File:* `scripts/data/AmmoDamageConfig.gd`
*Class name:* `AmmoDamageConfig`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name AmmoDamageConfig
extends Resource
```

## Brief

Resource that maps ammo type identifiers to their damage metadata.

## Public Member Functions

- [`func get_damage_for(ammo_type: String) -> float`](AmmoDamageConfig/functions/get_damage_for.md) — Returns the configured damage value for the provided ammo type.
- [`func get_profile(ammo_type: String) -> Dictionary`](AmmoDamageConfig/functions/get_profile.md) — Returns the metadata profile for an ammo type (damage, tags, etc.).
- [`func get_vehicle_damage_for(ammo_type: String) -> float`](AmmoDamageConfig/functions/get_vehicle_damage_for.md) — Returns vehicle-specific damage for the provided ammo type.
- [`func is_anti_vehicle(ammo_type: String) -> bool`](AmmoDamageConfig/functions/is_anti_vehicle.md) — Returns true if the ammo type is considered anti-vehicle capable.
- [`func _resolve_profile(ammo_type: String, visited: Array) -> Dictionary`](AmmoDamageConfig/functions/_resolve_profile.md) — Resolve/normalize a profile, supporting aliases, dictionaries, and scalars.
- [`func _normalize_entry(entry: Variant) -> Dictionary`](AmmoDamageConfig/functions/_normalize_entry.md) — Convert an arbitrary entry into the canonical profile dictionary.
- [`func _normalize_tags(raw_tags: Array) -> Array`](AmmoDamageConfig/functions/_normalize_tags.md) — Copy tags into a normalized lowercase string array.
- [`func _tags_imply_anti_vehicle(tags: Array) -> bool`](AmmoDamageConfig/functions/_tags_imply_anti_vehicle.md) — Check if any known anti-vehicle tags were supplied.

## Public Attributes

- `Dictionary damage_by_type` — Dictionary of ammo type -> damage data (float or Dictionary).

## Member Function Documentation

### get_damage_for

```gdscript
func get_damage_for(ammo_type: String) -> float
```

Returns the configured damage value for the provided ammo type.

### get_profile

```gdscript
func get_profile(ammo_type: String) -> Dictionary
```

Returns the metadata profile for an ammo type (damage, tags, etc.).

### get_vehicle_damage_for

```gdscript
func get_vehicle_damage_for(ammo_type: String) -> float
```

Returns vehicle-specific damage for the provided ammo type.

### is_anti_vehicle

```gdscript
func is_anti_vehicle(ammo_type: String) -> bool
```

Returns true if the ammo type is considered anti-vehicle capable.

### _resolve_profile

```gdscript
func _resolve_profile(ammo_type: String, visited: Array) -> Dictionary
```

Resolve/normalize a profile, supporting aliases, dictionaries, and scalars.

### _normalize_entry

```gdscript
func _normalize_entry(entry: Variant) -> Dictionary
```

Convert an arbitrary entry into the canonical profile dictionary.

### _normalize_tags

```gdscript
func _normalize_tags(raw_tags: Array) -> Array
```

Copy tags into a normalized lowercase string array.

### _tags_imply_anti_vehicle

```gdscript
func _tags_imply_anti_vehicle(tags: Array) -> bool
```

Check if any known anti-vehicle tags were supplied.

## Member Data Documentation

### damage_by_type

```gdscript
var damage_by_type: Dictionary
```

Decorators: `@export`

Dictionary of ammo type -> damage data (float or Dictionary).
