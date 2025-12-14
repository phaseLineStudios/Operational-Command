# UnitData Class Reference

*File:* `scripts/data/UnitData.gd`
*Class name:* `UnitData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name UnitData
extends Resource
```

## Brief

Weapon Equipment Ammunition types

Handheld weapons (5.56, 7.62, 9mm etc.)

Heavy crew-served or non-manportable weapons (.50)

20-40mm (IFVs, AAA Guns)

90-125mm MBT main gun ammo

HEAT weapons (M72, RPG-7, etc.)

Guided Anti-Tank Missiles (TOW, MILAN, Konkurs, etc.)

60/81/120 mm mortar (Anti-Personnel)

60/81/120 mm mortar (Smoke)

60/81/120 mm mortar (Flare)

105/122/152/155 mm tube artillery (Anti-Personnel)

105/122/152/155 mm tube artillery (Smoke)

105/122/152/155 mm tube artillery (Flare)

Engineer Munitions: Mines

Engineer Munitions: Demolition charges

Engineer Munitions: Bridge

Ammunition variables

Logistics variables, is part of ammunition and we can add stuff here later, like fuel

Calculates the attack rating using equipment, ammo profiles, and strength.

## Detailed Description

`ammo_damage_config` Optional ammo damage configuration.
`current_strength` Optional current strength override (defaults to full strength).

Calculates the attack contribution for a single weapon entry.

## Public Member Functions

- [`func _init() -> void`](UnitData/functions/_init.md)
- [`func _queue_icon_update() -> void`](UnitData/functions/_queue_icon_update.md) — Schedule an async icon refresh (debounced to next idle message).
- [`func _update_icons_async(rev: int) -> void`](UnitData/functions/_update_icons_async.md) — Build both friend/enemy icons asynchronously.
- [`func serialize() -> Dictionary`](UnitData/functions/serialize.md) — Serialize this unit to JSON
- [`func deserialize(data: Variant) -> UnitData`](UnitData/functions/deserialize.md) — Deserialize Unit JSON
- [`func get_weapon_ammo_types() -> Dictionary`](UnitData/functions/get_weapon_ammo_types.md) — Returns the ammo types referenced by the unit's weapon equipment.
- [`func has_anti_vehicle_weapons() -> bool`](UnitData/functions/has_anti_vehicle_weapons.md) — Returns true when the equipment loadout includes anti-vehicle weapons.
- [`func _is_anti_vehicle_ammo(ammo_type: int) -> bool`](UnitData/functions/_is_anti_vehicle_ammo.md) — Helper to classify a weapon ammo enum index as anti-vehicle capable.
- [`func is_vehicle_unit() -> bool`](UnitData/functions/is_vehicle_unit.md) — Returns true when the unit should be treated as a vehicle target in combat.
- [`func _ensure_ammunition_from_equipment() -> void`](UnitData/functions/_ensure_ammunition_from_equipment.md) — Builds ammunition dictionaries based on equipped weapons when values are missing.
- [`func _get_equipment_category(category_name: String) -> Dictionary`](UnitData/functions/_get_equipment_category.md) — Lookup an equipment category while tolerating mixed-case keys.
- [`func _ammo_index_to_key(idx: int) -> String`](UnitData/functions/_ammo_index_to_key.md) — Convert ammo enum index -> string key ("SMALL_ARMS").
- [`func _ammo_key_to_index(ammo_key: String) -> int`](UnitData/functions/_ammo_key_to_index.md) — Convert ammo key name to enum index.
- [`func _get_ammo_amount(source: Dictionary, ammo_key: String) -> float`](UnitData/functions/_get_ammo_amount.md) — Safely fetch an ammo value from a dictionary that might use string or numeric keys.
- [`func _has_ammo_key(source: Dictionary, ammo_key: String) -> bool`](UnitData/functions/_has_ammo_key.md) — Returns true if the dictionary contains the ammo key as string or enum index.
- [`func _default_ammo_damage(ammo_key: String) -> float`](UnitData/functions/_default_ammo_damage.md) — Fallback damage when no config entry is available.
- [`func _resolve_ammo_index(value: Variant) -> int`](UnitData/functions/_resolve_ammo_index.md) — Normalize mixed ammo representations (string/int) to an enum index.

## Public Attributes

