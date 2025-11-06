# Motorized::_get_default_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/Motorized.gd` (lines 33–42)</br>
*Belongs to:* [Motorized](../../Motorized.md)

**Signature**

```gdscript
func _get_default_icon() -> Dictionary
```

## Source

```gdscript
func _get_default_icon() -> Dictionary:
	return {
		"type": "lines",
		"paths":
		[
			[Vector2(45, 45), Vector2(155, 155)],
			[Vector2(45, 155), Vector2(155, 45)],
			[Vector2(100, 45), Vector2(100, 155)]
		]
	}
```
