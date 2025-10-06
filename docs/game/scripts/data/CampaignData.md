# CampaignData Class Reference

*File:* `scripts/data/CampaignData.gd`
*Class name:* `CampaignData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name CampaignData
extends Resource
```

## Brief

Unique identifier for this campaign

## Detailed Description

Human-readable title of the campaign

Description of the campaign, shown to the player

Preview image for the campaign

Background texture for the scenario selection screen

## Public Member Functions

- [`func serialize() -> Dictionary`](CampaignData/functions/serialize.md) — Serialize campaign data to JSON
- [`func deserialize(data: Variant) -> CampaignData`](CampaignData/functions/deserialize.md) — Deserialize Campaign data from JSON

## Public Attributes

- `String id`
- `String title`
- `String description`
- `Texture2D preview`
- `Texture2D scenario_bg`
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

### title

```gdscript
var title: String
```

### description

```gdscript
var description: String
```

### preview

```gdscript
var preview: Texture2D
```

### scenario_bg

```gdscript
var scenario_bg: Texture2D
```

### scenarios

```gdscript
var scenarios: Array[ScenarioData]
```

List of scenarios that make up this campaign

### order

```gdscript
var order: int
```

Order index for this campaign

### saves

```gdscript
var saves: Array
```

Saved states of this campaign (future campaign save structure).