- `String id` — Unique identifier for the unit
- `String title` — Human-readable title of the unit
- `Texture2D icon` — Unit icon texture
- `Texture2D enemy_icon` — Enemy unit icon texture
- `String role` — role for this unit
- `Array[String] allowed_slots` — Allowed slot codes where this unit can be deployed
- `int cost` — Deployment cost in points
- `TerrainBrush.MoveProfile movement_profile` — Movement Profile for navigation
- `MilSymbol.UnitSize size` — Organizational size of the unit
- `MilSymbol.UnitType type` — Organizational size of the unit
- `int strength` — Number of personnel in the unit at full strength
- `bool is_engineer` — Is unit an engineer unit (can repair).
- `bool is_medical` — Is unit a medical unit (can medic injured).
- `Dictionary equipment` — Dictionary of equipment definitions
- `float experience` — Average experience level
- `float attack` — Offensive rating of the unit
- `float defense` — Defensive rating of the unit
- `float spot_m` — Spotting range in meters
- `float range_m` — Effective weapon range in meters
- `float morale` — Morale level (0 = broken, 1 = max)
- `float speed_kph` — Movement speed in kilometers per hour
- `float understrength_threshold` — Per-unit understrength threshold (0.0-1.0)
- `Dictionary throughput` — Supply throughput { "supply_type": (int)amount }
- `Array[String] equipment_tags` — Equipment tag codes associated with this unit [ "AMMO_PALLET" ]
- `String doctrine` — Doctrine code used by the AI for this unit.
- `UnitCategoryData unit_category`
- `Dictionary ammunition` — Ammo capacity per type, e.g.
- `float ammunition_low_threshold` — Ratio (0..1): when `current/capacity <= ammunition_low_threshold` emit "Bingo ammo".
- `float ammunition_critical_threshold` — Ratio (0..1): when `current/capacity <= ammunition_critical_threshold` emit “Ammo critical”.
- `float supply_transfer_rate` — Transfer rate (rounds per second) a logistics unit can push to a recipient in range.
- `float supply_transfer_radius_m` — Transfer radius in meters within which resupply is possible.
- `int _icon_rev`
- `Dictionary weapons`
- `float total_weapon_power`
- `Variant weapon_data`
- `Dictionary weapon_entry`
- `float effective_strength`
- `float ratio`
- `float manpower_component`
- `float computed`
- `float qty`
- `float ammo_ratio`

## Signals

- `signal icons_ready` — Emitted when icons were (re)generated successfully.

## Enumerations

- `enum EquipCategory` — Equipment categories

## Member Function Documentation

### _init

```gdscript
func _init() -> void
```

### _queue_icon_update

```gdscript
func _queue_icon_update() -> void
```

Schedule an async icon refresh (debounced to next idle message).

### _update_icons_async

```gdscript
func _update_icons_async(rev: int) -> void
```

Build both friend/enemy icons asynchronously. Drops stale results.
`rev` Internal version token to ignore out-of-date completions.

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize this unit to JSON

### deserialize

```gdscript
func deserialize(data: Variant) -> UnitData
```

Deserialize Unit JSON

### get_weapon_ammo_types

```gdscript
func get_weapon_ammo_types() -> Dictionary
```

Returns the ammo types referenced by the unit's weapon equipment.

### has_anti_vehicle_weapons

```gdscript
func has_anti_vehicle_weapons() -> bool
```

Returns true when the equipment loadout includes anti-vehicle weapons.

### _is_anti_vehicle_ammo

```gdscript
func _is_anti_vehicle_ammo(ammo_type: int) -> bool
```

Helper to classify a weapon ammo enum index as anti-vehicle capable.

### is_vehicle_unit

```gdscript
func is_vehicle_unit() -> bool
```

Returns true when the unit should be treated as a vehicle target in combat.

### _ensure_ammunition_from_equipment

```gdscript
func _ensure_ammunition_from_equipment() -> void
```

Builds ammunition dictionaries based on equipped weapons when values are missing.

### _get_equipment_category

```gdscript
func _get_equipment_category(category_name: String) -> Dictionary
```

Lookup an equipment category while tolerating mixed-case keys.

### _ammo_index_to_key

```gdscript
func _ammo_index_to_key(idx: int) -> String
```

Convert ammo enum index -> string key ("SMALL_ARMS").

### _ammo_key_to_index

```gdscript
func _ammo_key_to_index(ammo_key: String) -> int
```

Convert ammo key name to enum index.

### _get_ammo_amount

```gdscript
func _get_ammo_amount(source: Dictionary, ammo_key: String) -> float
```

Safely fetch an ammo value from a dictionary that might use string or numeric keys.

### _has_ammo_key

```gdscript
func _has_ammo_key(source: Dictionary, ammo_key: String) -> bool
```

Returns true if the dictionary contains the ammo key as string or enum index.

### _default_ammo_damage

```gdscript
func _default_ammo_damage(ammo_key: String) -> float
```

Fallback damage when no config entry is available.

### _resolve_ammo_index

```gdscript
func _resolve_ammo_index(value: Variant) -> int
```

Normalize mixed ammo representations (string/int) to an enum index.

## Member Data Documentation

### id

```gdscript
var id: String
```

Decorators: `@export`

Unique identifier for the unit

### title

```gdscript
var title: String
```

Decorators: `@export`

