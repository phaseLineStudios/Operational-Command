# EnvSoundController Class Reference

*File:* `scripts/audio/EnvSoundController.gd`
*Class name:* `EnvSoundController`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name EnvSoundController
extends Node
```

## Public Member Functions

- [`func _ready() -> void`](EnvSoundController/functions/_ready.md) — Initialize timers and random generator.
- [`func _setup_timers() -> void`](EnvSoundController/functions/_setup_timers.md) — Setup Timer nodes for ambient SFX and thunder instead of _process() updates.
- [`func init_env_sounds(scenario: ScenarioData) -> void`](EnvSoundController/functions/init_env_sounds.md) — Initialize environment sound controller.
- [`func update_time(seconds: int) -> void`](EnvSoundController/functions/update_time.md) — Manually update ambience from an hour-of-day value.
- [`func set_weather(rain_mm_per_hour: float, wind_speed_m: float, use_snow: bool = false) -> void`](EnvSoundController/functions/set_weather.md) — Manually update weather ambience from numeric values.
- [`func _reset_timers() -> void`](EnvSoundController/functions/_reset_timers.md) — Reset random SFX timers to a random offset.
- [`func _update_ambient_for_scenario(time: int) -> void`](EnvSoundController/functions/_update_ambient_for_scenario.md) — Update day/night ambient loop based on ScenarioData.
- [`func _update_weather_for_scenario() -> void`](EnvSoundController/functions/_update_weather_for_scenario.md) — Update weather loop from ScenarioData weather values.
- [`func _update_precip_for_scenario() -> void`](EnvSoundController/functions/_update_precip_for_scenario.md) — Update precipitation (rain/snow) loop.
- [`func _update_wind_for_scenario() -> void`](EnvSoundController/functions/_update_wind_for_scenario.md) — Update wind loop independent of precipitation.
- [`func _is_day_hour(hour: int) -> bool`](EnvSoundController/functions/_is_day_hour.md) — Returns true if hour is considered daytime.
- [`func _rain_level_from_mm(rain_mm: float) -> int`](EnvSoundController/functions/_rain_level_from_mm.md) — Map rain mm/h to 0 (none), 1 (light), 2 (heavy).
- [`func _wind_level_from_speed(speed_m: float) -> int`](EnvSoundController/functions/_wind_level_from_speed.md) — Map wind speed m/s to 0 (none), 1 (light), 2 (heavy).
- [`func _should_use_snow(scenario: ScenarioData) -> bool`](EnvSoundController/functions/_should_use_snow.md) — Simple heuristic: use snow in winter months if snow sounds exist.
- [`func _stop_precip() -> void`](EnvSoundController/functions/_stop_precip.md) — Stop precipitation ambience.
- [`func _stop_wind() -> void`](EnvSoundController/functions/_stop_wind.md) — Stop wind ambience.
- [`func _crossfade_ambient(new_stream: AudioStream) -> void`](EnvSoundController/functions/_crossfade_ambient.md) — Crossfade to a new ambient loop.
- [`func _crossfade_precip(new_stream: AudioStream) -> void`](EnvSoundController/functions/_crossfade_precip.md) — Crossfade to a new precipitation loop.
- [`func _crossfade_wind(new_stream: AudioStream) -> void`](EnvSoundController/functions/_crossfade_wind.md) — Crossfade to a new wind loop.
- [`func _on_ambient_sfx_timeout() -> void`](EnvSoundController/functions/_on_ambient_sfx_timeout.md) — Called when ambient SFX timer times out.
- [`func _on_thunder_timeout() -> void`](EnvSoundController/functions/_on_thunder_timeout.md) — Called when thunder timer times out.
- [`func _pick_random_stream(list: Array[AudioStream]) -> AudioStream`](EnvSoundController/functions/_pick_random_stream.md) — Returns a random AudioStream from list or null if empty.

## Public Attributes

- `float crossfade_time` — Crossfade duration in seconds for ambience changes.
- `bool enable_ambient_sfx` — Enable random ambient SFX playback.
- `float ambient_sfx_interval_min` — Minimum seconds between random ambient SFX.
- `float ambient_sfx_interval_max` — Maximum seconds between random ambient SFX.
- `bool enable_thunder` — Enable random thunder playback when raining/snowing.
- `float thunder_interval_min` — Minimum seconds between thunder sounds.
- `float thunder_interval_max` — Maximum seconds between thunder sounds.
- `Array[AudioStream] sound_ambient_day` — Ambient sound effects for daytime.
- `Array[AudioStream] sound_ambient_night` — Ambient sound effects for nighttime.
- `Array[AudioStream] ambient_sfx` — Short one-shot ambience flavour sound effects.
- `Array[AudioStream] sound_rain_light` — Light rain sound effects.
- `Array[AudioStream] sound_rain_heavy` — Heavy rain sound effects.
- `Array[AudioStream] sound_snow` — Snow sound effects.
- `Array[AudioStream] sound_wind_light` — Light wind sound effects.
- `Array[AudioStream] sound_wind_heavy` — Heavy wind sound effects.
- `Array[AudioStream] sound_thunder` — Thunder sound effects.
- `ScenarioData _scenario`
- `bool _precip_using_a`
- `bool _wind_using_a`
- `Timer _ambient_sfx_timer`
- `Timer _thunder_timer`
- `AudioStreamPlayer _ambient_a`
- `AudioStreamPlayer _ambient_b`
- `AudioStreamPlayer _precip_a`
- `AudioStreamPlayer _precip_b`
- `AudioStreamPlayer _wind_a`
- `AudioStreamPlayer _wind_b`
- `AudioStreamPlayer _sfx_ambient`
- `AudioStreamPlayer _sfx_thunder`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Initialize timers and random generator.

### _setup_timers

```gdscript
func _setup_timers() -> void
```

Setup Timer nodes for ambient SFX and thunder instead of _process() updates.

### init_env_sounds

```gdscript
func init_env_sounds(scenario: ScenarioData) -> void
```

Initialize environment sound controller.

### update_time

```gdscript
func update_time(seconds: int) -> void
```

Manually update ambience from an hour-of-day value.

### set_weather

```gdscript
func set_weather(rain_mm_per_hour: float, wind_speed_m: float, use_snow: bool = false) -> void
```

Manually update weather ambience from numeric values.

### _reset_timers

```gdscript
func _reset_timers() -> void
```

Reset random SFX timers to a random offset.

### _update_ambient_for_scenario

```gdscript
func _update_ambient_for_scenario(time: int) -> void
```

Update day/night ambient loop based on ScenarioData.

### _update_weather_for_scenario

```gdscript
func _update_weather_for_scenario() -> void
```

Update weather loop from ScenarioData weather values.

### _update_precip_for_scenario

```gdscript
func _update_precip_for_scenario() -> void
```

Update precipitation (rain/snow) loop.

### _update_wind_for_scenario

```gdscript
func _update_wind_for_scenario() -> void
```

Update wind loop independent of precipitation.

### _is_day_hour

```gdscript
func _is_day_hour(hour: int) -> bool
```

Returns true if hour is considered daytime.

### _rain_level_from_mm

```gdscript
func _rain_level_from_mm(rain_mm: float) -> int
```

Map rain mm/h to 0 (none), 1 (light), 2 (heavy).

### _wind_level_from_speed

```gdscript
func _wind_level_from_speed(speed_m: float) -> int
```

Map wind speed m/s to 0 (none), 1 (light), 2 (heavy).

### _should_use_snow

```gdscript
func _should_use_snow(scenario: ScenarioData) -> bool
```

Simple heuristic: use snow in winter months if snow sounds exist.

### _stop_precip

```gdscript
func _stop_precip() -> void
```

Stop precipitation ambience.

### _stop_wind

```gdscript
func _stop_wind() -> void
```

Stop wind ambience.

### _crossfade_ambient

```gdscript
func _crossfade_ambient(new_stream: AudioStream) -> void
```

Crossfade to a new ambient loop.

### _crossfade_precip

```gdscript
func _crossfade_precip(new_stream: AudioStream) -> void
```

Crossfade to a new precipitation loop.

### _crossfade_wind

```gdscript
func _crossfade_wind(new_stream: AudioStream) -> void
```

Crossfade to a new wind loop.

### _on_ambient_sfx_timeout

```gdscript
func _on_ambient_sfx_timeout() -> void
```

Called when ambient SFX timer times out.

### _on_thunder_timeout

```gdscript
func _on_thunder_timeout() -> void
```

Called when thunder timer times out.

### _pick_random_stream

```gdscript
func _pick_random_stream(list: Array[AudioStream]) -> AudioStream
```

Returns a random AudioStream from list or null if empty.

## Member Data Documentation

### crossfade_time

```gdscript
var crossfade_time: float
```

Decorators: `@export_range(0.1, 20.0, 0.1)`

Crossfade duration in seconds for ambience changes.

### enable_ambient_sfx

```gdscript
var enable_ambient_sfx: bool
```

Decorators: `@export`

Enable random ambient SFX playback.

### ambient_sfx_interval_min

```gdscript
var ambient_sfx_interval_min: float
```

Decorators: `@export_range(0.0, 600.0, 0.1)`

Minimum seconds between random ambient SFX.

### ambient_sfx_interval_max

```gdscript
var ambient_sfx_interval_max: float
```

Decorators: `@export_range(0.0, 600.0, 0.1)`

Maximum seconds between random ambient SFX.

### enable_thunder

```gdscript
var enable_thunder: bool
```

Decorators: `@export`

Enable random thunder playback when raining/snowing.

### thunder_interval_min

```gdscript
var thunder_interval_min: float
```

Decorators: `@export_range(0.0, 600.0, 0.1)`

Minimum seconds between thunder sounds.

### thunder_interval_max

```gdscript
var thunder_interval_max: float
```

Decorators: `@export_range(0.0, 600.0, 0.1)`

Maximum seconds between thunder sounds.

### sound_ambient_day

```gdscript
var sound_ambient_day: Array[AudioStream]
```

Decorators: `@export`

Ambient sound effects for daytime.

### sound_ambient_night

```gdscript
var sound_ambient_night: Array[AudioStream]
```

Decorators: `@export`

Ambient sound effects for nighttime.

### ambient_sfx

```gdscript
var ambient_sfx: Array[AudioStream]
```

Decorators: `@export`

Short one-shot ambience flavour sound effects.

### sound_rain_light

```gdscript
var sound_rain_light: Array[AudioStream]
```

Decorators: `@export`

Light rain sound effects.

### sound_rain_heavy

```gdscript
var sound_rain_heavy: Array[AudioStream]
```

Decorators: `@export`

Heavy rain sound effects.

### sound_snow

```gdscript
var sound_snow: Array[AudioStream]
```

Decorators: `@export`

Snow sound effects.

### sound_wind_light

```gdscript
var sound_wind_light: Array[AudioStream]
```

Decorators: `@export`

Light wind sound effects.

### sound_wind_heavy

```gdscript
var sound_wind_heavy: Array[AudioStream]
```

Decorators: `@export`

Heavy wind sound effects.

### sound_thunder

```gdscript
var sound_thunder: Array[AudioStream]
```

Decorators: `@export`

Thunder sound effects.

### _scenario

```gdscript
var _scenario: ScenarioData
```

### _precip_using_a

```gdscript
var _precip_using_a: bool
```

### _wind_using_a

```gdscript
var _wind_using_a: bool
```

### _ambient_sfx_timer

```gdscript
var _ambient_sfx_timer: Timer
```

### _thunder_timer

```gdscript
var _thunder_timer: Timer
```

### _ambient_a

```gdscript
var _ambient_a: AudioStreamPlayer
```

### _ambient_b

```gdscript
var _ambient_b: AudioStreamPlayer
```

### _precip_a

```gdscript
var _precip_a: AudioStreamPlayer
```

### _precip_b

```gdscript
var _precip_b: AudioStreamPlayer
```

### _wind_a

```gdscript
var _wind_a: AudioStreamPlayer
```

### _wind_b

```gdscript
var _wind_b: AudioStreamPlayer
```

### _sfx_ambient

```gdscript
var _sfx_ambient: AudioStreamPlayer
```

### _sfx_thunder

```gdscript
var _sfx_thunder: AudioStreamPlayer
```
