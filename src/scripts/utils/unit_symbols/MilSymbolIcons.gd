## Icon definitions for military symbols
## Provides simple icon shapes for different unit types
class_name MilSymbolIcons
extends RefCounted


## Get drawing instructions for an icon type
## Returns a dictionary with drawing commands
## Icons are based on MIL-STD-2525 standard, coordinates in 200x200 space
static func get_icon(icon_type: MilSymbol.UnitType, affiliation: MilSymbol.UnitAffiliation) -> Dictionary:
	match icon_type:
		MilSymbol.UnitType.INFANTRY:
			# Crossed diagonal lines corner to corner (varies by affiliation)
			match affiliation:
				MilSymbol.UnitAffiliation.FRIEND:
					return {
						"type": "lines",
						"paths":
						[[Vector2(25, 50), Vector2(175, 150)], [Vector2(25, 150), Vector2(175, 50)]]
					}
				MilSymbol.UnitAffiliation.ENEMY:
					return {
						"type": "lines",
						"paths":
						[[Vector2(64, 64), Vector2(136, 136)], [Vector2(64, 136), Vector2(136, 64)]]
					}
				MilSymbol.UnitAffiliation.NEUTRAL:
					return {
						"type": "lines",
						"paths":
						[[Vector2(45, 45), Vector2(155, 155)], [Vector2(45, 155), Vector2(155, 45)]]
					}
				MilSymbol.UnitAffiliation.UNKNOWN:
					return {
						"type": "lines",
						"paths":
						[[Vector2(45, 45), Vector2(155, 155)], [Vector2(45, 155), Vector2(155, 45)]]
					}
				_:
					return {}
		MilSymbol.UnitType.ARMOR:
			# Oval track outline (MIL-STD-2525: oval shape)
			return {
				"type": "shapes",
				"shapes": [
					{
						"shape": "rect",
						"rect": Rect2(60, 79, 82, 44),
						"corner_radius": 19.5,
						"filled": false
					}
				],
			}
		MilSymbol.UnitType.MOTORIZED:
			match affiliation:
				MilSymbol.UnitAffiliation.FRIEND:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(25, 50), Vector2(175, 150)],
							[Vector2(25, 150), Vector2(175, 50)],
							[Vector2(100, 50), Vector2(100, 150)]
						]
					}
				MilSymbol.UnitAffiliation.ENEMY:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(64, 64), Vector2(136, 136)], 
							[Vector2(64, 136), Vector2(136, 64)],
							[Vector2(100, 28), Vector2(100, 172)]
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
		MilSymbol.UnitType.MECHANIZED:
			match affiliation:
				MilSymbol.UnitAffiliation.FRIEND:
					return {
						"type": "mixed",
						"shapes": [
							{
								"shape": "rect",
								"rect": Rect2(60, 79, 82, 44),
								"corner_radius": 19.5,
								"filled": false
							}
						],
						"paths": [
							[Vector2(25, 50), Vector2(175, 150)],
							[Vector2(25, 150), Vector2(175, 50)]
						]
					}
				MilSymbol.UnitAffiliation.ENEMY:
					return {
						"type": "mixed",
						"shapes": [
							{
								"shape": "rect",
								"rect": Rect2(60, 79, 82, 44),
								"corner_radius": 19.5,
								"filled": false
							}
						],
						"paths": [
							[Vector2(64, 64), Vector2(136, 136)], 
							[Vector2(64, 136), Vector2(136, 64)]
						]
					}
				_:
					return {
						"type": "mixed",
						"shapes": [
							{
								"shape": "rect",
								"rect": Rect2(60, 79, 82, 44),
								"corner_radius": 19.5,
								"filled": false
							}
						],
						"paths": [
							[Vector2(45, 45), Vector2(155, 155)], 
							[Vector2(155, 45), Vector2(45, 155)]
						]
					}
		MilSymbol.UnitType.ARTILLERY:
			# Filled circle (MIL-STD-2525 standard)
			return {"type": "circle", "center": Vector2(100, 100), "radius": 15, "filled": true}
		MilSymbol.UnitType.RECON:
			# Single diagonal line (MIL-STD-2525)
			match affiliation:
				MilSymbol.UnitAffiliation.FRIEND:
					return {"type": "lines", "paths": [[Vector2(25, 150), Vector2(175, 50)]]}
				MilSymbol.UnitAffiliation.ENEMY:
					return {"type": "lines", "paths": [[Vector2(64, 136), Vector2(136, 64)]]}
				MilSymbol.UnitAffiliation.NEUTRAL:
					return {"type": "lines", "paths": [[Vector2(45, 155), Vector2(155, 45)]]}
				MilSymbol.UnitAffiliation.UNKNOWN:
					return {"type": "lines", "paths": [[Vector2(50, 135), Vector2(150, 65)]]}
				_:
					return {}
		MilSymbol.UnitType.ENGINEER:
			# Box with vertical center line (MIL-STD-2525)
			return {
				"type": "lines",
				"paths":
				[
					[Vector2(60, 118), Vector2(60, 83), Vector2(140, 83), Vector2(140, 118)],
					[Vector2(100, 83), Vector2(100, 110)]
				]
			}
		MilSymbol.UnitType.ANTI_TANK:
			# Two lines from bottom corners meeting at top center (MIL-STD-2525: antitank symbol)
			# Forms a "V" or chevron shape pointing upward
			match affiliation:
				MilSymbol.UnitAffiliation.FRIEND:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(25, 150), Vector2(100, 52)],  # Left line
							[Vector2(175, 150), Vector2(100, 52)]  # Right line
						]
					}
				MilSymbol.UnitAffiliation.ENEMY:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(60, 132), Vector2(100, 30)],  # Left line
							[Vector2(140, 132), Vector2(100, 30)]  # Right line
						]
					}
				MilSymbol.UnitAffiliation.NEUTRAL:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(45, 150), Vector2(100, 47)],  # Left line
							[Vector2(155, 150), Vector2(100, 47)]  # Right line
						]
					}
				MilSymbol.UnitAffiliation.UNKNOWN:
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
		MilSymbol.UnitType.ANTI_AIR:
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
		MilSymbol.UnitType.HQ:
			# Horizontal line through center (MIL-STD-2525)
			match affiliation:
				MilSymbol.UnitAffiliation.FRIEND:
					return {"type": "lines", "paths": [[Vector2(25, 80), Vector2(175, 80)]]}
				MilSymbol.UnitAffiliation.ENEMY:
					return {"type": "lines", "paths": [[Vector2(50, 80), Vector2(150, 80)]]}
				MilSymbol.UnitAffiliation.NEUTRAL:
					return {"type": "lines", "paths": [[Vector2(45, 80), Vector2(155, 80)]]}
				_:
					return {"type": "lines", "paths": [[Vector2(35, 80), Vector2(165, 80)]]}
		MilSymbol.UnitType.SUPPLY:
			# Horizontal line through center (MIL-STD-2525)
			match affiliation:
				MilSymbol.UnitAffiliation.FRIEND:
					return {"type": "lines", "paths": [[Vector2(25, 120), Vector2(175, 120)]]}
				MilSymbol.UnitAffiliation.ENEMY:
					return {"type": "lines", "paths": [[Vector2(50, 120), Vector2(150, 120)]]}
				MilSymbol.UnitAffiliation.NEUTRAL:
					return {"type": "lines", "paths": [[Vector2(45, 120), Vector2(155, 120)]]}
				_:
					return {"type": "lines", "paths": [[Vector2(35, 120), Vector2(165, 120)]]}
		MilSymbol.UnitType.MEDICAL:
			match affiliation:
				MilSymbol.UnitAffiliation.FRIEND:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(25, 100), Vector2(175, 100)],
							[Vector2(100, 50), Vector2(100, 150)]
						]
					}
				MilSymbol.UnitAffiliation.ENEMY:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(28, 100), Vector2(172, 100)], 
							[Vector2(100, 28), Vector2(100, 172)]
						]
					}
				_:
					return {
						"type": "lines",
						"paths":
						[
							[Vector2(45, 100), Vector2(155, 100)],
							[Vector2(100, 45), Vector2(100, 155)]
						]
					}
		_:
			return {}


