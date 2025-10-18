#class_name TTSService
extends Node
## Piper CLI bridge using piper_gd.

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


## Generate a TTS response.
## [param text] The text to say.
## [return] True if TTS was played, false if failed.
func say(text: String) -> bool:
	if not _tts.is_ready():
		push_error("Piper not ready.")
		return false
	var stream := _tts.synthesize_to_stream(text, {})
	if stream:
		var p := AudioStreamPlayer.new()
		p.stream = stream
		add_child(p)
		p.bus = "Radio"
		p.play()
		return true
		
	return false


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
