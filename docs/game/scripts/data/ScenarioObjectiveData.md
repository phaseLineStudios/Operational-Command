# ScenarioObjectiveData Class Reference

*File:* `scripts/data/ScenarioObjectiveData.gd`
*Class name:* `ScenarioObjectiveData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name ScenarioObjectiveData
extends Resource
```

## Public Member Functions

- [`func serialize() -> Dictionary`](ScenarioObjectiveData/functions/serialize.md) — Serialize into JSON
- [`func deserialize(data: Variant) -> ScenarioObjectiveData`](ScenarioObjectiveData/functions/deserialize.md) — Deserialize from JSON

## Public Attributes

- `String id` — Unique identifier for this objective
- `String title` — Human-readable title of the objective
- `String success` — Description of success conditions for this objective
- `int score` — Score awarded for completing this objective

## Member Function Documentation

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize into JSON

### deserialize

```gdscript
func deserialize(data: Variant) -> ScenarioObjectiveData
```

Deserialize from JSON

## Member Data Documentation

### id

```gdscript
var id: String
```

Decorators: `@export`

Unique identifier for this objective

### title

```gdscript
var title: String
```

Decorators: `@export`

Human-readable title of the objective

### success

```gdscript
var success: String
```

Decorators: `@export`

Description of success conditions for this objective

### score

```gdscript
var score: int
```

Decorators: `@export`

Score awarded for completing this objective
