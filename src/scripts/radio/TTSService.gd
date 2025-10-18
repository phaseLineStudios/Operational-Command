#class_name TTSService
extends Node
## Piper CLI bridge using piper_gd.

## Emitted when TTS message is ready
signal tts_ready(id: int, stream: AudioStreamWAV)
## Emitted when TTS message failed.
signal tts_failed(id: int, message: String)

## Available speaker models.
enum Model { EN_US_MEDIUM_RYAN }

const BASE_PATH := "res://third_party/piper"
const VOICES_PATH := BASE_PATH + "/voices"

## Model to use for voice.
@export var model: Model = Model.EN_US_MEDIUM_RYAN

var _tts := PiperTTS.new()
var _piper_path: String
var _model_path: String
var _config_path: String


func _ready() -> void:
	_piper_path = _get_platform_binary()
	if _piper_path == "":
		LogService.warning("Could not find piper binary.", "TTSService.gd:23")
		push_warning("Could not find piper binary.")
		return
	_tts.set_piper_path(_abs_path(_piper_path))
	
	var mdl := _get_model_path(model)
	if mdl.is_empty():
		LogService.warning("Could not find piper model.", "TTSService.gd:23")
		push_warning("Could not find piper model.")
		return
	
	_model_path = mdl.get("model", "")
	_config_path = mdl.get("config", "")
	_tts.set_voice(_abs_path(_model_path), _abs_path(_config_path))
	
	_tts.synthesis_completed.connect(_on_tts_done)
	_tts.synthesis_failed.connect(_on_tts_failed)


## Check if TTS Service is ready.
## [return] true if ready, false if not.
func is_ready() -> bool:
	return _tts.is_ready()


## Set speaker model.
## [param new_model] New model to use.
## [return] True if model switched, false if failed.
func set_model(new_model: Model) -> bool:
	var mdl := _get_model_path(new_model)
	if mdl.is_empty():
		LogService.warning("Could not find piper model.", "TTSService.gd:23")
		push_warning("Could not find piper model.")
		return false
	
	_model_path = mdl.get("model", "")
	_config_path = mdl.get("config", "")
	_tts.set_voice(_abs_path(_model_path), _abs_path(_config_path))
	return true


## Generate a TTS response (async).
## [param text] The text to speak.
## [return] Request id (>0) on success, 0 if busy, -1 if not ready.
func say(text: String) -> int:
	if not _tts.is_ready():
		push_error("Piper not ready.")
		return -1
	return _tts.synthesize_to_stream_async(text, {})


## Called on tts done.
func _on_tts_done(id: int, stream: AudioStreamWAV) -> void:
	var p := AudioStreamPlayer.new()
	p.stream = stream
	p.bus = "Radio"
	add_child(p)
	p.play()
	emit_signal("tts_ready", id, stream)

## Called on tts failed.
func _on_tts_failed(id: int, message: String) -> void:
	push_warning("TTS failed: %s" % message)
	emit_signal("tts_failed", id, message)


## Get platform specific path for piper binary.
## [return] path to platform specific binary or empty string for unknown.
func _get_platform_binary() -> String:
	var platform := OS.get_name()
	
	if platform == "Windows":
		return BASE_PATH + "/win64/piper.exe"
	elif platform == "Linux":
		return BASE_PATH + "/linux/piper"
	elif platform == "macOS":
		return BASE_PATH + "/macos/piper"
	else:
		return ""


## Get path of selected model.
## [param model] a Model enum identifier.
## [return] Path to model or empty string for unknown.
func _get_model_path(mdl: Model) -> Dictionary:
	if mdl == Model.EN_US_MEDIUM_RYAN:
		return {
			"model": VOICES_PATH + "/medium-en-us/ryan/en_US-ryan-medium.onnx",
			"config": VOICES_PATH + "/medium-en-us/ryan/en_US-ryan-medium.onnx.json",
		}
	else:
		return {}


## Helper: returns absolute path
## [param path] res path to translate.
## [return] Returns absolute path.
func _abs_path(path: String) -> String:
	return ProjectSettings.globalize_path(path)
