extends Control
class_name Debrief

## Signals for higher-level flow
signal continue_requested(payload: Dictionary)
signal retry_requested(payload: Dictionary)
signal commendation_assigned(commendation: String, recipient: String)

# Bottom bar
@onready var _title: Label         = $Root/BottomBar/Title
@onready var _btn_retry: Button    = $Root/BottomBar/Retry
@onready var _btn_continue: Button = $Root/BottomBar/Continue

# Left column
@onready var _objectives_list: ItemList = $Root/Content/LeftCol/ObjectivesPanel/VBoxContainer/Objectives
@onready var _score_base: Label         = $Root/Content/LeftCol/ScorePanel/VBoxContainer/ScoreGrid/BaseValue
@onready var _score_bonus: Label        = $Root/Content/LeftCol/ScorePanel/VBoxContainer/ScoreGrid/BonusValue
@onready var _score_penalty: Label      = $Root/Content/LeftCol/ScorePanel/VBoxContainer/ScoreGrid/PenaltyValue
@onready var _score_total: Label        = $Root/Content/LeftCol/ScorePanel/VBoxContainer/ScoreGrid/TotalValue
@onready var _cas_friend: RichTextLabel = $Root/Content/LeftCol/CasualtiesPanel/VBoxContainer/Friendlies
@onready var _cas_enemy: RichTextLabel  = $Root/Content/LeftCol/CasualtiesPanel/VBoxContainer/Enemies

# Right column
@onready var _units_tree: Tree            = $Root/Content/RightCol/UnitsPanel/VBoxContainer/Units
@onready var _recipient_dd: OptionButton  = $Root/Content/RightCol/CommendationPanel/VBoxContainer/RecipientRow/Recipient
@onready var _award_dd: OptionButton      = $Root/Content/RightCol/CommendationPanel/VBoxContainer/AwardRow/Commendation
@onready var _assign_btn: Button          = $Root/Content/RightCol/CommendationPanel/VBoxContainer/Assign

# For right-side split alignment
@onready var _left_col: VBoxContainer        = $Root/Content/LeftCol
@onready var _right_col: VBoxContainer       = $Root/Content/RightCol
@onready var _left_objectives_panel: Panel   = $Root/Content/LeftCol/ObjectivesPanel
@onready var _left_score_panel: Panel        = $Root/Content/LeftCol/ScorePanel
@onready var _left_casualties_panel: Panel   = $Root/Content/LeftCol/CasualtiesPanel
@onready var _right_units_panel: Panel       = $Root/Content/RightCol/UnitsPanel
@onready var _right_commend_panel: Panel     = $Root/Content/RightCol/CommendationPanel

# State
var _mission_name := ""
var _outcome := "Failure"
var _score := {"base": 0, "bonus": 0, "penalty": 0, "total": 0}
var _casualties := {
	"friendly": {"kia": 0, "wia": 0, "vehicles": 0},
	"enemy": {"kia": 0, "wia": 0, "vehicles": 0}
}

func _ready() -> void:
	_assert_nodes()
	_btn_retry.pressed.connect(_on_retry_pressed)
	_btn_continue.pressed.connect(_on_continue_pressed)
	_assign_btn.pressed.connect(_on_assign_pressed)
	_init_units_tree_columns()
	_update_title()

	# Initial alignment after one frame so sizes are valid
	await get_tree().process_frame
	_align_right_split()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_align_right_split()
		
# ============ Public API ============

func set_mission_name(name: String) -> void:
	_mission_name = name
	_update_title()
	

func set_outcome(outcome: String) -> void:
	_outcome = outcome
	_update_title()

func set_objectives_results(results: Array) -> void:
	# Each item can be {title, completed} or {objective: Resource(.title/.name), completed}
	_objectives_list.clear()
	for r in results:
		var title := ""
		var completed := false
		if r is Dictionary:
			if r.has("title"):
				title = str(r["title"])
			elif r.has("objective"):
				var obj = r["objective"]
				if obj != null:
					if obj is Object and obj.has_method("title"):
						title = str(obj.title)
					elif obj is Object and obj.has_method("name"):
						title = str(obj.name)
					else:
						title = "Objective"
			completed = bool(r.get("completed", false))
		else:
			title = str(r)
		var prefix := "✔ " if completed else "✖ "
		_objectives_list.add_item(prefix + title)
	_request_align()

func set_score(score: Dictionary) -> void:
	_score = score.duplicate(true)
	var base := int(_score.get("base", 0))
	var bonus := int(_score.get("bonus", 0))
	var penalty := int(_score.get("penalty", 0))
	var total := int(_score.get("total", base + bonus - penalty))
	_score["total"] = total
	_score_base.text = str(base)
	_score_bonus.text = str(bonus)
	_score_penalty.text = str(penalty)
	_score_total.text = str(total)
	_request_align()

