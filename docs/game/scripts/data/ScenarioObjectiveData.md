# ScenarioObjectiveData Class Reference

*File:* `scripts/data/ScenarioObjectiveData.gd`
*Class name:* `ScenarioObjectiveData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name ScenarioObjectiveData
extends Resource
```

## Brief

Unique identifier for this objective

## Detailed Description

Human-readable title of the objective

Description of success conditions for this objective

## Public Member Functions

- [`func serialize() -> Dictionary`](ScenarioObjectiveData/functions/serialize.md) — Serialize into JSON
- [`func deserialize(data: Variant) -> ScenarioObjectiveData`](ScenarioObjectiveData/functions/deserialize.md) — Deserialize from JSON

## Public Attributes

- `String id`
- `String title`
- `String success`
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

### title

```gdscript
var title: String
```

### success

```gdscript
var success: String
```

### score

```gdscript
var score: int
```

Score awarded for completing this objective
