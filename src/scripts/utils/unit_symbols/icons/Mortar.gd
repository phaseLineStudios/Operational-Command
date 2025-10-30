extends BaseMilSymbolIcon
## Mechanized Icon.


func get_type() -> MilSymbol.UnitType:
	return MilSymbol.UnitType.MORTAR


func _get_default_icon() -> Dictionary:
	return {
		"type": "mixed",
		"shapes": [{"shape": "circle", "center": Vector2(100, 115), "radius": 5, "filled": false}],
		"paths":
		[
			[Vector2(100, 110), Vector2(100, 80)],
			[Vector2(100, 80), Vector2(91, 90)],
			[Vector2(100, 80), Vector2(109, 90)]
		]
	}