## Parse a simple unit type string to MilSymbol.UnitType
static func parse_unit_type(unit_type: String) -> MilSymbol.UnitType:
	var lower_type := unit_type.to_lower()

	# Check compound types first (anti-tank, anti-air) before simple types (tank, air)
	if "anti-tank" in lower_type or "anti_tank" in lower_type or "at" == lower_type:
		return MilSymbol.UnitType.ANTI_TANK
	elif "anti-air" in lower_type or "anti_air" in lower_type or "aa" in lower_type:
		return MilSymbol.UnitType.ANTI_AIR
	elif "infantry" in lower_type or "inf" in lower_type:
		return MilSymbol.UnitType.INFANTRY
	elif "armor" in lower_type or "tank" in lower_type:
		return MilSymbol.UnitType.ARMOR
	elif "mech" in lower_type:
		return MilSymbol.UnitType.MECHANIZED
	elif "motor" in lower_type:
		return MilSymbol.UnitType.MOTORIZED
	elif "artillery" in lower_type or "arty" in lower_type:
		return MilSymbol.UnitType.ARTILLERY
	elif "recon" in lower_type or "scout" in lower_type:
		return MilSymbol.UnitType.RECON
	elif "engineer" in lower_type or "eng" in lower_type:
		return MilSymbol.UnitType.ENGINEER
	elif "sup" in lower_type or "supply" in lower_type:
		return MilSymbol.UnitType.SUPPLY
	elif "med" in lower_type or "medical" in lower_type:
		return MilSymbol.UnitType.MEDICAL
	elif "hq" in lower_type or "headquarters" in lower_type:
		return MilSymbol.UnitType.HQ

	return MilSymbol.UnitType.NONE
