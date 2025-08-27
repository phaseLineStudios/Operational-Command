extends Node
## Offline speech-to-text capture using Vosk via GDExtension.
##
## Captures microphone audio, applies optional VAD, and submits chunks to
## vosk_gd. Emits transcription results for parsing into orders.

## Emitted on partial recognition
signal partial(text: String)
## Emitted on final recognition
signal result(text: String)
## Emitted on setup or runtime errors
signal error(msg: String)

const BUFFER_LENGTH_FRAMES := 100
const SAMPLE_RATE_HZ := 16000
const CAPTURE_BUS := "Capture"
const LANG_MODEL := "res://third_party/vosk/small-en-us"

var _effect : AudioEffectCapture
var _stt: Vosk
var _recording := false

func _ready() -> void:
	var bus := AudioServer.get_bus_index(CAPTURE_BUS)
	if bus < 0:
		emit_signal("error", "Audio bus '%s' not found." % CAPTURE_BUS)
		return
	
	for i in AudioServer.get_bus_effect_count(bus):
		var eff := AudioServer.get_bus_effect(bus, i)
		if eff is AudioEffectCapture:
			_effect = eff
			break
	if _effect == null:
		emit_signal("error", "No AudioEffectCapture on bus '%s'." % CAPTURE_BUS)
		return
	
	# TODO Use wordslist for more accurate and faster recognition
	_stt = Vosk.new()
	_stt.init(ProjectSettings.globalize_path(LANG_MODEL))

## Starts streaming mic audio into Vosk.
func start() -> void:
	if _recording:
		return
	_recording = true
	set_process(true)

## Stops streaming mic audio.
func stop() -> void:
	if not _recording:
		return
	_recording = false
	set_process(false)

## Pull audio from the capture bus and feed Vosk in small chunks.
func _process(_dt: float) -> void:
	if not _recording or _effect == null:
		return

	# Read stereo float frames from the capture buffer.
	var frames := _effect.get_frames_available()
	if frames <= 0:
		return

	# Limit chunk size to keep latency low.
	var to_read: int = min(frames, 2048)
	var stereo_buffer: PackedVector2Array = _effect.get_buffer(to_read)

	# Feed to native recognizer.
	var accepted := _stt.accept_wave_form_stereo_float(stereo_buffer)
	print("recording")
	if accepted:
		var text := _stt.result()
		if text.length() > 0:
			print(text)
			emit_signal("result", text)
	else:
		var p := _stt.partial_result()
		if p.length() > 0:
			print(p)
			emit_signal("partial", p)

## Returns the last final result from the recognizer (non-blocking).
func get_final_result() -> String:
	return _stt.result()

## Returns the latest partial result from the recognizer (non-blocking).
func get_partial() -> String:
	return _stt.partial_result()
