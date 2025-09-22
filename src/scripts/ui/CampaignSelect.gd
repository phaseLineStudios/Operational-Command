extends Control
## Campaign Select scene controller.
##
## Wires the campaign list, details panel, and action buttons.
## Flow:
## 1) User selects a campaign from [member list_campaigns].
## 2) Details placeholder updates and action buttons become visible.
## 3) "Create new save" creates/selects a save and advances to Mission Select.

@onready var list_campaigns: ItemList = $"HBoxContainer/VBoxContainer/CampaignList"
@onready var details_root: VBoxContainer = $"HBoxContainer/DetailsRoot"
@onready var btn_continue_last: Button = $"HBoxContainer/DetailsRoot/Options/ContinueLast"
@onready var btn_select_save: Button = $"HBoxContainer/DetailsRoot/Options/SelectSave"
@onready var btn_new_save: Button = $"HBoxContainer/DetailsRoot/Options/NewSave"
@onready var btn_back: Button = $"HBoxContainer/VBoxContainer/HBoxContainer/BackToMainMenu"

## Path to Mission Select Scene
const MISSION_SELECT_SCENE := "res://scenes/mission_select.tscn"

## Path to Main Menu Scene
const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

# Track mapping from ItemList index -> campaign_id
var _campaign_rows: Array[CampaignData] = []
var _selected_campaign: CampaignData

## Init UI, populate list, connect signals.
func _ready() -> void:
	_set_action_buttons_visible(false)
	_populate_campaigns()
	_connect_signals()

## Connects UI signals to handlers.
func _connect_signals() -> void:
	list_campaigns.item_selected.connect(_on_campaign_selected)
	btn_new_save.pressed.connect(_on_new_save_pressed)
	btn_continue_last.pressed.connect(_on_continue_last_pressed)
	btn_select_save.pressed.connect(_on_select_save_pressed)
	btn_back.pressed.connect(_on_back_pressed)

## Fill ItemList from ContentDB.
func _populate_campaigns() -> void:
	list_campaigns.clear()
	_campaign_rows.clear()

	var campaigns := ContentDB.list_campaigns()
	for c in campaigns:
		var title: String = c.title
		var _idx := list_campaigns.add_item(title)
		_campaign_rows.append(c)

	if list_campaigns.item_count > 0:
		list_campaigns.select(0)
		_on_campaign_selected(0)

## Handle campaign selection; update details + show actions.
func _on_campaign_selected(index: int) -> void:
	_selected_campaign = _campaign_rows[index]
	_update_details_placeholder(_selected_campaign)
	_set_action_buttons_visible(true)

## Placeholder details update (to be replaced later).
func _update_details_placeholder(campaign: CampaignData) -> void:
	# TODO populate CampaignDetails UI later with real data
	# For now, just update the placeholder label if present
	var label := details_root.get_node_or_null("Panel/CampaignDetails/PlaceholderLabel") as Label
	if label:
		label.text = "CAMPAIGN DETAILS Placeholder\n\nSelected: %s" % [String(campaign.id)]

## Show/hide the three action buttons.
func _set_action_buttons_visible(state: bool) -> void:
	btn_continue_last.visible = state
	btn_select_save.visible = state
	btn_new_save.visible = state

## Create/select new save and go to Mission Select.
func _on_new_save_pressed() -> void:
	if not _selected_campaign:
		return

	var save_id := Persistence.create_new_campaign_save(_selected_campaign.id)
	Game.select_campaign(_selected_campaign)
	Game.select_save(save_id)
	Game.goto_scene(MISSION_SELECT_SCENE)

## resolves last save for the current campaign (if any).
func _on_continue_last_pressed() -> void:
	if not _selected_campaign:
		return

	var last_id := Persistence.get_last_save_id_for_campaign(_selected_campaign.id)
	if last_id != "":
		Game.select_campaign(_selected_campaign)
		Game.select_save(last_id)
		Game.goto_scene(MISSION_SELECT_SCENE)
	else:
		# TODO: show "no saves found" dialog
		push_warning("No previous save found for this campaign.")

## open a save picker filtered to the current campaign.
func _on_select_save_pressed() -> void:
	if not _selected_campaign:
		return
	# TODO Open a save picker dialog/scene filtered by campaign
	push_warning("Save selection UI not implemented yet.")

## Back to main menu.
func _on_back_pressed() -> void:
	Game.goto_scene(MAIN_MENU_SCENE)
