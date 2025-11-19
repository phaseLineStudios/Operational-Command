extends Control
## Campaign Select scene controller.
##
## Wires the campaign list, details panel, and action buttons.
## Flow:
## 1) User selects a campaign from [member list_campaigns].
## 2) Details placeholder updates and action buttons become visible.
## 3) "Create new save" creates/selects a save and advances to Mission Select.

## Path to Mission Select Scene
const MISSION_SELECT_SCENE := "res://scenes/mission_select.tscn"

## Path to Main Menu Scene
const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

# Track mapping from ItemList index -> campaign_id
var _campaign_rows: Array[CampaignData] = []
var _selected_campaign: CampaignData

@onready var list_campaigns: ItemList = %CampaignList
@onready var details_root: PanelContainer = %DetailsRoot
@onready var btn_continue_last: OCMenuButton = %ContinueLast
@onready var btn_select_save: OCMenuButton = %SelectSave
@onready var btn_new_save: OCMenuButton = %NewSave
@onready var btn_back: OCMenuButton = %BackToMainMenu
@onready var campaign_poster: TextureRect = %CampaignPoster
@onready var campaign_desc: RichTextLabel = %CampaignDescription
@onready var select_save: OCMenuContentLoad = %SelectSaveDialog
@onready var new_save: OCMenuWindow = %NewSaveDialog
@onready var new_save_name: LineEdit = %NewSaveName
@onready var delete_save: OCMenuButton = %SaveDeleteButton
@onready var confirm_dialog: OCMenuConfirmation = %ConfirmationDialog


## Init UI, populate list, connect signals.
func _ready() -> void:
	_populate_campaigns()
	_connect_signals()


## Connects UI signals to handlers.
func _connect_signals() -> void:
	list_campaigns.item_selected.connect(_on_campaign_selected)
	btn_new_save.pressed.connect(_on_new_save_pressed)
	btn_continue_last.pressed.connect(_on_continue_last_pressed)
	btn_select_save.pressed.connect(_on_select_save_pressed)
	btn_back.pressed.connect(_on_back_pressed)
	select_save.ok_pressed.connect(_select_save_load)
	select_save.cancel_pressed.connect(_select_save_close)
	select_save.close_pressed.connect(_select_save_close)
	select_save.content_selected.connect(func(idx: int): delete_save.disabled = idx == -1)
	delete_save.pressed.connect(_select_save_delete)
	new_save.ok_pressed.connect(_on_new_save_created)
	new_save.cancel_pressed.connect(_on_new_save_cancelled)
	new_save.close_pressed.connect(_on_new_save_cancelled)
	confirm_dialog.close_pressed.connect(func(): confirm_dialog.hide())
	confirm_dialog.cancel_pressed.connect(func(): confirm_dialog.hide())


## Fill ItemList from ContentDB.
func _populate_campaigns() -> void:
	list_campaigns.clear()
	_campaign_rows.clear()

	var campaigns := ContentDB.list_campaigns()
	for c in campaigns:
		var title: String = c.title
		list_campaigns.add_item(title)
		_campaign_rows.append(c)

	if list_campaigns.item_count > 0:
		list_campaigns.select(0)
		_on_campaign_selected(0)


## Handle campaign selection; update details + show actions.
func _on_campaign_selected(index: int) -> void:
	_selected_campaign = _campaign_rows[index]
	_update_details(_selected_campaign)
	_update_action_buttons()


## Placeholder details update (to be replaced later).
func _update_details(campaign: CampaignData) -> void:
	if campaign.preview != null:
		campaign_poster.texture = campaign.preview
	else:
		campaign_poster.texture = null
	campaign_desc.text = campaign.description


## Update action button visibility and states based on existing saves.
func _update_action_buttons() -> void:
	if not _selected_campaign:
		btn_continue_last.visible = false
		btn_select_save.visible = false
		btn_new_save.visible = false
		return

	var saves := Persistence.list_saves_for_campaign(_selected_campaign.id)
	var has_saves := not saves.is_empty()

	btn_continue_last.visible = true
	btn_select_save.visible = true
	btn_new_save.visible = true

	btn_continue_last.disabled = not has_saves
	btn_select_save.disabled = not has_saves

	if has_saves:
		btn_continue_last.text = "Continue Last Save"
		btn_select_save.text = "Load Save (%d)" % saves.size()
	else:
		btn_continue_last.text = "Continue (No Saves)"
		btn_select_save.text = "Load Save (No Saves)"


## Create/select new save and go to Mission Select.
func _on_new_save_pressed() -> void:
	if not _selected_campaign:
		return
	
	new_save.popup_centered()


## Create new save with entered name
func _on_new_save_created() -> void:
	var save_id := Persistence.create_new_campaign_save(_selected_campaign.id, new_save_name.text)
	Game.select_campaign(_selected_campaign)
	Game.select_save(save_id)
	Game.goto_scene(MISSION_SELECT_SCENE)


## Called when new save is cancelled
func _on_new_save_cancelled() -> void:
	new_save.hide()
	new_save_name.text = "My Savegame"


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

	var saves := Persistence.list_saves_for_campaign(_selected_campaign.id)
	if saves.is_empty():
		push_warning("No saves found for this campaign.")
		return

	_show_save_picker(saves)


## Show save picker dialog.
func _show_save_picker(saves: Array[CampaignSave]) -> void:
	delete_save.disabled = true
	select_save.content_list.clear()
	select_save.popup_centered()

	for save in saves:
		var last_played := Time.get_datetime_string_from_unix_time(save.last_played_timestamp)

		var item_text := "%s (Last played: %s)" % [save.save_name, last_played.replace("T", " ")]
		select_save.content_list.add_item(item_text)
		select_save.content_list.set_item_metadata(select_save.content_list.item_count - 1, save.save_id)


## Load selected save
func _select_save_load() -> void:
	var selected := select_save.content_list.get_selected_items()
	if selected.size() > 0:
		var save_id: String = select_save.content_list.get_item_metadata(selected[0])
		Game.select_campaign(_selected_campaign)
		Game.select_save(save_id)
		Game.goto_scene(MISSION_SELECT_SCENE)
	_select_save_close()


## Handle deletion of saves
func _select_save_delete() -> void:
	var selected := select_save.content_list.get_selected_items()
	if selected.size() > 0:
		var save_id: String = select_save.content_list.get_item_metadata(selected[0])
		var save_name: String = Persistence.load_save(save_id).save_name
		confirm_dialog.window_title = "Delete Save"
		confirm_dialog.description = "Are you sure you want to delete %s?" % save_name
		confirm_dialog.ok_pressed.connect(func(): _delete_save(save_id), CONNECT_ONE_SHOT)
		confirm_dialog.popup_centered()
	_select_save_close()


## Delete save by save id
func _delete_save(save_id: String) -> void:
	Game.delete_save(save_id)
	confirm_dialog.hide()
	_update_action_buttons()

## Handle closing of select save dialog
func _select_save_close() -> void:
	select_save.hide()


## Back to main menu.
func _on_back_pressed() -> void:
	Game.goto_scene(MAIN_MENU_SCENE)