func set_casualties(c: Dictionary) -> void:
	_casualties = c.duplicate(true)
	var f : Dictionary = _casualties.get("friendly", {})
	var e : Dictionary = _casualties.get("enemy", {})
	_cas_friend.text = "[b]Friendly[/b]\nKIA: %d\nWIA: %d\nVehicles: %d" % [
		int(f.get("kia", 0)), int(f.get("wia", 0)), int(f.get("vehicles", 0))
	]
	_cas_enemy.text = "[b]Enemy[/b]\nKIA: %d\nWIA: %d\nVehicles: %d" % [
		int(e.get("kia", 0)), int(e.get("wia", 0)), int(e.get("vehicles", 0))
	]
	_request_align()

func set_units(units: Array) -> void:
	_units_tree.clear()
	_init_units_tree_columns()
	var root := _units_tree.create_item()
	for u in units:
		var name := ""
		var status := ""
		var kills := 0
		var wia := 0
		var kia := 0
		var xp := 0
		if u is Dictionary:
			if u.has("name"):
				name = str(u["name"])
			elif u.has("unit"):
				var uu = u["unit"]
				if uu != null:
					if uu is Object and uu.has_method("title"):
						name = str(uu.title)
					elif uu is Object and uu.has_method("name"):
						name = str(uu.name)
			status = str(u.get("status", ""))
			kills = int(u.get("kills", 0))
			wia   = int(u.get("wia", 0))
			kia   = int(u.get("kia", 0))
			xp    = int(u.get("xp", 0))
		else:
			name = str(u)
		var it := _units_tree.create_item(root)
		it.set_text(0, name)
		it.set_text(1, status)
		it.set_text(2, str(kills))
		it.set_text(3, str(wia))
		it.set_text(4, str(kia))
		it.set_text(5, str(xp))

func set_recipients_from_units() -> void:
	_recipient_dd.clear()
	var root := _units_tree.get_root()
	if root:
		var ch := root.get_first_child()
		while ch:
			_recipient_dd.add_item(ch.get_text(0))
			ch = ch.get_next()

func set_commendation_options(options: Array) -> void:
	_award_dd.clear()
	for o in options:
		_award_dd.add_item(str(o))

func populate_from_dict(d: Dictionary) -> void:
	if d.has("mission_name"): set_mission_name(str(d["mission_name"]))
	if d.has("outcome"): set_outcome(str(d["outcome"]))
	if d.has("objectives"): set_objectives_results(d["objectives"])
	if d.has("score"): set_score(d["score"])
	if d.has("casualties"): set_casualties(d["casualties"])
	if d.has("units"):
		set_units(d["units"])
		set_recipients_from_units()
	if d.has("commendations"): set_commendation_options(d["commendations"])
	
func get_selected_commendation() -> String:
	if _award_dd.item_count == 0 or _award_dd.get_selected_id() == -1: return ""
	return _award_dd.get_item_text(_award_dd.get_selected())

func get_selected_recipient() -> String:
	if _recipient_dd.item_count == 0 or _recipient_dd.get_selected_id() == -1: return ""
	return _recipient_dd.get_item_text(_recipient_dd.get_selected())

# ============ Buttons and payload ============

func _on_assign_pressed() -> void: pass
func _on_continue_pressed() -> void: pass
func _on_retry_pressed() -> void: pass
func _collect_payload() -> Dictionary: return {}

# ============ Helpers ============

func _update_title() -> void:
	_title.text = "Debrief: %s (%s)" % [
		_mission_name if _mission_name != "" else "<mission>",
		_outcome
	]

func _assert_nodes() -> void:
	if _objectives_list == null: push_warning("Objectives ItemList missing.")
	if _units_tree == null: push_warning("Units Tree missing.")
	if _recipient_dd == null or _award_dd == null: push_warning("Commendation dropdowns missing.")
	if _assign_btn == null: push_warning("Assign Button missing.")

func _init_units_tree_columns() -> void:
	if _units_tree == null:
		return
	_units_tree.columns = 6
	_units_tree.column_titles_visible = true
	_units_tree.set_column_title(0, "Unit")
	_units_tree.set_column_title(1, "Status")
	_units_tree.set_column_title(2, "Kills")
	_units_tree.set_column_title(3, "WIA")
	_units_tree.set_column_title(4, "KIA")
	_units_tree.set_column_title(5, "XP")
	_units_tree.set_column_expand(0, true)
	for i in range(1, 6):
		_units_tree.set_column_expand(i, false)

func _request_align() -> void:
	# Defer to the next frame so Control sizes have updated
	call_deferred("_align_right_split")

func _align_right_split() -> void:
	# Target: bottom of Units equals bottom of Casualties
	if _left_col == null or _right_col == null:
		return
	var sep_l := _left_col.get_theme_constant("separation")
	var sep_r := _right_col.get_theme_constant("separation")

	var target_units_h := (
		_left_objectives_panel.size.y +
		sep_l +
		_left_score_panel.size.y +
		sep_l +
		_left_casualties_panel.size.y
	)
	var min_comm := 120
	var desired_comm: float = max(min_comm, _right_col.size.y - target_units_h - sep_r)

	_right_commend_panel.custom_minimum_size = Vector2(0, desired_comm)