Human-readable title of the unit

### icon

```gdscript
var icon: Texture2D
```

Decorators: `@export`

Unit icon texture

### enemy_icon

```gdscript
var enemy_icon: Texture2D
```

Decorators: `@export`

Enemy unit icon texture

### role

```gdscript
var role: String
```

Decorators: `@export`

role for this unit

### allowed_slots

```gdscript
var allowed_slots: Array[String]
```

Decorators: `@export`

Allowed slot codes where this unit can be deployed

### cost

```gdscript
var cost: int
```

Decorators: `@export`

Deployment cost in points

### movement_profile

```gdscript
var movement_profile: TerrainBrush.MoveProfile
```

Decorators: `@export`

Movement Profile for navigation

### size

```gdscript
var size: MilSymbol.UnitSize
```

Decorators: `@export`

Organizational size of the unit

### type

```gdscript
var type: MilSymbol.UnitType
```

Decorators: `@export`

Organizational size of the unit

### strength

```gdscript
var strength: int
```

Decorators: `@export`

Number of personnel in the unit at full strength

### is_engineer

```gdscript
var is_engineer: bool
```

Decorators: `@export`

Is unit an engineer unit (can repair).

### is_medical

```gdscript
var is_medical: bool
```

Decorators: `@export`

Is unit a medical unit (can medic injured).

### equipment

```gdscript
var equipment: Dictionary
```

Decorators: `@export`

Dictionary of equipment definitions

### experience

```gdscript
var experience: float
```

Decorators: `@export`

Average experience level

### attack

```gdscript
var attack: float
```

Decorators: `@export`

Offensive rating of the unit

### defense

```gdscript
var defense: float
```

Decorators: `@export`

Defensive rating of the unit

### spot_m

```gdscript
var spot_m: float
```

Decorators: `@export`

Spotting range in meters

### range_m

```gdscript
var range_m: float
```

Decorators: `@export`

Effective weapon range in meters

### morale

```gdscript
var morale: float
```

Decorators: `@export_range(0.0, 1.0, 0.05)`

Morale level (0 = broken, 1 = max)

### speed_kph

```gdscript
var speed_kph: float
```

Decorators: `@export`

Movement speed in kilometers per hour

### understrength_threshold

```gdscript
var understrength_threshold: float
```

Decorators: `@export`

Per-unit understrength threshold (0.0-1.0)

### throughput

```gdscript
var throughput: Dictionary
```

Decorators: `@export`

Supply throughput { "supply_type": (int)amount }

### equipment_tags

```gdscript
var equipment_tags: Array[String]
```

Decorators: `@export`

Equipment tag codes associated with this unit [ "AMMO_PALLET" ]

### doctrine

```gdscript
var doctrine: String
```

Decorators: `@export`

Doctrine code used by the AI for this unit.

### unit_category

```gdscript
var unit_category: UnitCategoryData
```

### ammunition

```gdscript
var ammunition: Dictionary
```

Decorators: `@export`

Ammo capacity per type, e.g. `{ "small_arms": 30, "he": 10 }`.

### ammunition_low_threshold

```gdscript
var ammunition_low_threshold: float
```

Decorators: `@export_range(0.0, 1.0, 0.01)`

Ratio (0..1): when `current/capacity <= ammunition_low_threshold` emit "Bingo ammo".

### ammunition_critical_threshold

```gdscript
var ammunition_critical_threshold: float
```

Decorators: `@export_range(0.0, 1.0, 0.01)`

Ratio (0..1): when `current/capacity <= ammunition_critical_threshold` emit “Ammo critical”.

### supply_transfer_rate

```gdscript
var supply_transfer_rate: float
```

Decorators: `@export`

Transfer rate (rounds per second) a logistics unit can push to a recipient in range.

### supply_transfer_radius_m

```gdscript
var supply_transfer_radius_m: float
```

Decorators: `@export`

Transfer radius in meters within which resupply is possible.

### _icon_rev

```gdscript
var _icon_rev: int
```

### weapons

```gdscript
var weapons: Dictionary
```

### total_weapon_power

```gdscript
var total_weapon_power: float
```

### weapon_data

```gdscript
var weapon_data: Variant
```

### weapon_entry

```gdscript
var weapon_entry: Dictionary
```

### effective_strength

```gdscript
var effective_strength: float
```

### ratio

```gdscript
var ratio: float
```

### manpower_component

```gdscript
var manpower_component: float
```

### computed

```gdscript
var computed: float
```

### qty

```gdscript
var qty: float
```

### ammo_ratio

```gdscript
var ammo_ratio: float
```

## Signal Documentation

### icons_ready

```gdscript
signal icons_ready
```

Emitted when icons were (re)generated successfully.

## Enumeration Type Documentation

### EquipCategory

```gdscript
enum EquipCategory
```

Equipment categories
