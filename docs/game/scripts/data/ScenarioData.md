# ScenarioData Class Reference

*File:* `scripts/data/ScenarioData.gd`
*Class name:* `ScenarioData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name ScenarioData
extends Resource
```

## Public Member Functions

- [`func serialize() -> Dictionary`](ScenarioData/functions/serialize.md) — Serialize data to JSON
- [`func deserialize(json: Variant) -> ScenarioData`](ScenarioData/functions/deserialize.md) — Deserialize data from JSON
- [`func _vec2_to_dict(v: Vector2) -> Dictionary`](ScenarioData/functions/_vec2_to_dict.md)
- [`func _dict_to_vec2(d: Variant) -> Vector2`](ScenarioData/functions/_dict_to_vec2.md)
- [`func _serialize_unit_slots(arr: Array) -> Array`](ScenarioData/functions/_serialize_unit_slots.md)
- [`func _deserialize_unit_slots(payload: Variant) -> Array[UnitSlotData]`](ScenarioData/functions/_deserialize_unit_slots.md)
- [`func _difficulty_from(json_value: Variant) -> int`](ScenarioData/functions/_difficulty_from.md)

## Public Attributes

- `String id` — Unique identifier for this scenario
- `String title` — Human-readable title of the scenario
- `String description` — Short Scenario description shown to the player
- `String preview_path` — File path to the scenario preview image
- `TerrainData terrain` — The scenario terrain data
- `BriefData briefing` — The scenario briefing data
- `ScenarioDifficulty difficulty` — Difficulty of the scenario
- `Vector2 map_position` — Position of the scenario on the campaign/selection map
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

Decorators: `@export`

Unique identifier for this scenario

### title

```gdscript
var title: String
```

Decorators: `@export`

Human-readable title of the scenario

### description

```gdscript
var description: String
```

Decorators: `@export`

Short Scenario description shown to the player

### preview_path

```gdscript
var preview_path: String
```

Decorators: `@export_file("*.png *.jpg ; Image")`

File path to the scenario preview image

### terrain

```gdscript
var terrain: TerrainData
```

Decorators: `@export`

The scenario terrain data

### briefing

```gdscript
var briefing: BriefData
```

Decorators: `@export`

The scenario briefing data

### difficulty

```gdscript
var difficulty: ScenarioDifficulty
```

Decorators: `@export`

Difficulty of the scenario

### map_position

```gdscript
var map_position: Vector2
```

Decorators: `@export`

Position of the scenario on the campaign/selection map

### scenario_order

```gdscript
var scenario_order: int
```

Decorators: `@export`

Order index of the scenario in a campaign sequence

### rain

```gdscript
var rain: float
```

Decorators: `@export_range(0.0, 50.0, 0.05)`

Rainfall in millimeters per hour

### fog_m

```gdscript
var fog_m: float
```

Decorators: `@export_range(0.0, 10000.0, 1.0)`

Fog visibility in meters

### wind_dir

```gdscript
var wind_dir: float
```

Decorators: `@export_range(0.0, 360.0, 1.0)`

Wind direction in degrees

### wind_speed_m

```gdscript
var wind_speed_m: float
```

Decorators: `@export_range(0.0, 110.0, 0.5)`

Wind speed in meters per second

### year

```gdscript
var year: int
```

Decorators: `@export`

Year when the scenario takes place

### month

```gdscript
var month: int
```

Decorators: `@export_range(1.0, 12.0, 1.0)`

Month when the scenario takes place

### day

```gdscript
var day: int
```

Decorators: `@export_range(1.0, 31.0, 1.0)`

Day of the month

### hour

```gdscript
var hour: int
```

Decorators: `@export_range(0.0, 23.0, 1.0)`

Hour of the day

### minute

```gdscript
var minute: int
```

Decorators: `@export_range(0.0, 59.0, 1.0)`

Minute of the hour

### unit_points

```gdscript
var unit_points: int
```

Decorators: `@export`

Total points available to the player to deploy units

### unit_slots

```gdscript
var unit_slots: Array[UnitSlotData]
```

Decorators: `@export`

Slots available for units to be placed into

### unit_recruits

```gdscript
var unit_recruits: Array[UnitData]
```

Decorators: `@export`

Recruitable units available at the start

### unit_reserves

```gdscript
var unit_reserves: Array[UnitSlotData]
```

Decorators: `@export`

Reserve slots for reinforcements or delayed units

### friendly_callsigns

```gdscript
var friendly_callsigns: Array[String]
```

Decorators: `@export`

Friendly Callsign List

### enemy_callsigns

```gdscript
var enemy_callsigns: Array[String]
```

Decorators: `@export`

Enemy Callsign List

### units

```gdscript
var units: Array[ScenarioUnit]
```

Decorators: `@export`

List of units placed in this scenario

### triggers

```gdscript
var triggers: Array[ScenarioTrigger]
```

Decorators: `@export`

Triggers that define scripted events and conditions

### tasks

```gdscript
var tasks: Array[ScenarioTask]
```

Decorators: `@export`

Tasks or objectives for the AI to complete

### drawings

```gdscript
var drawings: Array
```

Decorators: `@export`

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
