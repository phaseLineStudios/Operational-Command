class_name EnvSoundController
extends Node

@export_category(" Settings ")
## Crossfade duration in seconds for ambience changes.
@export_range(0.1, 20.0, 0.1) var crossfade_time: float = 4.0
## Enable random ambient SFX playback.
@export var enable_ambient_sfx: bool = true
## Minimum seconds between random ambient SFX.
@export_range(0.0, 600.0, 0.1) var ambient_sfx_interval_min: float = 20.0
## Maximum seconds between random ambient SFX.
@export_range(0.0, 600.0, 0.1) var ambient_sfx_interval_max: float = 60.0
## Enable random thunder playback when raining/snowing.
@export var enable_thunder: bool = true
## Minimum seconds between thunder sounds.
@export_range(0.0, 600.0, 0.1) var thunder_interval_min: float = 15.0
## Maximum seconds between thunder sounds.
@export_range(0.0, 600.0, 0.1) var thunder_interval_max: float = 45.0

@export_category("Sounds")
## Ambient sound effects for daytime.
@export var sound_ambient_day: Array[AudioStream]
## Ambient sound effects for nighttime.
@export var sound_ambient_night: Array[AudioStream]
## Short one-shot ambience flavour sound effects.
@export var ambient_sfx: Array[AudioStream]

@export_group("Weather")
## Light rain sound effects.
@export var sound_rain_light: Array[AudioStream]
## Heavy rain sound effects.
@export var sound_rain_heavy: Array[AudioStream]
## Snow sound effects.
@export var sound_snow: Array[AudioStream]
## Light wind sound effects.
@export var sound_wind_light: Array[AudioStream]
## Heavy wind sound effects.
@export var sound_wind_heavy: Array[AudioStream]
## Thunder sound effects.
@export var sound_thunder: Array[AudioStream]

var _scenario: ScenarioData
var _is_day := true
var _has_rain := false
var _has_snow := false
var _ambient_initialized := false
var _ambient_using_a := true
var _precip_using_a: bool = true
var _wind_using_a: bool = true
var _rng := RandomNumberGenerator.new()
var _ambient_sfx_timer := 0.0
var _thunder_timer := 0.0

@onready var _ambient_a: AudioStreamPlayer = $Ambient/StreamA
@onready var _ambient_b: AudioStreamPlayer = $Ambient/StreamB
@onready var _precip_a: AudioStreamPlayer = $WeatherPrecipitation/StreamA
@onready var _precip_b: AudioStreamPlayer = $WeatherPrecipitation/StreamB
@onready var _wind_a: AudioStreamPlayer = $WeatherWind/StreamA
@onready var _wind_b: AudioStreamPlayer = $WeatherWind/StreamB
@onready var _sfx_ambient: AudioStreamPlayer = $SfxAmbient
@onready var _sfx_thunder: AudioStreamPlayer = $SfxThunder


## Initialize timers and random generator.
func _ready() -> void:
	_rng.randomize()
	_reset_timers()
	set_process(true)


## Update random SFX timers.
func _process(dt: float) -> void:
	_update_ambient_sfx(dt)
	_update_thunder(dt)


## Initialize environment sound controller.
func init_env_sounds(scenario: ScenarioData) -> void:
	_scenario = scenario
	_update_ambient_for_scenario(_scenario.hour)
	_update_weather_for_scenario()


## Manually update ambience from an hour-of-day value.
func update_time(seconds: int) -> void:
	var hour := int(seconds / 3600.0)
	_update_ambient_for_scenario(hour)


## Manually update weather ambience from numeric values.
func set_weather(rain_mm_per_hour: float, wind_speed_m: float, use_snow: bool = false) -> void:
	if _scenario == null:
		_scenario = ScenarioData.new()
	_scenario.rain = rain_mm_per_hour
	_scenario.wind_speed_m = wind_speed_m
	_scenario.month = _scenario.month
	_has_snow = use_snow
	_update_weather_for_scenario()


