@tool
extends EditorScript

## Serialize TerrainData.tres to terrain json.
##
## Configure the paths below and run via File -> Run in the Godot editor.

## Terrain Data source - EDIT THIS PATH
var terrain_data_path: String = "res://campaigns/terrains/fulda_gap.tres"
## Terrain json export path - EDIT THIS PATH
var export_path: String = "res://data/terrains/fulda_gap.json"


func _run():
	print("SerializeTerrain: Starting...")
	print("  Source: %s" % terrain_data_path)
	print("  Export: %s" % export_path)

	var res := ResourceLoader.load(terrain_data_path)
	if not res is TerrainData:
		push_error("SerializeTerrain: Resource is not TerrainData")
		return

	print("SerializeTerrain: Loaded TerrainData successfully")

	var srl := JSON.stringify(res.serialize(), "\t")
	var f := FileAccess.open(export_path, FileAccess.WRITE)
	if f == null:
		push_error("SerializeTerrain: Failed to open export path: %s" % export_path)
		return

	f.store_string(srl)
	f.flush()
	f.close()

	print("SerializeTerrain: Successfully exported to %s" % export_path)
