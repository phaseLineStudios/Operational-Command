## Debrief UI control.
## Renders a mission debrief screen with a left column (objectives, score, casualties),
## a right column (unit performance table and commendation assignment), and a bottom bar
## (Retry and Continue buttons with a dynamic title).
##
## Public API for filling the UI from game logic:
## - set_mission_name(), set_outcome(), set_objectives_results()
## - set_score(), set_casualties(), set_units()
## - set_recipients_from_units(), set_commendation_options()
## - populate_from_dict()
##
## Emits signals so the parent scene can react:
## - continue_requested(payload: Dictionary)
## - retry_requested(payload: Dictionary)
## - commendation_assigned(commendation: String, recipient: String)
##
## All set_* methods are idempotent. The layout adjusts the commendation panel height
## so the bottom of the Units panel aligns with the bottom of the Casualties panel.
extends Control
class_name Debrief

# --- Signals ---

## Emitted when the user continues the flow. Carries a snapshot payload.
signal continue_requested(payload: Dictionary)
## Emitted when the user requests a retry. Carries the same payload as continue.
signal retry_requested(payload: Dictionary)
## Emitted when a commendation is assigned to a recipient.
signal commendation_assigned(commendation: String, recipient: String)

# --- Constants ---

## Minimum vertical size reserved for the commendation panel to keep controls usable.
const MIN_COMMEND_PANEL_HEIGHT := 120.0

# --- Bottom bar ---

@onready var _title: Label         = $Root/BottomBar/Title
@onready var _btn_retry: Button    = $Root/BottomBar/Retry
@onready var _btn_continue: Button = $Root/BottomBar/Continue

# --- Left column ---

@onready var _objectives_list: ItemList = $Root/Content/LeftCol/ObjectivesPanel/VBoxContainer/Objectives
@onready var _score_base: Label         = $Root/Content/LeftCol/ScorePanel/VBoxContainer/ScoreGrid/BaseValue
@onready var _score_bonus: Label        = $Root/Content/LeftCol/ScorePanel/VBoxContainer/ScoreGrid/BonusValue
@onready var _score_penalty: Label      = $Root/Content/LeftCol/ScorePanel/VBoxContainer/ScoreGrid/PenaltyValue
@onready var _score_total: Label        = $Root/Content/LeftCol/ScorePanel/VBoxContainer/ScoreGrid/TotalValue
@onready var _cas_friend: RichTextLabel = $Root/Content/LeftCol/CasualtiesPanel/VBoxContainer/Friendlies
@onready var _cas_enemy: RichTextLabel  = $Root/Content/LeftCol/CasualtiesPanel/VBoxContainer/Enemies

# --- Right column ---

@onready var _units_tree: Tree            = $Root/Content/RightCol/UnitsPanel/VBoxContainer/Units
@onready var _recipient_dd: OptionButton  = $Root/Content/RightCol/CommendationPanel/VBoxContainer/RecipientRow/Recipient
@onready var _award_dd: OptionButton      = $Root/Content/RightCol/CommendationPanel/VBoxContainer/AwardRow/Commendation
@onready var _assign_btn: Button          = $Root/Content/RightCol/CommendationPanel/VBoxContainer/Assign

# --- For right-side split alignment ---

@onready var _left_col: VBoxContainer        = $Root/Content/LeftCol
@onready var _right_col: VBoxContainer       = $Root/Content/RightCol
@onready var _left_objectives_panel: Panel   = $Root/Content/LeftCol/ObjectivesPanel
@onready var _left_score_panel: Panel        = $Root/Content/LeftCol/ScorePanel
@onready var _left_casualties_panel: Panel   = $Root/Content/LeftCol/CasualtiesPanel
@onready var _right_commend_panel: Panel     = $Root/Content/RightCol/CommendationPanel

# --- State ---

## Backing fields for the payload collected on Continue and Retry.
## "score" and "casualties" mirror the structure accepted by the set_* methods.
var _mission_name := ""
var _outcome := "Failure"
var _score := {"base": 0, "bonus": 0, "penalty": 0, "total": 0}
var _casualties := {
	"friendly": {"kia": 0, "wia": 0, "vehicles": 0},
	"enemy": {"kia": 0, "wia": 0, "vehicles": 0}
}

