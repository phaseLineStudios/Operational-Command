class_name RadioSignalModulator
extends Node
## Modulates Radio bus effects to simulate signal strength variation.
## Creates realistic radio fading, interference, and signal dropout.

## Base effect values
const BASE_LOWPASS_CUTOFF: float = 2800.0
const BASE_DISTORTION_DRIVE: float = 0.15

## Signal strength variation parameters
@export var min_signal_strength: float = 0.3
@export var max_signal_strength: float = 1.0
@export var fade_speed: float = 2.0  # How fast signal fades
@export var interference_chance: float = 0.15  # Chance per second of interference

## Radio bus index
var _radio_bus_idx: int = -1
## Effect indices on the Radio bus
var _lowpass_idx: int = 1
var _distortion_idx: int = 2
## Current signal strength (0.0 to 1.0)
var _signal_strength: float = 1.0
## Target signal strength
var _target_strength: float = 1.0
## Interference accumulator
var _interference_timer: float = 0.0


func _ready() -> void:
	_radio_bus_idx = AudioServer.get_bus_index("Radio")
	if _radio_bus_idx == -1:
		push_warning("RadioSignalModulator: Radio bus not found")
		set_process(false)
		return

	# Start with strong signal
	_signal_strength = max_signal_strength
	_target_strength = max_signal_strength


func _process(delta: float) -> void:
	if _radio_bus_idx == -1:
		return

	# Randomly decide to change signal strength
	_interference_timer += delta
	if _interference_timer >= 1.0:
		_interference_timer = 0.0
		if randf() < interference_chance:
			# Signal interference - drop to weak signal
			_target_strength = randf_range(min_signal_strength, min_signal_strength + 0.2)
		else:
			# Normal variation
			_target_strength = randf_range(max_signal_strength - 0.3, max_signal_strength)

	# Smoothly interpolate to target strength
	_signal_strength = lerp(_signal_strength, _target_strength, delta * fade_speed)

	# Modulate low-pass filter (weaker signal = more filtering)
	var lowpass_effect: AudioEffectLowPassFilter = AudioServer.get_bus_effect(
		_radio_bus_idx, _lowpass_idx
	)
	if lowpass_effect:
		# Weaker signal = lower cutoff (more muffled)
		var cutoff: float = lerp(1200.0, BASE_LOWPASS_CUTOFF, _signal_strength)
		lowpass_effect.cutoff_hz = cutoff

	# Modulate distortion (weaker signal = more static/distortion)
	var distortion_effect: AudioEffectDistortion = AudioServer.get_bus_effect(
		_radio_bus_idx, _distortion_idx
	)
	if distortion_effect:
		# Weaker signal = more distortion
		var drive: float = lerp(
			BASE_DISTORTION_DRIVE * 3.0, BASE_DISTORTION_DRIVE, _signal_strength
		)
		distortion_effect.drive = drive

	# Modulate overall bus volume (signal fading)
	var volume_db: float = lerp(-8.0, -2.5, _signal_strength)
	AudioServer.set_bus_volume_db(_radio_bus_idx, volume_db)
