extends BaseMilSymbolIcon
## Armored Icon.


func get_type() -> MilSymbol.UnitType:
	return MilSymbol.UnitType.ARMOR


func _get_default_icon() -> Dictionary:
	return {
		"type": "shapes",
		"shapes":
		[{"shape": "rect", "rect": Rect2(60, 79, 82, 44), "corner_radius": 19.5, "filled": false}],
	}
