extends Node
## Campaign save/load and progression persistence.
##
## Stores and retrieves long-term game state: unit rosters, veterancy,
## equipment/manpower pools, mission results, and campaign branching.

## Base directory for saves.
const SAVE_DIR := "user://saves"  # TODO: implement real storage

## Return last save ID for [param campaign_id], or empty.
func get_last_save_id_for_campaign(_campaign_id: StringName) -> String:
	# TODO: read metadata and return the most recent save id
	return ""

## Return array of save dicts for [param campaign_id].
func list_saves_for_campaign(_campaign_id: StringName) -> Array:
	# TODO: return [{id, name, timestamp, progress}, ...]
	return []

## Create a new save for [param campaign_id]; return new ID.
func create_new_campaign_save(_campaign_id: StringName) -> String:
	# TODO: write initial save data; return new save id
	var new_id := "save_" + str(Time.get_unix_time_from_system())
	return new_id
