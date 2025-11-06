# ArtilleryController Class Reference

*File:* `scripts/sim/systems/ArtilleryController.gd`
*Class name:* `ArtilleryController`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name ArtilleryController
extends Node
```

## Brief

Manages artillery and mortar fire missions.

## Detailed Description

Responsibilities:
- Identify artillery-capable units from equipment
- Process fire mission orders (position, ammo type, rounds)
- Simulate projectile flight time and impact
- Emit signals for voice responses (confirm, shot, splash, impact)
- Generate battle damage assessments from observer units

Active fire mission data

Request a fire mission from an artillery unit
Returns true if accepted, false if unable to comply

## Public Member Functions

- [`func _ready() -> void`](ArtilleryController/functions/_ready.md)
- [`func register_unit(unit_id: String, u: UnitData) -> void`](ArtilleryController/functions/register_unit.md) — Register a unit and check if it's artillery-capable.
- [`func unregister_unit(unit_id: String) -> void`](ArtilleryController/functions/unregister_unit.md) — Unregister a unit
- [`func set_unit_position(unit_id: String, pos: Vector2) -> void`](ArtilleryController/functions/set_unit_position.md) — Update unit position
- [`func bind_ammo_system(ammo_sys: AmmoSystem) -> void`](ArtilleryController/functions/bind_ammo_system.md) — Bind external systems
- [`func bind_los_adapter(los: LOSAdapter) -> void`](ArtilleryController/functions/bind_los_adapter.md)
- [`func is_artillery_unit(unit_id: String) -> bool`](ArtilleryController/functions/is_artillery_unit.md) — Check if a unit is artillery-capable
- [`func get_available_ammo_types(unit_id: String) -> Array[String]`](ArtilleryController/functions/get_available_ammo_types.md) — Get available artillery ammunition types for a unit
- [`func tick(delta: float) -> void`](ArtilleryController/functions/tick.md) — Tick active fire missions
- [`func _process_impact(mission: FireMission) -> void`](ArtilleryController/functions/_process_impact.md) — Process round impacts and generate damage/BDA
- [`func _generate_bda(mission: FireMission) -> void`](ArtilleryController/functions/_generate_bda.md) — Generate battle damage assessment from observer units
- [`func _generate_bda_description(mission: FireMission) -> String`](ArtilleryController/functions/_generate_bda_description.md) — Generate BDA description based on mission type
- [`func _is_artillery_unit(u: UnitData) -> bool`](ArtilleryController/functions/_is_artillery_unit.md) — Check if unit has artillery/mortar ammunition

## Public Attributes

- `String unit_id`
- `Vector2 target_pos`
- `String ammo_type`
- `int rounds`
- `float flight_time`
- `float time_elapsed`
- `bool shot_called`
- `bool splash_called`
- `float mortar_flight_time_base` — Flight time calculation parameters
- `float artillery_flight_time_base`
- `float splash_warning_time`
- `float ap_damage_per_round` — Damage parameters
- `float ap_damage_radius_m`
- `Dictionary _units`
- `Dictionary _positions`
- `Dictionary _artillery_units`
- `Array[FireMission] _active_missions`
- `AmmoSystem _ammo_system`
- `LOSAdapter _los_adapter`
- `UnitData u`
- `int current_ammo`
- `bool is_mortar`
- `float base_flight_time`

## Signals

- `signal mission_confirmed(unit_id: String, target_pos: Vector2, ammo_type: String, rounds: int)` — Emitted when a fire mission is confirmed/accepted
- `signal rounds_shot(unit_id: String, target_pos: Vector2, ammo_type: String, rounds: int)` — Emitted when rounds are fired ("Shot")
- `signal rounds_splash(unit_id: String, target_pos: Vector2, ammo_type: String, rounds: int)` — Emitted 5 seconds before impact ("Splash")
- `signal rounds_impact` — Emitted when rounds impact
- `signal battle_damage_assessment(observer_id: String, target_pos: Vector2, description: String)` — Emitted when friendly observers provide BDA

## Enumerations

- `enum ArtilleryAmmoType` — Artillery ammunition types

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### register_unit

```gdscript
func register_unit(unit_id: String, u: UnitData) -> void
```

Register a unit and check if it's artillery-capable.
`unit_id` The ScenarioUnit ID (with SLOT suffix if applicable).
`u` The UnitData to register.

### unregister_unit

```gdscript
func unregister_unit(unit_id: String) -> void
```

Unregister a unit

### set_unit_position

```gdscript
func set_unit_position(unit_id: String, pos: Vector2) -> void
```

Update unit position

### bind_ammo_system

```gdscript
func bind_ammo_system(ammo_sys: AmmoSystem) -> void
```

Bind external systems

### bind_los_adapter

```gdscript
func bind_los_adapter(los: LOSAdapter) -> void
```

### is_artillery_unit

```gdscript
func is_artillery_unit(unit_id: String) -> bool
```

Check if a unit is artillery-capable

### get_available_ammo_types

```gdscript
func get_available_ammo_types(unit_id: String) -> Array[String]
```

Get available artillery ammunition types for a unit

### tick

```gdscript
func tick(delta: float) -> void
```

Tick active fire missions

### _process_impact

```gdscript
func _process_impact(mission: FireMission) -> void
```

Process round impacts and generate damage/BDA

### _generate_bda

```gdscript
func _generate_bda(mission: FireMission) -> void
```

Generate battle damage assessment from observer units

### _generate_bda_description

```gdscript
func _generate_bda_description(mission: FireMission) -> String
```

Generate BDA description based on mission type

### _is_artillery_unit

```gdscript
func _is_artillery_unit(u: UnitData) -> bool
```

Check if unit has artillery/mortar ammunition

## Member Data Documentation

### unit_id

```gdscript
var unit_id: String
```

### target_pos

```gdscript
var target_pos: Vector2
```

### ammo_type

```gdscript
var ammo_type: String
```

### rounds

```gdscript
var rounds: int
```

### flight_time

```gdscript
var flight_time: float
```

### time_elapsed

```gdscript
var time_elapsed: float
```

### shot_called

```gdscript
var shot_called: bool
```

### splash_called

```gdscript
var splash_called: bool
```

### mortar_flight_time_base

```gdscript
var mortar_flight_time_base: float
```

Decorators: `@export`

Flight time calculation parameters

### artillery_flight_time_base

```gdscript
var artillery_flight_time_base: float
```

### splash_warning_time

```gdscript
var splash_warning_time: float
```

### ap_damage_per_round

```gdscript
var ap_damage_per_round: float
```

Decorators: `@export`

Damage parameters

### ap_damage_radius_m

```gdscript
var ap_damage_radius_m: float
```

### _units

```gdscript
var _units: Dictionary
```

### _positions

```gdscript
var _positions: Dictionary
```

### _artillery_units

```gdscript
var _artillery_units: Dictionary
```

### _active_missions

```gdscript
var _active_missions: Array[FireMission]
```

### _ammo_system

```gdscript
var _ammo_system: AmmoSystem
```

### _los_adapter

```gdscript
var _los_adapter: LOSAdapter
```

### u

```gdscript
var u: UnitData
```

### current_ammo

```gdscript
var current_ammo: int
```

### is_mortar

```gdscript
var is_mortar: bool
```

### base_flight_time

```gdscript
var base_flight_time: float
```

## Signal Documentation

### mission_confirmed

```gdscript
signal mission_confirmed(unit_id: String, target_pos: Vector2, ammo_type: String, rounds: int)
```

Emitted when a fire mission is confirmed/accepted

### rounds_shot

```gdscript
signal rounds_shot(unit_id: String, target_pos: Vector2, ammo_type: String, rounds: int)
```

Emitted when rounds are fired ("Shot")

### rounds_splash

```gdscript
signal rounds_splash(unit_id: String, target_pos: Vector2, ammo_type: String, rounds: int)
```

Emitted 5 seconds before impact ("Splash")

### rounds_impact

```gdscript
signal rounds_impact
```

Emitted when rounds impact

### battle_damage_assessment

```gdscript
signal battle_damage_assessment(observer_id: String, target_pos: Vector2, description: String)
```

Emitted when friendly observers provide BDA

## Enumeration Type Documentation

### ArtilleryAmmoType

```gdscript
enum ArtilleryAmmoType
```

Artillery ammunition types
