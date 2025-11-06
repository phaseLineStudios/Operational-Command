extends BaseMilSymbolIcon
## Armored Icon.


func get_type() -> MilSymbol.UnitType:
	return MilSymbol.UnitType.ARTILLERY


func _get_default_icon() -> Dictionary:
	return {"type": "circle", "center": Vector2(100, 100), "radius": 15, "filled": true}
