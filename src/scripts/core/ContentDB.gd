extends Node
## Data loader and index for units, maps, briefs, and scenarios.
##
## Loads JSON assets from [code]res://data/[/code] and exposes typed accessors
## with basic validation and helpful error messages.

## List campaign dicts: {id, title, blurb}.
func list_campaigns() -> Array:
	# TODO load from JSON in res://data/campaigns/*.json
	return [
		{
			"id": "nato_1985_west_ger",
			"title": "NATO 1985 – West German Front",
			"blurb": "Defensive to counteroffensive along the Inner German Border.",
			"image": "res://maps/previews/west_ger_preview.png",
			"campaign_map": "res://maps/campaign/west_ger_map.png",
			"missions": [
				{
					"id": "wg_exercise_reforger",
					"title": "Exercise Reforger 85'",
					"description": "Annual NATO exercise held in West Germany.",
					"image": "res://maps/previews/wg_exercise_reforger.png",
					"difficulty": "Easy",
					"pos": Vector2(0.44, 0.40)
				},
				{
					"id": "wg_border_probe",
					"title": "Border Probe",
					"description": "Soviet recon-in-force tests your line near Fulda.",
					"image": "res://maps/previews/wg_border_probe.png",
					"difficulty": "Normal",
					"pos": Vector2(0.52, 0.55)
				}
			]
		},
		{
			"id": "ddr_1985_east_ger",
			"title": "DDR 1985 – Berlin Gambit",
			"blurb": "Alt-history coup & breakout from Berlin.",
			"image": "res://maps/previews/berlin_preview.png",
			"campaign_map": "res://maps/campaign/east_ger_map.png",
			"missions": [
				{
					"id": "berlin_airlift",
					"title": "Airlift Scramble",
					"description": "Secure air corridors while ground routes are contested.",
					"image": "res://maps/previews/berlin_airlift.png",
					"difficulty": "Easy",
					"pos": Vector2(0.60, 0.30)
				}
			]
		}
	]

## Get a full campaign object by ID, or null if not found.
func get_campaign(campaign_id: StringName) -> Dictionary:
	for c in list_campaigns():
		if StringName(c.get("id", "")) == campaign_id:
			return c
	return {}

## List missions for a campaign (each with id/title/description/image/difficulty/pos).
func list_missions(campaign_id: StringName) -> Array:
	var c := get_campaign(campaign_id)
	return c.get("missions", [])
