extends Node
class_name SpeechWordlistUpdater
## Updates the recognizer's word list at mission start using mission callsigns
## and TerrainData.labels texts. Requires recognizer.set_wordlist(String).

## Nodes to wire (auto-fallbacks try %UniqueName)
@export var sim: SimWorld
@export var terrain_renderer: TerrainRender
@export var recognizer: Vosk

## Emitted after updating the grammar.
signal wordlist_updated(count: int)

func _ready() -> void:
	if sim and not sim.is_connected("mission_state_changed", Callable(self, "_on_state_changed")):
		sim.mission_state_changed.connect(_on_state_changed)

	_refresh_wordlist()

func bind_recognizer(r: Vosk) -> void:
	recognizer = r

func _on_state_changed(_prev, next) -> void:
	if str(next).findn("RUN") != -1:
		_refresh_wordlist()

## Collect callsigns and labels, build JSON, and push to recognizer.
func _refresh_wordlist() -> void:
	var callsigns := _collect_mission_callsigns()
	var labels := _collect_terrain_labels()

	var words := NARules.build_vosk_word_array(callsigns, labels)
	var json := JSON.stringify(words)

	if recognizer and recognizer.has_method("set_wordlist"):
		recognizer.set_wordlist(json)
		emit_signal("wordlist_updated", words.size())

## Pull callsigns from scenario units and playable units.
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

## Read label text.
func _collect_terrain_labels() -> Array[String]:
	var out: Array[String] = []
	var data := terrain_renderer.data
	if data == null:
		return out
	var labels := data.labels
	for L in labels:
		var txt := str(L.get("text", "")).strip_edges()
		if txt != "":
			out.append(txt)
	return _dedup_preserve(out)

func _dedup_preserve(arr: Array[String]) -> Array[String]:
	var seen := {}
	var out: Array[String] = []
	for s in arr:
		if not seen.has(s):
			seen[s] = true
			out.append(s)
	return out
