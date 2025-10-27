## Icon definitions for military symbols
## Provides simple icon shapes for different unit types
class_name MilSymbolIcons
extends RefCounted

## Unit type icons (simplified)
enum IconType {
	NONE,
	INFANTRY,
	ARMOR,
	MECHANIZED,
	ARTILLERY,
	RECON,
	ENGINEER,
	ANTI_TANK,
	ANTI_AIR,
	HEADQUARTERS,
	COMMAND_POST
}


## Get drawing instructions for an icon type
## Returns a dictionary with drawing commands
## Icons are based on MIL-STD-2525 standard, coordinates in 200x200 space
static func get_icon(icon_type: IconType, affiliation: MilSymbolConfig.Affiliation) -> Dictionary:
	match icon_type:
		IconType.INFANTRY:
			# Crossed diagonal lines corner to corner (varies by affiliation)
			match affiliation:
				MilSymbolConfig.Affiliation.FRIEND:
					return {
						"type": "lines",
						"paths":
						[[Vector2(25, 50), Vector2(175, 150)], [Vector2(25, 150), Vector2(175, 50)]]
					}
				MilSymbolConfig.Affiliation.HOSTILE:
					return {
						"type": "lines",
						"paths":
						[[Vector2(60, 70), Vector2(140, 130)], [Vector2(60, 130), Vector2(140, 70)]]
					}
				MilSymbolConfig.Affiliation.NEUTRAL:
					return {
						"type": "lines",
						"paths":
						[[Vector2(45, 45), Vector2(155, 155)], [Vector2(45, 155), Vector2(155, 45)]]
					}
				MilSymbolConfig.Affiliation.UNKNOWN:
					return {
						"type": "lines",
						"paths":
						[[Vector2(50, 65), Vector2(150, 135)], [Vector2(50, 135), Vector2(150, 65)]]
					}
				_:
					return {}
		IconType.ARMOR:
			# Oval track outline (MIL-STD-2525: oval shape)
			# Using ellipse approximation for simplicity
			return {
				"type": "ellipse", "center": Vector2(100, 100), "rx": 50, "ry": 20, "filled": false
			}
		IconType.MECHANIZED:
			# Infantry + vertical line for wheeled
			match affiliation:
				MilSymbolConfig.Affiliation.FRIEND:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(25, 50), Vector2(175, 150)],  # Infantry cross
							[Vector2(25, 150), Vector2(175, 50)],
							[Vector2(100, 50), Vector2(100, 150)]  # Motorized line
						]
					}
				MilSymbolConfig.Affiliation.HOSTILE:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(60, 70), Vector2(140, 130)],
							[Vector2(60, 130), Vector2(140, 70)],
							[Vector2(100, 70), Vector2(100, 130)]
						]
					}
				_:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(45, 45), Vector2(155, 155)],
							[Vector2(45, 155), Vector2(155, 45)],
							[Vector2(100, 45), Vector2(100, 155)]
						]
					}
		IconType.ARTILLERY:
			# Filled circle (MIL-STD-2525 standard)
			return {"type": "circle", "center": Vector2(100, 100), "radius": 15, "filled": true}
		IconType.RECON:
			# Single diagonal line (MIL-STD-2525)
			match affiliation:
				MilSymbolConfig.Affiliation.FRIEND:
					return {"type": "lines", "paths": [[Vector2(25, 150), Vector2(175, 50)]]}
				MilSymbolConfig.Affiliation.HOSTILE:
					return {"type": "lines", "paths": [[Vector2(60, 130), Vector2(140, 70)]]}
				MilSymbolConfig.Affiliation.NEUTRAL:
					return {"type": "lines", "paths": [[Vector2(45, 155), Vector2(155, 45)]]}
				MilSymbolConfig.Affiliation.UNKNOWN:
					return {"type": "lines", "paths": [[Vector2(50, 135), Vector2(150, 65)]]}
				_:
					return {}
		IconType.ENGINEER:
			# Box with vertical center line (MIL-STD-2525)
			return {
				"type": "lines",
				"paths":
				[
					[Vector2(60, 118), Vector2(60, 83), Vector2(140, 83), Vector2(140, 118)],
					[Vector2(100, 83), Vector2(100, 110)]
				]
			}
		IconType.ANTI_TANK:
			# Two lines from bottom corners meeting at top center (MIL-STD-2525: antitank symbol)
			# Forms a "V" or chevron shape pointing upward
			match affiliation:
				MilSymbolConfig.Affiliation.FRIEND:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(25, 150), Vector2(100, 52)],  # Left line
							[Vector2(175, 150), Vector2(100, 52)]  # Right line
						]
					}
				MilSymbolConfig.Affiliation.HOSTILE:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(60, 132), Vector2(100, 30)],  # Left line
							[Vector2(140, 132), Vector2(100, 30)]  # Right line
						]
					}
				MilSymbolConfig.Affiliation.NEUTRAL:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(45, 150), Vector2(100, 47)],  # Left line
							[Vector2(155, 150), Vector2(100, 47)]  # Right line
						]
					}
				MilSymbolConfig.Affiliation.UNKNOWN:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(55, 135), Vector2(100, 33)],  # Left line
							[Vector2(145, 135), Vector2(100, 33)]  # Right line
						]
					}
				_:
					return {}
		IconType.ANTI_AIR:
			# Three vertical lines (MIL-STD-2525: Air Defense Gun Unit)
			return {
				"type": "lines",
				"paths":
				[
					[Vector2(100, 80), Vector2(100, 120)],
					[Vector2(92, 90), Vector2(92, 110)],
					[Vector2(108, 90), Vector2(108, 110)]
				]
			}
		IconType.HEADQUARTERS:
			# Horizontal line through center (MIL-STD-2525)
			match affiliation:
				MilSymbolConfig.Affiliation.FRIEND:
					return {"type": "lines", "paths": [[Vector2(25, 80), Vector2(175, 80)]]}
				MilSymbolConfig.Affiliation.HOSTILE:
					return {"type": "lines", "paths": [[Vector2(50, 80), Vector2(150, 80)]]}
				_:
					return {"type": "lines", "paths": [[Vector2(35, 80), Vector2(165, 80)]]}
		IconType.COMMAND_POST:
			return {"type": "text", "text": "CP", "position": Vector2(100, 100), "size": 32}
		_:
			return {}


## Parse a simple unit type string to IconType
static func parse_unit_type(unit_type: String) -> IconType:
	var lower_type := unit_type.to_lower()

	# Check compound types first (anti-tank, anti-air) before simple types (tank, air)
	if "anti-tank" in lower_type or "anti_tank" in lower_type or "at" == lower_type:
		return IconType.ANTI_TANK
	elif "anti-air" in lower_type or "anti_air" in lower_type or "aa" in lower_type:
		return IconType.ANTI_AIR
	elif "infantry" in lower_type or "inf" in lower_type:
		return IconType.INFANTRY
	elif "armor" in lower_type or "tank" in lower_type:
		return IconType.ARMOR
	elif "mech" in lower_type:
		return IconType.MECHANIZED
	elif "artillery" in lower_type or "arty" in lower_type:
		return IconType.ARTILLERY
	elif "recon" in lower_type or "scout" in lower_type:
		return IconType.RECON
	elif "engineer" in lower_type or "eng" in lower_type:
		return IconType.ENGINEER
	elif "hq" in lower_type or "headquarters" in lower_type:
		return IconType.HEADQUARTERS
	elif "cp" in lower_type or "command" in lower_type:
		return IconType.COMMAND_POST

	return IconType.NONE
