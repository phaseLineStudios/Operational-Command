class_name SubtitleTrack
extends Resource

## Reusable subtitle track resource for video or audio playback.
## Contains an array of subtitle entries with timing and text.

## Array of subtitle entries
@export var subtitles: Array[Subtitle] = []


## Add a subtitle entry
func add_subtitle(start: float, end: float, text: String) -> void:
	var subtitle := Subtitle.new(start, end, text)
	subtitles.append(subtitle)


## Get subtitle at specific time position
func get_subtitle_at_time(time: float) -> String:
	for subtitle in subtitles:
		if time >= subtitle.start_time and time <= subtitle.end_time:
			return subtitle.text

	return ""


## Get all subtitles as Subtitle objects
func get_all_subtitles() -> Array[Subtitle]:
	return subtitles.duplicate()


## Serialize subtitle track to dictionary (for JSON export)
func serialize() -> Dictionary:
	var subtitle_dicts: Array = []
	for subtitle in subtitles:
		subtitle_dicts.append(subtitle.serialize())
	return {"subtitles": subtitle_dicts}


## Deserialize subtitle track from dictionary (for JSON import)
func deserialize(data: Dictionary) -> void:
	subtitles.clear()
	var subtitle_array: Array = data.get("subtitles", [])
	for subtitle_data in subtitle_array:
		if subtitle_data is Dictionary:
			subtitles.append(Subtitle.deserialize(subtitle_data))
