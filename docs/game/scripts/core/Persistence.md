# Persistence Class Reference

*File:* `scripts/core/Persistence.gd`
*Inherits:* `Node`

## Synopsis

```gdscript
extends Node
```

## Brief

Campaign save/load and progression persistence.

## Detailed Description

Stores and retrieves long-term game state: unit rosters, veterancy,
equipment/manpower pools, mission results, and campaign branching.

Base directory for saves.

## Public Member Functions

- [`func get_last_save_id_for_campaign(_campaign_id: StringName) -> String`](Persistence/functions/get_last_save_id_for_campaign.md) — Return last save ID for `campaign_id`, or empty.
- [`func list_saves_for_campaign(_campaign_id: StringName) -> Array`](Persistence/functions/list_saves_for_campaign.md) — Return array of save dicts for `campaign_id`.
- [`func create_new_campaign_save(_campaign_id: StringName) -> String`](Persistence/functions/create_new_campaign_save.md) — Create a new save for `campaign_id`; return new ID.

## Member Function Documentation

### get_last_save_id_for_campaign

```gdscript
func get_last_save_id_for_campaign(_campaign_id: StringName) -> String
```

Return last save ID for `campaign_id`, or empty.

### list_saves_for_campaign

```gdscript
func list_saves_for_campaign(_campaign_id: StringName) -> Array
```

Return array of save dicts for `campaign_id`.

### create_new_campaign_save

```gdscript
func create_new_campaign_save(_campaign_id: StringName) -> String
```

Create a new save for `campaign_id`; return new ID.
