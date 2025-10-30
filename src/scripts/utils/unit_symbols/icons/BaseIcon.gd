class_name BaseMilSymbolIcon
extends RefCounted
## Represents a MilSymbol Icon


## Retrieve Unit Type.
## [return] Unit Type.
func get_type() -> MilSymbol.UnitType:
	return MilSymbol.UnitType.NONE


## Retrieve Icon config.
## [return] Dictionary of icon config.
func get_icon_config(affiliation: MilSymbol.UnitAffiliation) -> Dictionary:
	match affiliation:
		MilSymbol.UnitAffiliation.FRIEND:
			return _get_friendly_icon()
		MilSymbol.UnitAffiliation.ENEMY:
			return _get_enemy_icon()
		MilSymbol.UnitAffiliation.NEUTRAL:
			return _get_neutral_icon()
		MilSymbol.UnitAffiliation.UNKNOWN:
			return _get_unknown_icon()
		_:
			return _get_default_icon()


## Get friendly icon (overrideable).
## [return] Dictionary of icon config.
func _get_friendly_icon() -> Dictionary:
	return _get_default_icon()


## Get enemy icon (overrideable).
## [return] Dictionary of icon config.
func _get_enemy_icon() -> Dictionary:
	return _get_default_icon()


## Get neutral icon (overrideable).
## [return] Dictionary of icon config.
func _get_neutral_icon() -> Dictionary:
	return _get_default_icon()


## Get unknown icon (overrideable).
## [return] Dictionary of icon config.
func _get_unknown_icon() -> Dictionary:
	return _get_default_icon()


## Get default icon (overrideable).
## [return] Dictionary of icon config.
func _get_default_icon() -> Dictionary:
	return {}
