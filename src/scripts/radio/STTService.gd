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

var _recording := false
var _committed := ""
var _segment := ""
var _last_partial := ""
var _last_emitted := ""

var _effect: AudioEffectCapture
var _stt: Vosk


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

	_stt = Vosk.new()
	var wordlist = NARules.get_vosk_grammar_words()
	_stt.init_wordlist(ProjectSettings.globalize_path(LANG_MODEL), wordlist)


## Starts streaming mic audio into Vosk.
func start() -> void:
	if _recording:
		return
	_reset_buffers()
	_recording = true
	set_process(true)


## Stops streaming mic audio.
func stop() -> void:
	if not _recording:
		return
	_recording = false
	set_process(false)

	var raw := _stt.result()
	var tail := _extract_final_text(raw)
	if tail.length() > 0:
		_apply_final(tail)

	var full := _build_full_sentence()
	if full.length() > 0:
		emit_signal("result", full)


## Pull audio from the capture bus and feed Vosk in small chunks.
func _process(_dt: float) -> void:
	if not _recording or _effect == null:
		return

	var frames := _effect.get_frames_available()
	if frames <= 0:
		return

	var to_read: int = min(frames, 2048)
	var stereo_buffer: PackedVector2Array = _effect.get_buffer(to_read)

	var accepted := _stt.accept_wave_form_stereo_float(stereo_buffer)
	if accepted:
		var raw := _stt.result()
		var text := _extract_final_text(raw)
		if text.length() > 0:
			_apply_final(text)
			_emit_partial()
	else:
		var p := _stt.partial_result()
		if p.length() > 0:
			var j: Dictionary = JSON.parse_string(p)
			if typeof(j) == TYPE_DICTIONARY and j.has("partial"):
				_update_partial_segment(String(j["partial"]))
				_emit_partial()


## Returns the last final result from the recognizer (non-blocking).
func get_final_result() -> String:
	return _stt.result()


## Returns the latest partial result from the recognizer (non-blocking).
func get_partial() -> String:
	return _stt.partial_result()


## Reset sentence buffers for a new recording session.
func _reset_buffers() -> void:
	_committed = ""
	_segment = ""
	_last_partial = ""
	_last_emitted = ""


## Update the current segment with a new partial.
func _update_partial_segment(partial_text: String) -> void:
	partial_text = partial_text.strip_edges()
	if partial_text == _last_partial:
		return

	# Grow by suffix when possible; otherwise replace the segment (Vosk rewrites).
	if _last_partial != "" and partial_text.begins_with(_last_partial):
		var suffix := partial_text.substr(_last_partial.length()).strip_edges()
		if suffix.length() > 0:
			if _segment.length() == 0:
				_segment = suffix
			else:
				_segment += (" " if not _segment.ends_with(" ") else "") + suffix
	else:
		# Rewrite: drop previous segment and use the new partial as the entire segment.
		_segment = partial_text

	_last_partial = partial_text


## Apply a Vosk final by replacing the current partial segment with final text.
func _apply_final(final_text: String) -> void:
	final_text = final_text.strip_edges()
	_committed = _join_non_empty(_committed, final_text)
	_segment = ""
	_last_partial = ""


## Emit the current accumulated sentence as a partial update.
func _emit_partial() -> void:
	var full := _build_full_sentence()
	if full.length() == 0 or full == _last_emitted:
		return
	_last_emitted = full
	LogService.trace("Partial: %s" % full, "STTService.gd:146")
	emit_signal("partial", full)


## Extract final text from Vosk's result(), which may be JSON or plain text.
func _extract_final_text(raw: String) -> String:
	var s := raw.strip_edges()
	if s.begins_with("{"):
		var j: Dictionary = JSON.parse_string(s)
		if typeof(j) == TYPE_DICTIONARY and j.has("text"):
			return String(j["text"]).strip_edges()
	return s


## Build the visible sentence from committed + segment with single spacing.
func _build_full_sentence() -> String:
	return _join_non_empty(_committed, _segment).strip_edges()


## Join a and b with a single space if both are non-empty.
func _join_non_empty(a: String, b: String) -> String:
	if a.length() == 0:
		return b
	if b.length() == 0:
		return a
	return a + ("" if a.ends_with(" ") else " ") + b

## Return a reference to the current recognizer.
func get_recognizer() -> Vosk:
	return _stt
