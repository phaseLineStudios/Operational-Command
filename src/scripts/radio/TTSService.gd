#class_name TTSService
extends Node
## Piper CLI streaming bridge using piper_gd.

## Emitted when the streaming daemon is ready. Receiver should attach this 
## stream to their own AudioStreamPlayer.
signal stream_ready(stream: AudioStreamGenerator)
## Emitted on streaming error.
signal stream_error(message: String)
## Emitted when a line is sent to Piper (best-effort).
signal speaking_started(text: String)

## Available speaker models.
enum Model { EN_US_MEDIUM_RYAN, EN_US_MEDIUM_NORMAN }

const BASE_PATH := "res://third_party/piper"
const VOICES_PATH := BASE_PATH + "/voices"

## Model to use for voice.
@export var model: Model = Model.EN_US_MEDIUM_RYAN
## Audio generator buffer length (sec).
@export var buffer_length_sec := 0.35

var _tts := PiperTTS.new()
var _piper_path := ""
var _model_path := ""
var _config_path := ""
var _sample_rate := 22050

var _gen := AudioStreamGenerator.new()
var _playback: AudioStreamGeneratorPlayback = null

func _ready() -> void:
	_piper_path = _get_platform_binary()
	if _piper_path == "":
		LogService.warning("Could not find piper binary.", "TTSService.gd:_ready")
		return
	if not set_voice(model):
		return
	say("check")


## Check if TTS Service is ready.
## [return] True if the Piper streaming process is running.
func is_ready() -> bool:
	return _tts.is_stream_running()


## Return the current AudioStreamGenerator.
## [return] current AudioStreamGenerator.
func get_stream() -> AudioStreamGenerator:
	return _gen


## Set speaker voice model and restart streaming service.
## [param new_model] New model to use.
## [return] True if model switched, false if failed.
func set_voice(new_model: Model) -> bool:
	var mdl := _get_model_path(new_model)
	if mdl.is_empty():
		LogService.warning("Could not find piper model.", "TTSService.gd:set_voice")
		return false

	_model_path = mdl.get("model", "")
	_config_path = mdl.get("config", "")
	_sample_rate = _read_sample_rate(_config_path, 22050)

	_gen = AudioStreamGenerator.new()
	_gen.mix_rate = _sample_rate
	_gen.buffer_length = buffer_length_sec

	emit_signal("stream_ready", _gen)
	call_deferred("emit_signal", "stream_ready", _gen)

	var ok := _tts.start_stream(
		_abs_path(_piper_path),
		_abs_path(_model_path),
		_abs_path(_config_path),
		_sample_rate
	)
	if not ok:
		LogService.error("Failed to start Piper streaming process.", "TTSService.gd:81")
		emit_signal("stream_error", "Failed to start Piper streaming process.")
		return false

	LogService.trace("Streaming TTS started (%s @ %d Hz)" % [Model.keys()[new_model], _sample_rate], "TTSService.gd:set_voice")
	return true


## Register the consumer's playback so we can push frames into it.
## [param playback] The player's stream playback.
func register_playback(playback: AudioStreamGeneratorPlayback) -> void:
	_playback = playback
	_tts.set_playback(_playback)
	LogService.trace("Registered playback.", "TTSService.gd:register_playback")


## Register by passing the player's node (sets stream & plays).
## [param player] The player to register for playback.
func register_player(player: AudioStreamPlayer) -> void:
	player.stream = _gen
	player.play()
	LogService.trace("Registered player.", "TTSService.gd:register_player")
	register_playback(player.get_stream_playback() as AudioStreamGeneratorPlayback)


## Generate a TTS response (async).
## [param text] The text to speak.
## [return] True if speaking started.
func say(text: String) -> bool:
	if not _tts.is_stream_running():
		return false
	emit_signal("speaking_started", text)
	LogService.trace("speaking started", "TTSService.gd:say")
	return _tts.say_stream(text)


## Pull bytes from the extension and push frames (if playback registered).
func _process(_dt: float) -> void:
	_tts.pump()


## Stop stream thread to avoid hang on exit.
func _exit_tree() -> void:
	_tts.stop_stream()


## Helper: Read sample rate from model config.
## [param cfg_res_path] res:// path to model config.
## [param fallback] Fallback sample rate.
## [return] Model sample rate.
func _read_sample_rate(cfg_res_path: String, fallback: int) -> int:
	var sr := fallback
	var path := _abs_path(cfg_res_path)
	if FileAccess.file_exists(path):
		var s := FileAccess.get_file_as_string(path)
		var j: Dictionary = JSON.parse_string(s)
		if typeof(j) == TYPE_DICTIONARY and j.has("sample_rate"):
			sr = int(j["sample_rate"])
	return sr

## Helper: Get platform specific path for piper binary.
## [return] path to platform specific binary or empty string for unknown.
func _get_platform_binary() -> String:
	match OS.get_name():
		"Windows": return BASE_PATH + "/win64/piper.exe"
		"Linux":   return BASE_PATH + "/linux/piper"
		"macOS":   return BASE_PATH + "/macos/piper"
		_:         return ""


## Helper: Get path of selected model.
## [param model] a Model enum identifier.
## [return] Path to model or empty string for unknown.
func _get_model_path(mdl: Model) -> Dictionary:
	if mdl == Model.EN_US_MEDIUM_RYAN:
		return {
			"model": VOICES_PATH + "/medium-en-us/ryan/en_US-ryan-medium.onnx",
			"config": VOICES_PATH + "/medium-en-us/ryan/en_US-ryan-medium.onnx.json",
		}
	elif mdl == Model.EN_US_MEDIUM_NORMAN:
		return {
			"model": VOICES_PATH + "/medium-en-us/ryan/en_US-norman-medium.onnx",
			"config": VOICES_PATH + "/medium-en-us/ryan/en_US-norman-medium.onnx.json",
		}
	return {}

## Helper: returns absolute path
## [param path] res path to translate.
## [return] Returns absolute path.
func _abs_path(path: String) -> String:
	return ProjectSettings.globalize_path(path)
