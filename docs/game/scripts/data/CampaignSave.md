# CampaignSave Class Reference

*File:* `scripts/data/CampaignSave.gd`
*Class name:* `CampaignSave`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name CampaignSave
extends Resource
```

## Brief

Campaign save data for persistence.

## Detailed Description

Tracks progress through a campaign: completed missions, current mission,
unit states, and metadata. Can be serialized to/from JSON for file storage.

## Public Member Functions

- [`func create_new(p_campaign_id: String, p_save_name: String = "") -> Resource`](CampaignSave/functions/create_new.md) — Create a new campaign save with initial values.
- [`func complete_mission(mission_id: String) -> void`](CampaignSave/functions/complete_mission.md) — Mark a mission as completed.
- [`func is_mission_completed(mission_id: String) -> bool`](CampaignSave/functions/is_mission_completed.md) — Check if a mission is completed.
- [`func touch() -> void`](CampaignSave/functions/touch.md) — Update last played timestamp.
- [`func update_unit_state(unit_id: String, state: Dictionary) -> void`](CampaignSave/functions/update_unit_state.md) — Update unit state for a unit.
- [`func get_unit_state(unit_id: String) -> Dictionary`](CampaignSave/functions/get_unit_state.md) — Get unit state for a unit, or empty dict if not found.
- [`func serialize() -> Dictionary`](CampaignSave/functions/serialize.md) — Serialize to JSON-compatible dictionary.
- [`func deserialize(data: Variant) -> Resource`](CampaignSave/functions/deserialize.md) — Deserialize from JSON dictionary.

## Public Attributes

- `String save_id` — Unique identifier for this save
- `String save_name` — Human-readable name for this save
- `String campaign_id` — Campaign ID this save belongs to
- `int created_timestamp` — Unix timestamp of save creation
- `int last_played_timestamp` — Unix timestamp of last update
- `Array[String] completed_missions` — List of completed scenario IDs
- `String current_mission` — Current/active scenario ID (empty if at campaign start)
- `float total_playtime_seconds` — Total playtime in seconds
- `Dictionary unit_states` — Dictionary mapping unit IDs to their persistent state
Format: { "unit_id": { "state_strength": float, "state_injured": float, ...

## Member Function Documentation

### create_new

```gdscript
func create_new(p_campaign_id: String, p_save_name: String = "") -> Resource
```

Create a new campaign save with initial values.

### complete_mission

```gdscript
func complete_mission(mission_id: String) -> void
```

Mark a mission as completed.

### is_mission_completed

```gdscript
func is_mission_completed(mission_id: String) -> bool
```

Check if a mission is completed.

### touch

```gdscript
func touch() -> void
```

Update last played timestamp.

### update_unit_state

```gdscript
func update_unit_state(unit_id: String, state: Dictionary) -> void
```

Update unit state for a unit.
`unit_id` The unit ID.
`state` Dictionary with state keys: state_strength, state_injured,
state_equipment, cohesion, state_ammunition.

### get_unit_state

```gdscript
func get_unit_state(unit_id: String) -> Dictionary
```

Get unit state for a unit, or empty dict if not found.

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize to JSON-compatible dictionary.

### deserialize

```gdscript
func deserialize(data: Variant) -> Resource
```

Deserialize from JSON dictionary.

## Member Data Documentation

### save_id

```gdscript
var save_id: String
```

Decorators: `@export`

Unique identifier for this save

### save_name

```gdscript
var save_name: String
```

Decorators: `@export`

Human-readable name for this save

### campaign_id

```gdscript
var campaign_id: String
```

Decorators: `@export`

Campaign ID this save belongs to

### created_timestamp

```gdscript
var created_timestamp: int
```

Decorators: `@export`

Unix timestamp of save creation

### last_played_timestamp

```gdscript
var last_played_timestamp: int
```

Decorators: `@export`

Unix timestamp of last update

### completed_missions

```gdscript
var completed_missions: Array[String]
```

Decorators: `@export`

List of completed scenario IDs

### current_mission

```gdscript
var current_mission: String
```

Decorators: `@export`

Current/active scenario ID (empty if at campaign start)

### total_playtime_seconds

```gdscript
var total_playtime_seconds: float
```

Decorators: `@export`

Total playtime in seconds

### unit_states

```gdscript
var unit_states: Dictionary
```

Decorators: `@export`

Dictionary mapping unit IDs to their persistent state
Format: { "unit_id": { "state_strength": float, "state_injured": float, ... } }
