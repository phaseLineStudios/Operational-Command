# SceneEnvironment Class Reference

*File:* `scripts/sim/SceneEnvironment.gd`
*Class name:* `SceneEnvironment`
*Inherits:* `Node3D`

## Synopsis

```gdscript
class_name SceneEnvironment
extends Node3D
```

## Public Member Functions

- [`func _ready() -> void`](SceneEnvironment/functions/_ready.md)
- [`func get_sound_controller() -> EnvSoundController`](SceneEnvironment/functions/get_sound_controller.md)
- [`func get_scenario() -> ScenarioData`](SceneEnvironment/functions/get_scenario.md)
- [`func hide_helpers() -> void`](SceneEnvironment/functions/hide_helpers.md)

## Public Attributes

- `ScenarioData: scenario` — Currently loaded scenario
- `EnvSoundController sound_controller`

## Signals

- `signal scenario_changed(scenario: ScenarioData)` — Emitted when scenario changes.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### get_sound_controller

```gdscript
func get_sound_controller() -> EnvSoundController
```

### get_scenario

```gdscript
func get_scenario() -> ScenarioData
```

### hide_helpers

```gdscript
func hide_helpers() -> void
```

## Member Data Documentation

### scenario

```gdscript
var scenario: ScenarioData:
```

Decorators: `@export`

Currently loaded scenario

### sound_controller

```gdscript
var sound_controller: EnvSoundController
```

## Signal Documentation

### scenario_changed

```gdscript
signal scenario_changed(scenario: ScenarioData)
```

Emitted when scenario changes.
