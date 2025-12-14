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

- [`func _ready() -> void`](Persistence/functions/_ready.md)
- [`func _ensure_save_directory() -> void`](Persistence/functions/_ensure_save_directory.md) — Ensure the save directory exists.
- [`func get_last_save_id_for_campaign(campaign_id: StringName) -> String`](Persistence/functions/get_last_save_id_for_campaign.md) — Return last save ID for `campaign_id`, or empty.
- [`func list_saves_for_campaign(campaign_id: StringName) -> Array[CampaignSave]`](Persistence/functions/list_saves_for_campaign.md) — Return array of CampaignSave objects for `campaign_id`.
- [`func create_new_campaign_save(campaign_id: StringName, save_name: String = "") -> String`](Persistence/functions/create_new_campaign_save.md) — Create a new save for `campaign_id`; return new ID.
- [`func load_save(save_id: String) -> CampaignSave`](Persistence/functions/load_save.md) — Load a save by ID.
- [`func load_save_from_file(save_id: String) -> CampaignSave`](Persistence/functions/load_save_from_file.md) — Load a save from file by ID.
- [`func save_to_file(save: CampaignSave) -> bool`](Persistence/functions/save_to_file.md) — Save a CampaignSave to file.
- [`func delete_save(save_id: String) -> bool`](Persistence/functions/delete_save.md) — Delete a save by ID.
- [`func _get_save_path(save_id: String) -> String`](Persistence/functions/_get_save_path.md) — Get the file path for a save ID.

## Public Attributes

- `Dictionary _save_cache`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _ensure_save_directory

```gdscript
func _ensure_save_directory() -> void
```

Ensure the save directory exists.

### get_last_save_id_for_campaign

```gdscript
func get_last_save_id_for_campaign(campaign_id: StringName) -> String
```

Return last save ID for `campaign_id`, or empty.

### list_saves_for_campaign

```gdscript
func list_saves_for_campaign(campaign_id: StringName) -> Array[CampaignSave]
```

Return array of CampaignSave objects for `campaign_id`.

### create_new_campaign_save

```gdscript
func create_new_campaign_save(campaign_id: StringName, save_name: String = "") -> String
```

Create a new save for `campaign_id`; return new ID.

### load_save

```gdscript
func load_save(save_id: String) -> CampaignSave
```

Load a save by ID. Returns null if not found.

### load_save_from_file

```gdscript
func load_save_from_file(save_id: String) -> CampaignSave
```

Load a save from file by ID. Returns null if not found.

### save_to_file

```gdscript
func save_to_file(save: CampaignSave) -> bool
```

Save a CampaignSave to file.

### delete_save

```gdscript
func delete_save(save_id: String) -> bool
```

Delete a save by ID. Returns true on success.

### _get_save_path

```gdscript
func _get_save_path(save_id: String) -> String
```

Get the file path for a save ID.

## Member Data Documentation

### _save_cache

```gdscript
var _save_cache: Dictionary
```
