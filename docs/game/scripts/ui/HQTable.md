# HQTable Class Reference

*File:* `scripts/ui/HQTable.gd`
*Class name:* `HQTable`
*Inherits:* `Node3D`

## Synopsis

```gdscript
class_name HQTable
extends Node3D
```

## Public Member Functions

- [`func _ready() -> void`](HQTable/functions/_ready.md) — Initialize mission systems and bind services.
- [`func _init_drawing_controller() -> void`](HQTable/functions/_init_drawing_controller.md) — Initialize the drawing controller and bind to trigger API
- [`func _init_counter_controller() -> void`](HQTable/functions/_init_counter_controller.md) — Initialize the counter controller and bind to trigger API
- [`func _init_document_controller(scenario: ScenarioData) -> void`](HQTable/functions/_init_document_controller.md) — Initialize the document controller and render documents
- [`func _on_radio_transcript_player_early(text: String) -> void`](HQTable/functions/_on_radio_transcript_player_early.md) — Handle player radio result for transcript
- [`func _on_radio_transcript_ai(level: String, text: String) -> void`](HQTable/functions/_on_radio_transcript_ai.md) — Handle AI radio messages for transcript
- [`func _on_unit_voice_transcript(callsign: String, message: String) -> void`](HQTable/functions/_on_unit_voice_transcript.md) — Handle unit voice responses for transcript (both acknowledgments and auto-responses)
- [`func _extract_speaker_from_message(text: String) -> String`](HQTable/functions/_extract_speaker_from_message.md) — Extract speaker callsign from message text if present, otherwise return "HQ".
- [`func _init_combat_controllers() -> void`](HQTable/functions/_init_combat_controllers.md) — Bind artillery and engineer controllers to trigger API for tracking
- [`func _init_tts_system() -> void`](HQTable/functions/_init_tts_system.md) — Initialize TTS service and wire up unit voice responses
- [`func _wire_logistics_warnings() -> void`](HQTable/functions/_wire_logistics_warnings.md) — Wire up ammo/fuel warning signals to auto-response system.
- [`func _on_ammo_low(unit_id: String) -> void`](HQTable/functions/_on_ammo_low.md) — Handle ammo low warning.
- [`func _on_ammo_critical(unit_id: String) -> void`](HQTable/functions/_on_ammo_critical.md) — Handle ammo critical warning.
- [`func _on_fuel_low(unit_id: String) -> void`](HQTable/functions/_on_fuel_low.md) — Handle fuel low warning.
- [`func _on_fuel_critical(unit_id: String) -> void`](HQTable/functions/_on_fuel_critical.md) — Handle fuel critical warning.
- [`func _on_radio_message(_level: String, text: String) -> void`](HQTable/functions/_on_radio_message.md) — Handle radio messages from SimWorld (trigger API, ammo/fuel warnings, etc.)
- [`func _exit_tree() -> void`](HQTable/functions/_exit_tree.md) — Clean up when exiting (clears session drawings)
- [`func generate_playable_units(slots: Array[UnitSlotData]) -> Array[ScenarioUnit]`](HQTable/functions/generate_playable_units.md) — Build the list of playable units from scenario slots and current loadout.
- [`func _on_radio_on() -> void`](HQTable/functions/_on_radio_on.md) — Handle radio PTT pressed
- [`func _on_radio_off() -> void`](HQTable/functions/_on_radio_off.md) — Handle radio PTT released
- [`func _on_radio_partial(text: String) -> void`](HQTable/functions/_on_radio_partial.md) — Handle partial speech recognition
- [`func _on_radio_result(text: String) -> void`](HQTable/functions/_on_radio_result.md) — Handle final speech recognition result
- [`func _update_subtitle_suggestions(scenario: ScenarioData) -> void`](HQTable/functions/_update_subtitle_suggestions.md) — Update subtitle suggestions with terrain labels and unit callsigns
- [`func _create_initial_unit_counters(playable_units: Array[ScenarioUnit]) -> void`](HQTable/functions/_create_initial_unit_counters.md)
- [`func _terrain_pos_to_world(pos_m: Vector2) -> Variant`](HQTable/functions/_terrain_pos_to_world.md) — Convert terrain 2D position to 3D world position on the map.
- [`func _init_test_scenario() -> void`](HQTable/functions/_init_test_scenario.md)
- [`func _init_enemy_ai() -> void`](HQTable/functions/_init_enemy_ai.md)

## Public Attributes

- `SimWorld sim` — Headquarter table bootstrapper for a mission.
- `MapController map`
- `TerrainRender renderer`
- `Control debug_overlay`
- `TriggerEngine trigger_engine`
- `Camera3D camera`
- `Control radio_subtitles`
- `Radio radio`
- `Control loading_screen`
- `Control mission_dialog`
- `DrawingController drawing_controller`
- `UnitCounterController counter_controller`
- `DocumentController document_controller`
- `UnitVoiceResponses unit_voices`
- `UnitAutoResponses unit_auto_voices`
- `AudioStreamPlayer tts_player`
- `AIController ai_controller`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Initialize mission systems and bind services.

### _init_drawing_controller

```gdscript
func _init_drawing_controller() -> void
```

Initialize the drawing controller and bind to trigger API