## Reset random SFX timers to a random offset.
func _reset_timers() -> void:
	if ambient_sfx_interval_max > ambient_sfx_interval_min:
		_ambient_sfx_timer = _rng.randf_range(ambient_sfx_interval_min, ambient_sfx_interval_max)
	else:
		_ambient_sfx_timer = max(ambient_sfx_interval_min, 0.0)

	if thunder_interval_max > thunder_interval_min:
		_thunder_timer = _rng.randf_range(thunder_interval_min, thunder_interval_max)
	else:
		_thunder_timer = max(thunder_interval_min, 0.0)


## Update day/night ambient loop based on ScenarioData.
func _update_ambient_for_scenario(time: int) -> void:
	if _scenario == null:
		return

	var is_daytime := _is_day_hour(time)

	if is_daytime == _is_day and _ambient_initialized:
		return

	var list: Array[AudioStream] = sound_ambient_day if is_daytime else sound_ambient_night

	var stream := _pick_random_stream(list)
	_crossfade_ambient(stream)

	_is_day = is_daytime
	_ambient_initialized = stream != null


## Update weather loop from ScenarioData weather values.
func _update_weather_for_scenario() -> void:
	if _scenario == null:
		return

	_update_precip_for_scenario()
	_update_wind_for_scenario()



## Update precipitation (rain/snow) loop.
func _update_precip_for_scenario() -> void:
	var rain_level := _rain_level_from_mm(_scenario.rain)
	var use_snow := _should_use_snow(_scenario)

	_has_snow = use_snow
	_has_rain = rain_level > 0 and not use_snow

	var stream: AudioStream = null

	if use_snow:
		stream = _pick_random_stream(sound_snow)
	elif rain_level == 1:
		stream = _pick_random_stream(sound_rain_light)
	elif rain_level >= 2:
		stream = _pick_random_stream(sound_rain_heavy)

	if stream == null:
		_stop_precip()
	else:
		_crossfade_precip(stream)


## Update wind loop independent of precipitation.
func _update_wind_for_scenario() -> void:
	var wind_level := _wind_level_from_speed(_scenario.wind_speed_m)
	var stream: AudioStream = null

	if wind_level == 1:
		stream = _pick_random_stream(sound_wind_light)
	elif wind_level >= 2:
		stream = _pick_random_stream(sound_wind_heavy)

	if stream == null:
		_stop_wind()
	else:
		_crossfade_wind(stream)


## Returns true if hour is considered daytime.
func _is_day_hour(hour: int) -> bool:
	return hour >= 6 and hour < 19


## Map rain mm/h to 0 (none), 1 (light), 2 (heavy).
func _rain_level_from_mm(rain_mm: float) -> int:
	if rain_mm < 0.1:
		return 0
	if rain_mm < 4.0:
		return 1
	return 2


## Map wind speed m/s to 0 (none), 1 (light), 2 (heavy).
func _wind_level_from_speed(speed_m: float) -> int:
	if speed_m < 2.0:
		return 0
	if speed_m < 8.0:
		return 1
	return 2


## Simple heuristic: use snow in winter months if snow sounds exist.
func _should_use_snow(scenario: ScenarioData) -> bool:
	if sound_snow.is_empty():
		return false

	if scenario.month == 12 or scenario.month == 1 or scenario.month == 2:
		return scenario.rain > 0.1

	return false


## Stop precipitation ambience.
func _stop_precip() -> void:
	_precip_a.stop()
	_precip_b.stop()
	_precip_a.stream = null
	_precip_b.stream = null
	_precip_a.volume_db = 0.0
	_precip_b.volume_db = 0.0
	_has_rain = false
	_has_snow = false


## Stop wind ambience.
func _stop_wind() -> void:
	_wind_a.stop()
	_wind_b.stop()
	_wind_a.stream = null
	_wind_b.stream = null
	_wind_a.volume_db = 0.0
	_wind_b.volume_db = 0.0


