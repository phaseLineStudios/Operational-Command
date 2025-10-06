# Settings Class Reference

*File:* `scripts/ui/Settings.gd`
*Class name:* `Settings`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name Settings
extends Control
```

## Brief

Config path.

## Public Member Functions

- [`func _ready() -> void`](Settings/functions/_ready.md) — Build UI and load config.
- [`func _build_video_ui() -> void`](Settings/functions/_build_video_ui.md) — Populate video controls.
- [`func _build_audio_ui() -> void`](Settings/functions/_build_audio_ui.md) — Create rows for each audio bus.
- [`func _build_controls_ui() -> void`](Settings/functions/_build_controls_ui.md) — Create rebind buttons for actions.
- [`func _connect_signals() -> void`](Settings/functions/_connect_signals.md) — Wire up buttons and live labels.
- [`func _load_config() -> void`](Settings/functions/_load_config.md) — Load config file (if present).
- [`func _apply_ui_from_config() -> void`](Settings/functions/_apply_ui_from_config.md) — Push saved values into UI.
- [`func _apply_and_save() -> void`](Settings/functions/_apply_and_save.md) — Apply settings and persist.
- [`func _reset_defaults() -> void`](Settings/functions/_reset_defaults.md) — Reset to defaults.
- [`func _reset_all_bindings() -> void`](Settings/functions/_reset_all_bindings.md) — Remove custom bindings and restore defaults (uses InputSchema if present).
- [`func _apply_video() -> void`](Settings/functions/_apply_video.md) — Apply video settings to the window/engine.
- [`func _apply_audio() -> void`](Settings/functions/_apply_audio.md) — Apply audio to buses.
- [`func _apply_gameplay() -> void`](Settings/functions/_apply_gameplay.md) — Apply gameplay flags.
- [`func _save_config() -> void`](Settings/functions/_save_config.md) — Save config file.
- [`func _set_bus_volume(bus_name: String, v: float) -> void`](Settings/functions/_set_bus_volume.md) — Set bus volume (linear 0..1).
- [`func _set_bus_mute(bus_name: String, on: bool) -> void`](Settings/functions/_set_bus_mute.md) — Mute/unmute bus.
- [`func linear_to_db(v: float) -> float`](Settings/functions/linear_to_db.md) — Linear→dB helper.
- [`func set_visibility(state: bool)`](Settings/functions/set_visibility.md) — API to set settigns visibility

## Public Attributes

- `Array[String] audio_buses` — Exposed buses.
- `Array[String] actions_to_rebind` — Actions to rebind (must exist in InputMap).
- `Array[Vector2i] resolutions` — Resolution list.
- `Dictionary _bus_rows` — Scene to navigate to on back (leave empty for no action)
- `Button btn_back`
- `Button _btn_apply`
- `Button _btn_defaults`
- `OptionButton _mode`
- `OptionButton _res`
- `CheckBox _vsync`
- `HSlider _scale`
- `Label _scale_val`
- `SpinBox _fps`
- `VBoxContainer _buses_list`
- `VBoxContainer _controls_list`
- `Button _reset_bindings`
- `Button _rebind_template`

## Signals

- `signal back_requested` — Settings controller
Tabs: Video, Audio, Controls, Gameplay.

## Enumerations

- `enum WindowMode` — Window modes.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Build UI and load config.

### _build_video_ui

```gdscript
func _build_video_ui() -> void
```

Populate video controls.

### _build_audio_ui

```gdscript
func _build_audio_ui() -> void
```

Create rows for each audio bus.

### _build_controls_ui

```gdscript
func _build_controls_ui() -> void
```

Create rebind buttons for actions.

### _connect_signals

```gdscript
func _connect_signals() -> void
```

Wire up buttons and live labels.

### _load_config

```gdscript
func _load_config() -> void
```

Load config file (if present).

### _apply_ui_from_config

```gdscript
func _apply_ui_from_config() -> void
```

Push saved values into UI.

### _apply_and_save

```gdscript
func _apply_and_save() -> void
```

Apply settings and persist.

### _reset_defaults

```gdscript
func _reset_defaults() -> void
```

Reset to defaults.

### _reset_all_bindings

```gdscript
func _reset_all_bindings() -> void
```

Remove custom bindings and restore defaults (uses InputSchema if present).

### _apply_video

```gdscript
func _apply_video() -> void
```

Apply video settings to the window/engine.

### _apply_audio

```gdscript
func _apply_audio() -> void
```

Apply audio to buses.

### _apply_gameplay

```gdscript
func _apply_gameplay() -> void
```

Apply gameplay flags.

### _save_config

```gdscript
func _save_config() -> void
```

Save config file.

### _set_bus_volume

```gdscript
func _set_bus_volume(bus_name: String, v: float) -> void
```

Set bus volume (linear 0..1).

### _set_bus_mute

```gdscript
func _set_bus_mute(bus_name: String, on: bool) -> void
```

Mute/unmute bus.

### linear_to_db

```gdscript
func linear_to_db(v: float) -> float
```

Linear→dB helper.

### set_visibility

```gdscript
func set_visibility(state: bool)
```

API to set settigns visibility

## Member Data Documentation

### audio_buses

```gdscript
var audio_buses: Array[String]
```

Exposed buses. Missing buses are ignored.

### actions_to_rebind

```gdscript
var actions_to_rebind: Array[String]
```

Actions to rebind (must exist in InputMap).

### resolutions

```gdscript
var resolutions: Array[Vector2i]
```

Resolution list.

### _bus_rows

```gdscript
var _bus_rows: Dictionary
```

Decorators: `@export var back_scene: PackedScene`

Scene to navigate to on back (leave empty for no action)

### btn_back

```gdscript
var btn_back: Button
```

### _btn_apply

```gdscript
var _btn_apply: Button
```

### _btn_defaults

```gdscript
var _btn_defaults: Button
```

### _mode

```gdscript
var _mode: OptionButton
```

### _res

```gdscript
var _res: OptionButton
```

### _vsync

```gdscript
var _vsync: CheckBox
```

### _scale

```gdscript
var _scale: HSlider
```

### _scale_val

```gdscript
var _scale_val: Label
```

### _fps

```gdscript
var _fps: SpinBox
```

### _buses_list

```gdscript
var _buses_list: VBoxContainer
```

### _controls_list

```gdscript
var _controls_list: VBoxContainer
```

### _reset_bindings

```gdscript
var _reset_bindings: Button
```

### _rebind_template

```gdscript
var _rebind_template: Button
```

## Signal Documentation

### back_requested

```gdscript
signal back_requested
```

Settings controller
Tabs: Video, Audio, Controls, Gameplay. Loads/applies/saves config.

## Enumeration Type Documentation

### WindowMode

```gdscript
enum WindowMode
```

Window modes.