### _init_counter_controller

```gdscript
func _init_counter_controller() -> void
```

Initialize the counter controller and bind to trigger API

### _init_document_controller

```gdscript
func _init_document_controller(scenario: ScenarioData) -> void
```

Initialize the document controller and render documents

### _on_radio_transcript_player_early

```gdscript
func _on_radio_transcript_player_early(text: String) -> void
```

Handle player radio result for transcript

### _on_radio_transcript_ai

```gdscript
func _on_radio_transcript_ai(level: String, text: String) -> void
```

Handle AI radio messages for transcript

### _on_unit_voice_transcript

```gdscript
func _on_unit_voice_transcript(callsign: String, message: String) -> void
```

Handle unit voice responses for transcript (both acknowledgments and auto-responses)

### _extract_speaker_from_message

```gdscript
func _extract_speaker_from_message(text: String) -> String
```

Extract speaker callsign from message text if present, otherwise return "HQ".
Handles formats: "ALPHA: message", "ALPHA message", or plain messages.

### _init_combat_controllers

```gdscript
func _init_combat_controllers() -> void
```

Bind artillery and engineer controllers to trigger API for tracking

### _init_tts_system

```gdscript
func _init_tts_system() -> void
```

Initialize TTS service and wire up unit voice responses

### _wire_logistics_warnings

```gdscript
func _wire_logistics_warnings() -> void
```

Wire up ammo/fuel warning signals to auto-response system.

### _on_ammo_low

```gdscript
func _on_ammo_low(unit_id: String) -> void
```

Handle ammo low warning.

### _on_ammo_critical

```gdscript
func _on_ammo_critical(unit_id: String) -> void
```

Handle ammo critical warning.

### _on_fuel_low

```gdscript
func _on_fuel_low(unit_id: String) -> void
```

Handle fuel low warning.

### _on_fuel_critical

```gdscript
func _on_fuel_critical(unit_id: String) -> void
```

Handle fuel critical warning.

### _on_radio_message

```gdscript
func _on_radio_message(_level: String, text: String) -> void
```

Handle radio messages from SimWorld (trigger API, ammo/fuel warnings, etc.)

### _exit_tree

```gdscript
func _exit_tree() -> void
```

Clean up when exiting (clears session drawings)

### generate_playable_units

```gdscript
func generate_playable_units(slots: Array[UnitSlotData]) -> Array[ScenarioUnit]
```

Build the list of playable units from scenario slots and current loadout.
Assigns callsigns, positions, affiliation, and marks them as playable.
`slots` Array of UnitSlotData describing player-assignable slots.
[return] Array[ScenarioUnit] created from the active loadout assignments.

### _on_radio_on

```gdscript
func _on_radio_on() -> void
```

Handle radio PTT pressed

### _on_radio_off

```gdscript
func _on_radio_off() -> void
```

Handle radio PTT released

### _on_radio_partial

```gdscript
func _on_radio_partial(text: String) -> void
```

Handle partial speech recognition

### _on_radio_result

```gdscript
func _on_radio_result(text: String) -> void
```

Handle final speech recognition result

### _update_subtitle_suggestions

```gdscript
func _update_subtitle_suggestions(scenario: ScenarioData) -> void
```

Update subtitle suggestions with terrain labels and unit callsigns

### _create_initial_unit_counters

```gdscript
func _create_initial_unit_counters(playable_units: Array[ScenarioUnit]) -> void
```

### _terrain_pos_to_world

```gdscript
func _terrain_pos_to_world(pos_m: Vector2) -> Variant
```

Convert terrain 2D position to 3D world position on the map.
`pos_m` Terrain position in meters (Vector2).
[return] World position as Vector3, or null if conversion fails.

### _init_test_scenario

```gdscript
func _init_test_scenario() -> void
```

### _init_enemy_ai

```gdscript
func _init_enemy_ai() -> void
```

## Member Data Documentation

### sim

```gdscript
var sim: SimWorld
```

Decorators: `@onready`

Headquarter table bootstrapper for a mission.

Sets up terrain, simulation world, radio pipeline, and speech word list.
Generates playable units from scenario slots and binds controllers.

### map

```gdscript
var map: MapController
```

### renderer

```gdscript
var renderer: TerrainRender
```

### debug_overlay

```gdscript
var debug_overlay: Control
```

### trigger_engine

```gdscript
var trigger_engine: TriggerEngine
```

### camera

```gdscript
var camera: Camera3D
```

### radio_subtitles

```gdscript
var radio_subtitles: Control
```

### radio

```gdscript
var radio: Radio
```

### loading_screen

```gdscript
var loading_screen: Control
```

### mission_dialog

```gdscript
var mission_dialog: Control
```

### drawing_controller

```gdscript
var drawing_controller: DrawingController
```

### counter_controller

```gdscript
var counter_controller: UnitCounterController
```

### document_controller

```gdscript
var document_controller: DocumentController
```

### unit_voices

```gdscript
var unit_voices: UnitVoiceResponses
```

### unit_auto_voices

```gdscript
var unit_auto_voices: UnitAutoResponses
```

### tts_player

```gdscript
var tts_player: AudioStreamPlayer
```

### ai_controller

```gdscript
var ai_controller: AIController
```