## Initializes node references, connects button handlers, prepares the Units tree,
## draws the initial title, and aligns the right split after the first layout pass.
func _ready() -> void:
	_assert_nodes()
	_btn_retry.pressed.connect(_on_retry_pressed)
	_btn_continue.pressed.connect(_on_continue_pressed)
	_assign_btn.pressed.connect(_on_assign_pressed)
	_init_units_tree_columns()
	_update_title()

	await get_tree().process_frame
	_align_right_split()

## Reapplies alignment when the control is resized by the parent or user.
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_align_right_split()

# ============ Public API ============

## Sets the mission name and refreshes the title label.
func set_mission_name(mission_name: String) -> void:
	_mission_name = mission_name
	_update_title()

## Sets the outcome label text and refreshes the title label.
func set_outcome(outcome: String) -> void:
	_outcome = outcome
	_update_title()

## Populates the objectives list with checkmarks and crosses.
## Accepted per-item shapes:
## - String: "Seize objective"
## - Dictionary: {"title": String, "completed": bool}
## - Dictionary: {"objective": Object|Dictionary, "completed": bool}
##   For nested objects or dictionaries, "title" is preferred, then "name".
func set_objectives_results(results: Array) -> void:
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
					if typeof(obj) == TYPE_DICTIONARY:
						if obj.has("title"):
							title = str(obj["title"])
						elif obj.has("name"):
							title = str(obj["name"])
					elif obj is Object:
						var t = obj.get("title")
						if t == null or str(t) == "":
							t = obj.get("name")
						title = str(t if t != null else "Objective")
			completed = bool(r.get("completed", false))
		else:
			title = str(r)

		var prefix := "✔ " if completed else "✖ "
		_objectives_list.add_item(prefix + title)

	_request_align()

## Sets base, bonus, penalty, and total score fields.
## "total" is derived as base + bonus - penalty if omitted.
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

## Sets friendly and enemy casualty figures and updates the RichText labels.
## Missing values default to 0.
## Shape:
## {
##   "friendly": {"kia": int, "wia": int, "vehicles": int},
##   "enemy":    {"kia": int, "wia": int, "vehicles": int}
## }
func set_casualties(c: Dictionary) -> void:
	_casualties = c.duplicate(true)
	var f: Dictionary = _casualties.get("friendly", {})
	var e: Dictionary = _casualties.get("enemy", {})
	_cas_friend.text = "[b]Friendly[/b]\nKIA: %d\nWIA: %d\nVehicles: %d" % [
		int(f.get("kia", 0)), int(f.get("wia", 0)), int(f.get("vehicles", 0))
	]
	_cas_enemy.text = "[b]Enemy[/b]\nKIA: %d\nWIA: %d\nVehicles: %d" % [
		int(e.get("kia", 0)), int(e.get("wia", 0)), int(e.get("vehicles", 0))
	]
	_request_align()

## Populates the Units tree with per-unit rows.
## Accepted per-row shapes:
## - {"name": String, "kills"?: int, "wia"?: int, "kia"?: int, "xp"?: int, "status"?: String}
## - {"unit": Object with "title" or "name", same optional stats as above}
func set_units(units: Array) -> void:
	_units_tree.clear()
	_init_units_tree_columns()

	var root := _units_tree.create_item()
	for u in units:
		var unit_name := ""
		var status := ""
		var kills := 0
		var wia := 0
		var kia := 0
		var xp := 0

		if u is Dictionary:
			if u.has("name"):
				unit_name = str(u["name"])
			elif u.has("unit"):
				var ud = u["unit"]
				if ud != null:
					var t = ud.get("title")
					if t != null and str(t) != "":
						unit_name = str(t)
					else:
						var n = ud.get("name")
						if n != null and str(n) != "":
							unit_name = str(n)
			status = str(u.get("status", ""))
			kills  = int(u.get("kills", 0))
			wia    = int(u.get("wia", 0))
			kia    = int(u.get("kia", 0))
			xp     = int(u.get("xp", 0))
		else:
			unit_name = str(u)

		var it := _units_tree.create_item(root)
		it.set_text(0, unit_name)
		it.set_text(1, status)
		it.set_text(2, str(kills))
		it.set_text(3, str(wia))
		it.set_text(4, str(kia))
		it.set_text(5, str(xp))

	_request_align()

## Copies the unit names currently displayed into the Recipient dropdown.
func set_recipients_from_units() -> void:
	_recipient_dd.clear()
	var root := _units_tree.get_root()
	if root:
		var ch := root.get_first_child()
		while ch:
			_recipient_dd.add_item(ch.get_text(0))
			ch = ch.get_next()

