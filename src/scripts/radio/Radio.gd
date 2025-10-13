class_name Radio
extends Node
## Simulated field radio: PTT state, audio FX, and routing to STT.
##
## Plays squelch/static, shows UI state, and opens/closes the mic path to the
## speech recognizer while PTT is active.

signal radio_on
signal radio_off
signal radio_partial(text: String)
signal radio_result(text: String)

## Turn on/off the radio stream
var _tx := false


## Connect to STTService signals.
func _ready() -> void:
	STTService.partial.connect(func(t): emit_signal("radio_partial", t))
	STTService.result.connect(_on_result)
	STTService.error.connect(func(m): push_error("[Radio] STT error: %s" % m))


## Handle PTT input.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.echo:
		return

	if event.is_action_pressed("ptt"):
		_start_tx()
		# prevent UI from also handling it
		get_viewport().set_input_as_handled()
	elif event.is_action_released("ptt"):
		_stop_tx()
		get_viewport().set_input_as_handled()


## Temporary for testing
## TODO Remove this
func _on_result(t):
	LogService.trace("Heard: %s" % t, "Radio.gd:39")
	OrdersParser.parse(t)
	emit_signal("radio_result", t)


## Manually enable the radio / STT.
func _start_tx() -> void:
	if _tx:
		return
	LogService.info("PTT Pressed", "Radio.gd:46")
	_tx = true
	STTService.start()
	emit_signal("radio_on")


## Manually disable the radio / STT.
func _stop_tx() -> void:
	if not _tx:
		return
	_tx = false
	STTService.stop()
	emit_signal("radio_off")
	LogService.info("PTT Released", "Radio.gd:58")


## Ensure we stop capture when the radio node leaves.
func _exit_tree() -> void:
	if _tx:
		_stop_tx()
