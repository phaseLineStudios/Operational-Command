# AntiAir::_get_default_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/icons/AntiAir.gd` (lines 9–18)</br>
*Belongs to:* [AntiAir](../../AntiAir.md)

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
			[Vector2(100, 80), Vector2(100, 120)],
			[Vector2(92, 90), Vector2(92, 110)],
			[Vector2(108, 90), Vector2(108, 110)]
		]
	}
```
