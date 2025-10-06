# ContentDB Class Reference

*File:* `scripts/core/ContentDB.gd`
*Inherits:* `Node`

## Synopsis

```gdscript
extends Node
```

## Brief

Data loader and index for units, maps, briefs, and scenarios.

## Detailed Description

Loads JSON assets from `res://data/` and exposes typed accessors
with basic validation and helpful error messages.

## Public Member Functions

- [`func _norm_dir(dir_path: String) -> String`](ContentDB/functions/_norm_dir.md) — Normalize to res:// and remove trailing slash.
- [`func _postprocess(v: Variant) -> Variant`](ContentDB/functions/_postprocess.md) — Recursively convert special string literals to engine types (minimal).
- [`func _load_json(abs_path: String) -> Dictionary`](ContentDB/functions/_load_json.md) — Load a JSON file to Dictionary.
- [`func _resolve_id_path(dir_abs: String, id: String) -> String`](ContentDB/functions/_resolve_id_path.md) — Get absolute file path for id in a directory.
- [`func get_all_objects(dir_path: String) -> Array`](ContentDB/functions/get_all_objects.md) — Read all objects in a directory.
- [`func get_object(dir_path: String, id: String) -> Dictionary`](ContentDB/functions/get_object.md) — Read a single object by id.
- [`func get_objects(dir_path: String, ids: Array) -> Array`](ContentDB/functions/get_objects.md) — Read multiple objects by ids (keeps order).
- [`func get_campaign(id: String) -> CampaignData`](ContentDB/functions/get_campaign.md) — Campaigns helpers.
- [`func get_campaigns(ids: Array) -> Array`](ContentDB/functions/get_campaigns.md) — Get multiple campaigns by IDs
- [`func list_campaigns() -> Array`](ContentDB/functions/list_campaigns.md) — List all campaigns
- [`func get_scenario(id: String) -> ScenarioData`](ContentDB/functions/get_scenario.md) — Missions helpers.
- [`func get_scenarios(ids: Array) -> Array[CampaignData]`](ContentDB/functions/get_scenarios.md) — Get multiple scenarios by IDs
- [`func list_scenarios() -> Array[ScenarioData]`](ContentDB/functions/list_scenarios.md) — list all scenarios
- [`func list_scenarios_for_campaign(campaign_id: StringName) -> Array[ScenarioData]`](ContentDB/functions/list_scenarios_for_campaign.md) — List all scenarios for a campaign by ID
- [`func get_briefing(id_or_mission_id: String) -> BriefData`](ContentDB/functions/get_briefing.md) — Briefing helpers.
- [`func get_briefings(ids: Array) -> Array[BriefData]`](ContentDB/functions/get_briefings.md) — Get multiple briefings by ids
- [`func list_briefings() -> Array[BriefData]`](ContentDB/functions/list_briefings.md) — List all briefings
- [`func get_briefing_for_mission(mission_id: String) -> BriefData`](ContentDB/functions/get_briefing_for_mission.md) — Convenience explicit mission briefing resolver.
- [`func get_unit(id: String) -> UnitData`](ContentDB/functions/get_unit.md) — Units helpers.
- [`func get_units(ids: Array) -> Array[UnitData]`](ContentDB/functions/get_units.md) — Get units by IDs
- [`func list_units() -> Array[UnitData]`](ContentDB/functions/list_units.md) — List all units
- [`func get_unit_category(id: String) -> UnitCategoryData`](ContentDB/functions/get_unit_category.md) — Unit Category helpers.
- [`func get_unit_categories(ids: Array) -> Array[UnitCategoryData]`](ContentDB/functions/get_unit_categories.md) — Get unit categories by IDs
- [`func list_unit_categories() -> Array[UnitCategoryData]`](ContentDB/functions/list_unit_categories.md) — List all unit categories
- [`func list_recruitable_units(mission_id: String) -> Array[UnitData]`](ContentDB/functions/list_recruitable_units.md) — Get list of reqreuitable units for scenario
- [`func v2(v: Vector2) -> Dictionary`](ContentDB/functions/v2.md) — Serialization helpers
- [`func v2_from(d: Variant) -> Vector2`](ContentDB/functions/v2_from.md) — Deserialize Vector2
- [`func v2arr_serialize(a: PackedVector2Array) -> Array`](ContentDB/functions/v2arr_serialize.md) — Serialize PackedVector2Array
- [`func v2arr_deserialize(a: Variant) -> PackedVector2Array`](ContentDB/functions/v2arr_deserialize.md) — deserialize PackedVector2Array
- [`func res_path_or_null(res: Variant) -> Variant`](ContentDB/functions/res_path_or_null.md) — serialize a resource
- [`func load_res(path: Variant) -> Variant`](ContentDB/functions/load_res.md) — Deserialize a resource
- [`func image_to_png_b64(img: Image) -> String`](ContentDB/functions/image_to_png_b64.md) — Serialize a image to Base 64
- [`func png_b64_to_image(b64: Variant) -> Image`](ContentDB/functions/png_b64_to_image.md) — Deserialize a image from Base 64
- [`func ids_from_resources(arr: Array, id_prop: String = "id") -> Array`](ContentDB/functions/ids_from_resources.md) — Serialize resources to IDs
- [`func resources_from_ids(ids: Array, loader: Callable) -> Array`](ContentDB/functions/resources_from_ids.md) — Deserialize resources from IDs
- [`func safe_dup(v: Variant) -> Variant`](ContentDB/functions/safe_dup.md) — Safely duplicate a dictionary or array

