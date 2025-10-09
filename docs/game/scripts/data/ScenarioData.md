# ScenarioData Class Reference

*File:* `scripts/data/ScenarioData.gd`
*Class name:* `ScenarioData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name ScenarioData
extends Resource
```

## Brief

Unique identifier for this scenario

## Detailed Description

Human-readable title of the scenario

Short Scenario description shown to the player

File path to the scenario preview image

The scenario terrain data

The scenario briefing data

Difficulty of the scenario

Position of the scenario on the campaign/selection map

## Public Member Functions

- [`func serialize() -> Dictionary`](ScenarioData/functions/serialize.md) — Serialize data to JSON
- [`func deserialize(json: Variant) -> ScenarioData`](ScenarioData/functions/deserialize.md) — Deserialize data from JSON
- [`func _vec2_to_dict(v: Vector2) -> Dictionary`](ScenarioData/functions/_vec2_to_dict.md)
- [`func _dict_to_vec2(d: Variant) -> Vector2`](ScenarioData/functions/_dict_to_vec2.md)
- [`func _serialize_unit_slots(arr: Array) -> Array`](ScenarioData/functions/_serialize_unit_slots.md)
- [`func _deserialize_unit_slots(payload: Variant) -> Array[UnitSlotData]`](ScenarioData/functions/_deserialize_unit_slots.md)
- [`func _difficulty_from(json_value: Variant) -> int`](ScenarioData/functions/_difficulty_from.md)

## Public Attributes

- `String id`
- `String title`
- `String description`
- `TerrainData terrain`
- `BriefData briefing`
- `ScenarioDifficulty difficulty`
- `Vector2 map_position`
- `int scenario_order` — Order index of the scenario in a campaign sequence
- `float rain` — Rainfall in millimeters per hour
- `float fog_m` — Fog visibility in meters
- `float wind_dir` — Wind direction in degrees
- `float wind_speed_m` — Wind speed in meters per second
- `int year` — Year when the scenario takes place
- `int month` — Month when the scenario takes place
- `int day` — Day of the month
- `int hour` — Hour of the day
- `int minute` — Minute of the hour
- `int unit_points` — Total points available to the player to deploy units
- `Array[UnitSlotData] unit_slots` — Slots available for units to be placed into
- `Array[UnitData] unit_recruits` — Recruitable units available at the start
- `Array[UnitSlotData] unit_reserves` — Reserve slots for reinforcements or delayed units
- `Array[String] friendly_callsigns` — Friendly Callsign List
- `Array[String] enemy_callsigns` — Enemy Callsign List
- `Array[ScenarioUnit] units` — List of units placed in this scenario
- `Array[ScenarioUnit] playable_units` — List of playable units.
- `Array[ScenarioTrigger] triggers` — Triggers that define scripted events and conditions
- `Array[ScenarioTask] tasks` — Tasks or objectives for the AI to complete
- `Array drawings` — Drawings or map overlays associated with the scenario
- `Texture2D preview`

## Enumerations

- `enum ScenarioDifficulty` — Enumeration of scenario difficulty levels

## Member Function Documentation

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize data to JSON

### deserialize

```gdscript
func deserialize(json: Variant) -> ScenarioData
```

Deserialize data from JSON

### _vec2_to_dict

```gdscript
func _vec2_to_dict(v: Vector2) -> Dictionary
```

### _dict_to_vec2

```gdscript
func _dict_to_vec2(d: Variant) -> Vector2
```

### _serialize_unit_slots

```gdscript
func _serialize_unit_slots(arr: Array) -> Array
```

### _deserialize_unit_slots

```gdscript
func _deserialize_unit_slots(payload: Variant) -> Array[UnitSlotData]
```

### _difficulty_from

```gdscript
func _difficulty_from(json_value: Variant) -> int
```

## Member Data Documentation

### id

```gdscript
var id: String
```

### title

```gdscript
var title: String
```

### description

```gdscript
var description: String
```

### terrain

```gdscript
var terrain: TerrainData
```

### briefing

```gdscript
var briefing: BriefData
```

### difficulty

```gdscript
var difficulty: ScenarioDifficulty
```

### map_position

```gdscript
var map_position: Vector2
```

### scenario_order

```gdscript
var scenario_order: int
```

Order index of the scenario in a campaign sequence

### rain

```gdscript
var rain: float
```

Rainfall in millimeters per hour

### fog_m

```gdscript
var fog_m: float
```

Fog visibility in meters

### wind_dir

```gdscript
var wind_dir: float
```

Wind direction in degrees

### wind_speed_m

```gdscript
var wind_speed_m: float
```

Wind speed in meters per second

### year

```gdscript
var year: int
```

Year when the scenario takes place

### month

```gdscript
var month: int
```

Month when the scenario takes place

### day

```gdscript
var day: int
```

Day of the month

### hour

```gdscript
var hour: int
```

Hour of the day

### minute

```gdscript
var minute: int
```

Minute of the hour

### unit_points

```gdscript
var unit_points: int
```

Total points available to the player to deploy units

### unit_slots

```gdscript
var unit_slots: Array[UnitSlotData]
```

Slots available for units to be placed into

### unit_recruits

```gdscript
var unit_recruits: Array[UnitData]
```

Recruitable units available at the start

### unit_reserves

```gdscript
var unit_reserves: Array[UnitSlotData]
```

Reserve slots for reinforcements or delayed units

### friendly_callsigns

```gdscript
var friendly_callsigns: Array[String]
```

Friendly Callsign List

### enemy_callsigns

```gdscript
var enemy_callsigns: Array[String]
```

Enemy Callsign List

### units

```gdscript
var units: Array[ScenarioUnit]
```

List of units placed in this scenario

### playable_units

```gdscript
var playable_units: Array[ScenarioUnit]
```

List of playable units. Populated on game start

### triggers

```gdscript
var triggers: Array[ScenarioTrigger]
```

Triggers that define scripted events and conditions

### tasks

```gdscript
var tasks: Array[ScenarioTask]
```

Tasks or objectives for the AI to complete

### drawings

```gdscript
var drawings: Array
```

Drawings or map overlays associated with the scenario

### preview

```gdscript
var preview: Texture2D
```

## Enumeration Type Documentation

### ScenarioDifficulty

```gdscript
enum ScenarioDifficulty
```

Enumeration of scenario difficulty levels
