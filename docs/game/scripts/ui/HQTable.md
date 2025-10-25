# HQTable Class Reference

*File:* `scripts/ui/HQTable.gd`
*Class name:* `HQTable`
*Inherits:* `Node3D`

## Synopsis

```gdscript
class_name HQTable
extends Node3D
```

## Brief

Headquarter table bootstrapper for a mission.

## Detailed Description

Sets up terrain, simulation world, radio pipeline, and speech word list.
Generates playable units from scenario slots and binds controllers.

## Public Member Functions

- [`func _ready() -> void`](HQTable/functions/_ready.md) — Initialize mission systems and bind services.
- [`func generate_playable_units(slots: Array[UnitSlotData]) -> Array[ScenarioUnit]`](HQTable/functions/generate_playable_units.md) — Build the list of playable units from scenario slots and current loadout.

## Public Attributes

- `bool debug` — Enable extra debug paths/overlays in connected systems.
- `SimWorld sim`
- `MapController map`
- `Control debug_overlay`
- `SpeechWordlistUpdater wordlist`
- `TriggerEngine trigger_engine`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Initialize mission systems and bind services.

### generate_playable_units

```gdscript
func generate_playable_units(slots: Array[UnitSlotData]) -> Array[ScenarioUnit]
```

Build the list of playable units from scenario slots and current loadout.
Assigns callsigns, positions, affiliation, and marks them as playable.
`slots` Array of UnitSlotData describing player-assignable slots.
[return] Array[ScenarioUnit] created from the active loadout assignments.

## Member Data Documentation

### debug

```gdscript
var debug: bool
```

Decorators: `@export`

Enable extra debug paths/overlays in connected systems.

### sim

```gdscript
var sim: SimWorld
```

### map

```gdscript
var map: MapController
```

### debug_overlay

```gdscript
var debug_overlay: Control
```

### wordlist

```gdscript
var wordlist: SpeechWordlistUpdater
```

### trigger_engine

```gdscript
var trigger_engine: TriggerEngine
```
