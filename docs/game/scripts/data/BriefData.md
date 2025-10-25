# BriefData Class Reference

*File:* `scripts/data/BriefData.gd`
*Class name:* `BriefData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name BriefData
extends Resource
```

## Public Member Functions

- [`func serialize() -> Dictionary`](BriefData/functions/serialize.md) — Serializes briefing data to JSON
- [`func deserialize(data: Variant) -> BriefData`](BriefData/functions/deserialize.md) — Deserializes briefing data from JSON

## Public Attributes

- `String id` — Unique identifier for this briefing
- `String title` — Human-readable title of the briefing
- `String frag_enemy` — Enemy situation fragment (enemy composition, disposition, activity)
- `String frag_friendly` — Friendly situation fragment (own forces/adjacent/supporting)
- `String frag_terrain` — Terrain and obstacles fragment (key terrain, avenues of approach)
- `String frag_weather` — Weather fragment (visibility, precipitation, wind, effects)
- `String frag_start_time` — Start time / H-Hour context fragment
- `String frag_mission` — Mission statement fragment (task & purpose)
- `Array[ScenarioObjectiveData] frag_objectives` — Objectives list
- `String frag_execution` — Execution guidance (e.g., scheme of maneuver)
- `String frago_logi` — Administration & logistics fragment
- `Texture2D board_texture` — Background texture for the intel/briefing board
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

Decorators: `@export`

Unique identifier for this briefing

### title

```gdscript
var title: String
```

Decorators: `@export`

Human-readable title of the briefing

### frag_enemy

```gdscript
var frag_enemy: String
```

Decorators: `@export`

Enemy situation fragment (enemy composition, disposition, activity)

### frag_friendly

```gdscript
var frag_friendly: String
```

Decorators: `@export`

Friendly situation fragment (own forces/adjacent/supporting)

### frag_terrain

```gdscript
var frag_terrain: String
```

Decorators: `@export`

Terrain and obstacles fragment (key terrain, avenues of approach)

### frag_weather

```gdscript
var frag_weather: String
```

Decorators: `@export`

Weather fragment (visibility, precipitation, wind, effects)

### frag_start_time

```gdscript
var frag_start_time: String
```

Decorators: `@export`

Start time / H-Hour context fragment

### frag_mission

```gdscript
var frag_mission: String
```

Decorators: `@export`

Mission statement fragment (task & purpose)

### frag_objectives

```gdscript
var frag_objectives: Array[ScenarioObjectiveData]
```

Decorators: `@export`

Objectives list

### frag_execution

```gdscript
var frag_execution: String
```

Decorators: `@export`

Execution guidance (e.g., scheme of maneuver)

### frago_logi

```gdscript
var frago_logi: String
```

Decorators: `@export`

Administration & logistics fragment

### board_texture

```gdscript
var board_texture: Texture2D
```

Decorators: `@export`

Background texture for the intel/briefing board

### board_items

```gdscript
var board_items: Array[BriefItemData]
```

Decorators: `@export`

Items pinned on the intel board (documents, images, etc.)
