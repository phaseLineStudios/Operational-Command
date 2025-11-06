# ScenarioEditorIDGenerator Class Reference

*File:* `scripts/editors/helpers/ScenarioEditorIDGenerator.gd`
*Class name:* `ScenarioEditorIDGenerator`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name ScenarioEditorIDGenerator
extends RefCounted
```

## Brief

Helper for generating unique IDs and callsigns in the Scenario Editor.

## Detailed Description

Handles generation of slot keys, trigger IDs, callsigns (with NATO defaults),
and unit instance IDs while ensuring uniqueness.

## Public Member Functions

- [`func init(parent: ScenarioEditor) -> void`](ScenarioEditorIDGenerator/functions/init.md) — Initialize with parent editor reference.
- [`func next_slot_key() -> String`](ScenarioEditorIDGenerator/functions/next_slot_key.md) — Generate next unique slot key (SLOT_n).
- [`func generate_trigger_id() -> String`](ScenarioEditorIDGenerator/functions/generate_trigger_id.md) — Generate next unique trigger id (TRG_n).
- [`func generate_callsign(affiliation: ScenarioUnit.Affiliation) -> String`](ScenarioEditorIDGenerator/functions/generate_callsign.md) — Compute next available callsign for given affiliation.
- [`func get_callsign_pool(affiliation: ScenarioUnit.Affiliation) -> Array[String]`](ScenarioEditorIDGenerator/functions/get_callsign_pool.md) — Get callsign pool for faction (uses defaults if scenario lacks overrides).
- [`func collect_used_callsigns(affiliation: ScenarioUnit.Affiliation) -> Dictionary`](ScenarioEditorIDGenerator/functions/collect_used_callsigns.md) — Build set of already-used callsigns for uniqueness checks.
- [`func generate_unit_instance_id_for(u: UnitData) -> String`](ScenarioEditorIDGenerator/functions/generate_unit_instance_id_for.md) — Generate unique unit instance id based on UnitData.id.

## Public Attributes

- `ScenarioEditor editor` — Reference to parent ScenarioEditor

## Public Constants

- `const DEFAULT_FRIENDLY_CALLSIGNS: Array[String]` — Default NATO-style callsigns for friendly units
- `const DEFAULT_ENEMY_CALLSIGNS: Array[String]` — Default adversary callsigns for enemy units

## Member Function Documentation

### init

```gdscript
func init(parent: ScenarioEditor) -> void
```

Initialize with parent editor reference.
`parent` Parent ScenarioEditor instance.

### next_slot_key

```gdscript
func next_slot_key() -> String
```

Generate next unique slot key (SLOT_n).
[return] Unique slot key string.

### generate_trigger_id

```gdscript
func generate_trigger_id() -> String
```

Generate next unique trigger id (TRG_n).
[return] Unique trigger ID string.

### generate_callsign

```gdscript
func generate_callsign(affiliation: ScenarioUnit.Affiliation) -> String
```

Compute next available callsign for given affiliation.
`affiliation` Unit affiliation (FRIEND or ENEMY).
[return] Unique callsign string.

### get_callsign_pool

```gdscript
func get_callsign_pool(affiliation: ScenarioUnit.Affiliation) -> Array[String]
```

Get callsign pool for faction (uses defaults if scenario lacks overrides).
`affiliation` Unit affiliation (FRIEND or ENEMY).
[return] Array of available callsign strings.

### collect_used_callsigns

```gdscript
func collect_used_callsigns(affiliation: ScenarioUnit.Affiliation) -> Dictionary
```

Build set of already-used callsigns for uniqueness checks.
`affiliation` Unit affiliation (FRIEND or ENEMY).
[return] Dictionary of used callsigns (keys are callsigns).

### generate_unit_instance_id_for

```gdscript
func generate_unit_instance_id_for(u: UnitData) -> String
```

Generate unique unit instance id based on UnitData.id.
`u` Unit data to generate instance ID for.
[return] Unique unit instance ID string.

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

Reference to parent ScenarioEditor

## Constant Documentation

### DEFAULT_FRIENDLY_CALLSIGNS

```gdscript
const DEFAULT_FRIENDLY_CALLSIGNS: Array[String]
```

Default NATO-style callsigns for friendly units

### DEFAULT_ENEMY_CALLSIGNS

```gdscript
const DEFAULT_ENEMY_CALLSIGNS: Array[String]
```

Default adversary callsigns for enemy units
