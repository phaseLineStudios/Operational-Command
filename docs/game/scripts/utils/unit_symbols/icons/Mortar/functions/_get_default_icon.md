# Mortar::_get_default_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/Mortar.gd` (lines 9–19)</br>
*Belongs to:* [Mortar](../../Mortar.md)

**Signature**

```gdscript
func _get_default_icon() -> Dictionary
```

## Source

```gdscript
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
```