## Crossfade to a new ambient loop.
func _crossfade_ambient(new_stream: AudioStream) -> void:
	if new_stream == null:
		return

	var from_player: AudioStreamPlayer = _ambient_a if _ambient_using_a else _ambient_b
	var to_player: AudioStreamPlayer = _ambient_b if _ambient_using_a else _ambient_a

	if from_player.stream == new_stream and from_player.playing:
		return

	to_player.stream = new_stream
	to_player.volume_db = -80.0
	to_player.play()

	var tween := create_tween()
	tween.tween_property(to_player, "volume_db", 0.0, crossfade_time)
	tween.parallel().tween_property(from_player, "volume_db", -80.0, crossfade_time)
	tween.finished.connect(func() -> void:
		from_player.stop()
	)

	_ambient_using_a = not _ambient_using_a


## Crossfade to a new precipitation loop.
func _crossfade_precip(new_stream: AudioStream) -> void:
	if new_stream == null:
		return

	var from_player: AudioStreamPlayer = _precip_a if _precip_using_a else _precip_b
	var to_player: AudioStreamPlayer = _precip_b if _precip_using_a else _precip_a

	if from_player.stream == new_stream and from_player.playing:
		return

	to_player.stream = new_stream
	to_player.volume_db = -80.0
	to_player.play()

	var tween := create_tween()
	tween.tween_property(to_player, "volume_db", 0.0, crossfade_time)
	tween.parallel().tween_property(from_player, "volume_db", -80.0, crossfade_time)
	tween.finished.connect(func() -> void:
		from_player.stop()
	)

	_precip_using_a = not _precip_using_a


## Crossfade to a new wind loop.
func _crossfade_wind(new_stream: AudioStream) -> void:
	if new_stream == null:
		return

	var from_player: AudioStreamPlayer = _wind_a if _wind_using_a else _wind_b
	var to_player: AudioStreamPlayer = _wind_b if _wind_using_a else _wind_a

	if from_player.stream == new_stream and from_player.playing:
		return

	to_player.stream = new_stream
	to_player.volume_db = -80.0
	to_player.play()

	var tween := create_tween()
	tween.tween_property(to_player, "volume_db", 0.0, crossfade_time)
	tween.parallel().tween_property(from_player, "volume_db", -80.0, crossfade_time)
	tween.finished.connect(func() -> void:
		from_player.stop()
	)

	_wind_using_a = not _wind_using_a


## Tick and play random ambient SFX.
func _update_ambient_sfx(delta: float) -> void:
	if not enable_ambient_sfx:
		return
	if ambient_sfx.is_empty():
		return
	if ambient_sfx_interval_min <= 0.0 and ambient_sfx_interval_max <= 0.0:
		return

	_ambient_sfx_timer -= delta
	if _ambient_sfx_timer > 0.0:
		return

	var sfx := _pick_random_stream(ambient_sfx)
	if sfx != null:
		_sfx_ambient.stream = sfx
		_sfx_ambient.play()

	if ambient_sfx_interval_max > ambient_sfx_interval_min:
		_ambient_sfx_timer = _rng.randf_range(ambient_sfx_interval_min, ambient_sfx_interval_max)
	else:
		_ambient_sfx_timer = max(ambient_sfx_interval_min, 0.1)


## Tick and play thunder when raining or snowing.
func _update_thunder(delta: float) -> void:
	if not enable_thunder:
		return
	if not _has_rain and not _has_snow:
		return
	if sound_thunder.is_empty():
		return
	if thunder_interval_min <= 0.0 and thunder_interval_max <= 0.0:
		return

	_thunder_timer -= delta
	if _thunder_timer > 0.0:
		return

	var sfx := _pick_random_stream(sound_thunder)
	if sfx != null:
		_sfx_thunder.stream = sfx
		_sfx_thunder.play()

	if thunder_interval_max > thunder_interval_min:
		_thunder_timer = _rng.randf_range(thunder_interval_min, thunder_interval_max)
	else:
		_thunder_timer = max(thunder_interval_min, 0.1)


## Returns a random AudioStream from list or null if empty.
func _pick_random_stream(list: Array[AudioStream]) -> AudioStream:
	if list.is_empty():
		return null
	if list.size() == 1:
		return list[0]
	var index := _rng.randi_range(0, list.size() - 1)
	return list[index]
