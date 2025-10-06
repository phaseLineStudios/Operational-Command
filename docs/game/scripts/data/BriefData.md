# BriefData Class Reference

*File:* `scripts/data/BriefData.gd`
*Class name:* `BriefData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name BriefData
extends Resource
```

## Brief

Unique identifier for this briefing

## Detailed Description

Human-readable title of the briefing

Enemy situation fragment (enemy composition, disposition, activity)

Friendly situation fragment (own forces/adjacent/supporting)

Terrain and obstacles fragment (key terrain, avenues of approach)

Weather fragment (visibility, precipitation, wind, effects)

Start time / H-Hour context fragment

Mission statement fragment (task & purpose)

Administration & logistics fragment

Background texture for the intel/briefing board

## Public Member Functions

- [`func serialize() -> Dictionary`](BriefData/functions/serialize.md) — Serializes briefing data to JSON
- [`func deserialize(data: Variant) -> BriefData`](BriefData/functions/deserialize.md) — Deserializes briefing data from JSON

## Public Attributes

- `String id`
- `String title`
- `String frag_enemy`
- `String frag_friendly`
- `String frag_terrain`
- `String frag_weather`
- `String frag_start_time`
- `String frag_mission`
- `Array[ScenarioObjectiveData] frag_objectives` — Objectives list
- `Array[String] frag_execution` — Execution guidance (e.g., scheme of maneuver)
- `String frago_logi`
- `Texture2D board_texture`
- `Array[BriefItemData] board_items` — Items pinned on the intel board (documents, images, etc.)

## Member Function Documentation

### serialize

```gdscript
func serialize() -> Dictionary
```

Serializes briefing data to JSON

### deserialize

```gdscript
func deserialize(data: Variant) -> BriefData
```

Deserializes briefing data from JSON

## Member Data Documentation

### id

```gdscript
var id: String
```

### title

```gdscript
var title: String
```

### frag_enemy

```gdscript
var frag_enemy: String
```

### frag_friendly

```gdscript
var frag_friendly: String
```

### frag_terrain

```gdscript
var frag_terrain: String
```

### frag_weather

```gdscript
var frag_weather: String
```

### frag_start_time

```gdscript
var frag_start_time: String
```

### frag_mission

```gdscript
var frag_mission: String
```

### frag_objectives

```gdscript
var frag_objectives: Array[ScenarioObjectiveData]
```

Objectives list

### frag_execution

```gdscript
var frag_execution: Array[String]
```

Execution guidance (e.g., scheme of maneuver)

### frago_logi

```gdscript
var frago_logi: String
```

### board_texture

```gdscript
var board_texture: Texture2D
```

### board_items

```gdscript
var board_items: Array[BriefItemData]
```

Items pinned on the intel board (documents, images, etc.)
