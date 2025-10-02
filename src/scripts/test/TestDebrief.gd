extends Node

@export var debrief_scene: PackedScene  # assign in Inspector if using as standalone

var _debrief: Debrief

func _ready() -> void:
	# Use existing Debrief if we're a child of one; else instantiate from export
	if get_parent() is Debrief:
		_debrief = get_parent() as Debrief
	elif debrief_scene:
		_debrief = debrief_scene.instantiate()
		add_child(_debrief)
	else:
		push_error("TestDebrief: no Debrief instance available. Assign debrief_scene or place this node under a Debrief.")
		return

	# Verify project data structures and print what we found
	_verify_project_types()

	# Connect signals
	_debrief.continue_requested.connect(_on_continue)
	_debrief.retry_requested.connect(_on_retry)
	_debrief.commendation_assigned.connect(_on_award)

	# Build realistic test data, preferring your real classes if present
	var objectives := _make_objective_results()
	var units := _make_units()

	# Fill UI using the public API
	_debrief.set_mission_name("Operation Silent Harbor")
	_debrief.set_outcome("Success")
	_debrief.set_objectives_results(objectives)
	_debrief.set_score({"base": 950, "bonus": 120, "penalty": 50})
	_debrief.set_casualties({
		"friendly": {"kia": 0, "wia": 2, "vehicles": 0},
		"enemy": {"kia": 11, "wia": 5, "vehicles": 1}
	})
	_debrief.set_units(units)
	_debrief.set_recipients_from_units()
	_debrief.set_commendation_options(["Campaign Ribbon", "Bronze Star", "Service Ribbon"])

	# Select first options & simulate Assign; use node paths (don't touch private vars)
	await get_tree().process_frame
	var rec_dd: OptionButton = _debrief.get_node_or_null("Root/Content/RightCol/CommendationPanel/VBoxContainer/RecipientRow/Recipient")
	var award_dd: OptionButton = _debrief.get_node_or_null("Root/Content/RightCol/CommendationPanel/VBoxContainer/AwardRow/Commendation")
	var assign_btn: Button = _debrief.get_node_or_null("Root/Content/RightCol/CommendationPanel/VBoxContainer/Assign")
	if rec_dd and rec_dd.item_count > 0:
		rec_dd.select(0)
	if award_dd and award_dd.item_count > 0:
		award_dd.select(0)
	if assign_btn:
		assign_btn.emit_signal("pressed")

	# Also test the "one shot" population
	await get_tree().create_timer(0.6).timeout
	_debrief.populate_from_dict({
		"mission_name": "Operation Night Relay",
		"outcome": "Failure",
		"objectives": objectives,
		"score": {"base": 600, "bonus": 0, "penalty": 200},
		"casualties": {
			"friendly": {"kia": 1, "wia": 2, "vehicles": 0},
			"enemy": {"kia": 7, "wia": 3, "vehicles": 0}
		},
		"units": units,
		"commendations": ["Campaign Ribbon", "Merit Cross"]
	})

# --------- Signal handlers ---------

func _on_continue(payload: Dictionary) -> void:
	print("[Test] continue_requested: ", payload)

func _on_retry(payload: Dictionary) -> void:
	print("[Test] retry_requested: ", payload)

func _on_award(commendation: String, recipient: String) -> void:
	print("[Test] commendation_assigned: %s -> %s" % [commendation, recipient])

# --------- Verification & data builders ---------

func _verify_project_types() -> void:
	var names := ["ScenarioObjectiveData", "UnitData"]
	for n in names:
		var path := _global_class_path(n)
		if path == "":
			print("[Verify] NOT FOUND:", n)
			continue
		print("[Verify] Found", n, "->", path)
		var S = load(path)
		if S:
			var inst = S.new()
			var props: Array[String] = []
			for p in inst.get_property_list():
				# list script-declared variables only
				if (p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) != 0:
					props.append(p.name)
			print("[Verify] Props for", n, ":", props)

func _global_class_path(name: String) -> String:
	for cls in ProjectSettings.get_global_class_list():
		if cls.get("class", "") == name:
			return cls.get("path", "")
	return ""

func _make_objective_results() -> Array:
	var list: Array = []
	var path := _global_class_path("ScenarioObjectiveData")
	if path != "":
		var Obj = load(path)
		var o1 = Obj.new()
		var o2 = Obj.new()
		_set_prop_if_exists(o1, "title", "Seize radio tower")
		_set_prop_if_exists(o2, "title", "Recover SIGINT package")
		list = [
			{"objective": o1, "completed": true},
			{"objective": o2, "completed": false},
		]
	else:
		# Fallback matches Debrief API structure
		list = [
			{"title": "Seize radio tower", "completed": true},
			{"title": "Recover SIGINT package", "completed": false},
		]
	return list

func _make_units() -> Array:
	var arr: Array = []
	var path := _global_class_path("UnitData")
	if path != "":
		var UD = load(path)
		var u1 = UD.new()
		var u2 = UD.new()
		var u3 = UD.new()
		_set_prop_if_exists(u1, "title", "1st Squad")
		_set_prop_if_exists(u2, "title", "2nd Squad")
		_set_prop_if_exists(u3, "title", "Recon")
		arr = [
			{"unit": u1, "status": "Combat ready", "kills": 5, "wia": 1, "kia": 0, "xp": 40},
			{"unit": u2, "status": "Needs rest",  "kills": 2, "wia": 2, "kia": 1, "xp": 25},
			{"unit": u3, "status": "OK",           "kills": 3, "wia": 0, "kia": 0, "xp": 30},
		]
	else:
		# Fallback matches Debrief API structure
		arr = [
			{"name": "1st Squad", "status": "Combat ready", "kills": 5, "wia": 1, "kia": 0, "xp": 40},
			{"name": "2nd Squad", "status": "Needs rest",  "kills": 2, "wia": 2, "kia": 1, "xp": 25},
			{"name": "Recon",     "status": "OK",           "kills": 3, "wia": 0, "kia": 0, "xp": 30},
		]
	return arr

func _set_prop_if_exists(obj: Object, prop: String, val) -> void:
	for p in obj.get_property_list():
		if p.name == prop:
			obj.set(prop, val)
			return