## Sets the available commendation names in the Award dropdown.
func set_commendation_options(options: Array) -> void:
	_award_dd.clear()
	for o in options:
		_award_dd.add_item(str(o))

## Populates the entire UI from a single dictionary.
## Keys:
## {
##   "mission_name": String,
##   "outcome": String,
##   "objectives": Array,      see set_objectives_results()
##   "score": Dictionary,      see set_score()
##   "casualties": Dictionary, see set_casualties()
##   "units": Array,           see set_units()
##   "commendations": Array    list of award names
## }
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

## Returns the currently selected award, or an empty string if none is selected.
func get_selected_commendation() -> String:
	var idx := _award_dd.get_selected()
	return "" if idx == -1 else _award_dd.get_item_text(idx)

## Returns the selected recipient name, or an empty string if none is selected.
func get_selected_recipient() -> String:
	var idx := _recipient_dd.get_selected()
	return "" if idx == -1 else _recipient_dd.get_item_text(idx)

# ============ Buttons and payload ============

## Emits "commendation_assigned" only when both selection fields are non-empty.
func _on_assign_pressed() -> void:
	var award := get_selected_commendation()
	var recip := get_selected_recipient()
	if award != "" and recip != "":
		emit_signal("commendation_assigned", award, recip)

## Emits "continue_requested" with a snapshot of the current debrief state.
func _on_continue_pressed() -> void:
	emit_signal("continue_requested", _collect_payload())

## Emits "retry_requested" with the same payload format as continue.
func _on_retry_pressed() -> void:
	emit_signal("retry_requested", _collect_payload())

## Collects a snapshot of all user-visible state for higher-level flow management.
func _collect_payload() -> Dictionary:
	return {
		"mission_name": _mission_name,
		"outcome": _outcome,
		"score": _score,
		"casualties": _casualties,
		"selected_commendation": get_selected_commendation(),
		"selected_recipient": get_selected_recipient()
	}

# ============ Helpers ============

## Keeps the bottom title in sync with the latest mission and outcome.
func _update_title() -> void:
	_title.text = "Debrief: %s (%s)" % [
		_mission_name if _mission_name != "" else "<mission>",
		_outcome
	]

## Emits editor warnings if required scene nodes are missing.
func _assert_nodes() -> void:
	if _objectives_list == null: push_warning("Objectives ItemList missing.")
	if _units_tree == null: push_warning("Units Tree missing.")
	if _recipient_dd == null or _award_dd == null: push_warning("Commendation dropdowns missing.")
	if _assign_btn == null: push_warning("Assign Button missing.")

## Applies headers and column sizing rules to the Units tree.
## Safe to call multiple times.
func _init_units_tree_columns() -> void:
	if _units_tree == null:
		return
	_units_tree.columns = 6
	_units_tree.column_titles_visible = true
	_units_tree.hide_root = true

	_units_tree.set_column_title(0, "Unit")
	_units_tree.set_column_title(1, "Status")
	_units_tree.set_column_title(2, "Kills")
	_units_tree.set_column_title(3, "WIA")
	_units_tree.set_column_title(4, "KIA")
	_units_tree.set_column_title(5, "XP")

	_units_tree.set_column_expand(0, true)
	if _units_tree.has_method("set_column_expand_ratio"):
		_units_tree.set_column_expand_ratio(0, 6)
		for i in range(1, 6):
			_units_tree.set_column_expand(i, true)
			_units_tree.set_column_expand_ratio(i, 1)
	else:
		_units_tree.set_column_expand(0, true)
		_units_tree.set_column_custom_minimum_width(0, 180)
		for i in range(1, 6):
			_units_tree.set_column_expand(i, false)

## Defers alignment one frame so container sizes update before measuring.
func _request_align() -> void:
	call_deferred("_align_right_split")

## Computes the required commendation panel height so the bottom of the Units area
## aligns with the bottom of the Casualties panel, without shrinking below
## MIN_COMMEND_PANEL_HEIGHT.
func _align_right_split() -> void:
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
	var desired_comm: float = max(MIN_COMMEND_PANEL_HEIGHT, _right_col.size.y - target_units_h - float(sep_r))

	_right_commend_panel.custom_minimum_size = Vector2(0, desired_comm)
