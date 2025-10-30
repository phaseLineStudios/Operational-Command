## Icon definitions for military symbols
## Provides simple icon shapes for different unit types
class_name MilSymbolIcons
extends RefCounted


const ICONS_PATH := "res://scripts/utils/unit_symbols/icons"

static var _generators: Dictionary = {}

## Load and cache icon generators from ICONS_PATH.
## Skips files with global class_names.
## [return] Dictionary of generators keyed by MilSymbol.UnitType.
static func _get_icon_generators() -> Dictionary:
	if not _generators.is_empty():
		return _generators

	var dir := DirAccess.open(ICONS_PATH)
	if dir == null:
		LogService.error("Could not open directory: %s" % ICONS_PATH, "MilSymbolIcons.gd:20")
		return _generators

	dir.list_dir_begin()
	var fname := dir.get_next()
	while fname != "":
		if not dir.current_is_dir() and fname.get_extension() == "gd":
			var script := load(ICONS_PATH.path_join(fname)) as GDScript
			if script:
				var inst: Variant = script.new()
				if inst is BaseMilSymbolIcon:
					var unit_type: MilSymbol.UnitType = inst.get_type()
					_generators[unit_type] = inst
		fname = dir.get_next()
	dir.list_dir_end()
	return _generators

## Get drawing instructions for [param icon_type] and [param affiliation].
## Coordinates use a 200x200 space.
## [return] Dictionary with drawing commands; {} if missing.
static func get_icon(
	icon_type: MilSymbol.UnitType, affiliation: MilSymbol.UnitAffiliation
) -> Dictionary:
	var gens := _get_icon_generators()
	var inst: Variant = gens.get(icon_type, null)
	if inst:
		return (inst as BaseMilSymbolIcon).get_icon_config(affiliation)
	LogService.warning("No icon generator for type: %s" % [str(icon_type)], "MilSymbolIcons.gd:47")
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
