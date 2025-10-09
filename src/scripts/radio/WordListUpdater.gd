class_name SpeechWordlistUpdater
extends Node
## Updates the speech recognizer's grammar per mission.
##
## Builds a mission-scoped Vosk word list from unit callsigns and
## TerrainData labels, then pushes it to the recognizer.
## On mission start (RUN/RUNNING), it refreshes the list automatically.
## @experimental

## Emitted after the recognizer's word list is updated.
## [param count] Number of entries in the applied word list.
signal wordlist_updated(count: int)

## Simulation world that emits the mission state changes used to trigger refresh.
@export var sim: SimWorld
## Terrain renderer providing access to [member TerrainRender.data.labels].
@export var terrain_renderer: TerrainRender
## Vosk recognizer instance exposing `set_wordlist(String)`.
@export var recognizer: Vosk


## Connects mission state change and performs an initial refresh.
func _ready() -> void:
	if sim and not sim.is_connected("mission_state_changed", Callable(self, "_on_state_changed")):
		sim.mission_state_changed.connect(_on_state_changed)

	_refresh_wordlist()


## Bind or replace the active recognizer.
## Use when the recognizer is created after this node is ready.
## [param r] Recognizer instance exposing `set_wordlist(String)`.
func bind_recognizer(r: Vosk) -> void:
	recognizer = r


## Handles mission state transitions.
## Refreshes the word list when the new state string contains "RUN".
## [param _prev] Previous state (unused).
## [param next] New state token or enum string.
func _on_state_changed(_prev, next) -> void:
	if str(next).findn("RUN") != -1:
		_refresh_wordlist()


## Rebuilds the word list from mission callsigns and map labels,
## serializes it to JSON, and applies it to the recognizer.
func _refresh_wordlist() -> void:
	var callsigns := _collect_mission_callsigns()
	var labels := _collect_terrain_labels()

	var words := NARules.build_vosk_word_array(callsigns, labels)
	var json := JSON.stringify(words)

	if recognizer and recognizer.has_method("set_wordlist"):
		recognizer.set_wordlist(json)
		emit_signal("wordlist_updated", words.size())


## Collects callsigns from both scenario units and playable units.
## Returns a lowercase, de-duplicated list.
## [return] Array[String] of callsigns.
func _collect_mission_callsigns() -> Array[String]:
	var out: Array[String] = []
	var scen := Game.current_scenario
	if scen == null:
		return out
	for su in scen.units:
		if su != null and su.callsign != "":
			out.append(su.callsign.to_lower())
	for su in scen.playable_units:
		if su != null and su.callsign != "":
			out.append(su.callsign.to_lower())
	return _dedup_preserve(out)


## Extracts map label texts from [member TerrainRender.data.labels].
## Returns a de-duplicated list (original casing).
## [return] Array[String] of label texts.
func _collect_terrain_labels() -> Array[String]:
	var out: Array[String] = []
	var data := terrain_renderer.data
	if data == null:
		return out
	var labels := data.labels
	for label in labels:
		var txt := str(label.get("text", "")).strip_edges()
		if txt != "":
			out.append(txt)
	return _dedup_preserve(out)


## De-duplicates an array while preserving order.
## [param arr] Input list.
## [return] New list with unique items, first occurrence kept.
func _dedup_preserve(arr: Array[String]) -> Array[String]:
	var seen := {}
	var out: Array[String] = []
	for s in arr:
		if not seen.has(s):
			seen[s] = true
			out.append(s)
	return out
