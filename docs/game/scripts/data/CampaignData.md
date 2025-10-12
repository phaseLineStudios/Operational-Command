# CampaignData Class Reference

*File:* `scripts/data/CampaignData.gd`
*Class name:* `CampaignData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name CampaignData
extends Resource
```

## Public Member Functions

- [`func serialize() -> Dictionary`](CampaignData/functions/serialize.md) — Serialize campaign data to JSON
- [`func deserialize(data: Variant) -> CampaignData`](CampaignData/functions/deserialize.md) — Deserialize Campaign data from JSON

## Public Attributes

- `String id` — Unique identifier for this campaign
- `String title` — Human-readable title of the campaign
- `String description` — Description of the campaign, shown to the player
- `Texture2D preview` — Preview image for the campaign
- `Texture2D scenario_bg` — Background texture for the scenario selection screen
- `Array[ScenarioData] scenarios` — List of scenarios that make up this campaign
- `int order` — Order index for this campaign
- `Array saves` — Saved states of this campaign (future campaign save structure).

## Member Function Documentation

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize campaign data to JSON

### deserialize

```gdscript
func deserialize(data: Variant) -> CampaignData
```

Deserialize Campaign data from JSON

## Member Data Documentation

### id

```gdscript
var id: String
```

Decorators: `@export`

Unique identifier for this campaign

### title

```gdscript
var title: String
```

Decorators: `@export`

Human-readable title of the campaign

### description

```gdscript
var description: String
```

Decorators: `@export`

Description of the campaign, shown to the player

### preview

```gdscript
var preview: Texture2D
```

Decorators: `@export`

Preview image for the campaign

### scenario_bg

```gdscript
var scenario_bg: Texture2D
```

Decorators: `@export`

Background texture for the scenario selection screen

### scenarios

```gdscript
var scenarios: Array[ScenarioData]
```

Decorators: `@export`

List of scenarios that make up this campaign

### order

```gdscript
var order: int
```

Decorators: `@export`

Order index for this campaign

### saves

```gdscript
var saves: Array
```

Decorators: `@export`

Saved states of this campaign (future campaign save structure).
