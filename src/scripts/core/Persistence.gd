extends Node
## Campaign save/load and progression persistence.
##
## Stores and retrieves long-term game state: unit rosters, veterancy,
## equipment/manpower pools, mission results, and campaign branching.

## Base directory for saves.
const SAVE_DIR := "user://saves"

var _save_cache: Dictionary = {}


func _ready() -> void:
	_ensure_save_directory()


## Ensure the save directory exists.
func _ensure_save_directory() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		var err := DirAccess.make_dir_recursive_absolute(SAVE_DIR)
		if err != OK:
			push_error("Failed to create save directory: %s" % SAVE_DIR)


## Return last save ID for [param campaign_id], or empty.
func get_last_save_id_for_campaign(campaign_id: StringName) -> String:
	var saves := list_saves_for_campaign(campaign_id)
	if saves.is_empty():
		return ""

	# Find the most recent save by last_played_timestamp
	var latest_save: CampaignSave = null
	var latest_timestamp := 0

	for save in saves:
		if save is CampaignSave:
			if save.last_played_timestamp > latest_timestamp:
				latest_timestamp = save.last_played_timestamp
				latest_save = save

	return latest_save.save_id if latest_save else ""


## Return array of CampaignSave objects for [param campaign_id].
func list_saves_for_campaign(campaign_id: StringName) -> Array[CampaignSave]:
	var saves: Array[CampaignSave] = []

	var dir := DirAccess.open(SAVE_DIR)
	if not dir:
		push_warning("Could not open save directory: %s" % SAVE_DIR)
		return saves

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			var save: CampaignSave = load_save_from_file(file_name.get_basename())
			if save and save.campaign_id == campaign_id:
				saves.append(save)
		file_name = dir.get_next()
	dir.list_dir_end()

	# Sort by last played timestamp (most recent first)
	saves.sort_custom(
		func(a: CampaignSave, b: CampaignSave) -> bool:
			return a.last_played_timestamp > b.last_played_timestamp
	)

	return saves


## Create a new save for [param campaign_id]; return new ID.
func create_new_campaign_save(campaign_id: StringName, save_name: String = "") -> String:
	var save: CampaignSave = CampaignSave.create_new(campaign_id, save_name)
	save_to_file(save)
	_save_cache[save.save_id] = save
	return save.save_id


## Load a save by ID. Returns null if not found.
func load_save(save_id: String) -> CampaignSave:
	# Check cache first
	if _save_cache.has(save_id):
		return _save_cache[save_id]

	# Load from file
	return load_save_from_file(save_id)


## Load a save from file by ID. Returns null if not found.
func load_save_from_file(save_id: String) -> CampaignSave:
	var file_path := _get_save_path(save_id)

	if not FileAccess.file_exists(file_path):
		return null

	var file := FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Failed to open save file: %s" % file_path)
		return null

	var json_string := file.get_as_text()
	file.close()

	var json := JSON.new()
	var parse_result := json.parse(json_string)
	if parse_result != OK:
		push_error(
			"Failed to parse save file: %s (error at line %d)" % [file_path, json.get_error_line()]
		)
		return null

	var save: CampaignSave = CampaignSave.deserialize(json.data)
	if save:
		_save_cache[save_id] = save

	return save


## Save a CampaignSave to file.
func save_to_file(save: CampaignSave) -> bool:
	if not save:
		push_error("Cannot save null CampaignSave")
		return false

	_ensure_save_directory()

	save.touch()  # Update last played timestamp

	var file_path := _get_save_path(save.save_id)
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		push_error("Failed to create save file: %s" % file_path)
		return false

	var data := save.serialize()
	var json_string := JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()

	_save_cache[save.save_id] = save
	LogService.info("Saved campaign progress to: %s" % file_path, "Persistence")
	return true


## Delete a save by ID. Returns true on success.
func delete_save(save_id: String) -> bool:
	var file_path := _get_save_path(save_id)

	if not FileAccess.file_exists(file_path):
		push_warning("Cannot delete save: file not found %s" % file_path)
		return false

	var err := DirAccess.remove_absolute(file_path)
	if err != OK:
		push_error("Failed to delete save file: %s" % file_path)
		return false

	_save_cache.erase(save_id)
	LogService.info("Deleted save: %s" % save_id, "Persistence")
	return true


## Get the file path for a save ID.
func _get_save_path(save_id: String) -> String:
	return SAVE_DIR.path_join(save_id + ".json")