## Public Attributes

- `Dictionary _cache` — Cache loaded objects by absolute path.

## Member Function Documentation

### _norm_dir

```gdscript
func _norm_dir(dir_path: String) -> String
```

Normalize to res:// and remove trailing slash.

### _postprocess

```gdscript
func _postprocess(v: Variant) -> Variant
```

Recursively convert special string literals to engine types (minimal).

### _load_json

```gdscript
func _load_json(abs_path: String) -> Dictionary
```

Load a JSON file to Dictionary. Uses cache.

### _resolve_id_path

```gdscript
func _resolve_id_path(dir_abs: String, id: String) -> String
```

Get absolute file path for id in a directory.

### get_all_objects

```gdscript
func get_all_objects(dir_path: String) -> Array
```

Read all objects in a directory.

### get_object

```gdscript
func get_object(dir_path: String, id: String) -> Dictionary
```

Read a single object by id.

### get_objects

```gdscript
func get_objects(dir_path: String, ids: Array) -> Array
```

Read multiple objects by ids (keeps order).

### get_campaign

```gdscript
func get_campaign(id: String) -> CampaignData
```

Campaigns helpers.
Get Campaign by ID

### get_campaigns

```gdscript
func get_campaigns(ids: Array) -> Array
```

Get multiple campaigns by IDs

### list_campaigns

```gdscript
func list_campaigns() -> Array
```

List all campaigns

### get_scenario

```gdscript
func get_scenario(id: String) -> ScenarioData
```

Missions helpers.
Get Mission by ID

### get_scenarios

```gdscript
func get_scenarios(ids: Array) -> Array[CampaignData]
```

Get multiple scenarios by IDs

### list_scenarios

```gdscript
func list_scenarios() -> Array[ScenarioData]
```

list all scenarios

### list_scenarios_for_campaign

```gdscript
func list_scenarios_for_campaign(campaign_id: StringName) -> Array[ScenarioData]
```

List all scenarios for a campaign by ID

### get_briefing

```gdscript
func get_briefing(id_or_mission_id: String) -> BriefData
```

Briefing helpers.
Get a briefing by id or by mission id

### get_briefings

```gdscript
func get_briefings(ids: Array) -> Array[BriefData]
```

Get multiple briefings by ids

### list_briefings

```gdscript
func list_briefings() -> Array[BriefData]
```

List all briefings

### get_briefing_for_mission

```gdscript
func get_briefing_for_mission(mission_id: String) -> BriefData
```

Convenience explicit mission briefing resolver.

### get_unit

```gdscript
func get_unit(id: String) -> UnitData
```

Units helpers.
Get unit by ID

### get_units

```gdscript
func get_units(ids: Array) -> Array[UnitData]
```

Get units by IDs

### list_units

```gdscript
func list_units() -> Array[UnitData]
```

List all units

### get_unit_category

```gdscript
func get_unit_category(id: String) -> UnitCategoryData
```

Unit Category helpers.
Get unit category by ID

### get_unit_categories

```gdscript
func get_unit_categories(ids: Array) -> Array[UnitCategoryData]
```

Get unit categories by IDs

### list_unit_categories

```gdscript
func list_unit_categories() -> Array[UnitCategoryData]
```

List all unit categories

### list_recruitable_units

```gdscript
func list_recruitable_units(mission_id: String) -> Array[UnitData]
```

Get list of reqreuitable units for scenario

### v2

```gdscript
func v2(v: Vector2) -> Dictionary
```

Serialization helpers
Serialize Vector2

### v2_from

```gdscript
func v2_from(d: Variant) -> Vector2
```

Deserialize Vector2

### v2arr_serialize

```gdscript
func v2arr_serialize(a: PackedVector2Array) -> Array
```

Serialize PackedVector2Array

### v2arr_deserialize

```gdscript
func v2arr_deserialize(a: Variant) -> PackedVector2Array
```

deserialize PackedVector2Array

### res_path_or_null

```gdscript
func res_path_or_null(res: Variant) -> Variant
```

serialize a resource

### load_res

```gdscript
func load_res(path: Variant) -> Variant
```

Deserialize a resource

### image_to_png_b64

```gdscript
func image_to_png_b64(img: Image) -> String
```

Serialize a image to Base 64

### png_b64_to_image

```gdscript
func png_b64_to_image(b64: Variant) -> Image
```

Deserialize a image from Base 64

### ids_from_resources

```gdscript
func ids_from_resources(arr: Array, id_prop: String = "id") -> Array
```

Serialize resources to IDs

### resources_from_ids

```gdscript
func resources_from_ids(ids: Array, loader: Callable) -> Array
```

Deserialize resources from IDs

### safe_dup

```gdscript
func safe_dup(v: Variant) -> Variant
```

Safely duplicate a dictionary or array

## Member Data Documentation

### _cache

```gdscript
var _cache: Dictionary
```

Cache loaded objects by absolute path.
