class_name ScenarioEditorIDGenerator
extends RefCounted
## Helper for generating unique IDs and callsigns in the Scenario Editor.
##
## Handles generation of slot keys, trigger IDs, callsigns (with NATO defaults),
## and unit instance IDs while ensuring uniqueness.

## Default NATO-style callsigns for friendly units
const DEFAULT_FRIENDLY_CALLSIGNS: Array[String] = [
	"ALPHA",
	"BRAVO",
	"CHARLIE",
	"DELTA",
	"ECHO",
	"FOXTROT",
	"GOLF",
	"HOTEL",
	"INDIA",
	"JULIET",
	"KILO",
	"LIMA",
	"MIKE",
	"NOVEMBER",
	"OSCAR",
	"PAPA",
	"QUEBEC",
	"ROMEO",
	"SIERRA",
	"TANGO",
	"UNIFORM",
	"VICTOR",
	"WHISKEY",
	"XRAY",
	"YANKEE",
	"ZULU"
]

## Default adversary callsigns for enemy units
const DEFAULT_ENEMY_CALLSIGNS: Array[String] = [
	"VICTOR",
	"BORIS",
	"IVAN",
	"SERGEI",
	"ANTON",
	"PAVEL",
	"DIMITRI",
	"MIKHAIL",
	"OSKAR",
	"YURI",
	"EGOR",
	"STEFAN",
	"NIKLAS",
	"ROLF",
	"GUNTER",
	"KLAUS",
	"DIETER",
	"HORST",
	"HELMUT",
	"ERICH",
	"MANFRED",
	"JURGEN",
	"ALARIC",
	"KONRAD",
	"ULRICH",
	"RUDOLF",
	"HENRIK",
	"VOLKMAR",
	"FALKO",
	"LEONID"
]

## Reference to parent ScenarioEditor
var editor: ScenarioEditor


## Initialize with parent editor reference.
## [param parent] Parent ScenarioEditor instance.
func init(parent: ScenarioEditor) -> void:
	editor = parent


## Generate next unique slot key (SLOT_n).
## [return] Unique slot key string.
func next_slot_key() -> String:
	var n := 1
	if editor.ctx.data and editor.ctx.data.unit_slots:
		n = editor.ctx.data.unit_slots.size() + 1
	return "SLOT_%d" % n


## Generate next unique trigger id (TRG_n).
## [return] Unique trigger ID string.
func generate_trigger_id() -> String:
	var used := {}
	if editor.ctx.data and editor.ctx.data.triggers:
		for t in editor.ctx.data.triggers:
			if t and t.id is String and (t.id as String).begins_with("TRG_"):
				var s := (t.id as String).substr(4)
				if s.is_valid_int():
					used[int(s)] = true
	var n := 1
	while used.has(n):
		n += 1
	return "TRG_%d" % n


## Compute next available callsign for given affiliation.
## [param affiliation] Unit affiliation (FRIEND or ENEMY).
## [return] Unique callsign string.
func generate_callsign(affiliation: ScenarioUnit.Affiliation) -> String:
	var pool := get_callsign_pool(affiliation)
	if pool.is_empty():
		return "UNIT"
	var used := collect_used_callsigns(affiliation)
	var cls_wrap := 0
	var idx := 0
	while true:
		var base := pool[idx]
		var candidate := base if (cls_wrap == 0) else "%s-%d" % [base, cls_wrap]
		if not used.has(candidate):
			return candidate
		idx += 1
		if idx >= pool.size():
			idx = 0
			cls_wrap += 1
	return "UNIT"


## Get callsign pool for faction (uses defaults if scenario lacks overrides).
## [param affiliation] Unit affiliation (FRIEND or ENEMY).
## [return] Array of available callsign strings.
func get_callsign_pool(affiliation: ScenarioUnit.Affiliation) -> Array[String]:
	var pool: Array[String]
	if affiliation == ScenarioUnit.Affiliation.FRIEND:
		if (
			editor.data
			and editor.data.friendly_callsigns
			and editor.data.friendly_callsigns.size() > 0
		):
			pool = editor.data.friendly_callsigns
		else:
			pool = DEFAULT_FRIENDLY_CALLSIGNS
	else:
		if editor.data and editor.data.enemy_callsigns and editor.data.enemy_callsigns.size() > 0:
			pool = editor.data.enemy_callsigns
		else:
			pool = DEFAULT_ENEMY_CALLSIGNS
	var out: Array[String] = []
	for v in pool:
		out.append(str(v))
	return out


## Build set of already-used callsigns for uniqueness checks.
## [param affiliation] Unit affiliation (FRIEND or ENEMY).
## [return] Dictionary of used callsigns (keys are callsigns).
func collect_used_callsigns(affiliation: ScenarioUnit.Affiliation) -> Dictionary:
	var used := {}
	if editor.ctx.data == null:
		return used
	if editor.ctx.data.units:
		for su in editor.ctx.data.units:
			if su and su.affiliation == affiliation:
				var cs := String(su.callsign).strip_edges()
				if not cs.is_empty():
					used[cs] = true
	if editor.ctx.data.unit_slots and affiliation == ScenarioUnit.Affiliation.FRIEND:
		for s in editor.ctx.data.unit_slots:
			if s:
				var title := String(s.title).strip_edges()
				if not title.is_empty():
					used[title] = true
	return used


## Generate unique unit instance id based on UnitData.id.
## [param u] Unit data to generate instance ID for.
## [return] Unique unit instance ID string.
func generate_unit_instance_id_for(u: UnitData) -> String:
	var base := String(u.id)
	if base.is_empty():
		base = "unit"
	var used := {}
	if editor.ctx.data and editor.ctx.data.units:
		var prefix := base + "_"
		for su in editor.ctx.data.units:
			if su and su.unit and String(su.unit.id) == base and su.id is String:
				var sid: String = su.id
				if sid.begins_with(prefix):
					var suffix := sid.substr(prefix.length())
					if suffix.is_valid_int():
						used[int(suffix)] = true
	var n := 1
	while used.has(n):
		n += 1
	return "%s_%d" % [base, n]
