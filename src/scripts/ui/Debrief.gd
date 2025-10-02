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

func set_objectives_results(results: Array) -> void: pass
func set_score(score: Dictionary) -> void: pass
func set_casualties(c: Dictionary) -> void: pass
func set_units(units: Array) -> void: pass
func set_recipients_from_units() -> void: pass
func set_commendation_options(options: Array) -> void: pass
func populate_from_dict(d: Dictionary) -> void: pass
func get_selected_commendation() -> String: return ""
func get_selected_recipient() -> String: return ""

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
