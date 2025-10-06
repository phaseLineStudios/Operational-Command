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

Unique identifier for the unit

Human-readable title of the unit

Current strength

Current injured

Current remaining equipment

Current cohesion level (0.0–1.0).

## Detailed Description

Ammunition variables

Logistics variables, is part of ammunition and we can add stuff here later, like fuel

## Public Member Functions

- [`func serialize() -> Dictionary`](UnitData/functions/serialize.md) — Serialize this unit to JSON
- [`func deserialize(data: Variant) -> UnitData`](UnitData/functions/deserialize.md) — Deserialize Unit JSON

## Public Attributes

- `String id`
- `String title`
- `Texture2D icon` — Unit icon texture
- `Texture2D enemy_icon` — Enemy unit icon texture
- `String role` — role for this unit
- `Array[String] allowed_slots` — Allowed slot codes where this unit can be deployed
- `int cost` — Deployment cost in points
- `TerrainBrush.MoveProfile movement_profile` — Movement Profile for navigation
- `UnitSize size` — Organizational size of the unit
- `int strength` — Number of personnel in the unit at full strength
- `Dictionary equipment` — Dictionary of equipment definitions
- `float experience` — Average experience level
- `float attack` — Offensive rating of the unit
- `float defense` — Defensive rating of the unit
- `float spot_m` — Spotting range in meters
- `float range_m` — Effective weapon range in meters
- `float morale` — Morale level (0 = broken, 1 = max)
- `float speed_kph` — Movement speed in kilometers per hour
- `float state_strength`
- `float state_injured`
- `float state_equipment`
- `float cohesion`
- `Dictionary throughput` — Supply throughput { "supply_type": (int)amount }
- `Array[String] equipment_tags` — Equipment tag codes associated with this unit [ "AMMO_PALLET" ]
- `String doctrine` — Doctrine code used by the AI for this unit.
- `UnitCategoryData unit_category`
- `Dictionary ammunition` — Ammo capacity per type, e.g.
- `Dictionary state_ammunition` — Current ammo per type for this unit, same keys as `ammunition`.
- `float ammunition_low_threshold` — Ratio (0..1): when `current/capacity <= ammunition_low_threshold` emit “Bingo ammo”.
- `float ammunition_critical_threshold` — Ratio (0..1): when `current/capacity <= ammunition_critical_threshold` emit “Ammo critical”.
- `float supply_transfer_rate` — Transfer rate (rounds per second) a logistics unit can push to a recipient in range.
- `float supply_transfer_radius_m` — Transfer radius in meters within which resupply is possible.

## Enumerations

- `enum UnitSize` — Enumeration of unit sizes

## Member Function Documentation

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

## Member Data Documentation

### id

```gdscript
var id: String
```

### title

```gdscript
var title: String
```

### icon

```gdscript
var icon: Texture2D
```

Unit icon texture

### enemy_icon

```gdscript
var enemy_icon: Texture2D
```

Enemy unit icon texture

### role

```gdscript
var role: String
```

role for this unit

### allowed_slots

```gdscript
var allowed_slots: Array[String]
```

Allowed slot codes where this unit can be deployed

### cost

```gdscript
var cost: int
```

Deployment cost in points

### movement_profile

```gdscript
var movement_profile: TerrainBrush.MoveProfile
```

Movement Profile for navigation

### size

```gdscript
var size: UnitSize
```

Organizational size of the unit

### strength

```gdscript
var strength: int
```

Number of personnel in the unit at full strength

### equipment

```gdscript
var equipment: Dictionary
```

Dictionary of equipment definitions

### experience

```gdscript
var experience: float
```

Average experience level

### attack

```gdscript
var attack: float
```

Offensive rating of the unit

### defense

```gdscript
var defense: float
```

Defensive rating of the unit

### spot_m

```gdscript
var spot_m: float
```

Spotting range in meters

### range_m

```gdscript
var range_m: float
```

Effective weapon range in meters

### morale

```gdscript
var morale: float
```

Morale level (0 = broken, 1 = max)

### speed_kph

```gdscript
var speed_kph: float
```

Movement speed in kilometers per hour

### state_strength

```gdscript
var state_strength: float
```

### state_injured

```gdscript
var state_injured: float
```

### state_equipment

```gdscript
var state_equipment: float
```

### cohesion

```gdscript
var cohesion: float
```

### throughput

```gdscript
var throughput: Dictionary
```

Supply throughput { "supply_type": (int)amount }

### equipment_tags

```gdscript
var equipment_tags: Array[String]
```

Equipment tag codes associated with this unit [ "AMMO_PALLET" ]

### doctrine

```gdscript
var doctrine: String
```

Doctrine code used by the AI for this unit.

### unit_category

```gdscript
var unit_category: UnitCategoryData
```

### ammunition

```gdscript
var ammunition: Dictionary
```

Ammo capacity per type, e.g. `{ "small_arms": 30, "he": 10 }`.

### state_ammunition

```gdscript
var state_ammunition: Dictionary
```

Current ammo per type for this unit, same keys as `ammunition`.

### ammunition_low_threshold

```gdscript
var ammunition_low_threshold: float
```

Ratio (0..1): when `current/capacity <= ammunition_low_threshold` emit “Bingo ammo”.

### ammunition_critical_threshold

```gdscript
var ammunition_critical_threshold: float
```

Ratio (0..1): when `current/capacity <= ammunition_critical_threshold` emit “Ammo critical”.

### supply_transfer_rate

```gdscript
var supply_transfer_rate: float
```

Transfer rate (rounds per second) a logistics unit can push to a recipient in range.

### supply_transfer_radius_m

```gdscript
var supply_transfer_radius_m: float
```

Transfer radius in meters within which resupply is possible.

## Enumeration Type Documentation

### UnitSize

```gdscript
enum UnitSize
```

Enumeration of unit sizes
